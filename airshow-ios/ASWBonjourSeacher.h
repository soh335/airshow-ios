//
//  ASWBonjourSeacher.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/16.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASWBonjourSeacherResult : NSObject 
@property (nonatomic, strong) NSNetService *service;
@property (nonatomic, copy) NSString *ip;
@end

@protocol ASWBonjourSeacherDelegate
- (void) aswBonjourSearcherFind:(ASWBonjourSeacherResult *)result;
- (void) aswBonjourSearcherRemove:(NSNetService *)service;
- (void) aswBonjourBrowseFinish;
@end

@interface ASWBonjourSeacher : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, weak) id<ASWBonjourSeacherDelegate> delegate;

- (void) search:(NSString *)serviceType;

@end
