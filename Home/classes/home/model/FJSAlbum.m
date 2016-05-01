//
//  FJSAlbum.m
//  Home
//
//  Created by fujisheng on 16/4/15.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSAlbum.h"

@implementation FJSAlbum

+ (NSDictionary *)eta_jsonKeyPathsByProperty
{
    return  @{
              @"albumId"          :     @"album_id",
              @"albumName"        :     @"album_name",
              @"createDate"       :     @"create_date",
              @"homeId"           :     @"home.home_id"
              };
}

+ (NSString *)eta_key
{
    return @"albumId";
}

+ (NSArray *)eta_dbStoreProperty
{
    return @[
             @"albumId",
             @"albumName",
             @"createDate",
             @"homeId"
             ];
}

@end
