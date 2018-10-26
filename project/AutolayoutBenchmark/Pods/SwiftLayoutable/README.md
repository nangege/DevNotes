## Layoutable 
[![Version](https://img.shields.io/cocoapods/v/SwiftLayoutable.svg?style=flat)](http://cocoapods.org/pods/SwiftLayoutable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![](https://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()
[![Swift 4.0](https://img.shields.io/badge/Swift-4.2-orange.svg)]()
<a href="https://travis-ci.org/https://travis-ci.org/nangege/Layoutable"><img src="https://travis-ci.org/nangege/Layoutable.svg?branch=master"></a>



Layoutable is a swift reimplement of apple's Autolayout. It uses the same [Cassowary ](https://constraints.cs.washington.edu/cassowary/) algorithm as it's core and provides a set of api similar to Autolayout. The difference is that Layouable is more flexable and easy to use.Layoutable don't rely on UIView, it can be used in any object that conform to Layoutable protocol such as CALaye or self defined object.It can be used in background thread which is the core benefit of Layoutable. Layoutable also provides high level api and syntax sugar to make it easy to use.

## Requirements
- iOS 8.0+
- Swift 4.2 
- Xcode 10.0 or higher

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Cocoa projects. Install it with the following command:

`$ gem install cocoapods`

To integrate Layoutable into your Xcode project using CocoaPods, specify it to a target in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  # your other pod
  # ...
  pod 'SwiftLayoutable'
end
```
Then, run the following command:

`$ pod install`

open the `{Project}.xcworkspace` instead of the `{Project}.xcodeproj` after you installed anything from CocoaPods.

For more information about how to use CocoaPods, [see this tutorial](http://www.raywenderlich.com/64546/introduction-to-cocoapods-2).


[Layoutable](https://github.com/nangege/Layoutable) rely on [Cassowary](https://github.com/nangege/Cassowary), you need to add both of them to your projetc.


### Carthage


[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager for Cocoa application. To install the carthage tool, you can use [Homebrew](http://brew.sh).

```bash
$ brew update
$ brew install carthage
```

To integrate Panda into your Xcode project using Carthage, specify it in your `Cartfile`:

```bash
github "https://github.com/nangege/Layoutable" "master"
```

Then, run the following command to build the Panda framework:

```bash
$ carthage update
```

At last, you need to set up your Xcode project manually to add the Panda,Layoutable and Cassowary framework.

On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:

```bash
/usr/local/bin/carthage copy-frameworks
```

and add the paths to the frameworks you want to use under “Input Files”:

```bash
$(SRCROOT)/Carthage/Build/iOS/Layoutable.framework
$(SRCROOT)/Carthage/Build/iOS/Cassowary.framework
```

For more information about how to use Carthage, please see its [project page](https://github.com/Carthage/Carthage).

### Manually
               
    `git clone git@github.com:nangege/Layoutable.git` ,
    `git clone git@github.com:nangege/Cassowary.git`
            
            
  then drag `Layoutable.xcodeproj` and `Cassowary.xcodeproj` file to your projrct 

On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section,add `Layoutable.framework` and `Cassowary.framework`.


## Usage

1. define your own Layout Object
 
    ```swift
    import Layoutable
	
    class TestNode: Layoutable{

      public init() {}
  
      lazy var layoutManager  = LayoutManager(self)
  
      var layoutSize = CGSize(width: InvalidIntrinsicMetric, height: InvalidIntrinsicMetric)

      weak var superItem: Layoutable? = nil
  
      var subItems = [Layoutable]()
  
      func addSubnode(_ node: TestNode){
        subItems.append(node)
        node.superItem = self
      }
  
      func layoutSubItems() {}
  
      func updateConstraint() {}
  
      var layoutRect: CGRect = .zero
  
      var itemIntrinsicContentSize: CGSize{
        return layoutSize
      }
  
      func contentSizeFor(maxWidth: CGFloat) -> CGSize {
        return InvaidIntrinsicSize
      }
  
    }

    ```

2. use Layout object to Layout
    
    ```swift
    import Layoutable   
    
    // Layout node1 and node2  horizontalally in node,space 10 and equal center in Vertical
    
    let node = TestNode()
    let node1 = TestNode()
    let node2 = TestNode()
    
    node.addSubnode(node1)
    node.addSubnode(node2)
    
    node1.size == (30,30)
    node2.size == (40,40)
	  
    [node,node1].equal(.centerY,.left)  
    [node2,node].equal(.top,.bottom,.centerY,.right)
    [node1,node2].space(10, axis: .horizontal)
	  
    node.layoutIfEnabled()
	
    print(node.frame)       //  (0.0, 0.0, 80.0, 40.0)
    print(node1.frame)      //  (0.0, 5.0, 30.0, 30.0)
    print(node2.frame)      //  (40.0, 0.0, 40.0, 40.0)
    
    ```
    
### Operation

1. basic attributes
  
    Like Autolayout, Layoutable support both Equal, lessThanOrEqual and greatThanOrEqualTo

    ```swift
     node1.left.equalTo(node2.left)
     node1.top.greatThanOrEqualTo(node2.top)
     node1.bottom.lessThanOrEqualTo(node2.bottom)
    ```
     or
	
    ```swift
     node1.left == node2.left   // can bve write as node1.left == node2  
     node1.top >= node2.top     // can bve write as node1.top >= node2
     node1.bottom <= node2.bottom // can bve write as node1.bottom <= node2
    
    ```
2. composit attribute

   beside basic attribute such as  left,right, Layoutable also provide some Composit attribute like size ,xSide,ySide,edge
   
   ```swift
    node1.xSide.equalTo(node2,insets:(10,10))
    node1.edge(node2,insets:(5,5,5,5))
    node.topLeft.equalTo(node2, offset: (10,5))
      
   ```
   or
   
   ```swift
    node1.xSide == node2.xSide + (10,10) 
    //node1.xSide == node2.xSide.insets(10)
    //node1.xSide == node2.xSide.insets((10,10))
   
    node1.edge == node2.insets((5,5,5,5))
    // node1.edge == node2 + (5,5,5,5)
    
    node.topLeft == node2.topLeft.offset((10,5))
    
   ```
 
3. update Priority

     ```swift 
     node1.width == 100 ~.strong 
     node1.height == 200 ~ 760.0
      ``` 
4. update constant

    ```swift
    let c =  node.left == node2.left + 10
    c.constant = 100
    
    ```   
 
## Supported attributes


Layoutable                   |  NSLayoutAttribute
-------------------------    |  --------------------------
Layoutable.left              |  NSLayoutAttributeLeft
Layoutable.right             |  NSLayoutAttributeRight
Layoutable.top               |  NSLayoutAttributeTop
Layoutable.bottom            |  NSLayoutAttributeBottom
Layoutable.width             |  NSLayoutAttributeWidth
Layoutable.height            |  NSLayoutAttributeHeight
Layoutable.centerX           |  NSLayoutAttributeCenterX
Layoutable.centerY           |  NSLayoutAttributeCenterY
Layoutable.size              |  width and height
Layoutable.center            |  centerX and centerY
Layoutable.xSide             |  left and right
Layoutable.ySide             |  top and bottom
Layoutable.edge              |  top,left,bottom,right
Layoutable.topLeft           |  top and left
Layoutable.topRight          |  top and right
Layoutable.bottomLeft        |  bottom and left
Layoutable.bottomRight       |  bottom and right


## Lisence

The MIT License (MIT)




