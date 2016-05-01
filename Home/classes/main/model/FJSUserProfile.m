//
//  FJSUserProfile.m
//  Home
//
//  Created by fujisheng on 16/3/22.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSUserProfile.h"

@implementation FJSUserProfile

+ (NSDictionary *)eta_jsonKeyPathsByProperty
{
    return  @{
              @"u_userProfileId"  :     @"user_profile_id",
              @"u_phoneNumber"    :     @"phone_number",
              @"u_password"       :     @"password",
              @"u_realName"       :     @"real_name",
              @"u_registerDate"   :     @"register_date",
              @"u_iconUrl"        :     @"icon_url",
              @"u_sex"            :     @"sex",
              @"u_birthday"       :     @"birthday",
              @"u_sign"           :     @"sign"
              };
}

+ (NSString *)eta_key
{
    return @"u_userProfileId";
}

+ (NSArray *)eta_dbStoreProperty
{
    return @[
             @"u_userProfileId",
             @"u_phoneNumber",
             @"u_password",
             @"u_realName",
             @"u_registerDate",
             @"u_iconUrl",
             @"u_sex",
             @"u_birthday",
             @"u_realName",
             @"u_sign"
             ];
}

@end
