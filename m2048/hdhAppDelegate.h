//
//  hdhAppDelegate.h
//  hdh048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"b26a64ddb4158b611ef996fb";
static NSString *channel = @"App Store";
static BOOL isProduction = NO;
@interface hdhAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,weak)IBOutlet UIImageView * _splashImageView;

@end
