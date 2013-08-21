//
//  ASWPlayViewController.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWPlayViewController.h"
#import "ASWAppDelegate.h"

@interface ASWPlayViewController ()
@property (nonatomic, strong) ASWSlideshowConnection *slideshowConn;
@property (nonatomic, strong) ASWSlideshowStopConnection *slideshowStopConn;;
@end

@implementation ASWPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ASWAppDelegate *delegate = (ASWAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.sourceManager addSource:_source];
    [delegate.sourceManager save];
    
    _slideshowConn = [[ASWSlideshowConnection alloc] init];
    _slideshowConn.ip = _bonjourResult.ip;
    _slideshowConn.port = _bonjourResult.service.port;
    _slideshowConn.source = _source;
    _slideshowConn.theme = _theme;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_source run];
        [_slideshowConn tryHandshake];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _slideshowConn = nil;
    _slideshowStopConn = nil;
    _bonjourResult = nil;
    _theme = nil;
    _source = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _slideshowStopConn = [[ASWSlideshowStopConnection alloc] init];
    _slideshowStopConn.ip = _slideshowConn.ip;
    _slideshowStopConn.port = _slideshowConn.port;
    _slideshowStopConn.sessionId = _slideshowConn.sessionId;
    _slideshowStopConn.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_slideshowStopConn stopSlideShow];
    });
}

#pragma mark - stop slideshow delegate

- (void)aswSlideShowStoped
{
    _slideshowStopConn = nil;
    _source = nil;
    _slideshowConn = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
