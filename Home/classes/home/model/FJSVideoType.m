//
//  FJSVideoType.m
//  Home
//
//  Created by fujisheng on 16/4/29.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSVideoType.h"

@implementation FJSVideoType

+ (NSDictionary *)eta_jsonKeyPathsByProperty
{
    return  @{
              @"videoTypeId"          :     @"video_type_id",
              @"typeName"             :     @"type_name",
              @"createDate"           :     @"create_date",
              @"homeId"               :     @"home.home_id"
              };
}

+ (NSString *)eta_key
{
    return @"videoTypeId";
}

+ (NSArray *)eta_dbStoreProperty
{
    return @[
             @"videoTypeId",
             @"typeName",
             @"createDate",
             @"homeId"
             ];
}

@end
