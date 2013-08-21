//
//  ASWTableSourceViewController.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/19.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWTableSourceViewController.h"
#import "ASWSource.h"
#import "ASWSourceTumblrBlog.h"
#import "ASWSourceContainerViewController.h"


@interface ASWTableSourceViewController ()
@property (nonatomic, strong) NSArray *sourceClasses;
@end

@implementation ASWTableSourceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    _sourceClasses = @[
                       [ASWSourceTumblrBlog class]
                       ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _sourceClasses = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSourceContainer"]) {
        ASWSourceContainerViewController *containerViewContrller = (ASWSourceContainerViewController *)segue.destinationViewController;
        [containerViewContrller setChildViewController:sender];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sourceClasses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Class class = _sourceClasses[indexPath.row];
    NSString *sourceName = (NSString *)[class performSelector:@selector(sourceName)];
    
    cell.textLabel.text = sourceName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = _sourceClasses[indexPath.row];
    UIViewController *viewController = (UIViewController *)[class performSelector:@selector(getViewController)];
    
    [self performSegueWithIdentifier:@"showSourceContainer" sender:viewController];
}

@end
