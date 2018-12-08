//
//  hdhGomokuBaseStack.m
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "hdhGomokuBaseStack.h"

@interface hdhGomokuBaseStack ()
@property(nonatomic,strong)NSMutableArray * datas;
@end

@implementation hdhGomokuBaseStack

-(void)reuse
{
    _datas=[NSMutableArray array];
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        _datas=[NSMutableArray array];
    }
    return self;
}

-(void)push:(hdhGomokuChessPoint*)element
{
    if (element) {
        [element statuChanged];
        [_datas addObject:element];
    }
}

-(hdhGomokuChessPoint*)pop
{
    if (_datas.count==0) {
        return nil;
    }
    hdhGomokuChessPoint * point=[_datas objectAtIndex:_datas.count-1];
    point.chess=nil;
    [point statuChanged];
    [_datas removeObjectAtIndex:_datas.count-1];
    return point;
}
-(NSInteger)depth
{
    return _datas.count;
}

-(hdhGomokuChessPoint*)getTopElement
{
    return [_datas lastObject];
}

@end
