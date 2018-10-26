//
//  ViewController.m
//  Autolayout
//
//  Created by nangezao on 2018/9/5.
//  Copyright © 2018 Tang Nan. All rights reserved.
//

#import "ViewController.h"
#import "NSLayoutConstraint.h"
#import "NSISLinearExpression.h"
#import "UIWindow.h"
#import "NSISVariable.h"
#import "NSISEngine.h"
#import "TestLabel.h"
#import <objc/runtime.h>
#import "Foundation-Structs.h"

typedef struct Rows {
  NSISVariable __strong ** blocks;
  int  blocksCount;
  int blocksCapacity;
  NSISLinearExpression *expression;
  NSISVariable __strong **freeIndexes;
} Rows;


@interface NSObject(hehe)

- (void)logAllProperties;

- (void)logAlliVars;

- (void)logMethodList;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  

  UIView * view1 = [[UIView alloc] init];
  NSLayoutConstraint *c = [view1.leftAnchor constraintEqualToAnchor:self.view.leftAnchor];
  NSISLinearExpression *expression = c._loweredExpression;
  NSISVariable *var1 = expression.variablesArray[0];
  
  TestLabel *label = [[TestLabel alloc] init];
  label.translatesAutoresizingMaskIntoConstraints = false;
  label.numberOfLines = 0;

//  [label.superclass logAllProperties];
//  [label.superclass logAlliVars];
//  [label.superclass logMethodList];
//
//  [expression logAllProperties];
//  [expression logAlliVars];
//  [expression logMethodList];
  
  // {?="inline_capacity"S"var_count"I"constant"d"data"(?="extern_data"{?="stored_extern_marker"@"slab"^{?}"capacity"Q}"inline_slab"{?="aligner"Q}"padding"[48C])}
  // expr type: {Expression="inline_capacity"S"var_count"i"constant"d"data"(?="extern_data"{?="stored_extern_marker"@"slab"^v"capacity"Q}"inline_slab"{?="aligner"Q}"padding"[48C])}
  
  
  
  [self.view addSubview:label];
  [label.widthAnchor constraintEqualToConstant:300].active = true;
  label.text = @"fdfdsgfsgsgddddddddddddasdafafagseyerherhegdgdgrdgaragg";
  
//  NSLayoutConstraint *labelC = [label.widthAnchor constraintEqualToConstant:10];
//  labelC.priority = UILayoutPriorityDefaultLow;
//  labelC.active = true;
  
//  NSLog(@"%@", label);
//  NSLog(@"%@",expression);
  
  NSLayoutConstraint *c2 = [view1.rightAnchor constraintEqualToAnchor:self.view.rightAnchor];
//  NSLog(@"%@", c2._layoutEngine);

  [self.view addSubview:view1];
  [self.view layoutIfNeeded];
  
  label.text = @"ddvsdvsdvs生产技术出口斯诺克领scsdvddbvdbdbdbd是";
  [self.view layoutIfNeeded];
  
  UIView * view3 = [[UIView alloc] init];
  
  view3.translatesAutoresizingMaskIntoConstraints = false;
  NSLayoutConstraint *c3 =  [view3.widthAnchor constraintEqualToConstant:10];
  c3.priority = UILayoutPriorityDefaultHigh;
  c3.active = true;
  
  for(NSUInteger i = 0; i < 3; i++){
    NSLog(@"View3LayoutIfNeeded");
    [view3 setNeedsLayout];
    [view3 layoutIfNeeded];
  }
  
  for(NSUInteger i = 0; i < 3; i++){
    NSLog(@"No superview systemLayoutSizeFittingSize");
    [view3 setNeedsLayout];
    [view3 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  }
  NSLog(@"%@", view3.constraints);
  [self.view addSubview:view3];
  
  for(NSUInteger i = 0; i < 3; i++){
    NSLog(@"View3LayoutIfNeededSecondPass");
    c3.constant = rand()%20;
    [view3 setNeedsLayout];
    [view3 layoutIfNeeded];
  }
  
  for(NSUInteger i = 0; i < 3; i++){
    NSLog(@"systemLayoutSizeFittingSize");
    c3.constant = rand()%20;
    CGSize size = [view3 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  }
  
  NSLog(@"%@", c3._layoutEngine);
  NSLog(@"%@", view3);
  
  [NSLayoutConstraint activateConstraints:@[c,c2]];

  NSISEngine *enginer = c2._layoutEngine;
  NSLog(@"%@", enginer);
  
//  NSArray<NSISVariable *> * rowHeader = enginer.allRowHeads;
//  for (NSISVariable * var in rowHeader){
//    NSLog(@"%@", var);
//  }
//  [self.view addConstraint:c2];
  NSISLinearExpression *e2 = c2._loweredExpression;
  NSISVariable *var = (NSISVariable *)e2.variablesArray[2];
//  NSLog(@"%@", var.crossIndexSet);
//  [var logAlliVars];
//  // enumerateEngineVars
//  // enumerateCols
//  [enginer enumerateRows:^(id ob,XXRows *value,BOOL *index){
//    //NSLog(@"%@", (*value) -> blocksCount);
////    *index = true;
//  }];
  [enginer logAllProperties];
  [enginer logAlliVars];
  [enginer logMethodList];

  
  NSLog(@"%lu", (unsigned long)[(NSISVariable *)e2.variablesArray[0] hash]) ;
  NSLog(@"%@", e2) ;
  
//  struct Expression *expr = Expression;
//  NSValue *value = [expression valueForKey:@"linExp"];
//  [value getValue:expr];
  
  for (NSLayoutConstraint * constraint in label.constraints){
    //NSLog(@"%@",constraint);
    //NSLog(@"%@", constraint._loweredExpression);
  }
  
  NSString *version = [UIDevice currentDevice].systemVersion;
  
  if(version.doubleValue < 12.0) {
    NSLog(@"%@", enginer.rows);
    NSLog(@"%@",enginer.rowsCrossIndex);
  }

}


@end


@implementation NSObject(hehe)

- (void)logMethodList{
  unsigned int methodCount = 0;
  Method *methods = class_copyMethodList([self class], &methodCount);
  for (int i = 0; i < methodCount; i++){
    Method method = *(methods + i);
    SEL name = method_getName(method);
    int count = method_getNumberOfArguments(method);
    
    NSLog(@"%s",sel_getName(name));
    //    NSLog(@"%i",count);
    //
    //    const char *type = method_getTypeEncoding(method);
    //    NSLog(@"%s",type);
    //
    //    for(int j = 0 ; j < count; j ++){
    //      const char *type = method_copyArgumentType(method, j);
    //
    //      NSLog(@"%s",type);
    //    }
    
  }
}

- (void)logAlliVars {
  unsigned int count;
  Ivar *ivars = class_copyIvarList([self class], &count);
  
  for (unsigned int i = 0; i < count; i++) {
    Ivar ivar = ivars[i];
    
    const char *name = ivar_getName(ivar);
    NSLog(@"%s", name);
    
    const char *type = ivar_getTypeEncoding(ivar);
    
    NSLog(@"name: %s type: %s ",name,type);
    
//    ptrdiff_t offset = ivar_getOffset(ivar);
//
//    if (strncmp(type, "i", 1) == 0) {
//      int intValue = *(int*)((uintptr_t)self + offset);
//      NSLog(@"%s = %i", name, intValue);
//    } else if (strncmp(type, "f", 1) == 0) {
//      float floatValue = *(float*)((uintptr_t)self + offset);
//      NSLog(@"%s = %f", name, floatValue);
//    } else if (strncmp(type, "@", 1) == 0) {
//      id value = object_getIvar(self, ivar);
//      NSLog(@"%s = %@", name, value);
//    }else if (strncmp(type, "B", 1) == 0) {
//      BOOL intValue = *(BOOL*)((uintptr_t)self + offset);
//      NSLog(@"%s = %i", name, intValue);
//    }else if (strncmp(type, "I", 1) == 0) {
//      int intValue = *(int*)((uintptr_t)self + offset);
//      NSLog(@"%s = %i", name, intValue);
//    }else if (strncmp(type, "{CGSize='width'd'height'd}", 26) == 0) {
//      CGSize intValue = *(CGSize*)((uintptr_t)self + offset);
//      NSLog(@"%s = { %f , %f}", name, intValue.width,intValue.height);
//    }else if (strncmp(type, "{?='blocks'^{?}'blocksCount'Q'blocksCapacity'Q'freeIndexes'@'NSMutableIndexSet'}", 3) == 0) {
//      struct XXRows row = *(XXRows*)((uintptr_t)self + offset);
//      NSLog(@"name: %s type: %s ",name,type);
//    }else if (strncmp(type, "[2{?='blocks'^{?}'blocksCount'Q'blocksCapacity'Q'freeIndexes'@'NSMutableIndexSet'}]", 3) == 0) {
//      NSLog(@"name: %s type: %s ",name,type);
//      struct XXRows *row = (XXRows*)((uintptr_t)self + offset);
//    }else{
//
//
//      NSLog(@"name: %s type: %s ",name,type);
//    }
//    // And the rest for other type encodings
  }
  
  free(ivars);
}

- (void)logAllProperties{
  
    unsigned int pcount = 0;
  
    objc_property_t *pvars = class_copyPropertyList([self class], &pcount);
  
    for (int i = 0; i<pcount; i++) {
      // 取出成员变量
      objc_property_t ivar = *(pvars + i);
  
      const char *name = property_getName(ivar);
      // 打印成员变量名字
      NSLog(@"%s", name);
  
      // 打印成员变量的数据类型
  //    NSLog(@"%s", ivar_getTypeEncoding(ivar));
    }
  
    free(pvars);
  
}


@end
