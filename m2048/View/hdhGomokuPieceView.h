//
//  hdhGomokuPieceView.h
//  hdhGomoku
//
//  Created by weqia on 14-9-1.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdhGomokuChessPoint.h"
@interface hdhGomokuPieceView : UIView
@property(nonatomic,strong)hdhGomokuChessPoint * point;
+(instancetype)piece:(hdhGomokuChessPoint*)point;
-(void)setSelected:(BOOL)selected;

@end
