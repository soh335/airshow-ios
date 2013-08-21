//
//  ASWAppDelegate.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/16.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWAppDelegate.h"
#import "ASWSlideshowConnection.h"
#import "ASWSource.h"

@interface ASWAppDelegate ()
@property (nonatomic, strong) ASWSlideshowConnection *conn;
@property (nonatomic, strong) id<ASWSource> source;
@end

@implementation ASWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ASWSourceManager *sourceManager = [[ASWSourceManager alloc] init];
    [sourceManager load];
    _sourceManager = sourceManager;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
