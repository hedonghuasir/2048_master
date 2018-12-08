//
//  hdhGomokuBaseStack.h
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdhGomokuChessPoint.h"
@interface hdhGomokuBaseStack : NSObject

-(NSInteger)depth;
-(void)push:(hdhGomokuChessPoint*)element;
-(hdhGomokuChessPoint*)pop;
-(void)reuse;
-(hdhGomokuChessPoint*)getTopElement;
@end
