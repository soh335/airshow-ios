//
//  ASWRootViewController.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/18.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASWRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
