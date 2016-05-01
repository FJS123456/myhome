//
//  FJSVideoTypeViewController.m
//  Home
//
//  Created by fujisheng on 16/4/29.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSVideoTypeViewController.h"
#import "FJSAddFolderCell.h"
#import "MJRefresh.h"
#import "FJSConst.h"
#import "FJSHomeManager.h"
#import "UIView+FJSAdd.h"
#import "FJSVideoType.h"
#import "FJSVideoViewController.h"
#import "FJSHome.h"
#import <Eta/Eta.h>

static NSString *kAddFolderCell = @"addFolder";
static NSString *kFolderCell = @"folder";
static const CGFloat kItemHeight = 85;
static const NSUInteger kColumnCount = 3;

@interface FJSVideoTypeViewController ()<FJSHomeManagerDelegate>

@property (strong,nonatomic) FJSHomeManager *homeManager;
@property (strong,nonatomic) NSMutableArray *videoTypeArray;

@end

@implementation FJSVideoTypeViewController

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(85, 105);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[FJSAddFolderCell class] forCellWithReuseIdentifier:kAddFolderCell];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = FJSGlobalBg;
    self.collectionView.delegate = self;
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewFolder)];
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - 加载数据

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    self.albumArray = [self.homeManager getAlbumArrayFromDBWithHomeId:self.home.h_homeId];
    //    [self.collectionView reloadData];
}

- (void)loadNewFolder
{
    [self.homeManager getVideoTypeArrayFromAPIWithHomeId:self.home.h_homeId];
}

#pragma mark - 延迟加载
- (FJSHomeManager *)homeManager
{
    if (!_homeManager) {
        _homeManager = [[FJSHomeManager alloc] init];
        _homeManager.delegate = self;
    }
    return _homeManager;
}

- (NSMutableArray *)videoTypeArray
{
    if (!_videoTypeArray) {
        _videoTypeArray = [NSMutableArray array];
    }
    return _videoTypeArray;
}

#pragma mark - UICollectionViewDataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoTypeArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FJSAddFolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddFolderCell forIndexPath:indexPath];
    NSUInteger index = indexPath.item;
    
    if (index >= self.videoTypeArray.count + 1) {
        return cell;
    }
    
    if (index == 0) {
        cell.addImageView.image = [UIImage imageNamed:@"addFolder"];
        cell.titleLabel.text = @"新建视频库";
        cell.titleLabel.textColor = [UIColor lightGrayColor];
    } else {
        //
        FJSVideoType *videoType = self.videoTypeArray[indexPath.item - 1];
        
        cell.addImageView.image = [UIImage imageNamed:@"folder"];
        cell.titleLabel.text = videoType.typeName;
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat margin = (FJSScreenWidth - kItemHeight * kColumnCount) / (kColumnCount + 1);
    return UIEdgeInsetsMake(20,margin, 100, margin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建视频库" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入视频库名称";
        }];
        
        __weak typeof (self) weakSelf = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *VideoTypeField = alertController.textFields.firstObject;
            [weakSelf.homeManager createHomeVideoTypeWithAlbumName:VideoTypeField.text homeId:self.home.h_homeId];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        FJSVideoViewController *videoCtr = [[FJSVideoViewController alloc] init];
        //
        videoCtr.videoType = self.videoTypeArray[indexPath.item - 1];
        videoCtr.home = self.home;
        [self.navigationController pushViewController:videoCtr animated:YES];
    }
}

#pragma mark - FJSHomeManagerDelegate

- (void)queryVideoTypeListSuccess:(id)responseData
{
    [self.videoTypeArray removeAllObjects];
    
    NSArray *dictArray = [responseData objectForKey:@"videoTypeList"];
    for (NSDictionary *videoTypeDict in dictArray) {
        FJSVideoType *videoType = [FJSVideoType eta_modelFromDictionary:videoTypeDict];
        
        [[EtaContext shareInstance] saveModel:videoType];
        [self.videoTypeArray addObject:videoType];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)queryVideoTypeListFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

- (void)createHomeVideoTypeSuccess:(FJSVideoType *)videoType
{
    [self.videoTypeArray insertObject:videoType atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    });

}

- (void)createHomeVideoTypeFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

@end
