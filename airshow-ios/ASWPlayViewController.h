//
//  ASWPlayViewController.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/21.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWSlideshowConnection.h"
#import "ASWSlideshowStopConnection.h"
#import "ASWBonjourSeacher.h"
#import "ASWSource.h"

@interface ASWPlayViewController : UIViewController <ASWSlideshowStopConnectionDelegate>
@property (nonatomic, strong) ASWBonjourSeacherResult *bonjourResult;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, strong) id<ASWSource> source;

@end
