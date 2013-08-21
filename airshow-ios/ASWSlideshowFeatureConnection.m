//
//  ASWSlideshowFeatureConnection.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSlideshowFeatureConnection.h"
#import "GCDAsyncSocket+ASW.h"

@interface ASWSlideshowFeatureConnection ()
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSData *body;
@end

@implementation ASWSlideshowFeatureConnection

- (void)run
{
    NSError *error = nil;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    if (![_socket connectToHost:_ip onPort:_port error:&error]) {
        NSCAssert(NO, [error localizedDescription]);
        return;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSMutableString *header = @"".mutableCopy;
    [header appendString:@"GET /slideshow-features HTTP/1.1\r\n"];
    [header appendString:@"Accept-Language: English\r\n"];
    [header appendString:@"Content-Length: 0\r\n"];
    [header appendString:@"\r\n"];
    
    [_socket writeData:[header dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:-1];
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
        
        NSDictionary *header = (NSDictionary *)CFBridgingRelease(CFHTTPMessageCopyAllHeaderFields(messageRef));
        
        CFRelease(messageRef);
        
        NSString *contentLength = header[@"Content-Length"];
        NSInteger contentLengthInt = contentLength.integerValue;
        [sock readDataToLength:contentLengthInt withTimeout:-1 tag:TAG_BODY];
    }
    else if (tag == TAG_BODY) {
        _body = data;
        [_socket disconnect];
    }
    else {
        NSCAssert(NO, @"invalid tag");
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString *errorString = nil;
    NSPropertyListFormat format;
    
    NSDictionary *dict = [NSPropertyListSerialization propertyListFromData:_body mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&errorString];
    
    if (errorString) {
        NSAssert(NO, errorString);
    }
    
    [_delegate aswSlideFeatureFinish:dict];
}

- (void)dealloc
{
    _body = nil;
    _socket = nil;
    _ip = nil;
}

@end
