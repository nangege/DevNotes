//
//  TestLabel.h
//  Autolayout
//
//  Created by nangezao on 2018/9/11.
//  Copyright © 2018 Tang Nan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSISVariable.h"
#import "NSISLinearExpression.h"
#import "Foundation-Structs.h"

NS_ASSUME_NONNULL_BEGIN


typedef struct RowExpression {
  NSISVariable *variable;
  NSISLinearExpression __strong **row;
} RowExpression;

typedef struct XXRows {
  struct RowExpression * blocks;
  unsigned long long  blocksCount;
  unsigned long long blocksCapacity;
  NSMutableIndexSet __strong *freeIndexes;
} XXRows;

typedef struct Expression{
  unsigned short inline_capacity;
  unsigned int var_count;
  double constant;
  SCD_Union_NS65 data;
}Expression;

@interface TestLabel : UILabel

@end

NS_ASSUME_NONNULL_END
