//
//  ASWSourceManager.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/19.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASWSource.h"

@interface ASWSourceManager : NSObject

- (void)load;
- (void)addSource:(id<ASWSource>)source;
- (void)save;
- (id<ASWSource>)sourceAtIndex:(NSInteger)index;
- (void)deleteAtIndex:(NSInteger)index;
- (NSInteger)sourceCount;

@end
