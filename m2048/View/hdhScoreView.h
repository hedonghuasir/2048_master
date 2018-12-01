//
//  hdhScoreView.h
//  hdh048
//
//  Created by Danqing on 3/23/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hdhScoreView : UIView

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *score;

/** Updates the appearance of subviews and itself. */
- (void)updateAppearance;

@end
