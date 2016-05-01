//
//  FJSVideoViewController.m
//  Home
//
//  Created by fujisheng on 16/4/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSVideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "FJSConst.h"
#import "FJSHome.h"
#import "FJSVideoType.h"
#import "FJSHomeContext.h"
#import "FJSUserProfile.h"
#import "FJSHomeManager.h"
#import "FJSHomeVideo.h"
#import "FJSHomeVideoCell.h"
#import "UIView+FJSAdd.h"
#import "MJRefresh.h"
#import "FJSVideoPlayViewController.h"

static NSString *const kVideoCellID = @"videoCell";
static const CGFloat kItemWidth = 260;
static const NSUInteger kColumnCount = 1;

@interface FJSVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FJSHomeManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FJSHomeVideoCellDelegate>

@property (strong,nonatomic) UIImagePickerController *pickerCtr;
@property (strong,nonatomic) FJSHomeManager *homeManager;
@property (strong,nonatomic) UIImage *thumbImage;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *homeVideoArray;
@property (strong,nonatomic) FJSHomeVideo *tempUploadVideo;


@end

@implementation FJSVideoViewController

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

    [self layoutUI];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewHomeVideo)];
    [self.collectionView headerBeginRefreshing];
}

- (void)layoutUI
{
    self.title = self.videoType.typeName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editVideo)];
    [self.view addSubview:self.collectionView];
}

- (void)loadNewHomeVideo
{
    [self.homeManager getHomeVideoArrayFromAPIWithVideoTypeId:self.videoType.videoTypeId];
}

#pragma mark - getter & setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kItemWidth, 185);
        // 创建UICollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = FJSGlobalBg;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[FJSHomeVideoCell class] forCellWithReuseIdentifier:kVideoCellID];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIImagePickerController *)pickerCtr
{
    if (!_pickerCtr) {
        _pickerCtr = [[UIImagePickerController alloc] init];
        _pickerCtr.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        _pickerCtr.allowsEditing = YES;
        _pickerCtr.delegate = self;
    }
    return _pickerCtr;
}

- (FJSHomeManager *)homeManager
{
    if (!_homeManager) {
        _homeManager = [[FJSHomeManager alloc] init];
        _homeManager.delegate = self;
    }
    return _homeManager;
}

- (NSMutableArray *)homeVideoArray
{
    if (!_homeVideoArray) {
        _homeVideoArray = [NSMutableArray array];
    }
    return _homeVideoArray;
}

#pragma mark UICollectionViewDataSource & UICollectionViewDataDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeVideoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FJSHomeVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoCellID forIndexPath:indexPath];
    if (indexPath.item < self.homeVideoArray.count) {
        FJSHomeVideo *video = self.homeVideoArray[indexPath.item];
        [cell refreshCellWithHomeVideo:video];
        cell.delegate = self;
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat margin = (FJSScreenWidth - kItemWidth * kColumnCount) / (kColumnCount + 1);
    return UIEdgeInsetsMake(20,margin, margin, margin);
}

#pragma mark - FJSHomeVideoCellDelegate
- (void)homeVideoCellDidClickPlayBtn:(FJSHomeVideo *)video
{
    FJSVideoPlayViewController *videoPlayCtr = [[FJSVideoPlayViewController alloc] init];
    videoPlayCtr.video = video;
    [self.navigationController pushViewController:videoPlayCtr animated:YES];
}

#pragma mark - 事件交互
- (void)editVideo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑视频" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *localVideoAction = [UIAlertAction actionWithTitle:@"本地视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weakSelf.pickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:self.pickerCtr animated:YES completion:nil];
    }];
    
    UIAlertAction *takeVideoAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.pickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:self.pickerCtr animated:YES completion:nil];
    }];
    
    UIAlertAction *deleteVideoAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:localVideoAction];
    [alertController addAction:takeVideoAction];
    [alertController addAction:deleteVideoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传视频" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入视频描述";
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *VideoTypeField = alertController.textFields.firstObject;
        NSString *videoDesc = VideoTypeField.text;
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:(NSString *)kUTTypeMovie]) {
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];  // 初始化视频媒体文件
            
            UIImage *thumbImage = [weakSelf getThumbImageWithAsset:asset];
            long long videoTotalTime = [weakSelf getVideoTotalTimeWithAsset:asset];
            
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            parameter[@"userProfileId"] = @([FJSHomeContext shareContext].currentUserProfile.u_userProfileId);
            parameter[@"videoTypeId"] = @(weakSelf.videoType.videoTypeId);
            parameter[@"videoTypeName"] = weakSelf.videoType.typeName;
            parameter[@"homeId"] = weakSelf.home.h_homeId;
            parameter[@"videoTotalTime"] = @(videoTotalTime);
            parameter[@"videoDesc"] = videoDesc;
            
            [weakSelf.homeManager uploadHomeVideoWithParameter:parameter andFileUrl:url];
            
            weakSelf.thumbImage = thumbImage;
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//获取视频描述
- (NSString *)getVideoDescWith
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建视频库" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入视频库名称";
    }];
    
    __block NSString *videoDesc = @"";
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *VideoTypeField = alertController.textFields.firstObject;
        videoDesc = VideoTypeField.text;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        videoDesc = nil;
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    return videoDesc;
}

//获取视频缩略图
- (UIImage *)getThumbImageWithAsset:(AVURLAsset *)asset
{
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}
//获取视频总时长
- (long long)getVideoTotalTimeWithAsset:(AVURLAsset *)asset
{
    long long second = 0;
    second = asset.duration.value / asset.duration.timescale;
    return second;
}

#pragma mark - FJSHomeManagerDelegate
- (void)uploadHomeVideoSuccess:(FJSHomeVideo *)video
{
    self.tempUploadVideo = video;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    [imageArray addObject:self.thumbImage];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"videoId"] = @(video.videoId);
    parameter[@"videoTypeName"] = self.videoType.typeName;
    parameter[@"homeId"] = self.home.h_homeId;
    
    [self.homeManager uploadThumbImageWithParameter:parameter andImageArray:imageArray];
}

- (void)uploadHomeVideoFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

- (void)uploadThumbImageSuccess:(id)responseData
{
    FJSLog(@"%@",responseData);
    NSString *thumbUrl = [responseData objectForKey:@"thumbUrl"];
    self.tempUploadVideo.thumbUrl =thumbUrl;
    
    [self.homeVideoArray insertObject:self.tempUploadVideo atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    });

}

- (void)uploadThumbImageFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

- (void)queryHomeVideoSuccess:(id)responseData
{
    [self.homeVideoArray removeAllObjects];
    
    NSArray *dictArray = [responseData objectForKey:@"videoList"];
    for (NSDictionary *videoDict in dictArray) {
        FJSHomeVideo *video = [FJSHomeVideo eta_modelFromDictionary:videoDict];
        [self.homeVideoArray addObject:video];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)queryHomeVideoFail:(NSError *)error
{
    FJSLog(@"%@",error);
}

@end
