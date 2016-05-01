//
//  FJSHomeManager.h
//  Home
//
//  Created by fujisheng on 16/3/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJSHome,FJSAlbum,FJSVideoType,FJSHomeVideo;

@protocol FJSHomeManagerDelegate <NSObject>

@optional

- (void)queryHomeListSuccess:(id)responseData;
- (void)queryHomeListFail:(NSError *)error;
- (void)createHomeSuccess:(FJSHome *)home;
- (void)createHomeFail:(NSError *)error;

- (void)queryAlbumListSuccess:(id)responseData;
- (void)queryAlbumListFail:(NSError *)error;
- (void)createHomeAlbumSuccess:(FJSAlbum *)homeAlbum;
- (void)createHomeAlbumFail:(NSError *)error;

- (void)uploadHomePhotoSuccess:(id)responseData;
- (void)uploadHomePhotoFail:(NSError *)error;
- (void)queryHomePhotoSuccess:(id)responseData;
- (void)queryHomePhotoFail:(NSError *)error;

- (void)queryVideoTypeListSuccess:(id)responseData;
- (void)queryVideoTypeListFail:(NSError *)error;
- (void)createHomeVideoTypeSuccess:(FJSVideoType *)videoType;
- (void)createHomeVideoTypeFail:(NSError *)error;

- (void)uploadHomeVideoSuccess:(FJSHomeVideo *)video;
- (void)uploadHomeVideoFail:(NSError *)error;

- (void)uploadThumbImageSuccess:(id)responseData;
- (void)uploadThumbImageFail:(NSError *)error;
- (void)queryHomeVideoSuccess:(id)responseData;
- (void)queryHomeVideoFail:(NSError *)error;

@end

@interface FJSHomeManager : NSObject

@property (weak,nonatomic) id<FJSHomeManagerDelegate> delegate;


- (void)createHomeWithHomeName:(NSString *)homeName;
- (NSMutableArray *)getHomeArrayFromDB;
- (void)getHomeArrayFromAPI;

- (void)createHomeAlbumWithAlbumName:(NSString *)albumName homeId:(NSString *)homeId;
- (void)getAlbumArrayFromAPIWithHomeId:(NSString *)homeId;
- (NSMutableArray *)getAlbumArrayFromDBWithHomeId:(NSString *)homeId;

- (void)uploadHomePhotoWithParameter:(NSMutableDictionary *)parameters andImageArray:(NSArray *)imageArray;
- (void)getHomePhotoArrayFromAPIWithAlbumId:(NSUInteger)albumId;

- (void)createHomeVideoTypeWithAlbumName:(NSString *)videoTypeName homeId:(NSString *)homeId;
- (void)getVideoTypeArrayFromAPIWithHomeId:(NSString *)homeId;

- (void)uploadHomeVideoWithParameter:(NSMutableDictionary *)parameters andFileUrl:(NSURL *)fileUrl;
- (void)uploadThumbImageWithParameter:(NSMutableDictionary *)parameters andImageArray:(NSArray *)imageArray;
- (void)getHomeVideoArrayFromAPIWithVideoTypeId:(NSUInteger)videoTypeId;

@end
