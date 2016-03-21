//
//  FJSBaseAPIRequest.m
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSBaseAPIRequest.h"
#import "FJSRequestParam.h"

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
                [param.target performSelectorOnMainThread:param.errorSelector withObject:error waitUntilDone:YES];
            } else {
                NSDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",requestData);
                if ([[requestData objectForKey:@"error_code"] integerValue] == 1) { //请求成功
                    [param.target performSelectorOnMainThread:param.okSelector withObject:requestData waitUntilDone:YES];
                } else {
                    NSString *failMsg = [requestData objectForKey:@"msg"];
                    [param.target performSelectorOnMainThread:param.failSelector withObject:failMsg waitUntilDone:YES];
                }
            }
        }];
        
        [task resume];

    });
}

+ (void)getRequestWithRequestParam:(FJSRequestParam *)param
{
    
}

@end
