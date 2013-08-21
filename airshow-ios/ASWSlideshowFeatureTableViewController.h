//
//  ASWSlideshowFeatureTableViewController.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWBonjourSeacher.h"
#import "ASWSlideshowFeatureConnection.h"
#import "ASWSource.h"

@interface ASWSlideshowFeatureTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASWSlideshowFeatureConnectionDelegate>

@property (nonatomic, strong) ASWBonjourSeacherResult *bonjourResult;
@property (nonatomic, strong) id<ASWSource> source;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
