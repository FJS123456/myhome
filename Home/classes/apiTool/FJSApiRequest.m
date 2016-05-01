//
//  FJSApiRequest.m
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSApiRequest.h"
#import "FJSBaseAPIRequest.h"

@implementation FJSApiRequest

+ (void)postRequestWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict successBlock:(FJSSuccessBlock)successBlock
                 failBlock:(FJSFailBlock)failBlock
{
    FJSRequestParam *param = [[FJSRequestParam alloc] init];
    param.urlStr = urlStr;
    param.bodyDict = bodyDict;
    param.successBlock = successBlock;
    param.failBlock = failBlock;
    
    [FJSBaseAPIRequest postRequestWithRequestParam:param];
}

+ (void)uploadImagesWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict imageDataArray:(NSArray *)imageDatas successBlock:(FJSSuccessBlock)successBlock
                  failBlock:(FJSFailBlock)failBlock
{
    FJSRequestParam *param = [[FJSRequestParam alloc] init];
    param.urlStr = urlStr;
    param.bodyDict = bodyDict;
    param.successBlock = successBlock;
    param.failBlock = failBlock;
    
    [FJSBaseAPIRequest uploadImagesWithRequestParam:param imageDataArray:imageDatas];
}

+ (void)uploadVideoWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict fileUrl:(NSURL *)fileUrl successBlock:(FJSSuccessBlock)successBlock
                 failBlock:(FJSFailBlock)failBlock
{
    FJSRequestParam *param = [[FJSRequestParam alloc] init];
    param.urlStr = urlStr;
    param.bodyDict = bodyDict;
    param.successBlock = successBlock;
    param.failBlock = failBlock;
    
    [FJSBaseAPIRequest uploadVideoWithRequestParam:param fileUrl:fileUrl];
}

@end
