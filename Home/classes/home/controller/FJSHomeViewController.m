//
//  FJSHomeViewController.m
//  Home
//
//  Created by fujisheng on 16/3/23.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomeViewController.h"
#import "FJSHomeManager.h"
#import "FJSHomeCell.h"
#import "FJSConst.h"
#import "FJSHome.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import <Eta/Eta.h>
#import "FJSBaseHomeViewController.h"

@interface FJSHomeViewController()<UITableViewDataSource,UITableViewDelegate,FJSHomeManagerDelegate>

@property (strong,nonatomic) FJSHomeManager *homeManager;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *homeArray;

@end

@implementation FJSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewHomeArray)];
    [self.tableView headerBeginRefreshing];
}

- (void)layoutUI
{
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建家庭" style:UIBarButtonItemStylePlain target:self action:@selector(createHome)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.homeArray = [self.homeManager getHomeArrayFromDB];
    [self.tableView reloadData];
}

- (void)loadNewHomeArray
{
    [self.homeManager getHomeArrayFromAPI];
}

#pragma mark - 延迟加载
- (NSMutableArray *)homeArray
{
    if (!_homeArray) {
        _homeArray = [NSMutableArray array];
    }
    return _homeArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = FJSGlobalBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (FJSHomeManager *)homeManager
{
    if (!_homeManager) {
        _homeManager = [[FJSHomeManager alloc] init];
        _homeManager.delegate = self;
    }
    return _homeManager;
}

#pragma mark tableView datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJSHomeCell *homeCell = [FJSHomeCell homeCellWithTableView:tableView];
    
    if (indexPath.row < self.homeArray.count) {
     [homeCell refreshCellWithHome:self.homeArray[indexPath.row]];
    }
    
    return homeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FJSHome *home = self.homeArray[indexPath.row];
    
    FJSBaseHomeViewController *baseHomeCtr = [[FJSBaseHomeViewController alloc] init];
    baseHomeCtr.home = home;
    [self.navigationController pushViewController:baseHomeCtr animated:YES];
}

#pragma mark - FJSHomeManager delegate

- (void)queryHomeListSuccess:(id)responseData
{
    [self.homeArray removeAllObjects];
    
    NSArray *dictArray = [responseData objectForKey:@"homeList"];
    for (NSDictionary *homeDict in dictArray) {
        FJSHome *home = [FJSHome eta_modelFromDictionary:homeDict];
        
        [[EtaContext shareInstance] saveModel:home];
        [self.homeArray addObject:home];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    });
}

- (void)queryHomeListFail:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    NSLog(@"%@",error);
}

- (void)createHomeSuccess:(FJSHome *)home
{
    [self.homeArray insertObject:home atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    });

}

- (void)createHomeFail:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:@"创建房间失败"];
    });
    NSLog(@"%@",error);
}

#pragma mark - 事件交互
- (void)createHome
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建家庭" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入家庭名称";
    }];
    
    __weak typeof (self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *homeField = alertController.textFields.firstObject;
        [weakSelf.homeManager createHomeWithHomeName:homeField.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
