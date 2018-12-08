//
//  hdhGomokuChessElement.m
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "hdhGomokuChessElement.h"

@implementation hdhGomokuChessElement
+(instancetype)getChess:(hdhGomokuChessType)type
{
    hdhGomokuChessElement * chess=[[hdhGomokuChessElement alloc]initWithType:type];
    return chess;
    
}
-(instancetype)initWithType:(hdhGomokuChessType)type{
    self=[super init];
    if (self) {
        _type=type;
    }
    return self;
}

@end
