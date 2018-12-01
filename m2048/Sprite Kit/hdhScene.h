//
//  hdhScene.h
//  hdh048
//

//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class hdhGrid;
@class hdhViewController;

@interface hdhScene : SKScene

@property (nonatomic, weak) hdhViewController *controller;

- (void)startNewGame;

- (void)loadBoardWithGrid:(hdhGrid *)grid;

@end
