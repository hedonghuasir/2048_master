//
//  hdhGomokuGameEngine.h
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

// 游戏引擎

#import <Foundation/Foundation.h>
#import "hdhGomokuChessPoint.h"
#import "hdhGomokuEnvisionStack.h"
#import "hdhGomokuChessboard.h"
typedef NS_ENUM(NSUInteger, hdhGameSoundType) {
    hdhGameSoundTypeError,
    hdhGameSoundTypeStep,
    hdhGameSoundTypeVictory,
    hdhGameSoundTypeFailed,
    hdhGameSoundTypeTimeOver
};

typedef NS_ENUM(NSUInteger, hdhGameErrorType) {
    hdhGameErrorTypeChessAxist,
    hdhGameErrorTypeComputerIsChessing,
};

typedef NS_ENUM(NSUInteger, hdhGameStatu) {
    hdhGameStatuPlayChessing,
    hdhGameStatuComputerChessing,
    hdhGameStatuFinished
};


@class hdhGomokuGameEngine;
@protocol hdhGomokuGameEngineProtocol <NSObject>

-(void)game:(hdhGomokuGameEngine*)game updateSences:(hdhGomokuChessPoint*)point;

-(void)game:(hdhGomokuGameEngine*)game finish:(BOOL)success;

-(void)game:(hdhGomokuGameEngine*)game error:(hdhGameErrorType)errorType;

-(void)game:(hdhGomokuGameEngine*)game playSound:(hdhGameSoundType)soundType;

-(void)game:(hdhGomokuGameEngine *)game statuChange:(hdhGameStatu)gameStatu;

-(void)gameRestart:(hdhGomokuGameEngine*)game;

-(void)game:(hdhGomokuGameEngine*)game undo:(hdhGomokuChessPoint*)point;


@end

@interface hdhGomokuGameEngine : NSObject

@property(nonatomic,strong)id<hdhGomokuGameEngineProtocol>delegate;
@property(nonatomic,strong)hdhGomokuEnvisionStack * envisionStack;
@property(nonatomic,strong)hdhGomokuChessboard * chessBoard;
@property(nonatomic)hdhGameStatu gameStatu;
@property(nonatomic)NSInteger maxDepth;
@property(nonatomic)BOOL playerFirst;  //  YES : 玩家先手（黑棋）  NO :玩家后手(白棋)

+(instancetype)game;

-(void)playerChessDown:(NSInteger)row line:(NSInteger)line;

-(void)reStart;

-(BOOL)undo;

-(void)begin;


@end
