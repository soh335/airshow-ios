//
//  ASWConnectionSlideshow.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@class ASWSlideshowConnection;

@protocol ASWConnectionReadSlideshowDelegate

- (NSData *)readSlideshowGetImage;

@end

@interface ASWConnectionReadSlideshow : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, weak) id<ASWConnectionReadSlideshowDelegate> delegate;
- (void)startReadRequest:(ASWSlideshowConnection *)conn sock:(GCDAsyncSocket *)sock;

@end
