//
//  ASWSourceTumblrBlogViewController.m
//  airshow-ios
//
//  Created by soh335 on 2013/08/18.
//  Copyright (c) 2013年 soh335. All rights reserved.
//

#import "ASWSourceTumblrBlogViewController.h"
#import "ASWSourceTumblrBlog.h"

@interface ASWSourceTumblrBlogViewController ()

@end

@implementation ASWSourceTumblrBlogViewController

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
    _blogTextField.text = _source.blog;
    _blogTextField.placeholder = _source.placeHolder;
    _cacheCountTextField.text = [NSString stringWithFormat:@"%d", _source.cacheCount];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)closeKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - aswsource controller

- (id<ASWSource>)getSource
{
    _source.blog = _blogTextField.text;
    _source.cacheCount = _cacheCountTextField.text.integerValue;
    
    return _source;
}

@end
