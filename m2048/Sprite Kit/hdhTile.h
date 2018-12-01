//
//  hdhTile.h
//  hdh048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class hdhCell;

@interface hdhTile : SKShapeNode

/** The level of the tile. */
@property (nonatomic) NSInteger level;

/** The cell this tile belongs to. */
@property (nonatomic, weak) hdhCell *cell;

/**
 * Creates and inserts a new tile at the specified cell.
 *
 * @param cell The cell to insert tile into.
 * @return The tile created.
 */
+ (hdhTile *)insertNewTileToCell:(hdhCell *)cell;

- (void)commitPendingActions;

/**
 * Whether this tile can merge with the given tile.
 *
 * @param tile The target tile to merge with.
 * @return YES if the two tiles can be merged.
 */
- (BOOL)canMergeWithTile:(hdhTile *)tile;


/**
 * Checks whether this tile can merge with the given tile, and merge them
 * if possible. The resulting tile is at the position of the given tile.
 *
 * @param tile Target tile to merge into.
 * @return The resulting level of the merge, or 0 if unmergeable.
 */
- (NSInteger)mergeToTile:(hdhTile *)tile;

- (NSInteger)merge3ToTile:(hdhTile *)tile andTile:(hdhTile *)furtherTile;

/**
 * Moves the tile to the specified cell. If the tile is not already in the grid, 
 * calling this method would result in error.
 *
 * @param cell The destination cell.
 */
- (void)moveToCell:(hdhCell *)cell;


/**
 * Removes the tile from its cell and from the scene.
 *
 * @param animated If YES, the removal will be animated.
 */
- (void)removeAnimated:(BOOL)animated;

@end
