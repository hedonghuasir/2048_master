//
//  hdhGomokuChessPoint.m
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "hdhGomokuChessPoint.h"

@implementation hdhGomokuChessPoint
+(instancetype)pointAtRow:(NSInteger)row line:(NSInteger)line 
{
    return [[hdhGomokuChessPoint alloc]initWithRow:row line:line];
}
-(instancetype)initWithRow:(NSInteger)row line:(NSInteger)line
{
    self=[super init];
    if (self) {
        _row=row;
        _line=line;
    }
    return self;
}
-(void)statuChanged
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(chessPointStatuChanged:)]) {
        [self.delegate chessPointStatuChanged:self];
    }
}

@end
