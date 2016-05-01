//
//  FJSBaseAPIRequest.h
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJSRequestParam;

@interface FJSBaseAPIRequest : NSObject

//request请求
+ (void)postRequestWithRequestParam:(FJSRequestParam *)param;
//get请求
+ (void)getRequestWithRequestParam:(FJSRequestParam *)param;
//图片上传
+ (void)uploadImagesWithRequestParam:(FJSRequestParam *)param imageDataArray:(NSArray *)imageDatas;
//视频上传
+ (void)uploadVideoWithRequestParam:(FJSRequestParam *)param fileUrl:(NSURL *)fileUrl;

@end
