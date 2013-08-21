//
//  ASWSlideshowFeatureTableViewController.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSlideshowFeatureTableViewController.h"
#import "ASWPlayViewController.h"

@interface ASWSlideshowFeatureTableViewController ()
@property (nonatomic, strong) ASWSlideshowFeatureConnection *slideshowFeatureConn;
@property (nonatomic, strong) NSArray *themes;
@end

@implementation ASWSlideshowFeatureTableViewController

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
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    _slideshowFeatureConn = [[ASWSlideshowFeatureConnection alloc] init];
    _slideshowFeatureConn.delegate = self;
    _slideshowFeatureConn.ip = _bonjourResult.ip;
    _slideshowFeatureConn.port = _bonjourResult.service.port;
    [_slideshowFeatureConn run];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _themes[indexPath.row][@"key"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ASWPlayViewController *playerController = 
    ((ASWPlayViewController *)segue.destinationViewController);
    
    playerController.bonjourResult = _bonjourResult;
    playerController.theme = sender;
    playerController.source = _source;
    
}

- (void)dealloc
{
    _source = nil;
    _themes = nil;
    _slideshowFeatureConn = nil;
}

#pragma mark - table

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *theme = _themes[indexPath.row][@"key"];
    [self performSegueWithIdentifier:@"showPlayController" sender:theme];
}

#pragma mark - feature conn

- (void)aswSlideFeatureFinish:(NSDictionary *)dict
{
    _themes = dict[@"themes"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

@end
