//
//  ASWAppDelegate.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/16.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWSourceManager.h"

@interface ASWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ASWSourceManager *sourceManager;

@end
