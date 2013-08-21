//
//  ASWConnection.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/16.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSlideshowConnection.h"
#import "ASWConnectionStartSlideShow.h"
#import "GCDAsyncSocket+ASW.h"
#import "common.h"

@interface ASWSlideshowConnection ()
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) ASWConnectionStartSlideShow *startSlideShowConn;
@property (nonatomic, strong) ASWConnectionReadSlideshow *readSlideShowConn;
@end

@implementation ASWSlideshowConnection

- (id)init
{
    if (self = [super init]) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _sessionId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (void)tryHandshake
{
    NSError *error = nil;
    
    if (![_socket connectToHost:_ip onPort:_port error:&error]) {
        NSAssert(NO, [error localizedDescription]);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSMutableString *str = @"".mutableCopy;
    [str appendString:@"POST /reverse HTTP/1.1\r\n"];
    [str appendString:@"Upgrade: PTTH/1.0\r\n"];
    [str appendString:@"X-Apple-Purpose: slideshow\r\n"];
    [str appendString:@"Content-Length: 0\r\n"];
    [str appendFormat:@"X-Apple-Session-ID: %@\r\n", _sessionId];
    [str appendString:@"Connection: Upgrade\r\n"];
    [str appendString:@"\r\n"];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_socket writeData:data withTimeout:-1 tag:0];
    
    [_socket readHeaderData];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    ASWDebugLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CFHTTPMessageRef messageRef = CFHTTPMessageCreateEmpty(NULL, NO);
    CFHTTPMessageAppendBytes(messageRef, (const UInt8 *)data.bytes, data.length);
    
    if (!CFHTTPMessageIsHeaderComplete(messageRef)) {
        NSAssert(NO, @"invalid header");
    }

    if (tag == TAG_HEADER) {
        
        NSDictionary *header = (NSDictionary *)CFBridgingRelease(CFHTTPMessageCopyAllHeaderFields(messageRef));
        
        if ([header[@"Connection"] isEqualToString:@"Upgrade"]) {
            _startSlideShowConn = [[ASWConnectionStartSlideShow alloc] init];
            _startSlideShowConn.delegate = self;
            _startSlideShowConn.theme = _theme;
            [sock setDelegate:_startSlideShowConn];
            [_startSlideShowConn writeStartSlideshow:self sock:sock];
        }
        else {
            ASWDebugLog(@"failed handshake");
        }
    }
    else {
        NSCAssert(NO, @"invalid tag");
    }
}

#pragma mark - start slide show delegate

- (void)startSlideShowFinish
{
    ASWDebugLog(@"startSlideShowFinish");
    _startSlideShowConn = nil;

    _readSlideShowConn = [[ASWConnectionReadSlideshow alloc] init];
    _readSlideShowConn.delegate = self;
    [_socket setDelegate:_readSlideShowConn];
    [_readSlideShowConn startReadRequest:self sock:_socket];
}

#pragma mark - read slide show delegate

- (NSData *)readSlideshowGetImage
{
    NSData *data;
    while (!data) {
        data = [_source getImage];
    }
    return data;
}

- (void)dealloc
{
    _socket = nil;
    _sessionId = nil;
    _startSlideShowConn = nil;
}

@end
