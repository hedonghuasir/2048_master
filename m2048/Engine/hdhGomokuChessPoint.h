//
//  hdhGomokuChessPoint.h
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

// 棋盘的某个棋子落子点

#import <Foundation/Foundation.h>
#import "hdhGomokuChessElement.h"

@class hdhGomokuChessPoint;

@protocol hdhGomokuChessPointProtocol <NSObject>

-(void)chessPointStatuChanged:(hdhGomokuChessPoint*)point;

@end

@interface hdhGomokuChessPoint : NSObject

@property(nonatomic,strong)hdhGomokuChessElement * chess;
@property(nonatomic)hdhGomokuChessType  virtualChessType;  // 该位子上的虚拟棋子类型 （仅当chess 为空时有效）
@property(nonatomic,readonly)NSInteger row;
@property(nonatomic,readonly)NSInteger line;
@property(nonatomic)BOOL couldEnum;
@property(nonatomic,strong)id<hdhGomokuChessPointProtocol>delegate;
+(instancetype)pointAtRow:(NSInteger)row line:(NSInteger)row;

-(void)statuChanged;

@end
