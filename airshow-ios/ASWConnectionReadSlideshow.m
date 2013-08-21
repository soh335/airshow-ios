//
//  ASWConnectionSlideshow.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWConnectionReadSlideshow.h"
#import "ASWSlideshowConnection.h"
#import "GCDAsyncSocket+ASW.h"
#import "common.h"

@implementation ASWConnectionReadSlideshow

- (void)startReadRequest:(ASWSlideshowConnection *)conn sock:(GCDAsyncSocket *)sock
{
    [sock readHeaderData];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    ASWDebugLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if (tag == TAG_HEADER) {
        CFHTTPMessageRef messageRef = CFHTTPMessageCreateEmpty(NULL, YES);
        CFHTTPMessageAppendBytes(messageRef, (const UInt8 *)data.bytes, data.length);
        
        if (!CFHTTPMessageIsHeaderComplete(messageRef)) {
            NSAssert(NO, @"failed to parse header");
        }
        
        NSDictionary *header = (NSDictionary *)CFBridgingRelease(CFHTTPMessageCopyAllHeaderFields(messageRef));
        
        NSString *contentLength = header[@"Content-Length"];
        CFURLRef urlRef = CFHTTPMessageCopyRequestURL(messageRef);
        NSURL *url = (NSURL *)(CFBridgingRelease(urlRef));
        
        if (!(contentLength.integerValue == 0 && [url.path isEqualToString:@"/slideshows/1/assets/1"])) {
            NSAssert(NO, @"invalid request");
        }
        
        CFRelease(messageRef);
        
        // write to apple tv
        NSData *data = [_delegate readSlideshowGetImage];
        NSData *body = [self getBinaryPlist:data];
        
        NSMutableString *str = @"".mutableCopy;
        [str appendString:@"HTTP/1.1 200 OK\r\n"];
        [str appendString:@"Content-Type: application/x-apple-binary-plist\r\n"];
        [str appendFormat:@"Content-Length: %d\r\n", body.length];
        [str appendString:@"\r\n"];
        
        NSData *writeHeader = [str dataUsingEncoding:NSUTF8StringEncoding];
        [sock writeData:writeHeader withTimeout:-1 tag:-1];
        [sock writeData:body withTimeout:-1 tag:-1];
        ASWDebugLog(@"writed! %d %d", data.length, body.length);
        
        [self startReadRequest:nil sock:sock];
    }
}

- (NSData *)getBinaryPlist:(NSData *)imageData
{
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFMutableDictionaryRef info = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    int key = 1;
    int _id = 1;
    CFNumberRef keyRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberCFIndexType, &key);
    CFNumberRef _idRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberCFIndexType, &_id);
    
    CFDictionarySetValue(info, CFSTR("key"), keyRef);
    CFDictionarySetValue(info, CFSTR("id"), _idRef);
    
    CFRelease(keyRef);
    CFRelease(_idRef);
    
    CFDictionarySetValue(dict, CFSTR("info"), info);
    
    CFRelease(info);
    
    CFDataRef imageDataRef = CFDataCreate(kCFAllocatorDefault, (void *)imageData.bytes, imageData.length);
    CFDictionarySetValue(dict, CFSTR("data"), imageDataRef);
    
    CFRelease(imageDataRef);
    
    CFErrorRef errorRef = nil;
    CFDataRef binaryDataRef = CFPropertyListCreateData(kCFAllocatorDefault, dict, kCFPropertyListBinaryFormat_v1_0, 0, &errorRef);
    
    if (errorRef) {
        NSCAssert(NO, @"err create cfproperty binary list");
    }
    
    CFRelease(dict);
    
    return (NSData *)CFBridgingRelease(binaryDataRef);
}

@end
