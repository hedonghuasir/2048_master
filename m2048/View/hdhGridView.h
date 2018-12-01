//
//  hdhGridView.h
//  hdh048
//
//  Created by Danqing on 3/21/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class hdhGrid;

@interface hdhGridView : UIView

/**
 * Create the entire background of the view with the grid at the correct position.
 *
 * @param grid The grid object that the image bases on.
 */
+ (UIImage *)gridImageWithGrid:(hdhGrid *)grid;

/**
 * Create the entire background of the view with a translucent overlay on the grid.
 * The rest of the image is clear color, to create the illusion that the overlay is
 * only over the grid.
 */
+ (UIImage *)gridImageWithOverlay;

@end
