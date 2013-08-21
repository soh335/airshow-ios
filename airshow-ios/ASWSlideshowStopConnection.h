//
//  ASWSlideshowStopConnection.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@protocol ASWSlideshowStopConnectionDelegate

- (void)aswSlideShowStoped;

@end

@interface ASWSlideshowStopConnection : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSString *ip;
@property (nonatomic) NSInteger port;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, weak) id<ASWSlideshowStopConnectionDelegate> delegate;

- (void)stopSlideShow;

@end
