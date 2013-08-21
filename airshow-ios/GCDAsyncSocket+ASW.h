//
//  GCDAsyncSocket+ASW.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "GCDAsyncSocket.h"

#define TAG_HEADER 100
#define TAG_BODY   200

@interface GCDAsyncSocket (ASW)

-(void)readHeaderData;

@end
