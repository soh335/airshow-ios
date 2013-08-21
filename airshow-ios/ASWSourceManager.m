//
//  ASWSourceManager.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/19.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSourceManager.h"

@interface ASWSourceManager ()
@property (nonatomic, strong) NSMutableOrderedSet *sources;
@end

@implementation ASWSourceManager

- (id)init
{
    if (self = [super init]) {
        _sources = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (void)load
{
    
    NSArray *encodeArray = [[NSArray alloc] initWithContentsOfFile:[self plistPath]];
    
    for (NSData *data in encodeArray) {
        id<ASWSource> source = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_sources addObject:source];
    }
}

- (void)addSource:(id<ASWSource>)source
{
    // if exist source in set, remove and add head.
    [_sources removeObject:source];
    [_sources insertObject:source atIndex:0];
}

- (void)save
{
    NSMutableArray *encodeArray = @[].mutableCopy;
    
    for (id source in _sources) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:source];
        [encodeArray addObject:data];
    }
    
    if (![encodeArray writeToFile:[self plistPath] atomically:NO]) {
        NSCAssert(NO, @"failed to write file");
    }
}

- (id<ASWSource>)sourceAtIndex:(NSInteger)index
{
    return [_sources objectAtIndex:index];
}

- (void)deleteAtIndex:(NSInteger)index
{
    [_sources removeObjectAtIndex:index];
}

- (NSInteger)sourceCount
{
    return _sources.count;
}

- (NSString *)plistPath
{
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [dir stringByAppendingPathComponent:@"sources.plist"];
}

@end
