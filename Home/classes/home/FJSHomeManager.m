//
//  FJSHomeManager.m
//  Home
//
//  Created by fujisheng on 16/3/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomeManager.h"
#import "FJSHome.h"
#import "FJSAlbum.h"
#import "FJSUserProfile.h"
#import "NSString+extension.h"
#import "FJSHomeContext.h"
#import "FJSApiRequest.h"
#import "FJSConst.h"
#import "MBProgressHUD+MJ.h"
#import <Eta/Eta.h>
#import "EtaMapper.h"
#import "FJSVideoType.h"
#import "FJSHomeVideo.h"

@implementation FJSHomeManager

- (void)createHomeWithHomeName:(NSString *)homeName
{
    if ([homeName isNotEmpty]) {
        
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        userDict[@"user_profile_id"] = @([FJSHomeContext shareContext].currentUserProfile.u_userProfileId);
        
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"home_name"] = homeName;
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
        bodyDict[@"create_date"] = @(round(timeInterval) * 1000);
        bodyDict[@"score"] = @(0);
        bodyDict[@"creater"] = userDict;
        
        __weak typeof(self) weakSelf = self;
        
        [FJSApiRequest postRequestWithUrl:API_createHomeUrl bodyDict:bodyDict successBlock:^(id responseData) {
            
            NSDictionary *dict = [responseData objectForKey:@"home"];
            FJSHome *home = [FJSHome eta_modelFromDictionary:dict];
            
            [[EtaContext shareInstance] saveModel:home];
            
            if ([weakSelf.delegate respondsToSelector:@selector(createHomeSuccess:)]) {
                [weakSelf.delegate createHomeSuccess:home];
            }
            
        } failBlock:^(NSError *error) {
            if ([weakSelf.delegate respondsToSelector:@selector(createHomeFail:)]) {
                [weakSelf.delegate createHomeFail:error];
            }
        }];
    }
}

#pragma mark - home的DB操作
- (NSMutableArray *)getHomeArrayFromDB
{
    NSArray *homeArray = [[EtaContext shareInstance] allModels:EtaModelTypeHome];
    
    return [homeArray mutableCopy];
}

#pragma mark - 获取家庭列表
- (void)getHomeArrayFromAPI
{
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"user_profile_id"] = @([FJSHomeContext shareContext].currentUserProfile.u_userProfileId);
    
    __weak typeof(self) weakSelf = self;
    [FJSApiRequest postRequestWithUrl:API_getHomeListUrl bodyDict:bodyDict successBlock:^(id responseData) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryHomeListSuccess:)]) {
            [weakSelf.delegate queryHomeListSuccess:responseData];
        }
        
    } failBlock:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryHomeListFail:)]) {
            [weakSelf.delegate queryHomeListFail:error];
        }
    }];
}

#pragma mark - 获取一个家庭下的所有相册
- (void)getAlbumArrayFromAPIWithHomeId:(NSString *)homeId
{
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"home_id"] = homeId;
    
    __weak typeof(self) weakSelf = self;
    [FJSApiRequest postRequestWithUrl:API_getAlbumListUrl bodyDict:bodyDict successBlock:^(id responseData) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryAlbumListSuccess:)]) {
            [weakSelf.delegate queryAlbumListSuccess:responseData];
        }
    } failBlock:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryAlbumListFail:)]) {
            [weakSelf.delegate queryAlbumListFail:error];
        }
    }];
}

- (NSMutableArray *)getAlbumArrayFromDBWithHomeId:(NSString *)homeId
{
    NSArray *albumArray = [[EtaContext shareInstance] modelsQuery:homeId withType:EtaModelTypeAlbum];
    return [albumArray mutableCopy];
}

#pragma mark - 创建相册

- (void)createHomeAlbumWithAlbumName:(NSString *)albumName homeId:(NSString *)homeId
{
    if ([albumName isNotEmpty]) {
        
        NSMutableDictionary *homeDict = [NSMutableDictionary dictionary];
        homeDict[@"home_id"] = homeId;
        
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"album_name"] = albumName;
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
        bodyDict[@"create_date"] = @(round(timeInterval) * 1000);
        bodyDict[@"home"] = homeDict;
        
        __weak typeof(self) weakSelf = self;
        
        [FJSApiRequest postRequestWithUrl:API_createHomeAlbumUrl bodyDict:bodyDict successBlock:^(id responseData) {
            
            NSDictionary *dict = [responseData objectForKey:@"homeAlbum"];
            FJSAlbum *homeAlbum = [FJSAlbum eta_modelFromDictionary:dict];
            
            [[EtaContext shareInstance] saveModel:homeAlbum];
            
            if ([weakSelf.delegate respondsToSelector:@selector(createHomeAlbumSuccess:)]) {
                [weakSelf.delegate createHomeAlbumSuccess:homeAlbum];
            }
            
        } failBlock:^(NSError *error) {
            if ([weakSelf.delegate respondsToSelector:@selector(createHomeAlbumFail:)]) {
                [weakSelf.delegate createHomeAlbumFail:error];
            }
        }];
    }
}

#pragma mark 上传相片
- (void)uploadHomePhotoWithParameter:(NSMutableDictionary *)parameters andImageArray:(NSArray *)imageArray
{
    __weak typeof(self) weakSelf = self;
    
    [FJSApiRequest uploadImagesWithUrl:API_uploadHomePhotoUrl bodyDict:parameters imageDataArray:imageArray successBlock:^(id responseData) {
        if ([weakSelf.delegate respondsToSelector:@selector(uploadHomePhotoSuccess:)]) {
            [weakSelf.delegate uploadHomePhotoSuccess:responseData];
        }
    } failBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(uploadHomePhotoFail:)]) {
            [weakSelf.delegate uploadHomePhotoFail:error];
        }
    }];
}

#pragma mark 从服务器获取家庭相片
- (void)getHomePhotoArrayFromAPIWithAlbumId:(NSUInteger)albumId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"album_id"] = @(albumId);
    
    __weak typeof(self) weakSelf = self;
    [FJSApiRequest postRequestWithUrl:API_getHomePhotoListUrl bodyDict:parameters successBlock:^(id responseData) {
        if ([weakSelf.delegate respondsToSelector:@selector(queryHomePhotoSuccess:)]) {
            [weakSelf.delegate queryHomePhotoSuccess:responseData];
        }
        
    } failBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(queryHomePhotoFail:)]) {
            [weakSelf.delegate queryHomePhotoFail:error];
        }
    }];
}

#pragma mark 查询视频库列表 & 创建视频库
- (void)getVideoTypeArrayFromAPIWithHomeId:(NSString *)homeId
{
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"home_id"] = homeId;
    
    __weak typeof(self) weakSelf = self;
    [FJSApiRequest postRequestWithUrl:API_getVideoTypeListUrl bodyDict:bodyDict successBlock:^(id responseData) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryVideoTypeListSuccess:)]) {
            [weakSelf.delegate queryVideoTypeListSuccess:responseData];
        }
    } failBlock:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryVideoTypeListFail:)]) {
            [weakSelf.delegate queryVideoTypeListFail:error];
        }
    }];
}

- (void)createHomeVideoTypeWithAlbumName:(NSString *)videoTypeName homeId:(NSString *)homeId
{
    if ([videoTypeName isNotEmpty]) {
        
        NSMutableDictionary *homeDict = [NSMutableDictionary dictionary];
        homeDict[@"home_id"] = homeId;
        
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
        bodyDict[@"type_name"] = videoTypeName;
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
        bodyDict[@"create_date"] = @(round(timeInterval) * 1000);
        bodyDict[@"home"] = homeDict;
        
        __weak typeof(self) weakSelf = self;
        
        [FJSApiRequest postRequestWithUrl:API_createHomeVideoTypeUrl bodyDict:bodyDict successBlock:^(id responseData) {
            
            NSDictionary *dict = [responseData objectForKey:@"videoType"];
            FJSVideoType *videoType = [FJSVideoType eta_modelFromDictionary:dict];
            
            [[EtaContext shareInstance] saveModel:videoType];
            
            if ([weakSelf.delegate respondsToSelector:@selector(createHomeVideoTypeSuccess:)]) {
                [weakSelf.delegate createHomeVideoTypeSuccess:videoType];
            }
            
        } failBlock:^(NSError *error) {
            if ([weakSelf.delegate respondsToSelector:@selector(createHomeVideoTypeFail:)]) {
                [weakSelf.delegate createHomeVideoTypeFail:error];
            }
        }];
    }
}

#pragma mark - 上传视频 & 获取视频
- (void)uploadHomeVideoWithParameter:(NSMutableDictionary *)parameters andFileUrl:(NSURL *)fileUrl
{
     __weak typeof(self) weakSelf = self;
    
    [FJSApiRequest uploadVideoWithUrl:API_uploadHomeVideoUrl bodyDict:parameters fileUrl:fileUrl successBlock:^(id responseData) {
        
        NSDictionary *dict = [responseData objectForKey:@"video"];
        FJSHomeVideo *video = [FJSHomeVideo eta_modelFromDictionary:dict];
        
        [[EtaContext shareInstance] saveModel:video];
        
        if ([weakSelf.delegate respondsToSelector:@selector(uploadHomeVideoSuccess:)]) {
            [weakSelf.delegate uploadHomeVideoSuccess:video];
        }
        
    } failBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(uploadHomeVideoFail:)]) {
            [weakSelf.delegate uploadHomeVideoFail:error];
        }
    }];
}

- (void)getHomeVideoArrayFromAPIWithVideoTypeId:(NSUInteger)videoTypeId
{
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"video_type_id"] = @(videoTypeId);
    
    __weak typeof(self) weakSelf = self;
    [FJSApiRequest postRequestWithUrl:API_getHomeVideoListUrl bodyDict:bodyDict successBlock:^(id responseData) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryHomeVideoSuccess:)]) {
            [weakSelf.delegate queryHomeVideoSuccess:responseData];
        }
    } failBlock:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(queryHomeVideoFail:)]) {
            [weakSelf.delegate queryHomeVideoFail:error];
        }
    }];
}

#pragma mark - 上传视频缩略图
- (void)uploadThumbImageWithParameter:(NSMutableDictionary *)parameters andImageArray:(NSArray *)imageArray
{
    __weak typeof(self) weakSelf = self;
    
    [FJSApiRequest uploadImagesWithUrl:API_uploadVideoThumbUrl bodyDict:parameters imageDataArray:imageArray successBlock:^(id responseData) {
        if ([weakSelf.delegate respondsToSelector:@selector(uploadThumbImageSuccess:)]) {
            [weakSelf.delegate uploadThumbImageSuccess:responseData];
        }
    } failBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(uploadThumbImageFail:)]) {
            [weakSelf.delegate uploadThumbImageFail:error];
        }
    }];

}

@end
