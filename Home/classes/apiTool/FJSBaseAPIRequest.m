//
//  FJSBaseAPIRequest.m
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSBaseAPIRequest.h"
#import "FJSRequestParam.h"
#import "AFNetworking.h"
#import "FJSConst.h"

#define FJSCustomErrorDomain @"customError"

typedef enum {
    FJSErrorTypeDefault = -100
}FJSErrorType;

@implementation FJSBaseAPIRequest

+ (void)postRequestWithRequestParam:(FJSRequestParam *)param
{
    NSString *urlStr = [param.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //1.设置请求方式
    [request setHTTPMethod:@"POST"];
    //2.超时时间
    [request setTimeoutInterval:30];
    //3.设置请求内容格式
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:param.bodyDict options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                param.failBlock(error);
            } else {
                NSDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"%@",requestData);
                if ([[requestData objectForKey:@"error_code"] integerValue] == 1) { //请求成功
                    param.successBlock(requestData);
                } else {
                    NSString *failMsg = [requestData objectForKey:@"msg"];
                    if (failMsg == nil) {
                        failMsg = @"网络连接有问题";
                    }
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:failMsg forKey:NSLocalizedDescriptionKey];
                    NSError *failError = [NSError errorWithDomain:FJSCustomErrorDomain code:FJSErrorTypeDefault userInfo:userInfo];
                    param.failBlock(failError);
                }
            }
        }];
        
        [task resume];

    });
}

+ (void)getRequestWithRequestParam:(FJSRequestParam *)param
{
    
}

+ (void)uploadImagesWithRequestParam:(FJSRequestParam *)param imageDataArray:(NSArray *)imageDatas;
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    for (int i = 0 ; i < imageDatas.count; ++i) {
        UIImage *image = imageDatas[i];
        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
        param.bodyDict[@"width"] = @(image.size.width);
        param.bodyDict[@"height"] = @(image.size.height);
        [mgr POST:param.urlStr parameters:param.bodyDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:fileData name:@"file" fileName:@"" mimeType:@"image/jpg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (i == imageDatas.count - 1) {
                param.successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (error) {
                param.failBlock(error);
            }
        }];
    }
}

+ (void)uploadVideoWithRequestParam:(FJSRequestParam *)param fileUrl:(NSURL *)fileUrl
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:param.urlStr parameters:param.bodyDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:@"" mimeType:@"video/quicktime" error:&error];
        if (error) {
            FJSLog(@"%@",error);
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            param.successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            param.failBlock(error);
        }
    }];
}

@end
