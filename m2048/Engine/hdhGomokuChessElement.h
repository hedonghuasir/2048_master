//
//  hdhGomokuChessElement.h
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

// 棋子
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, hdhGomokuChessType) {
    hdhGomokuChessTypeEmpty=0, // 空白
    hdhGomokuChessTypeBlack=1, // 黑子
    hdhGomokuChessTypeWhite=2, // 白子
};

@interface hdhGomokuChessElement : NSObject
@property(nonatomic,readonly) hdhGomokuChessType type;
+(instancetype)getChess:(hdhGomokuChessType)type;
@end
