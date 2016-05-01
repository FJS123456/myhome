//
//  FJSHomeVideo.m
//  Home
//
//  Created by fujisheng on 16/4/30.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomeVideo.h"

//@property (assign,nonatomic) NSUInteger *videoId;
//@property (copy,nonatomic) NSString *videoUrl;
//@property (assign,nonatomic) NSUInteger uploadDate;
//@property (assign,nonatomic) NSUInteger *userProfileId;
//@property (assign,nonatomic) NSUInteger *videoTypeId;
//@property (copy,nonatomic) NSString *thumbUrl;
//@property (assign,nonatomic) NSUInteger playNumber;
//@property (assign,nonatomic) NSUInteger totalTime;
//@property (copy,nonatomic) NSString *desc;

@implementation FJSHomeVideo

+ (NSDictionary *)eta_jsonKeyPathsByProperty
{
    return  @{
              @"videoId"          :     @"video_id",
              @"videoUrl"         :     @"video_url",
              @"uploadDate"       :     @"upload_date",
              @"userProfileId"    :     @"creater.user_profile_id",
              @"videoTypeId"      :     @"videoType.video_type_id",
              @"thumbUrl"         :     @"thumb_url",
              @"playNumber"       :     @"play_number",
              @"totalTime"        :     @"video_total_time",
              @"desc"             :     @"video_desc"
              };
}

+ (NSString *)eta_key
{
    return @"videoId";
}

+ (NSArray *)eta_dbStoreProperty
{
    return @[
             @"videoId",
             @"videoUrl",
             @"uploadDate",
             @"userProfileId",
             @"videoTypeId",
             @"thumbUrl",
             @"playNumber",
             @"totalTime",
             @"desc"
             ];
}

@end
