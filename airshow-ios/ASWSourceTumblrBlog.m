//
//  ASWSourceTumblrBlog.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/17.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSourceTumblrBlog.h"
#import "ASWSourceTumblrBlogViewController.h"
#import "ASWConfig.h"
#import "common.h"

@interface ASWSourceTumblrBlog ()
@property (nonatomic) NSMutableArray *urls;
@property (nonatomic, copy) NSString *apiKey;
@end

@implementation ASWSourceTumblrBlog

- (id)init
{
    if (self = [super init]) {
        [self initProcess];
    }
    return self;
}

- (void) initProcess
{
    _urls = @[].mutableCopy;
    _apiKey = ASW_TUMBLR_API_KEY;
}

- (BOOL)isEqual:(id)object
{
    if ([object class] == [self class]) {
        return [self.blog isEqualToString:((ASWSourceTumblrBlog *)object).blog];
    }
    else {
        return [super isEqual:object];
    }
}

- (NSUInteger)hash
{
    return [_blog hash];
}

- (NSString *)placeHolder
{
    return @"aoi-miyazaki.tumblr.com";
}

- (UIViewController *)getViewControllerWithSource
{
    ASWSourceTumblrBlogViewController *viewController = [[ASWSourceTumblrBlogViewController alloc] initWithNibName:@"ASWSourceTumblrBlogViewController" bundle:nil];
    viewController.source = self;
    return viewController;
}

+ (NSString *)sourceName
{
    return @"TumblrBlog";
}

+ (UIViewController *)getViewController
{
    ASWSourceTumblrBlogViewController *viewController = [[ASWSourceTumblrBlogViewController alloc] initWithNibName:@"ASWSourceTumblrBlogViewController" bundle:nil];
    ASWSourceTumblrBlog *source = [[self alloc] init];
    viewController.source = source;
    
    return viewController;
}

- (NSString *)sourceDescription
{
    return _blog;
}

- (NSData *)getImage
{
    if (_urls.count < 1) {
        [NSThread sleepForTimeInterval:3.0f];
    }
    
    if (_urls.count < 1) {
        return nil;
    }
    
    int index = (int) arc4random_uniform(_urls.count);
    NSString *url = _urls[index];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    dispatch_semaphore_t s = dispatch_semaphore_create(0);
    __block NSData *data;
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *res, NSData *_data, NSError *error) {
                               if (error != nil) {
                                   ASWDebugLog(@"%@", error);
                                   return;
                               }
                               data = _data;
                               dispatch_semaphore_signal(s);
    }];
    
    dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
    return data;
}

- (void)run
{
    [self startCaching];
}

- (void)startCaching
{
    __block NSInteger offset = 0;
    NSInteger limit  = 20;
    dispatch_semaphore_t s = dispatch_semaphore_create(1);
    
    while (_urls.count < _cacheCount) {
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        
        [self searchTumblrLimit:limit
                         offset:offset
                 successHandler:^(id json){
                     NSArray *posts = ((NSDictionary *)json)[@"response"][@"posts"];
                     for (NSDictionary *post in posts) {
                         for (NSDictionary *photo in post[@"photos"]) {
                             NSString *url = photo[@"original_size"][@"url"];
                             [_urls addObject:url];
                         }
                     }
                     offset += limit;
                     dispatch_semaphore_signal(s);
                 }
                   errorHandler:^(NSError *error){
                       ASWDebugLog(@"%@", error);
                       dispatch_semaphore_signal(s);
                   }];
    }
}

- (void)searchTumblrLimit:(NSInteger) limit offset:(NSInteger)offset successHandler:(void(^)(id json))successHandler errorHandler:(void(^)(NSError *error))errorHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.tumblr.com/v2/blog/%@/posts/photo?api_key=%@&limit=%d&offset=%d", _blog, _apiKey, limit, offset]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
                               
                               ASWDebugLog(@"%@ is completion", req);
                               
                               if (error != nil) {
                                   errorHandler(error);
                                   return;
                               }
                               
                               NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)res;
                               if (httpRes.statusCode != 200) {
                                   NSError *error = [[NSError alloc] initWithDomain:@"airshow" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"not 200 status code"}];
                                   errorHandler(error);
                                   return;
                               }
                               
                               NSError *jsonError = nil;
                               id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                               
                               if (jsonError != nil) {
                                   errorHandler(jsonError);
                                   return;
                               }
                               
                               successHandler(json);
    }];
}

#pragma mark - coding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_blog forKey:@"blog"];
    [aCoder encodeInteger:_cacheCount forKey:@"cacheCount"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _blog = [aDecoder decodeObjectForKey:@"blog"];
        _cacheCount = [aDecoder decodeIntegerForKey:@"cacheCount"];
        [self initProcess];
    }
    return self;
}

@end
