//
//  ASWSourceContainerViewController.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/19.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWSourceController.h"
#import "ASWBonjourSeacher.h"

@interface ASWSourceContainerViewController : UIViewController <ASWBonjourSeacherDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;

- (void)setChildViewController:(UIViewController<ASWSourceController> *)viewController;
- (IBAction)searchButtonPressed:(id)sender;

@end
