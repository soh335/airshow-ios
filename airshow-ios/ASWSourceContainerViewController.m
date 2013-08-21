//
//  ASWSourceContainerViewController.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/19.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSourceContainerViewController.h"
#import "ASWSource.h"
#import "ASWAppDelegate.h"
#import "ASWSlideshowFeatureTableViewController.h"
#import "ASWSourceController.h"

@interface ASWSourceContainerViewController ()
@property (nonatomic, strong) ASWBonjourSeacher *bonjourSearcher;

@property (nonatomic, strong) NSMutableArray *airPlayServices;
@property (nonatomic, weak) ASWBonjourSeacherResult *selectedAirPlayService;
@property (nonatomic, strong) ASWBonjourSeacherResult *currentAirplayResult;
@property (nonatomic, strong) id<ASWSource> source;

@end

@implementation ASWSourceContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _bonjourSearcher = [[ASWBonjourSeacher alloc] init];
    _bonjourSearcher.delegate = self;
    _airPlayServices = @[].mutableCopy;
    [_playButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setChildViewController:(UIViewController<ASWSourceController> *)viewController;
{
    [self addChildViewController:viewController];
    [self.view insertSubview:viewController.view atIndex:0];
}

- (IBAction)searchButtonPressed:(id)sender {
    
    if (_airPlayServices.count < 1) {
        [_bonjourSearcher search:@"_airplay._tcp"];
    }
    else {
        [self showActionSheet];
    }
}

- (void)dealloc
{
    _bonjourSearcher = nil;
    _airPlayServices = nil;
    _currentAirplayResult = nil;
}

- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"airplay" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (ASWBonjourSeacherResult *r in _airPlayServices) {
        [actionSheet addButtonWithTitle:r.service.name];
    }
    
    [actionSheet addButtonWithTitle:@"cancel"];
    [actionSheet setCancelButtonIndex:_airPlayServices.count];
    [actionSheet showInView:self.view];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    ASWBonjourSeacherResult *r = _airPlayServices[buttonIndex];
    
    if (!r) {
        NSAssert(NO, @"invalid index");
    }
    
    _selectedAirPlayService = r;
    [_playButton setEnabled:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ASWSlideshowFeatureTableViewController *tableViewController = (ASWSlideshowFeatureTableViewController *)segue.destinationViewController;
    tableViewController.bonjourResult = _selectedAirPlayService;
    tableViewController.source = [((id<ASWSourceController>)self.childViewControllers[0]) getSource];
}

#pragma mark - bonjour delegate

- (void)aswBonjourBrowseFinish
{
    [self showActionSheet];
}

- (void)aswBonjourSearcherFind:(ASWBonjourSeacherResult *)result
{
    [_airPlayServices addObject:result];
}

- (void)aswBonjourSearcherRemove:(NSNetService *)service
{
    [_airPlayServices removeObject:service];
}

@end
