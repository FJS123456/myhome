//
//  FJSPhotoViewController.h
//  Home
//
//  Created by fujisheng on 16/4/23.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSAlbum,FJSHome;

@interface FJSPhotoViewController : UIViewController

@property (strong,nonatomic) FJSAlbum *album;
@property (strong,nonatomic) FJSHome *home;


@end
