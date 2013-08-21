//
//  ASWConnectionSlideShow.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@class ASWSlideshowConnection;

@protocol ASWConnectionStartSlideShowDelegate

- (void)startSlideShowFinish;

@end

@interface ASWConnectionStartSlideShow : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, weak) id<ASWConnectionStartSlideShowDelegate> delegate;
@property (nonatomic, copy) NSString *theme;
- (void)writeStartSlideshow:(ASWSlideshowConnection *)conn sock:(GCDAsyncSocket *)sock;

@end
