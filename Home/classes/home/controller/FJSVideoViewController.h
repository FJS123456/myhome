//
//  FJSVideoViewController.h
//  Home
//
//  Created by fujisheng on 16/4/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSHome,FJSVideoType;

@interface FJSVideoViewController : UIViewController

@property (strong,nonatomic) FJSVideoType *videoType;
@property (strong,nonatomic) FJSHome *home;

@end
