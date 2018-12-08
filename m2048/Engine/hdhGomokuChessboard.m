//
//  hdhGomokuChessboard.m
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "hdhGomokuChessboard.h"
#import "hdhGomokuChessPoint.h"
#import "hdhGomokuLinePoints.h"

@implementation NSNumber(cache)
+(NSNumber*)cahceNumber:(NSInteger)value
{
    static NSMutableArray * array=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array=[NSMutableArray array];
        for (int i=0;i<27;i++) {
            [array addObject:[NSNumber numberWithInteger:i+1]];
        }
    });
    if (value>=1&&value<=27) {
        return [array objectAtIndex:value-1];
    }else{
        return nil;
    }
}
@end


@interface hdhGomokuChessboard ()
@property(nonatomic,strong)NSMutableDictionary * pointsAtRows;
@property(nonatomic,strong)NSMutableDictionary * pointsAtLines;
@property(nonatomic,strong)NSMutableDictionary * pointsAtLeftToTops;
@property(nonatomic,strong)NSMutableDictionary * pointsAtLeftToBottoms;

@end

@implementation hdhGomokuChessboard

+(instancetype)newChessboard
{
    hdhGomokuChessboard * board=[[hdhGomokuChessboard alloc]init];
    return board;
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        NSMutableArray * points=[NSMutableArray array];
        for (NSInteger row=1; row<=RowCount; row++) {
            for (NSInteger line=1; line<=RowCount; line++) {
                hdhGomokuChessPoint * point=[hdhGomokuChessPoint pointAtRow:row line:line];
                point.delegate=self;
                [points addObject:point];
            }
        }
        _points=points;
        
        _pointsAtRows=[NSMutableDictionary dictionary];
        _pointsAtLines=[NSMutableDictionary dictionary];
        _pointsAtLeftToTops=[NSMutableDictionary dictionary];
        _pointsAtLeftToBottoms=[NSMutableDictionary dictionary];
    }
    return self;
}

-(hdhGomokuChessPoint*)pointAtRow:(NSInteger)row line:(NSInteger)line
{
    if (row<1||row>RowCount||line<1||line>RowCount) {
        return nil;
    }
    hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
    return point;
}

-(hdhGomokuLinePoints*)pointsAtRow:(NSInteger)row
{
    if (row<1||row>RowCount) {
        return nil;
    }
    hdhGomokuLinePoints * points=[_pointsAtRows objectForKey:[NSNumber cahceNumber:row]];
    if (points) {
        return points;
    }
    NSMutableArray* array=[[NSMutableArray alloc]init];
    for (NSInteger line=1; line<=RowCount; line++) {
        hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
        [array addObject:point];
    }
    points=[[hdhGomokuLinePoints alloc]initWithArray:array];
    [_pointsAtRows setObject:points forKey:[NSNumber cahceNumber:row]];
    return points;
}

-(hdhGomokuLinePoints*)pointsAtLine:(NSInteger)line
{
    if (line<1||line>RowCount) {
        return nil;
    }
    hdhGomokuLinePoints * points=[_pointsAtLines objectForKey:[NSNumber cahceNumber:line]];
    if (points) {
        return points;
    }
    NSMutableArray* array=[[NSMutableArray alloc]init];
    for (NSInteger row=1; row<=RowCount; row++) {
        hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
        [array addObject:point];
    }
    points=[[hdhGomokuLinePoints alloc]initWithArray:array];
    [_pointsAtLines setObject:points forKey:[NSNumber cahceNumber:line]];
    return points;
}

-(hdhGomokuLinePoints*)pointsByLeftToTop:(NSInteger)count
{
    if (count<5||count>25) {
        return nil;
    }
    hdhGomokuLinePoints * points=[_pointsAtLeftToTops objectForKey:[NSNumber cahceNumber:count]];
    if (points) {
        return points;
    }
    if (count<=RowCount) {
        NSMutableArray * array=[[NSMutableArray alloc]init];
        for (NSInteger row=count; row>=1; row--) {
            NSInteger line=count-row+1;
            hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
            [array addObject:point];
        }
        points=[[hdhGomokuLinePoints alloc]initWithArray:array];
        [_pointsAtLeftToTops setObject:points forKey:[NSNumber cahceNumber:count]];
        return points;
    }else{
        NSMutableArray * array=[[NSMutableArray alloc]init];
        for (NSInteger row=RowCount; row>count-RowCount; row--) {
            NSInteger line=count-row+1;
            hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
            [array addObject:point];
        }
        points=[[hdhGomokuLinePoints alloc]initWithArray:array];
        [_pointsAtLeftToTops setObject:points forKey:[NSNumber cahceNumber:count]];
        return points;
    }
    return nil;
}

-(hdhGomokuLinePoints*)pointsByLeftToBottom:(NSInteger)count
{
    if (count<5||count>25) {
        return nil;
    }
    hdhGomokuLinePoints * points=[_pointsAtLeftToBottoms objectForKey:[NSNumber cahceNumber:count]];
    if (points) {
        return points;
    }
    if (count<=RowCount) {
        NSMutableArray * array=[[NSMutableArray alloc]init];
        for (NSInteger row=1; row<=count; row++) {
            NSInteger line=RowCount-count+row;
            hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
            [array addObject:point];
        }
        points=[[hdhGomokuLinePoints alloc]initWithArray:array];
        [_pointsAtLeftToBottoms setObject:points forKey:[NSNumber cahceNumber:count]];
        return points;
    }else{
        NSMutableArray * array=[[NSMutableArray alloc]init];
        NSInteger line=1;
        for (NSInteger row=count-RowCount+1; row<=15; row++) {
            hdhGomokuChessPoint * point=[_points objectAtIndex:(row-1)*RowCount+(line-1)];
            [array addObject:point];
            line++;
        }
        points=[[hdhGomokuLinePoints alloc]initWithArray:array];
        [_pointsAtLeftToBottoms setObject:points forKey:[NSNumber cahceNumber:count]];
        return points;
    }
    return nil;
}

-(NSInteger)determine:(hdhGomokuLinePoints*)array;
{
    if ([array  count]<5) {
        return 0;
    }
    for (NSInteger i=0; i<=array.count-5; i++) {
        NSInteger blackCount=0;
        NSInteger whiteCount=0;
        for (NSInteger j=i; j<i+5; j++) {
            hdhGomokuChessPoint *point=[array objectAtIndex:j];
            if (point.chess) {
                if (point.chess.type==hdhGomokuChessTypeBlack) {
                    blackCount++;
                }else{
                    whiteCount++;
                }
            }
        }
        if (whiteCount==5) {
            NSRange range;
            range.location=i;
            range.length=5;
            self.successPoints=[array.array subarrayWithRange:range];
            return 2;
        }else if(blackCount==5){
            NSRange range;
            range.location=i;
            range.length=5;
            self.successPoints=[array.array subarrayWithRange:range];
            return 1;
        }
    }
    return 0;
}

-(NSInteger)determine
{
    self.successPoints=nil;
    for (NSInteger i=1; i<=RowCount; i++) {
        NSInteger rowScore=[self determine:[self pointsAtRow:i]];
        NSInteger lineScore=[self determine:[self pointsAtLine:i]];
        if (rowScore==1||lineScore==1) {
            return 1;
        }else if (rowScore==2||lineScore==2) {
            return 2;
        }
    }
    for (NSInteger i=5; i<=25; i++) {
        NSInteger rowScore=[self determine:[self pointsByLeftToTop:i]];
        NSInteger lineScore=[self determine:[self pointsByLeftToBottom:i]];
        if (rowScore==1||lineScore==1) {
            return 1;
        }else if (rowScore==2||lineScore==2) {
            return 2;
        }
    }
    return 0;
}


-(BOOL)couldChessDowm:(hdhGomokuChessPoint*)point
{
    if (point.chess==nil&&point.virtualChessType==hdhGomokuChessTypeEmpty) {
        NSInteger maxRow=point.row+3>15?15:point.row+3;
        NSInteger maxLine=point.line+3>15?15:point.line+3;
        NSInteger minRow=point.row-3<1?1:point.row-3;
        NSInteger minLine=point.line-3<1?1:point.line-3;
        for (NSInteger row=minRow; row<=maxRow; row++) {
            for (NSInteger line=minLine; line<=maxLine; line++) {
                hdhGomokuChessPoint * chessPoint=[self pointAtRow:row line:line];
                if ((chessPoint.chess!=nil)||chessPoint.virtualChessType!=hdhGomokuChessTypeEmpty) {
                    return YES;
                }
            }
        }
        return NO;
    }else{
        return NO;
    }
}

-(void)enumerateFrom:(hdhGomokuChessPoint*)point callback:(BOOL(^)(hdhGomokuChessPoint*))callback
{
    NSInteger maxRow=point.row+3>15?15:point.row+3;
    NSInteger maxLine=point.line+3>15?15:point.line+3;
    NSInteger minRow=point.row-3<1?1:point.row-3;
    NSInteger minLine=point.line-3<1?1:point.line-3;
    for (NSInteger row=minRow; row<=maxRow; row++) {
        for (NSInteger line=minLine; line<=maxLine; line++) {
            hdhGomokuChessPoint * chessPoint=[self pointAtRow:row line:line];
            if (callback) {
                BOOL result=callback(chessPoint);
                if (result) {
                    return;
                }
            }
        }
    }
    for (NSInteger row=1; row<=RowCount; row++) {
        for (NSInteger line=1; line<RowCount; line++) {
            if (!(row>=minRow&&row<=maxRow&&line>=minLine&&line<=maxLine)) {
                if (callback) {
                    BOOL result=callback([self pointAtRow:row line:line]);
                    if (result) {
                        return;
                    }
                }
            }
        }
    }
}

-(NSInteger)calculate
{
    NSInteger score=0;
    for (int i=1; i<=15; i++) {
        hdhGomokuLinePoints * points=[self pointsAtRow:i];
        score+=[points calculate];
        
        points=[self pointsAtLine:i];
        score+=[points calculate];
    }
    for (int i=5; i<=25; i++) {
        hdhGomokuLinePoints * points=[self pointsByLeftToTop:i];
        score+=[points calculate];
        
        points=[self pointsByLeftToBottom:i];
        score+=[points calculate];
    }
    return score;
}


-(void)chessPointStatuChanged:(hdhGomokuChessPoint*)point
{
    hdhGomokuLinePoints* points=[self pointsAtRow:point.row];
    points.statuChange=YES;
    points=[self pointsAtLine:point.line];
    points.statuChange=YES;
    points=[self pointsByLeftToTop:point.row+point.line-1];
    points.statuChange=YES;
    points=[self pointsByLeftToBottom:point.row+RowCount-point.line];
    points.statuChange=YES;
}


@end
