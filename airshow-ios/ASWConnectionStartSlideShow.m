//
//  ASWConnectionSlideShow.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWConnectionStartSlideShow.h"
#import "ASWSlideshowConnection.h"
#import "GCDAsyncSocket+ASW.h"
#import "common.h"

@implementation ASWConnectionStartSlideShow

- (void)writeStartSlideshow:(ASWSlideshowConnection *)conn sock:(GCDAsyncSocket *)sock
{
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(dict, CFSTR("state"), CFSTR("playing"));
    
    CFMutableDictionaryRef setting = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(setting, CFSTR("theme"), (CFStringRef)_theme);
    
    CFDictionarySetValue(dict, CFSTR("settings"), setting);
    CFRelease(setting);
    
    CFErrorRef errorRef = nil;
    CFDataRef xmlDataRef = CFPropertyListCreateData(kCFAllocatorDefault, dict, kCFPropertyListXMLFormat_v1_0, 0, &errorRef);
    
    if (errorRef) {
        NSAssert(NO,@"err create cfproperty list create data");
    }
    
    CFRelease(dict);
    
    NSData *body = (NSData *)CFBridgingRelease(xmlDataRef);
    
    NSMutableString *str = @"".mutableCopy;
    [str appendString:@"PUT /slideshows/1 HTTP/1.1\r\n"];
    [str appendString:@"Content-Type: text/x-apple-plist+xml\r\n"];
    [str appendFormat:@"X-Apple-Session-ID: %@\r\n", conn.sessionId];
    [str appendFormat:@"Content-Length: %d\r\n", body.length];
    [str appendString:@"\r\n"];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:data withTimeout:-1 tag:0];
    [sock writeData:body withTimeout:-1 tag:0];
    
    [sock readHeaderData];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    ASWDebugLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if (tag == TAG_HEADER) {
        CFHTTPMessageRef messageRef = CFHTTPMessageCreateEmpty(NULL, NO);
        CFHTTPMessageAppendBytes(messageRef, (const UInt8 *)data.bytes, data.length);
    
        if (!CFHTTPMessageIsHeaderComplete(messageRef)) {
            NSAssert(NO, @"failed to parse header");
        }
    
        NSDictionary *header = (NSDictionary *)CFBridgingRelease(CFHTTPMessageCopyAllHeaderFields(messageRef));
        NSString *contentLength = header[@"Content-Length"];
        if (!contentLength) {
            NSCAssert(NO, @"no content length");
        }
    
        NSInteger contentLengthInt = contentLength.integerValue;
        [sock readDataToLength:contentLengthInt withTimeout:-1 tag:TAG_BODY];
    }
    else if (tag == TAG_BODY) {
        [_delegate startSlideShowFinish];
    }
    else {
        NSAssert(NO, @"invalid tag");
    }
}

@end
