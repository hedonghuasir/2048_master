//
//  hdhGameManager.h
//  hdh048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class hdhScene;
@class hdhGrid;

typedef NS_ENUM(NSInteger, hdhDirection) {
  hdhDirectionUp,
  hdhDirectionLeft,
  hdhDirectionDown,
  hdhDirectionRight
};

@interface hdhGameManager : NSObject

/**
 * Starts a new session with the provided scene.
 *
 * @param scene The scene in which the game happens.
 */
- (void)startNewSessionWithScene:(hdhScene *)scene;

/**
 * Moves all movable tiles to the desired direction, then add one more tile to the grid.
 * Also refreshes score and checks game status (won/lost).
 *
 * @param direction The direction of the move (up, right, down, left).
 */
- (void)moveToDirection:(hdhDirection)direction;

@end
