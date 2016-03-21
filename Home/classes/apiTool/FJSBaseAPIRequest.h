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

@end
