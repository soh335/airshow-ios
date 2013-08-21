//
//  ASWSourceController.h
//  airshow-ios
//
//  Created by soh335 on 2013/08/19.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASWSource.h"

@protocol ASWSourceController <NSObject>
- (id<ASWSource>)getSource;
@end
