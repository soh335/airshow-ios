//
//  GCDAsyncSocket+ASW.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "GCDAsyncSocket+ASW.h"

@implementation GCDAsyncSocket (ASW)

-(void)readHeaderData
{
    NSData *toData = [@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    [self readDataToData:toData withTimeout:-1 tag:TAG_HEADER];
}
@end
