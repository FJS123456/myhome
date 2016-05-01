//
//  FJSAlbumViewController.m
//  Home
//
//  Created by fujisheng on 16/4/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSAlbumViewController.h"
#import "FJSConst.h"
#import "UIView+FJSAdd.h"
#import "FJSAddFolderCell.h"
#import "FJSHomeManager.h"
#import "MJRefresh.h"
#import "FJSHome.h"
#import "FJSAlbum.h"
#import <Eta/Eta.h>
#import "FJSPhotoViewController.h"

static NSString *kAddFolderCell = @"addFolder";
static NSString *kFolderCell = @"folder";
static const CGFloat kItemWidth = 85;
static const NSUInteger kColumnCount = 3;

@interface FJSAlbumViewController ()<UICollectionViewDelegateFlowLayout,FJSHomeManagerDelegate>

@property (strong,nonatomic) FJSHomeManager *homeManager;
@property (strong,nonatomic) NSMutableArray *albumArray;

@end

@implementation FJSAlbumViewController

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(kItemWidth, 105);
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
    
    self.albumArray = [self.homeManager getAlbumArrayFromDBWithHomeId:self.home.h_homeId];
    [self.collectionView reloadData];
}

- (void)loadNewFolder
{
    [self.homeManager getAlbumArrayFromAPIWithHomeId:self.home.h_homeId];
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

- (NSMutableArray *)albumArray
{
    if (!_albumArray) {
        _albumArray = [NSMutableArray array];
    }
    return _albumArray;
}

#pragma mark - UICollectionViewDataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FJSAddFolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddFolderCell forIndexPath:indexPath];
    NSUInteger index = indexPath.item;
    
    if (index >= self.albumArray.count + 1) {
        return cell;
    }
    
    if (index == 0) {
        cell.addImageView.image = [UIImage imageNamed:@"addFolder"];
        cell.titleLabel.text = @"新建相册";
        cell.titleLabel.textColor = [UIColor lightGrayColor];
    } else {
        //
        FJSAlbum *album = self.albumArray[indexPath.item - 1];
        
        cell.addImageView.image = [UIImage imageNamed:@"folder"];
        cell.titleLabel.text = album.albumName;
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat margin = (FJSScreenWidth - kItemWidth * kColumnCount) / (kColumnCount + 1);
    return UIEdgeInsetsMake(20,margin, 100, margin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入相册名称";
        }];
        
        __weak typeof (self) weakSelf = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *albumField = alertController.textFields.firstObject;
            [weakSelf.homeManager createHomeAlbumWithAlbumName:albumField.text homeId:weakSelf.home.h_homeId];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        FJSPhotoViewController *photoCtr = [[FJSPhotoViewController alloc] init];
        //
        photoCtr.album = self.albumArray[indexPath.item - 1];
        photoCtr.home = self.home;
        [self.navigationController pushViewController:photoCtr animated:YES];
    }
}

#pragma mark FJSHomeManagerDelegate

- (void)queryAlbumListSuccess:(id)responseData
{
    [self.albumArray removeAllObjects];
    
    NSArray *dictArray = [responseData objectForKey:@"albumList"];
    for (NSDictionary *albumDict in dictArray) {
        FJSAlbum *album = [FJSAlbum eta_modelFromDictionary:albumDict];
        
        [[EtaContext shareInstance] saveModel:album];
        [self.albumArray addObject:album];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)queryAlbumListFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

- (void)createHomeAlbumSuccess:(FJSAlbum *)homeAlbum
{
    [self.albumArray insertObject:homeAlbum atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    });
}

- (void)createHomeAlbumFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

@end
