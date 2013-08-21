//
//  ASWSourceTumblrBlogViewController.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/18.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWSourceController.h"

@class ASWSourceTumblrBlog;

@interface ASWSourceTumblrBlogViewController : UIViewController <ASWSourceController>
@property (weak, nonatomic) IBOutlet UITextField *blogTextField;
@property (weak, nonatomic) IBOutlet UITextField *cacheCountTextField;
@property (nonatomic, strong) ASWSourceTumblrBlog *source;

@end
