//
//  hdhGomokuChessboard.h
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//


// 棋局的抽象

#define RowCount 15
#define CenterRow 8

#import <Foundation/Foundation.h>
#import "hdhGomokuChessPoint.h"



@interface NSNumber (cache)
+(NSNumber*)cahceNumber:(NSInteger)value;
@end



@interface hdhGomokuChessboard : NSObject<hdhGomokuChessPointProtocol>
@property(nonatomic,strong,readonly)NSArray * points;
@property(nonatomic,strong)NSArray * successPoints; //胜利的五个子
+(instancetype)newChessboard;

-(hdhGomokuChessPoint*)pointAtRow:(NSInteger)row line:(NSInteger)line;

-(BOOL)couldChessDowm:(hdhGomokuChessPoint*)point;


-(NSInteger)calculate;

-(NSInteger)determine; // 0: 谁也没胜 ， 1 : 黑棋胜利   2:  白棋胜利

-(void)enumerateFrom:(hdhGomokuChessPoint*)point callback:(BOOL(^)(hdhGomokuChessPoint*))callback; // 从最后落子点的周围开始枚举

@end
