//
//  FJSVideoPlayViewController.m
//  Home
//
//  Created by fujisheng on 16/5/1.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSVideoPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FJSUtil.h"
#import "FJSHomeVideo.h"

@interface FJSVideoPlayViewController ()

@property (strong,nonatomic) MPMoviePlayerController *videoPlayer;

@end

@implementation FJSVideoPlayViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    
    [self.videoPlayer stop];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.video.desc;
    [self.videoPlayer play];
}

-(MPMoviePlayerController *)videoPlayer{
    if (!_videoPlayer) {
        NSURL *url=[FJSUtil transferToUrlWithUrlStr:self.video.videoUrl];
        _videoPlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _videoPlayer.view.frame=self.view.bounds;
        _videoPlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_videoPlayer.view];
    }
    return _videoPlayer;
}

@end
