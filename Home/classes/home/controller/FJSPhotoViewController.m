//
//  FJSPhotoViewController.m
//  Home
//
//  Created by fujisheng on 16/4/23.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSPhotoViewController.h"
#import "AJPhotoPickerViewController.h"
#import "AJPhotoBrowserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+FJSAdd.h"
#import "FJSConst.h"
#import "FJSHomeContext.h"
#import "FJSUserProfile.h"
#import "FJSAlbum.h"
#import "FJSHome.h"
#import "FJSHomePhotoCell.h"
#import "HMWaterflowLayout.h"
#import "FJSHomePhoto.h"
#import "MJRefresh.h"
#import "FJSHomePhotoHeaderView.h"
#import "FJSHomeManager.h"
#import "MBProgressHUD+MJ.h"

#import "YYPhotoGroupView.h"
#import "FJSUtil.h"

static NSString *const kPhotoCellID = @"homePhotoCell";

@interface FJSPhotoViewController ()<AJPhotoPickerProtocol,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,HMWaterflowLayoutDelegate,UICollectionViewDelegateFlowLayout,FJSHomeManagerDelegate>

@property (strong,nonatomic) NSMutableArray *homePhotos;
@property (strong, nonatomic) NSMutableArray *assetArray;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) AJPhotoPickerViewController *picker;
@property (strong,nonatomic) FJSHomeManager *homeManager;

@end

@implementation FJSPhotoViewController

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
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewPhotos)];
    [self.collectionView headerBeginRefreshing];
}

- (void)loadNewPhotos
{
    [self.homeManager getHomePhotoArrayFromAPIWithAlbumId:self.album.albumId];
}

- (void)layoutUI
{
    self.title = self.album.albumName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editPhoto)];
    [self.view addSubview:self.collectionView];
}

#pragma mark - setter & getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
        layout.delegate = self;
        // 创建UICollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[FJSHomePhotoCell class] forCellWithReuseIdentifier:kPhotoCellID];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSMutableArray *)homePhotos {
    if (_homePhotos == nil) {
        _homePhotos = [NSMutableArray array];
    }
    return _homePhotos;
}

- (NSMutableArray *)assetArray {
    if (_assetArray == nil) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (AJPhotoPickerViewController *)picker
{
    if (!_picker) {
        _picker = [[AJPhotoPickerViewController alloc] init];
        _picker.maximumNumberOfSelection = 5;
        _picker.multipleSelection = YES;
        _picker.assetsFilter = [ALAssetsFilter allPhotos];
        _picker.delegate = self;
        _picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
    }
    return _picker;
}

- (FJSHomeManager *)homeManager
{
    if (!_homeManager) {
        _homeManager = [[FJSHomeManager alloc] init];
        _homeManager.delegate = self;
    }
    return _homeManager;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FJSHomePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellID forIndexPath:indexPath];
    if (indexPath.item < self.homePhotos.count) {
        FJSHomePhoto *photo = self.homePhotos[indexPath.item];
        cell.photoUrl = photo.photoUrl;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FJSHomePhotoCell *cell = (FJSHomePhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imgView =  cell.imageView;
    UIImageView *fromView = nil;
    
    NSMutableArray *items = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < self.homePhotos.count; ++i) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        FJSHomePhoto *photo = self.homePhotos[i];
        item.thumbView = nil;
        item.largeImageURL = [FJSUtil transferToUrlWithUrlStr:photo.photoUrl];
        item.largeImageSize = CGSizeMake(photo.photoWidth, photo.photoHeight);
        [items addObject:item];
        
        if (i == indexPath.item) {
            item.thumbView = imgView;
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
    
}

#pragma mark - HMWaterflowLayoutDelegate

- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < self.homePhotos.count) {
        FJSHomePhoto *photo = self.homePhotos[indexPath.item];
        double scale = roundf(photo.photoHeight) / roundf(photo.photoWidth);
        CGFloat height =  width * scale;
        return height;
    } else {
        return 0;
    }
}

#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets
{
    [self.assetArray addObjectsFromArray:assets];
    for (int i = 0; i < self.assetArray.count; ++i) {
        ALAsset *asset = self.assetArray[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.imageArray addObject:tempImg];
        FJSLog(@"width:%f---height:%f",tempImg.size.width,tempImg.size.height);
    }
    
    [MBProgressHUD showMessage:@"正在上传相片。。。"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userProfileId"] = @([FJSHomeContext shareContext].currentUserProfile.u_userProfileId);
    parameters[@"albumId"] = @(self.album.albumId);
    parameters[@"albumName"] = self.album.albumName;
    parameters[@"homeId"] = self.home.h_homeId;
    
    [self.homeManager uploadHomePhotoWithParameter:parameters andImageArray:self.imageArray];
    
    [picker dismissViewControllerAnimated:NO completion:nil];

}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
    }];
}

#pragma mark - UIImagePickerDelegate

- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}


#pragma mark - UIImagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (!error) {
        NSLog(@"保存到相册成功");
    }else{
        NSLog(@"保存到相册出错%@", error);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:originalImage];
    
    [MBProgressHUD showMessage:@"正在上传相片。。。"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userProfileId"] = @([FJSHomeContext shareContext].currentUserProfile.u_userProfileId);
    parameters[@"albumId"] = @(self.album.albumId);
    parameters[@"albumName"] = self.album.albumName;
    parameters[@"homeId"] = self.home.h_homeId;
    
    [self.homeManager uploadHomePhotoWithParameter:parameters andImageArray:self.imageArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - homeManagerDelegate
- (void)uploadHomePhotoSuccess:(id)responseData
{
    [self.assetArray removeAllObjects];
    [self.imageArray removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [self.collectionView headerBeginRefreshing];
    });
}

- (void)uploadHomePhotoFail:(NSError *)error
{
    FJSLog(@"%@",error);
    [MBProgressHUD hideHUD];
}

- (void)queryHomePhotoSuccess:(id)responseData
{
    [self.homePhotos removeAllObjects];

    NSArray *dictArray = [responseData objectForKey:@"photoList"];
    for (NSDictionary *photoDict in dictArray) {
        FJSHomePhoto *photo = [FJSHomePhoto eta_modelFromDictionary:photoDict];

        [self.homePhotos addObject:photo];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView headerEndRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)queryHomePhotoFail:(NSError *)error
{
    
}

#pragma mark - 事件处理
- (void)editPhoto
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑相片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *uploadPhotoAction = [UIAlertAction actionWithTitle:@"上传图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
    }];
    
    UIAlertAction *deletePhotoAction = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:uploadPhotoAction];
    [alertController addAction:deletePhotoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
