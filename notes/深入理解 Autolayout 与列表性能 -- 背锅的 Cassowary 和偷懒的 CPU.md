# 深入理解 Autolayout 与列表性能 -- 背锅的 Cassowary 和偷懒的 CPU

 这篇文章会通过对 autolayout 内部实现的探索和数据分析和对 autolayout 的性能问题做一个详细的分析，并在最后给出一个高性能 `autolayout` 的解决方案。开始看文章之前，可以先试试这个 [demo](https://github.com/nangege/PandaDemo) ,使用 YYKit demo 数据做的微博 Feed 列表。使用我自己写的异步绘制组件 Panda 和和 ‘autolayout’ 框架 Layoutable 写的 ,cell 代码只有 五百多行,但是流畅度很高。
 
[Cassowary 算法性能](#aboutCassowary)

[Autolayout 设计问题](#autolayout)

[Text layout 对性能的影响](#textlayout)

[CPU 调度对列表性能的影响](#cpu)

[Autolayout 的一些结论](#conclusion)

[Panda](#Panda)


### <span id = "aboutCassowary">Cassowary 算法性能</span>

Autolayout 会将约束条件转换成线性规划问题，通过 Cassowary 算法求解线性规划问题得到 frame。因此分析 autolayout 性能都绕不开 Cassowary 算法。大部分分析最后都会给出结论 “autolayout 性能差是 cassowary 算法的多项式的时间复杂度造成的”。也有一些会给出 autolayout 的 benchmark 来证明 cassowary 算法的问题。但是

1. Cassowary 是 1997 年就被发表并被称作高效的线性方程求解算法，为什么 ‘8012’ 年了反而成了性能杀手？
2. 如果是 Cassowary 算法的问题，跑着 iOS 8 的 iPhone 6 应该比实际表现更卡顿才合理，毕竟算法时间复杂度不会随着设备和系统升级下降。由于系统开销造成的性能下降在 ios 设备升级的和过程中似乎额外的大了。

想到自己实现 cassowary 算法和 autolayout 也是由对这两个问题的不解引出的。


> Cassowary is an incremental constraint solving toolkit that efficiently solves systems of linear equalities and inequalities.

线性规划问题的求解很早就有通用解法--单纯型法，有兴趣的同学可以看看这篇文章 [AutoLayout 中的线性规划 - Simplex 算法
](https://xiaozhuanlan.com/topic/5378941206)。《算法导论》也有一章专门介绍单纯型法的（所以谁说算法对 iOS 开发没用🐶）。Cassowary 则是单纯型法在用户界面实践中的应用和改进算法，解决一些实际使用的问题，最重要的增加了增量的概念(Autolayout 实现中 Cassowary 相关的代码是以 `NSIS` 作为前缀的，`IS` 就是 `incremental Simplex` 增量单纯型的缩写 )，单纯型法通过建立单纯型表，在对单纯形表进行 pivot 和 optimize 操作得到最优解；Cassowary 则是可以在已经建立单纯型表上，高效的进行添加修改更新操作。因为用户界面应用中，大部分约束已经固定，界面变化只需要对其中的部分约束进行更新或者进行少量的增减操作。Cassowary 的高效是建立在增量跟新的基础上的。

完整介绍 Cassowary 需要很长篇幅，有时间单独介绍，这里用数据说话

一组 benchmark: （MacBook Pro 2016 i5,iPhone6S 模拟器）

![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d5fb440e0f?w=945&h=294&f=png&s=44919)

- Autolayout: 是相对布局的耗时
- Autolayout Nestlayout: 嵌套布局的耗时
- update constant: 更新约束的耗时,即更新 NSLayoutConstraint 的 constant 常量。

因为这里没有不含 UILabel，UIView 等有 intrincContentSize 的 UIView,update constant 基本就是 Cassowary 更新约束的耗时。Applelayout 和 Apple NestLayout 则也包含 UIView 创建，约束创建和求解的时间。

可以看到 update 约束是非常高效的， 80 个 view，160 条约束更新约束也只需要 2.5 个毫秒，这个数量在实际使用中基本上是用不到的。实际使用中，同时更新 40 个 view 80 条约束已经算是很多的了，也只耗时 1.25 ms。

列表滚动中，一般情况下页面加载的时候 cell 和 约束已经创建，性能应该主要和更新约束相关（更新约束包括 UILabel。UIView 更改 text ,image 造成的 size 变化，更新系统默认的约束；也包括手动调整 NSLayoutConstraint 的 constant 属性等）。为什么实际表现却差很多呢？
  
### <span id = "autolayout">Autolayout 设计问题</span>

Autolayout 构建在 Cassowary 之上，但是 autolayout 的一些机制没有充分利用 Cassowary 更新高效的特点。我们可以通过私有类和方法来研究系统内部的实现。这里有一个网站 [iOS SDK Header Dump](http://developer.limneos.net) 可以查看 iOS 的私有头文件。其中 `NSIS` 开头的类都是 Autolayout 相关的头文件。我把 iOS 11 Autolayout 相关的头文件下载下来并做成了一个可以运行的工程。可以 hook 内部实现或者打印变量来观察系统的调用，可以这里下载 [ExplorAutolayout](https://github.com/nangege/DevNotes/tree/master/project/ExplorAutolayout) 。后面一些测试代码会基于这个工程。

1. NSContentSizeLayoutConstraint

   这是 [FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) profile 的一段结果，展开部分是 cellForRowAIndex 里运行的代码。
   
   ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d601fba931?w=1269&h=146&f=png&s=74379)
  
   理论上 `cellForRowAIndex ` 是不需要创建 NSLayoutConstraint 的，毕竟 cell 已经创建过了, 更新数据的时候代码中并没有新加约束。但这里创建了 `UIContentSizeLayoutConstraint` 对象，`UIContentSizeLayoutConstraint` 继承自 `NSLayoutConstraint`,是专门用来约束 contentSize 的约束。 
  
   来一段测试代码，我们在 `NSLayoutConstraint` 对象创建的时候输出创建的约束类型:
  
   ```Objective-C
   // 子类化 UIlabel，每次调用 intrinsicContentSize 输出大小
   @implementation TestLabel

   - (CGSize)intrinsicContentSize{  
       NSLog(@"width: %f, height: %f",size.width,size.height);
       return [super intrinsicContentSize];
   }

   @end
  
   // 替换 NSLayoutConstraint init 方法，每次输出创建的类型
   @implementation NSLayoutConstraint (methodSwizze)

   + (void)load{
      [self replace:@selector(init) byNew:@selector(new_init)];
   }

   - (instancetype)new_init{
       NSLog(@"New %@",[self class]);
       return [self new_init];
   }

   @end  
   
   ```
  
   一个多行文字的 label 给一个宽度约束,然后设置 text, `layoutIfNeeded` 强制布局 输出结果：
  
   ```
   width: 1073741824.000000, height: 20.500000
   New NSContentSizeLayoutConstraint
   New NSContentSizeLayoutConstraint
   width: 296.500000, height: 41.000000
   New NSContentSizeLayoutConstraint
   New NSContentSizeLayoutConstraint
   ```
   创建的两个约束是根据 `intrinsicContentSize` 值给的宽度和高度约束。也就是每次 `intrinsicContentSize` 变化的时候，Autolayout 都会创建两个新的 `NSContentSizeLayoutConstraint` 约束分别约束宽和高，添加到 `NSISEnginer` 中求解, 而不是直接更新已经创建好的约束。
  
   水果公司一边告诉我们重新添加约束比更新约束低效，一边在频繁调用的地方用着低效的方法😂。

2. systemLayoutSizeFittingSize
  
   `NSContentSizeLayoutConstraint` 只是苹果浪费 Cassowary 算法优点的一个地方，
  
   * 看另一组不包含 `intrinsicContentSize` 的 `UIView` 的数据，都是单纯的更新约束,区别只在于有没有添加到 window 上，以及强制布局的方法：  

     ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d61931df5b?w=714&h=267&f=png&s=45075)

      -  `Apple constant` 是 view 没有并添加到 window 上，更新约束后调用 `layoutIfNeeded` 的数据。
      -  `Apple In Window constant`是把 view 添加到当前 window 上，更新约束后调用 `layoutIfNeeded ` 的数据
      -  `SystemFitSize constant` 是调用 `systemlayoutFitSize` 获取高度的数据。

      同样是更新约束，耗时差距却非常大，添加到 window 上再调用 `layoutIfNeeded` 的耗时远小于没有加到 window 上。同样没有加到 window 上，`systemlayoutFitSize ` 耗时又要小于 `layoutIfNeeded `.
  
   * 再以 FDTemplateLayoutCell 为例，我们在同一方法中同事调用 `systemLayoutSizeFittingSize ` 和 `layoutIfNeeded`

       ``` Objective-C
       - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
           [self measure:^{
             [self configureCell:self.cell atIndexPath:indexPath];
             [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
           } log:@"heightForRow"];
  
           FDFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDFeedCell"];
           [self measure:^{
               [self configureCell:cell atIndexPath:indexPath];
               [cell.contentView layoutIfNeeded];
           } log:@"cellForRowAtIndexPath"];
  
           return cell;
       }
       ```


       profile 下

       ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d600a217f8?w=1187&h=100&f=png&s=56342)

       `systemLayoutSizeFittingSize ` 总耗时 276 ms, `layoutIfNeeded` 总耗时 161 `ms` 多了 70% 的耗时


    * 看一下 autolayout 调用的过程：

      替换 `NSISEnginer` （`NSISEnginer` 就是 autolayout 的 线性规划求解器）的 `init` 方法，每次创建     `NSISEnginer` 打印 `New NSISEnginer`

      ```Objective-C
      + (void)load{
          [self replace:@selector(init) byNew:@selector(new_init)];
      }

      - (id)new_init{
          NSLog(@"New NSISEnginer");
          return [self new_init];
      }

      ...

      @implementation NSObject(methodExchange)

      + (void)replace:(SEL)old byNew:(SEL)new{
          Method oldMethod = class_getInstanceMethod([self class], old);
          Method newMethod = class_getInstanceMethod([self class], new);
  
          method_exchangeImplementations(oldMethod, newMethod);
      }
      ``` 		

      调用方法观察输出:

      ``` Objective-C
        UIView * view3 = [[UIView alloc] init];
  
        view3.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint *c3 =  [view3.widthAnchor constraintEqualToConstant:10];
        c3.priority = UILayoutPriorityDefaultHigh;
        c3.active = true;
  
        for(NSUInteger i = 0; i < 3; i++){
           [view3 setNeedsLayout];
           [view3 layoutIfNeeded];
           NSLog(@"View3LayoutIfNeeded");
         }
  
        for(NSUInteger i = 0; i < 3; i++){
          [view3 setNeedsLayout];
          [view3 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
          NSLog(@"No superview systemLayoutSizeFittingSize");
        }
  
        [self.view addSubview:view3];
  
        for(NSUInteger i = 0; i < 3; i++){
          c3.constant = rand()%20;
          [view3 setNeedsLayout];
          [view3 layoutIfNeeded];
          NSLog(@"View3LayoutIfNeededSecondPass");
        }
  
        for(NSUInteger i = 0; i < 3; i++){
          c3.constant = rand()%20;
          CGSize size = [view3 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
          NSLog(@"w :%f",size.width);
          NSLog(@"systemLayoutSizeFittingSize");
        }
      ```
      打印结果是

	  ```Objective-C
	   View3LayoutIfNeeded
	   New NSISEnginer
	   View3LayoutIfNeeded
	   New NSISEnginer 
	   View3LayoutIfNeeded
	   New NSISEnginer
	 
	   No superview systemLayoutSizeFittingSize
	   New NSISEnginer
	   No superview systemLayoutSizeFittingSize
	   New NSISEnginer
	   No superview systemLayoutSizeFittingSize
	   New NSISEnginer
	 
	   View3LayoutIfNeededSecondPass
	   View3LayoutIfNeededSecondPass
	   View3LayoutIfNeededSecondPass
	 
	   systemLayoutSizeFittingSize
	   New NSISEnginer
	   systemLayoutSizeFittingSize
	   New NSISEnginer
	   systemLayoutSizeFittingSize
	   New NSISEnginer
	  ```
	  可以看到，没有添加到 `window` 之前, 调用 `layoutIfNeeded` 和 `systemLayoutSizeFittingSize` 每次都会创建 `NSISEnginer`；添加到 window 上以后，`layoutIfNeeded` 并不会创建 NSISEnginer, 而`systemLayoutSizeFittingSize ` 还是每次都会创建 `NSISEnginer`。创建新的 `NSISEnginer` 则意味着对应的所有约束，也会重新添加到 `NSISEnginer`,重新进行优化求解，这时候的耗时就变成了初次添加约束的时间。在列表的使用中，我们一般会在 `heightForRowAtIndexPath` 中创建一个不会添加到 window 上的 `cell` 调用 `systemLayoutSizeFittingSize ` 来计算高度。这个的计算耗时就要比 `cellForRowAtIndexPath` 中的耗时大很多。

   ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d60dc98b7f?w=1013&h=433&f=png&s=88818)
   
    `systemLayoutSizeFittingSize` 会重新创建 `NSISEnginer`和 WWDC 《High performance Autolayout》 所讲也是一致的。使用 `systemLayoutSizeFittingSize` 时，Autolayout 会创建新的 NSISEnginer 对象,重新添加约束求解，然后释放掉 NSISEnginer 对象。而对于   `layoutIfNeeded` 也很好理解，Autolayout 中，一个 window 层级下的 view 会共用 window 节点的 `NSISEnginer` 对象，没有添加到 window 上的 view 没有父 window 也就没办法共用，只能重新创建.
   
   ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d62f5ff8d1?w=1014&h=447&f=png&s=50256)

   而在 WWDC  介绍中 `systemLayoutSizeFitting` 是提供给 autolayout 和 frame 混合使用的，也不建议常用，似乎不是给计算高度来用的。

   那么能不能在算高度时候把 cell 添加到 window 上，隐藏，然后用 `layoutIfNeeded` 来提高效率?

   🍎：呵呵 🙃
  
   `systemLayoutSizeFittingSize ` 对计算做了优化，计算好以后不会对 view 的 frame 进行操作，也就避免 layer 调整的相关耗时。所以同样是创建 `NSISEnginer` 重新添加约束， `systemLayoutSizeFittingSize` 比 `layoutIfNeeded` 要高效；添加到 window 上以后，`layoutIfNeeded` 计算的效率高于 `systemLayoutSizeFittingSize`,但是 `setFrame` 和触发的 layer 相关操作又会有额外的耗时，不一定会比直接使用 `systemLayoutSizeFittingSize ` 耗时少 。
    
    ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba91c89afc668?w=1596&h=812&f=png&s=906843)

  > The Enginer is a layout cache and dependency tracker 

  Cassowary 的增量更新机制其实也算是某种程度上的缓存机制，重新创建 Enginer 的设计也就丢掉了 cache 的能力，降低了性能。

### <span id = "textlayout">Text layout 对性能的影响</span>

虽然由于上述种种问题， 但如上图所示 `heightForRowAtIndexPath ` 里调用 `systemLayoutSizeFittingSize ` 再加上 `cellForRowAtIndexPath` 里调用 `layoutIfNeeded` 总耗时看起来也并不是很多，40 个 view 左右耗时也不到 4 ms，看起来还可以，为什么实际使用起来表现却差很多呢。

1. ***text layout 才是性能杀手***

    1. 以 FDTemplateLayoutCell demo，为例，我们对同一个 cell 连续执行三次一样的代码，

        ```Objective-C
        [self measure:^{
            [self configureCell:self.cell atIndexPath:indexPath];
            [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
         } log:@"heightForRow"];
  
        [self measure:^{
            [self configureCell:self.cell atIndexPath:indexPath];
            [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        } log:@"heightForRow"];
  
        [self measure:^{
            [self configureCell:self.cell atIndexPath:indexPath];
            [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        } log:@"heightForRow"];
    
        ``` 
  
        结果差距很大
        
        ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d6ec2073b7?w=1297&h=214&f=png&s=113831)
  
        第一遍耗时 231 ms,后面两遍只有 98,87 毫秒
  
        如果把第一遍展开的话，就会发现大部分时间都是在文字上：
 
        ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d6efbbfecb?w=1294&h=664&f=png&s=261386)
        
  
        后面两遍因为和第一遍的数据一样，不会触发文字相关的操作。计算的时间只占了  30%-40%

    2. 以我们的微博 [demo](https://github.com/nangege/PandaDemo) layout 做一个 benchmak

        ```Swift
        for status in self.statusViewModels{
          measureTime(desc: "without text layout cache", action: {
            self.statusNode.update(status)
            self.statusNode.layoutIfNeeded()
            status.layoutValues = self.statusNode.layoutValues
            status.height = self.statusNode.frame.height
          })
        }
        
        for status in self.statusViewModels{
          measureTime(desc: "without text layout cache", action: {
            self.statusNode.update(status)
            self.statusNode.layoutIfNeeded()
            status.layoutValues = self.statusNode.layoutValues
            status.height = self.statusNode.frame.height
          })
        }
        ```
       两个 for 循环中，除了输出的描述文案，代码是一样的，Panda 的实现中，会把已经创建的 TextKit 组成的 TextRender 对象缓存起来，并且是不可变。再次出现相同的文字会从缓存取。
    
       第一次 for 循环中，不存在相应的 TextRender 对象，每次都需要创建新的 TextRender 对象并进行 layout
  
       第二次 for 循环中，因为第一次计算过程中已经缓存了 TextRender，基本上只是单纯取值和 Cassowary 更新约束计算。  
  
  
       结果：（iPhone6 , iOS 12）
       
       ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d70db6d660?w=1023&h=437&f=png&s=101448)
  
       - Panda FirstPass 是第一个 for 循环数据
       - Panda SecondPass 是第二个 for 循环数据
       - YYKit 则是 YYKit 手算 frame 的数据 
       - 纵坐标是耗时
  
       同样更新数据，同样的 update 约束，同样的 Panda Layout 数据相差却非常大。而且第二次数据更加平稳

       对于 Panda Layou，相差的数据基本就是 text layout 的时间。第一次 Layout 平均数据 5.94，第二次平均数据 1.44. text layout 占了总耗时的 70%-80%。
 

2. ***Autolayout 要比手算多一些 Text layout过程***

     text layout 耗时最多， 使用 autolayout 会比 手算 frame 多一部分 text layout 过程
   
     其实上一个 `NSContentSizeLayoutConstraint` 的输出结果中已经给出部分答案，只设置一次 text,却输出了两次 `intrinsicContentSize `，而且结果也不一样。 检查一下 UIView 的私有方法，会发现一个`_needsDoubleUpdateConstraintsPass` 的方法，返回值为 true 的话，会调用两次 `intrinsicContentSize` 方法。

     * 手撕的 frame 时候开发人员需要额外注意计算顺序。比如计算一个多行的 UILabel，可能会先把左右两边相关的宽度计算好，这样可以知道 UILabel 最大宽度，或者直接指定 UILabel 的最大宽度，使用 `size(withAttributes:)` 进行一次 text layout 就可以把文字大小算出来。
     *  Autolayout 使开发者免去了操心布局顺序的负担（这也是 Autolayout 一个比较核心的优点）， 导致更新 UILabel 的约束时不能直接确定 UILabel 的最大宽度，怎么解决换行的问题？（iOS 6 的时候需要手动设置 preferrdMaxLayoutWidth，很多时候会造成很大困扰，因为并不是那么容易确定）。 对于多行文字的 UILabel,Autolayout 会进行两边 layout. 第一次 layout 会先假设文本可以一行展示完，进行一次 text layout ，计算一行文字的大小，更新 UILabel 的 size 约束。size 的宽高约束都不是 required 的，外部如果有对宽度相关的约束的话，也不会冲突。整个 view 层级一次布局结束之后，所有 view 的宽度就确定了，第二遍 layout 再以当前宽度再做一次 text layout ,更新文本宽高。这样 autolayout 文本的多行文字 textLayout 过程就要比手算 frame 多一倍。多行文本 layout 一般耗时更长。多出来一次的 text layout 的耗时就很多了了。

    ![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d70d1d8e66?w=940&h=442&f=png&s=356344)
  
    textlayout 耗时占比很大，这也是为什么苹果推荐重写 UIlable 的 `intrinsicContentSize` 方法，然后约束宽高的方式来避免 text layout。但是实际使用中能这样优化的场景并不多。

3. ***主线程运行的影响***
  
   关于列表性能优化，大家比较喜欢说的就是 frame 比 autolayout 快，其实更重要的是 frame 相对 autolayout 可以减少一些重复计算，以及把耗时操作丢到后台线程。
 
   1. 手算 frame 可以放到后台线程，从而避免了主线程的 text layout。
   2. 手算 frame 只会 layout 一遍，autolayout `heightForRowAtIndexPath` 和 `cellForRowAtIndexPath` 都需要计算，这个多出来的的计算和 text layout 就更多了。

Textlayout 在计算和渲染过程占的比重很大，也是很多 app 即使 cell 高度用 frame 算，没有做 text layout 相关缓存或者异步 Label 也会不流畅的原因。单纯做计算的优化，不做 text layout 缓存的布局框架一般实际表现都不会太好。
  

### <span id = "cpu">CPU 调度对列表性能的影响</span>

上面的 benchmark 是针对 iPhone 6 的, 数据其实已经很不错了，更好的设备岂不是要逆天？

看一组 iPhneX 的数据 （iPhoneX , iOS  12）

![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d7938beafc?w=1267&h=573&f=png&s=124813)

即使第一次 layout,Panda 和 YYKit 平均耗时只有 1.34 毫秒，只更新约束更是只需要 0.287 毫秒。（这个数据远好于 2016 MacBook Pro 的表现）。时间宽裕度很大，看起来即使 autolayout 的耗时多个一两倍问题也不大。

Apple: 呵呵🙃

benchmark 出来的耗时其实一般和实际运行是不一样。同样 iOS 12 iPhoneX ,如果对列表进行快速滑动的话，是可以到达 benchmark 的数据；如果滑动的不是很快的，上面 0.x,1.x ms 的耗时，很多就变成了 6 - 9 ms 左右。

![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d875e4d1dd?w=1880&h=680&f=png&s=377515)

![](https://user-gold-cdn.xitu.io/2018/10/28/166ba8d87272d066?w=1797&h=715&f=png&s=337570)

CPU 达到最好性能是需要时间的，benchmark 过程计算比较集中， CPU 一直处于高性能状态。但是滑的慢一点的话，可能 CPU 性能还没起来计算就结束了。然后 CPU 开始偷懒。刚好性能下去以后另一计算过程又开始了。而且 iOS 12 这个已经优化过了，iOS11 和 iOS 10 表现更差。做 benchmark 的有时候也会有一个有趣的现象，如果有几组数据需要测试，在同一段代码里调用这些方法进行测试，方法的调用顺序对 benchmark 出来的数据影响特别大。放在第一个的方法耗时会被大大增加。


### <span id = "conclusion">Autolayout 一些结论 </span>

总结一下，autolayout 性能不好并不是以前经常看到的是因为 cassowary 算法差导致的

1. cassowary 算法性能并没有太大问题，update 很高效，计算耗时并不多。
2. autolayout 的实现没有充分发挥 cassowary 的优点，没有父 window 的 view 重新创建 NSISEnginer 以及更新 intrincContentSize 需要重新创建和添加 NSLayoutConstraint 的设计加重了计算的负担
3. cassowary 算法占整体耗时并不多,text layout 对性能的影响大于 cassowary，autolayout 只能把 textlayout 放主线，使得 text layout 的耗时对流畅度的影响不可避免。
4. autolayout 重复的计算，重复的 text layout 使得整体耗时增加很多。
5. CPU 调度使得计算可用时间很少。


### <span id = "Panda">Panda</span>

为了解决上述问题，我用 swift 实现了一套异步绘制和 layout 组件 [Panda](https://github.com/nangege/Panda)。

Panda 包含第三个部分：

1. [Cassowary](https://github.com/nangege/Cassowary) Cassowary 算法
2. [Layoutable](https://github.com/nangege/Layoutable)  Autolayout API
3. [Panda](https://github.com/nangege/Panda) 异步绘制组件

Cassowary 是单纯的线性规划求解器；Layoutable 是在 Cassowary 之上构建的 'autolayout' ，底层上实现了类似 NSLayoutConstraint ，NSLayoutAnchor 类似的 LayoutConstraint 和 Anchor,也封装了更高级的 API 方便使用。Layoutable 提供 Layoutable 协议，任何实现了 Layoutable 的对象都可以使用 `autolayout`，比如 UIView,CALayer，或者其他自定义对象; Panda 则是实现了 Layoutable 协议的异步绘制组件，提供异步绘制，文本 layout 缓存,和通用的 FlowLayout,StackLayout 复合布局控件。 

Panda 基本上解决了上面提到的问题

1. Panda 里的 ViewNode 对象不继承自 UIView,计算高度的时候 不需要创建 view,也不操作 layer，开销更小；可以繁重把 text layout 计算从主线程剥离出去
2. 默认会缓存住 text layout 对象和结果，减少 text layout 计算过程，即使再次 layout 也不需要再 text layout 上耗时
3. 不会重新创建线性方程求解器和添加约束；更新 `intrincContentSize` 不会重新创建约束，只会更新约束常量。重复利用 Cassowary 的优势。
4. 对于多行文本，提供 `fixedWidth` 优化属性，大部分情况下可以避免一部分 text layout
5. 支持异步绘制，利用多线程提高效率。
6. 算高度的时候也可以缓存住所有子 view 的 frame，然后在 `cellForRowAIndexPath` 中可以禁止自动布局，直接使用缓存数据，防止重复计算。

Panda 使用也很简单, ViewNode，TextNode,ImageNode 分别代替 UIView,UILabel 和 UIImage,然后就可以像 autolayout 一样布局

```Swift 
let node = ViewNode()
let node1 = ViewNode()
let node2 = TextNode()

textNode.text = "hehe"

node.addSubnode(node1)
node.addSubnode(node2)

node1.size == (30,30)
node2.size == (40,40)
  
[node,node1].equal(.centerY,.left)  
/// 等价于
/// node.left == node1.left
/// node.centerY == node2.centerY
/// 或者 
/// node.left.equalTo(node1.left)
/// node.centerY.equalTo(node1.centerY)

[node2,node].equal(.top,.bottom,.centerY,.right)
[node1,node2].space(10, axis: .horizontal)

/// 支持约束优先级
node.width == 100 ~.strong 
node.height == 200 ~ 760.0
update constant

/// 更新约束
let c =  node.left ==  10
c.constant = 100
  
```

在上面提到的微博 Feed demo 中，只用 500 行代码就可以实现非常流程的列表。开发效率和运行效率都远超手算 frame。代码更少，维护起来更方便。

对比 Texture(或者说 AsyncDisplayKit), Panda

1. 集成成本更低。Panda 代码更少；使用上也不需要替换 UITabelView 或者 cell ,只需要实现 contentView 内容即可。
2. 学习成本更低，API 和 思想上和 autolayout 都是一致的，对于 autolayout 使用者基本零门槛
3. 完全 Swift 实现，对于使用 swift 的项目更友好。
4. 开发效率和运行效率不输 Texture