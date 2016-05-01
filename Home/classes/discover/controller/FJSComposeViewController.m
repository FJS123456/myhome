//
//  FJSComposeViewController.m
//  Home
//
//  Created by fujisheng on 16/3/23.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSComposeViewController.h"

@implementation FJSComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
