//
//  hdhGomokuEnvisionStack.m
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "hdhGomokuEnvisionStack.h"

@implementation hdhGomokuValue
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.value=0;
    }
    return self;
}
@end


@interface hdhGomokuEnvisionStack ()
@property(nonatomic,strong)NSMutableArray * values;

@end

@implementation hdhGomokuEnvisionStack
-(instancetype)init
{
    self=[super init];
    if (self ) {
        _values=[NSMutableArray array];
    }
    return self;
}
-(void)reuse
{
 //   NSLog(@"\n\n\n\n\n\n\n **********************");
    [super  reuse];
    _maxPoint=nil;
    _maxValue=nil;
    _values=[NSMutableArray array];
}

-(void)push:(hdhGomokuChessPoint*)element type:(hdhGomokuChessType)type
{
    if (element.chess!=nil) {
        return;
    }
    element.virtualChessType=type;
    [super push:element];
    [_values addObject:[[hdhGomokuValue alloc]init]];
}

-(hdhGomokuChessPoint*)onlyPop
{
    NSInteger depth=[self depth];
    if (depth==0) {
        return nil;
    }
    hdhGomokuChessPoint * point=[super pop];
    point.virtualChessType=hdhGomokuChessTypeEmpty;
    [_values removeObjectAtIndex:_values.count-1];
    return point;
}

-(hdhGomokuChessPoint*)pop
{
    NSInteger depth=[self depth];
    if (depth==0) {
        return nil;
    }
    hdhGomokuChessPoint * point=[super pop];
    point.virtualChessType=hdhGomokuChessTypeEmpty;
    hdhGomokuValue * value=[_values lastObject];
    if (depth==1) {
        if (_maxValue==nil) {
            _maxValue=[[hdhGomokuValue alloc]init];
            _maxValue.value=value.value;
            _maxPoint=point;
         //   NSLog(@"ROW: %d , LINE:%d  score :%d",point.row,point.line,self.maxValue.value);
        }
        if (value.value>_maxValue.value) {
            _maxValue.value=value.value;
            _maxPoint=point;
         //   NSLog(@"ROW: %d , LINE:%d  score :%d",point.row,point.line,self.maxValue.value);
        }
    }
    [_values removeObjectAtIndex:_values.count-1];
    if (_values.count>0) {
        hdhGomokuValue * valueBottom=[_values lastObject];
        if (valueBottom.hasValue) {
            if (depth%2==0) {
                valueBottom.value=valueBottom.value<value.value?valueBottom.value:value.value;
            }else{
                valueBottom.value=valueBottom.value>value.value?valueBottom.value:value.value;
            }
        }else{
            valueBottom.value=value.value;
            valueBottom.hasValue=YES;
        }
    }
    return point;
}

-(void)pushLeafValue:(NSInteger)value
{
    hdhGomokuValue * valueBottom=[_values lastObject];
    valueBottom.hasValue=YES;
    valueBottom.value=value;
}

-(BOOL)pruning
{
    NSInteger depth=[self depth];
    if (depth>0) {
        hdhGomokuValue * bottomValue=[_values lastObject];
        hdhGomokuValue *secondValue;
        if (depth>1) {
            secondValue=[_values objectAtIndex:depth-2];
        }else if(self.maxValue){
            secondValue=self.maxValue;
        }
        if (secondValue) {
            if (depth%2==0) {
                if (bottomValue.value>=secondValue.value) {
                    return YES;
                }else{
                    return NO;
                }
            }else{
                if (bottomValue.value<=secondValue.value) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
    }
    return NO;
}



@end
