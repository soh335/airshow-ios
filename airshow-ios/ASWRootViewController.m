//
//  ASWRootViewController.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/18.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWRootViewController.h"
#import "ASWAppDelegate.h"
#import "ASWSourceContainerViewController.h"

@interface ASWRootViewController ()
@end

@interface ASWUITableViewCell : UITableViewCell
@end

@implementation ASWUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

@end

@implementation ASWRootViewController

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
    
    [_tableView registerClass:[ASWUITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSourceContainer"]) {
        ASWSourceContainerViewController *containerViewController = segue.destinationViewController;
        [containerViewController setChildViewController:sender];
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASWAppDelegate *delegate = (ASWAppDelegate *)[UIApplication sharedApplication].delegate;
    id<ASWSource> source = [delegate.sourceManager sourceAtIndex:indexPath.row];
    UIViewController *viewController = [source getViewControllerWithSource];
    
    [self performSegueWithIdentifier:@"showSourceContainer" sender:viewController];
}


#pragma mark - data source delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ASWAppDelegate *delegate = (ASWAppDelegate *)[UIApplication sharedApplication].delegate;
    id<ASWSource> source = [delegate.sourceManager sourceAtIndex:indexPath.row];
    
    cell.textLabel.text = [[source class] sourceName];
    cell.detailTextLabel.text = [source sourceDescription];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ASWAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate.sourceManager.sourceCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ASWAppDelegate *delegate = (ASWAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.sourceManager deleteAtIndex:indexPath.row];
        [delegate.sourceManager save];
        [_tableView reloadData];
    }
}

@end
