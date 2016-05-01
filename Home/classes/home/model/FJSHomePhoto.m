//
//  FJSHomePhoto.m
//  Home
//
//  Created by fujisheng on 16/4/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomePhoto.h"

@implementation FJSHomePhoto

+ (NSDictionary *)eta_jsonKeyPathsByProperty
{
    return  @{
              @"photoId"            :     @"photo_id",
              @"photoUrl"           :     @"photo_url",
              @"uploadDate"         :     @"upload_date",
              @"userProfileId"      :     @"creater.user_profile_id",
              @"albumId"            :     @"homeAlbum.album_id",
              @"photoWidth"         :     @"width",
              @"photoHeight"        :     @"height"
              };
}

+ (NSString *)eta_key
{
    return @"photoId";
}

+ (NSArray *)eta_dbStoreProperty
{
    return @[
             @"photoId",
             @"photoUrl",
             @"uploadDate",
             @"userProfileId",
             @"albumId",
             @"photoWidth",
             @"photoHeight"
             ];
}

@end
