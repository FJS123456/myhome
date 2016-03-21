//
//  FJSApiRequest.m
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSApiRequest.h"
#import "FJSBaseAPIRequest.h"
#import "FJSRequestParam.h"

@implementation FJSApiRequest

+ (void)postRequestWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict tagert:(id)tagert okSel:(SEL)okSel errorSel:(SEL)errorSel failSel:(SEL)failSel
{
    FJSRequestParam *param = [[FJSRequestParam alloc] init];
    param.target = tagert;
    param.urlStr = urlStr;
    param.bodyDict = bodyDict;
    param.okSelector = okSel;
    param.errorSelector = errorSel;
    param.failSelector = failSel;
    
    [FJSBaseAPIRequest postRequestWithRequestParam:param];
}

@end
