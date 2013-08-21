//
//  ASWSourceTumblrBlog.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASWSource.h"

@interface ASWSourceTumblrBlog : NSObject <ASWSource, NSCoding>

@property (nonatomic, copy) NSString *blog;
@property (nonatomic) NSInteger cacheCount;

- (NSString *)placeHolder;

@end
