//
//  AppDelegate.m
//  Home
//
//  Created by fujisheng on 16/3/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSAppDelegate.h"
#import "FJSViewController.h"
#import "FJSLoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "FJSUserProfile.h"
#import <Eta/Eta.h>
#import "EtaMapper.h"

//SMSSDK官网公共key
#define appkey @"f3fc6baa9ac4"
#define app_secrect @"7f3dedcb36d92deebcb373af921d635a"

@interface FJSAppDelegate ()

@end

@implementation FJSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [SMSSDK registerApp:appkey withSecret:app_secrect];
    //配置数据库
    [self configDB];
    
    FJSLoginViewController *controller = [[FJSLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configDB
{
    [[EtaContext shareInstance] registerMapper:[EtaMapper class]];
    [[EtaContext shareInstance] registerDbPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/home.sqlite"]];
    NSLog(@"%@",[NSHomeDirectory() stringByAppendingFormat:@"/Documents/home.sqlite"]);
    [[EtaContext shareInstance] registerClass:@[@(EtaModelTypeUserProfile),@(EtaModelTypeHome),@(EtaModelTypeAlbum),@(EtaModelTypeVideoType),@(EtaModelTypeVideo)]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
