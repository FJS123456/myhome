//
//  FJSHome.m
//  Home
//
//  Created by fujisheng on 16/3/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHome.h"

@implementation FJSHome

+ (NSDictionary *)eta_jsonKeyPathsByProperty
{
    return  @{
              @"h_homeId"          :     @"home_id",
              @"h_homeName"        :     @"home_name",
              @"h_announcement"    :     @"annoucement",
              @"h_createrId"       :     @"creater.user_profile_id",
              @"h_createDate"      :     @"create_date",
              @"h_score"           :     @"score",
              @"h_sign"            :     @"sign"
              };
}

+ (NSString *)eta_key
{
    return @"h_homeId";
}

+ (NSArray *)eta_dbStoreProperty
{
    return @[
             @"h_homeId",
             @"h_announcement",
             @"h_createrId",
             @"h_createDate",
             @"h_score",
             @"h_sign",
             @"h_homeName",
             ];
}

@end
