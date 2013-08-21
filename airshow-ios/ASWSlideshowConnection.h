//
//  ASWConnection.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/16.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "ASWConnectionStartSlideShow.h"
#import "ASWConnectionReadSlideShow.h"
#import "ASWSource.h"

@interface ASWSlideshowConnection : NSObject <GCDAsyncSocketDelegate, ASWConnectionStartSlideShowDelegate, ASWConnectionReadSlideshowDelegate>

@property (nonatomic, copy) NSString *ip;
@property (nonatomic) NSInteger port;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) id<ASWSource> source;
@property (nonatomic, copy) NSString *theme;

- (void) tryHandshake;

@end
