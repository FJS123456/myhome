//
//  FJSUtil.h
//  Home
//
//  Created by fujisheng on 16/3/19.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJSUtil : NSObject

+ (BOOL)isPhoneNumberMatch:(NSString *)phoneNumber;
+ (NSURL *)transferToUrlWithUrlStr:(NSString *)urlStr;

@end
