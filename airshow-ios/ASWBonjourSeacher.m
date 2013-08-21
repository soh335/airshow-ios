//
//  ASWBonjourSeacher.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/16.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWBonjourSeacher.h"
#import <arpa/inet.h>
#import <netinet/in.h>
#import "common.h"

@implementation ASWBonjourSeacherResult

- (void) dealloc
{
    _ip = nil;
    _service = nil;
}

@end

@interface ASWBonjourSeacher ()
@property (nonatomic, strong) NSNetServiceBrowser *browser;
@property (nonatomic, strong) NSMutableArray *resolvingServices;
@property (nonatomic) int comingCount;
@property (nonatomic) int resolvedCount;
@property (nonatomic) BOOL noMoreComing;
@end

@implementation ASWBonjourSeacher

- (id) init
{
    if (self = [super init]) {
        _browser = [[NSNetServiceBrowser alloc] init];
        _browser.delegate = self;
        
        _resolvingServices = @[].mutableCopy;
        _comingCount = 0;
        _resolvedCount = 0;
        _noMoreComing = NO;
    }
    return self;
}

- (void) search:(NSString *)serviceType {
    [_browser searchForServicesOfType:serviceType inDomain:@"local"];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    [_resolvingServices addObject:aNetService];
    
    _comingCount++;
    if (!moreComing) {
        _noMoreComing = YES;
    }
    
    aNetService.delegate = self;
    [aNetService resolveWithTimeout:5.0];

}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    [_delegate aswBonjourSearcherRemove:aNetService];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    char ip[INET6_ADDRSTRLEN];

    struct sockaddr *address = (struct sockaddr *)((NSData *)sender.addresses[0]).bytes;
    switch (address->sa_family) {
        case AF_INET:
            inet_ntop(AF_INET, &(((struct sockaddr_in *)(address))->sin_addr), ip, sizeof(ip));
            break;
        case AF_INET6:
            inet_ntop(AF_INET, &(((struct sockaddr_in6 *)(address))->sin6_addr), ip, sizeof(ip));
            break;
        default:
            assert(nil);
    }
    
    ASWBonjourSeacherResult *r = [[ASWBonjourSeacherResult alloc] init];
    r.ip = [NSString stringWithCString:ip encoding:NSUTF8StringEncoding];
    r.service = sender;
    [_delegate aswBonjourSearcherFind:r];
    [self _resolvedFinishProcess];

    [_resolvingServices removeObject:sender];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    ASWDebugLog(@"%@", errorDict);
    [_resolvingServices removeObject:sender];
    [self _resolvedFinishProcess];
}

- (void)_resolvedFinishProcess {
    _resolvedCount++;
    if (_noMoreComing && _resolvedCount >= _comingCount) {
        [_delegate aswBonjourBrowseFinish];
    }
}

- (void) dealloc
{
    _browser = nil;
    _resolvingServices = nil;
}

@end
