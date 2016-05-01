//
//  FJSHomeVideo.h
//  Home
//
//  Created by fujisheng on 16/4/30.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Eta/EtaModel.h>

@interface FJSHomeVideo : EtaModel

@property (assign,nonatomic) NSUInteger videoId;
@property (copy,nonatomic) NSString *videoUrl;
@property (assign,nonatomic) NSUInteger uploadDate;
@property (assign,nonatomic) NSUInteger userProfileId;
@property (assign,nonatomic) NSUInteger videoTypeId;
@property (copy,nonatomic) NSString *thumbUrl;
@property (assign,nonatomic) NSUInteger playNumber;
@property (assign,nonatomic) NSUInteger totalTime;
@property (copy,nonatomic) NSString *desc;

@end
