#import <Foundation/Foundation.h>

#ifdef DEBUG
#define FJSLog(...) NSLog(__VA_ARGS__)
#else
#define FJSLog(...)
#endif

#define FJSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define FJSGlobalBg FJSColor(241, 240, 239)
#define FJSKeyWindow [UIApplication sharedApplication].keyWindow
#define FJSNotificationCenter [NSNotificationCenter defaultCenter]

#define API_baseUrl @"http://172.27.35.3"

#define API_loginUrl  [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/user/userLogin"]
#define API_registerUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/user/userRegister"]

#define API_createHomeUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/home/createHome"]
#define API_getHomeListUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/home/getHomeList"]

#define API_getAlbumListUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/home/getAlbumList"]
#define API_createHomeAlbumUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/home/createHomeAlbum"]
#define API_uploadHomePhotoUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/file/uploadHomePhoto"]
#define API_getHomePhotoListUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/file/getHomePhotoList"]

#define API_getVideoTypeListUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/home/getVideoTypeList"]
#define API_createHomeVideoTypeUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/home/createHomeVideoType"]

#define API_uploadHomeVideoUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/file/uploadHomeVideo"]
#define API_uploadVideoThumbUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/file/uploadVideoThumb"]
#define API_getHomeVideoListUrl [NSString stringWithFormat:@"%@%@",API_baseUrl,@"/myhome/file/getHomeVideoList"]



extern NSString *const MTCityDidChangeNotification;
extern NSString *const MTSelectCityName;

extern NSString *const MTSortDidChangeNotification;
extern NSString *const MTSelectSort;

extern NSString *const MTCategoryDidChangeNotification;
extern NSString *const MTSelectCategory;
extern NSString *const MTSelectSubcategoryName;

extern NSString *const MTRegionDidChangeNotification;
extern NSString *const MTSelectRegion;
extern NSString *const MTSelectSubregionName;

extern NSString *const MTCollectStateDidChangeNotification;
extern NSString *const MTIsCollectKey;
extern NSString *const MTCollectDealKey;