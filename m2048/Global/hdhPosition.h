//
//  hdhPosition.h
//  hdh048
//
//  Created by Danqing on 3/19/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#ifndef hdh048_hdhPosition_h
#define hdh048_hdhPosition_h

typedef struct Position {
  NSInteger x;
  NSInteger y;
} hdhPosition;

CG_INLINE hdhPosition hdhPositionMake(NSInteger x, NSInteger y)
{
  hdhPosition position;
  position.x = x; position.y = y;
  return position;
}

#endif
