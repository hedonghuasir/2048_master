//
//  hdhCell.m
//  hdh048
//
//  Created by Danqing on 3/17/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "hdhCell.h"
#import "hdhTile.h"

@implementation hdhCell

- (instancetype)initWithPosition:(hdhPosition)position
{
  if (self = [super init]) {
    self.position = position;
    self.tile = nil;
  }
  return self;
}


- (void)setTile:(hdhTile *)tile
{
  _tile = tile;
  if (tile) tile.cell = self;
}

@end
