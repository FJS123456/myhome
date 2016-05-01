//
//  FJSUtil.m
//  Home
//
//  Created by fujisheng on 16/3/19.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSUtil.h"
#import "NSString+extension.h"
#import "FJSConst.h"

@implementation FJSUtil

+ (BOOL)isPhoneNumberMatch:(NSString *)phoneNumber
{
    BOOL isMatch = false;
    if ([phoneNumber isNotEmpty]) {
        NSString *rule = @"^0{0,1}(13[0-9]|15[3-9]|15[0-2]|18[0-9]|17[5-8]|14[0-9]|170|171)[0-9]{8}$";
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
        isMatch = [pred evaluateWithObject:phoneNumber];
    }
    return isMatch;
}

+ (NSURL *)transferToUrlWithUrlStr:(NSString *)urlStr
{
    NSURL *url = nil;
    if ([urlStr isNotEmpty]) {
       NSString *tempStr = [[NSString stringWithFormat:@"%@%@",API_baseUrl,urlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       url = [NSURL URLWithString:tempStr];
    }
    return url;
}

@end
