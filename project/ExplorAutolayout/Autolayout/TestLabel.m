//
//  TestLabel.m
//  Autolayout
//
//  Created by nangezao on 2018/9/11.
//  Copyright © 2018 Tang Nan. All rights reserved.
//

#import "TestLabel.h"
#import "UIView.h"

@interface TestLabel(){
  XXRows row[2];
  Expression expr;
}

@end

@implementation TestLabel

-(void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth{
  [super setPreferredMaxLayoutWidth:preferredMaxLayoutWidth];
}

- (CGSize)intrinsicContentSize{
  CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
  CGSize size = super.intrinsicContentSize;
  CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
  CFAbsoluteTime time = (end - start)*100000/100;
  NSLog(@"time: %f",time);
  
  NSLog(@"width: %f, height: %f",size.width,size.height);
  return [super intrinsicContentSize];
}

- (BOOL)_needsDoubleUpdateConstraintsPass{
  BOOL needDouble = [super _needsDoubleUpdateConstraintsPass];
  NSLog(@"needDoubleUpdateConstraintsPass %d", needDouble);
  return needDouble;
}

@end
