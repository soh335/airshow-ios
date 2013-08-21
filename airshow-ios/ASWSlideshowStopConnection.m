//
//  ASWSlideshowStopConnection.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSlideshowStopConnection.h"
#import "GCDAsyncSocket+ASW.h"

@interface ASWSlideshowStopConnection ()
@property (nonatomic, strong) GCDAsyncSocket *socket;
@end

@implementation ASWSlideshowStopConnection

- (void)stopSlideShow
{
    NSError *error = nil;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if(![_socket connectToHost:_ip onPort:_port error:&error]) {
        NSCAssert(NO, [error localizedDescription]);
        return;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSData *body = [self getPlistBody];
    
    NSMutableString *str = @"".mutableCopy;
    [str appendString:@"PUT /slideshows/1 HTTP/1.1\r\n"];
    [str appendString:@"Content-Type: text/x-apple-plist+xml\r\n"];
    [str appendFormat:@"Content-Length: %d\r\n", body.length];
    [str appendFormat:@"X-Apple-Session-ID: %@\r\n", _sessionId];
    [str appendString:@"\r\n"];
    
    NSData *header = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [_socket writeData:header withTimeout:-1 tag:-1];
    [_socket writeData:body withTimeout:-1 tag:-1];
    
    [_socket readHeaderData];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_HEADER) {
        CFHTTPMessageRef messageRef = CFHTTPMessageCreateEmpty(NULL, NO);
        CFHTTPMessageAppendBytes(messageRef, (const UInt8 *)data.bytes, data.length);
        
        if (!CFHTTPMessageIsHeaderComplete(messageRef)) {
            NSCAssert(NO, @"invalid header");
        }
        
        CFIndex statusCodeRef = CFHTTPMessageGetResponseStatusCode(messageRef);
        if (statusCodeRef != 200) {
            NSCAssert(NO, @"invalid response");
        }
        
        CFRelease(messageRef);

        [sock disconnect];
    }
    else {
        NSCAssert(NO, @"invalid tag");
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [_delegate aswSlideShowStoped];
}

- (void)dealloc
{
    _socket = nil;
}

- (NSData *)getPlistBody
{
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(dict, CFSTR("state"), CFSTR("stopped"));
    
    CFErrorRef errorRef = nil;
    CFDataRef xmlDataRef = CFPropertyListCreateData(kCFAllocatorDefault, dict, kCFPropertyListXMLFormat_v1_0, 0, &errorRef);
    
    if (errorRef) {
        NSCAssert(NO, @"err create cfproperty list create data");
    }
    
    CFRelease(dict);
    
    return (NSData *)CFBridgingRelease(xmlDataRef);
}

@end
