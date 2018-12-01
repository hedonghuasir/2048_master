//
//  hdhCell.h
//  hdh048
//
//  Created by Danqing on 3/17/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class hdhTile;

@interface hdhCell : NSObject

/** The position of the cell. */
@property (nonatomic) hdhPosition position;

/** The tile in the cell, if any. */
@property (nonatomic, strong) hdhTile *tile;

/**
 * Initialize a hdhCell at the specified position with no tile in it.
 *
 * @param position The position of the cell.
 */
- (instancetype)initWithPosition:(hdhPosition)position;

@end
