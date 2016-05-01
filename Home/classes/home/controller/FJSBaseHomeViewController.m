//
//  FJSBaseHomeViewController.m
//  Home
//
//  Created by fujisheng on 16/4/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSBaseHomeViewController.h"
#import "FJSSlideView.h"
#import "FJSVideoTypeViewController.h"
#import "FJSAlbumViewController.h"
#import "FJSFeedViewController.h"
#import "UIView+FJSAdd.h"
#import "FJSHome.h"

@interface FJSBaseHomeViewController ()<UIScrollViewDelegate,FJSSlideViewDelegate>

@property (strong,nonatomic) FJSSlideView *slideView;
@property (strong,nonatomic) FJSAlbumViewController *albumCtr;
@property (strong,nonatomic) FJSVideoTypeViewController *videoTypeCtr;
@property (strong,nonatomic) FJSFeedViewController *feedCtr;
@property (strong,nonatomic) UIScrollView *scrollView;

@end

@implementation FJSBaseHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.home.h_homeName;
    [self.view addSubview:self.slideView];
    [self.view addSubview:self.scrollView];
}

#pragma mark - layout UI

- (FJSSlideView *)slideView
{
    if (!_slideView) {
        _slideView = [FJSSlideView slideViewWithTitleArray:@[@"相册",@"视频",@"动态"] andWidth:FJSScreenWidth];
        _slideView.left = 0;
        _slideView.top = 64;
        _slideView.delegate = self;
    }
    return _slideView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.slideView.bottom, FJSScreenWidth, FJSScreenHeight - self.slideView.bottom)];
        _scrollView.contentSize = CGSizeMake(FJSScreenWidth * 3, _scrollView.height);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        _albumCtr = [[FJSAlbumViewController alloc] init];
        _albumCtr.view.left = 0;
        [_scrollView addSubview:_albumCtr.view];
        //传递数据
        _albumCtr.home = self.home;
        [self addChildViewController:_albumCtr];
        
        _videoTypeCtr = [[FJSVideoTypeViewController alloc] init];
        _videoTypeCtr.view.left = _scrollView.width;
        [_scrollView addSubview:_videoTypeCtr.view];
        //传递数据
        _videoTypeCtr.home = self.home;
        [self addChildViewController:_videoTypeCtr];
        
        _feedCtr = [[FJSFeedViewController alloc] init];
        _feedCtr.view.left = _scrollView.width * 2;
        [_scrollView addSubview:_feedCtr.view];
        [self addChildViewController:_feedCtr];
    }
    
    return _scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.slideView.slideX = self.slideView.width * (scrollView.contentOffset.x / scrollView.contentSize.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.slideView.scrollToIndex = (scrollView.contentOffset.x / scrollView.contentSize.width) * (scrollView.contentSize.width / scrollView.width);
}

- (void)slideView:(FJSSlideView *)slideView didClickButtonIndex:(NSUInteger)selectedIndex
{
    self.scrollView.contentOffset = CGPointMake(FJSScreenWidth * selectedIndex, 0);
}

@end
