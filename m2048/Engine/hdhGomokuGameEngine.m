//
//  hdhGomokuGameEngine.m
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "hdhGomokuGameEngine.h"
#import "hdhGomokuChessboard.h"
#import "hdhGomokuActualStack.h"
#import "hdhGomokuEnvisionStack.h"
@interface hdhGomokuGameEngine ()
@property(nonatomic,strong)hdhGomokuActualStack * actualStack;

@property(nonatomic)NSInteger depth;
@end

@implementation hdhGomokuGameEngine

+(instancetype)game
{
    static hdhGomokuGameEngine * game=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        game=[[hdhGomokuGameEngine alloc]init];
    });
    return game;
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        _chessBoard=[[hdhGomokuChessboard alloc]init];
        _actualStack=[[hdhGomokuActualStack alloc]init];
        _envisionStack=[[hdhGomokuEnvisionStack alloc]init];
        _maxDepth=2;
    }
    return self;
}
-(void)setPlayerFirst:(BOOL)playerFirst
{
    _playerFirst=playerFirst;
    _envisionStack.playerFirst=playerFirst;
}

-(void)playerChessDown:(NSInteger)row line:(NSInteger)line
{
    hdhGomokuChessPoint * point=[self.chessBoard pointAtRow:row line:line];
    if (point) {
        if (point.chess) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(game:error:)]) {
                [self.delegate game:self error:hdhGameErrorTypeChessAxist];
            }
        }else if(self.gameStatu==hdhGameStatuComputerChessing){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(game:error:)]) {
                [self.delegate game:self error:hdhGameErrorTypeComputerIsChessing];
            }
        }else if(self.gameStatu==hdhGameStatuPlayChessing){
            BOOL finish=NO;
            if (self.playerFirst) {
                finish=[self chessDown:point chessType:hdhGomokuChessTypeBlack];
            }else{
                finish=[self chessDown:point chessType:hdhGomokuChessTypeWhite];
            }
            if (!finish) {
                [self computerPrepareChess];
            }
        }
    }
}

-(BOOL)chessDown:(hdhGomokuChessPoint*)point chessType:(hdhGomokuChessType)chessType
{
    hdhGomokuChessElement * element=[hdhGomokuChessElement getChess:chessType];
    point.chess=element;
    [_actualStack push:point];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(game:updateSences:)]) {
        [self.delegate game:self updateSences:point];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(game:playSound:)]) {
        [self.delegate game:self playSound:hdhGameSoundTypeStep];
    }
    return [self determine];   //判断胜负
}

-(void)computerPrepareChess
{
    [self.envisionStack reuse];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
        [self.delegate game:self statuChange:hdhGameStatuComputerChessing];
    }
    self.gameStatu=hdhGameStatuComputerChessing;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        hdhGomokuChessPoint*point=[self computerCalculateBestStep];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gameStatu=hdhGameStatuPlayChessing;
            if (self.playerFirst) {
                [self chessDown:point chessType:hdhGomokuChessTypeWhite];
            }else{
                [self chessDown:point chessType:hdhGomokuChessTypeBlack];
            }
            if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
                [self.delegate game:self statuChange:hdhGameStatuPlayChessing];
            }
        });
    });
}
-(hdhGomokuChessPoint*)computerCalculateBestStep
{
    if ([self.actualStack depth]==1) {      //开局  电脑为白子（后手）
        return [self opening_depth_1];
    }else if([self.actualStack depth]==2){
        hdhGomokuChessPoint * point=[self opening_depth_2];
        if (point==nil) {
            return [self computerCalculateBestStepAuto];
        }else{
            return point;
        }
    }else{
        return [self computerCalculateBestStepAuto];
    }
}


-(hdhGomokuChessPoint*)opening_depth_1
{
    hdhGomokuChessPoint * point=[self.actualStack getTopElement];
    int x = arc4random() % 2;
    NSInteger row,line;
    if (x==0) {
        if (point.row>=5&&point.row<=11&&point.line>=5&&point.line<=11) {
            int y = arc4random() % 4;
            if (y==0) {
                row=point.row-1;
                line=point.line;
            }else if(y==1){
                row=point.row;
                line=point.line-1;
            }else if(y==2){
                row=point.row+1;
                line=point.line;
            }else{
                row=point.row;
                line=point.line+1;
            }
        }
        else if(point.row<5){
            if (point.line<5) {
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }else if(point.line>11){
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }else{
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }
        }
        else if(point.row>11){
            if (point.line<5) {
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row-1;
                    line=point.line;
                }
            }else if(point.line>11){
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else{
                    row=point.row-1;
                    line=point.line;
                }
                
            }else{
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row-1;
                    line=point.line;
                }
            }
        }
        else{
            if (point.line<5) {
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row-1;
                    line=point.line;
                }else if(y==1){
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }else{
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row-1;
                    line=point.line;
                }else if(y==1){
                    row=point.row;
                    line=point.line-1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }
        }
    }else{
        if (point.row>=5&&point.row<=11&&point.line>=5&&point.line<=11) {
            int y = arc4random() % 4;
            if (y==0) {
                row=point.row-1;
                line=point.line-1;
            }else if(y==1){
                row=point.row+1;
                line=point.line-1;
            }else if(y==2){
                row=point.row-1;
                line=point.line+1;
            }else{
                row=point.row+1;
                line=point.line+1;
            }
        }
        else if(point.row<5){
            if (point.line<5) {
                row=point.row+1;
                line=point.line+1;
            }else if(point.line>11){
                row=point.row+1;
                line=point.line-1;
            }else{
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row+1;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row+1;
                    line=point.line+1;
                }
            }
        }
        else if(point.row>11){
            if (point.line<5) {
                row=point.row-1;
                line=point.line+1;
            }else if(point.line>11){
                row=point.row-1;
                line=point.line-1;
            }else{
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row-1;
                    line=point.line+1;
                }else if(y==1){
                    row=point.row-1;
                    line=point.line-1;
                }
            }
        }
        else{
            if (point.line<5) {
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row-1;
                    line=point.line+1;
                }else if(y==1){
                    row=point.row+1;
                    line=point.line+1;
                }
            }else{
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row-1;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row+1;
                    line=point.line-1;
                }
            }
        }
    }
    return[self.chessBoard pointAtRow:row line:line];
}

-(hdhGomokuChessPoint*)opening_depth_2
{
    return nil;
}

-(hdhGomokuChessPoint*)computerCalculateBestStepAuto
{
    if (_maxDepth==1) {
        [self calculateDepth1];
    }else if(_maxDepth==2){
        [self calculateDepth2];
    }else{
        [self calculateDepth3];
    }
    return self.envisionStack.maxPoint;
}


-(BOOL)determine
{
    NSInteger value=[self.chessBoard determine];
    if (value==1) { //黑棋胜利
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:finish:)]) {
            [self.delegate game:self finish:self.playerFirst];
        }
        self.gameStatu=hdhGameStatuFinished;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:self.gameStatu];
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:playSound:)]) {
            if (self.playerFirst) {
                [self.delegate game:self playSound:hdhGameSoundTypeVictory];
            }else{
                [self.delegate game:self  playSound:hdhGameSoundTypeFailed];
            }
        }
        return YES;
    }else if(value==2){ //白棋胜利
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:finish:)]) {
            [self.delegate game:self finish:!self.playerFirst];
        }
        self.gameStatu=hdhGameStatuFinished;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:self.gameStatu];
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:playSound:)]) {
            if (!self.playerFirst) {
                [self.delegate game:self playSound:hdhGameSoundTypeVictory];
            }else{
                [self.delegate game:self  playSound:hdhGameSoundTypeFailed];
            }
        }
        return YES;
    }
    return NO;
}

-(void)begin
{
    if (self.playerFirst) {
        self.gameStatu=hdhGameStatuPlayChessing;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:hdhGameStatuPlayChessing];
        }
    }else{
        self.gameStatu=hdhGameStatuComputerChessing;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:hdhGameStatuComputerChessing];
        }
        hdhGomokuChessPoint* point=[self.chessBoard pointAtRow:CenterRow line:CenterRow];
        [self chessDown:point chessType:hdhGomokuChessTypeBlack];
        self.gameStatu=hdhGameStatuPlayChessing;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:hdhGameStatuPlayChessing];
        }
    }
}

-(void)reStart
{
    if (self.gameStatu!=hdhGameStatuComputerChessing) {
        _chessBoard=[[hdhGomokuChessboard alloc]init];
        _actualStack=[[hdhGomokuActualStack alloc]init];
        _envisionStack=[[hdhGomokuEnvisionStack alloc]init];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(gameRestart:)]) {
            [self.delegate gameRestart:self];
        }
        [self begin];
    }
}

-(BOOL)undo
{
    if (self.gameStatu!=hdhGameStatuFinished&&self.gameStatu!=hdhGameStatuComputerChessing) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:undo:)]) {
            hdhGomokuChessPoint*point=[self.actualStack pop];
            [self.delegate game:self undo:point];
            
            point=[self.actualStack pop];
            [self.delegate game:self undo:point];
            return YES;
        }
    }
    return NO;
}

-(BOOL)calculateDepth1
{
    __block BOOL pruning=NO;
    [self.chessBoard enumerateFrom:[self getLastChessPoint] callback:^(hdhGomokuChessPoint *point) {
        if ([self.chessBoard couldChessDowm:point]){
            NSInteger depth=[self.envisionStack depth];
            if (depth%2==0) {
                if (self.playerFirst) {
                    [self.envisionStack push:point type:hdhGomokuChessTypeWhite];
                }else{
                    [self.envisionStack push:point type:hdhGomokuChessTypeBlack];
                }
            }else{
                if (self.playerFirst) {
                    [self.envisionStack push:point type:hdhGomokuChessTypeBlack];
                }else{
                    [self.envisionStack push:point type:hdhGomokuChessTypeWhite];
                }
            }
            NSInteger score=[self.chessBoard calculate];
            [self.envisionStack pushLeafValue:score];
            [self.envisionStack pop];
            if ([self.envisionStack pruning]) {
                pruning=YES;
                return YES;
            }
        }
        return  NO; 
    }];
    return pruning;
}

-(BOOL)calculateDepth2
{
    __block BOOL pruning=NO;
    [self.chessBoard enumerateFrom:[self getLastChessPoint] callback:^(hdhGomokuChessPoint *point) {
        if ([self.chessBoard couldChessDowm:point]){
            NSInteger depth=[self.envisionStack depth];
            if (depth%2==0) {
                if (self.playerFirst) {
                    [self.envisionStack push:point type:hdhGomokuChessTypeWhite];
                }else{
                    [self.envisionStack push:point type:hdhGomokuChessTypeBlack];
                }
            }else{
                if (self.playerFirst) {
                    [self.envisionStack push:point type:hdhGomokuChessTypeBlack];
                }else{
                    [self.envisionStack push:point type:hdhGomokuChessTypeWhite];
                }
            }
         //   NSLog(@"\n\n\n\n");
         //   NSLog(@"Row_1 :%d  Line_1:%d",point.row,point.line);
            if ([self calculateDepth1]) {
                [self.envisionStack onlyPop];
            }else{
                [self.envisionStack pop];
            }
            if ([self.envisionStack pruning]) {
                pruning=YES;
                return YES;
            }
        }
        return NO;
    }];
    return pruning;
}

-(void)calculateDepth3
{
    [self.chessBoard enumerateFrom:[self getLastChessPoint] callback:^(hdhGomokuChessPoint *point) {
        if ([self.chessBoard couldChessDowm:point]){
            NSInteger depth=[self.envisionStack depth];
            if (depth%2==0) {
                if (self.playerFirst) {
                    [self.envisionStack push:point type:hdhGomokuChessTypeWhite];
                }else{
                    [self.envisionStack push:point type:hdhGomokuChessTypeBlack];
                }
            }else{
                if (self.playerFirst) {
                    [self.envisionStack push:point type:hdhGomokuChessTypeBlack];
                }else{
                    [self.envisionStack push:point type:hdhGomokuChessTypeWhite];
                }
            }
            if ([self calculateDepth2]) {
                [self.envisionStack onlyPop];
            }else{
                [self.envisionStack pop];
            }
            if ([self.envisionStack pruning]) {
                return YES;
            }
        }
        return NO;
    }];
}

-(hdhGomokuChessPoint*)getLastChessPoint
{
    hdhGomokuChessPoint * point=[self.envisionStack getTopElement];
    if (point==nil) {
        point=[self.actualStack getTopElement];
    }
    return point;
}




@end
