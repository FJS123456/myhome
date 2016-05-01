//
//  FJSApiRequest.h
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJSRequestParam.h"

@interface FJSApiRequest : NSObject

+ (void)postRequestWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict successBlock:(FJSSuccessBlock)successBlock
                 failBlock:(FJSFailBlock)failBlock;

+ (void)uploadImagesWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict imageDataArray:(NSArray *)imageDatas successBlock:(FJSSuccessBlock)successBlock
                 failBlock:(FJSFailBlock)failBlock;

+ (void)uploadVideoWithUrl:(NSString *)urlStr bodyDict:(NSMutableDictionary *)bodyDict fileUrl:(NSURL *)fileUrl successBlock:(FJSSuccessBlock)successBlock
                  failBlock:(FJSFailBlock)failBlock;

@end
