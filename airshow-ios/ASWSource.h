//
//  ASWSource.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASWSource <NSObject>

- (NSData *)getImage;
- (void)run;

+ (NSString *)sourceName;
+ (UIViewController *)getViewController;
- (UIViewController *)getViewControllerWithSource;

- (NSString *)sourceDescription;

@end
