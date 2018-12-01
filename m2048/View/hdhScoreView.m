//
//  hdhScoreView.m
//  hdh048
//
//  Created by Danqing on 3/23/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "hdhScoreView.h"

@implementation hdhScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  return self;
}


- (void)commonInit
{
  self.layer.cornerRadius = GSTATE.cornerRadius;
  self.layer.masksToBounds = YES;
  self.backgroundColor = [UIColor greenColor];
}


- (void)updateAppearance
{
  self.backgroundColor = [GSTATE scoreBoardColor];
  self.title.font = [UIFont fontWithName:[GSTATE boldFontName] size:12];
  self.score.font = [UIFont fontWithName:[GSTATE regularFontName] size:16];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
