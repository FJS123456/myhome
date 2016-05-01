//
//  CZTabBarController.m
//  传智微博
//
//  Created by apple on 15-3-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZTabBarController.h"
#import "UIImage+Image.h"
#import "CZTabBar.h"

#import "FJSHomeViewController.h"
#import "FJSMessageViewController.h"
#import "FJSDiscoverViewController.h"
#import "FJSMeViewController.h"

#import "CZNavigationController.h"

//#import "CZUserTool.h"
//#import "CZUserResult.h"

#import "FJSComposeViewController.h"

@interface CZTabBarController ()<CZTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) FJSHomeViewController *home;

@property (nonatomic, weak) FJSMessageViewController *message;

@property (nonatomic, weak) FJSMeViewController *profile;

@property (nonatomic, weak) FJSDiscoverViewController *discover;

@end

@implementation CZTabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加所有子控制器
    [self setUpAllChildViewController];

    // 自定义tabBar
    [self setUpTabBar];
    
}

#pragma mark - 设置tabBar
- (void)setUpTabBar
{
    // 自定义tabBar
    CZTabBar *tabBar = [[CZTabBar alloc] initWithFrame:self.tabBar.frame];
    tabBar.backgroundColor = [UIColor whiteColor];
    
    // 设置代理
    tabBar.delegate = self;
    
    // 给tabBar传递tabBarItem模型
    tabBar.items = self.items;
    
    // 添加自定义tabBar
    [self.view addSubview:tabBar];
    
    // 移除系统的tabBar
    [self.tabBar removeFromSuperview];
}


#pragma mark - 当点击tabBar上的按钮调用
- (void)tabBar:(CZTabBar *)tabBar didClickButton:(NSInteger)index
{
//    if (index == 0 && self.selectedIndex == index) { // 点击首页，刷新
//        [_home refresh];
//    }
    
    self.selectedIndex = index;
}

// 点击加号按钮的时候调用
- (void)tabBarDidClickPlusButton:(CZTabBar *)tabBar
{
    // 创建发送微博控制器
    FJSComposeViewController *composeVc = [[FJSComposeViewController alloc] init];
    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:composeVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    // 发现
    FJSDiscoverViewController *discover = [[FJSDiscoverViewController alloc] init];
    [self setUpOneChildViewController:discover image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_discover_selected"] title:@"发现"];
    
    // 家
    FJSHomeViewController *home = [[FJSHomeViewController alloc] init];
    
    [self setUpOneChildViewController:home image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_home_selected"] title:@"家"];
    _home = home;
    
    
    // 消息
    FJSMessageViewController *message = [[FJSMessageViewController alloc] init];
    [self setUpOneChildViewController:message image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_message_center_selected"] title:@"消息"];
    _message = message;
    

    // 我
    FJSMeViewController *profile = [[FJSMeViewController alloc] init];
    [self setUpOneChildViewController:profile image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_profile_selected"] title:@"我"];
    _profile = profile;
}
// navigationItem决定导航条上的内容
// 导航条上的内容由栈顶控制器的navigationItem决定

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
//    // navigationItem模型
//    vc.navigationItem.title = title;
//    
//    // 设置子控件对应tabBarItem的模型属性
//    vc.tabBarItem.title = title;
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:vc];

    [self addChildViewController:nav];
}

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed
{
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[CZTabBar class]]) {
            CZTabBar *taBar = view;
            taBar.hidden = hidesBottomBarWhenPushed;
        }
    }
}

@end
