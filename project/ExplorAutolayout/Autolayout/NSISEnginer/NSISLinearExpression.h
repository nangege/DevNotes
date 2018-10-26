/*
* This header is generated by classdump-dyld 1.0
* on Thursday, January 25, 2018 at 11:20:40 PM Eastern European Standard Time
* Operating System: Version 11.1.2 (Build 15B202)
* Image Source: /System/Library/Frameworks/Foundation.framework/Foundation
* classdump-dyld is licensed under GPLv3, Copyright © 2013-2016 by Elias Limneos.
*/

#import <Foundation/Foundation.h>
#import "NSISRowBody.h"
#import "Foundation-Structs.h"

@class NSString;

@interface NSISLinearExpression : NSObject <NSISRowBody, NSFastEnumeration> {

	unsigned inline_capacity;
	unsigned var_count;
	double constant;
  SCD_Union_NS65* data;

}

@property (assign) double constant; 
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
+(id)newExpressionWithCapacity:(unsigned long long)arg1 ;
+(id)acquireFromPoolForUseCase:(long long)arg1 ;
+(void)initialize;
-(unsigned long long)variableCount;
-(id)variablesArray;
-(void)verifyInternalIntegrity;
-(void)enumerateVariablesAndCoefficients:(/*^block*/id)arg1 ;
-(void)removeVariable:(id)arg1 ;
-(void)addVariable:(id)arg1 coefficient:(double)arg2 processVariableNewToReceiver:(/*^block*/id)arg3 processVariableDroppedFromReceiver:(/*^block*/id)arg4 ;
-(void)addExpression:(id)arg1 times:(double)arg2 processVariableNewToReceiver:(/*^block*/id)arg3 processVariableDroppedFromReceiver:(/*^block*/id)arg4 ;
-(void)replaceVariable:(id)arg1 withVariablePlusDelta:(double)arg2 timesVariable:(id)arg3 processVariableNewToReceiver:(/*^block*/id)arg4 processVariableDroppedFromReceiver:(/*^block*/id)arg5 ;
-(void)enumerateVariables:(/*^block*/id)arg1 ;
-(id)copyContentsAndReturnToPool;
-(BOOL)enumerateVariablesAndCoefficientsUntil:(/*^block*/id)arg1 ;
-(void)replaceVariable:(id)arg1 withVariablePlusDelta:(double)arg2 ;
-(void)replaceVariable:(id)arg1 withVariable:(id)arg2 coefficient:(double)arg3 ;
-(void)replaceVariable:(id)arg1 withExpression:(id)arg2 processVariableNewToReceiver:(/*^block*/id)arg3 processVariableDroppedFromReceiver:(/*^block*/id)arg4 ;
-(id)initWithInlineCapacity:(unsigned long long)arg1 ;
-(double)coefficientForVariable:(id)arg1 ;
-(void)setCoefficient:(double)arg1 forVariable:(id)arg2 ;
-(void)returnToPool;
-(id)init;
//-(unsigned long long)countByEnumeratingWithState:(SCD_Struct_NS5*)arg1 objects:(id*)arg2 count:(unsigned long long)arg3 ;
-(void)dealloc;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(NSString *)description;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)setConstant:(double)arg1 ;
-(double)constant;
-(BOOL)isConstant;
-(double)incrementConstant:(double)arg1 ;
-(void)addVariable:(id)arg1 coefficient:(double)arg2 ;
-(void)addExpression:(id)arg1 times:(double)arg2 ;
-(void)scaleBy:(double)arg1 ;
@end

