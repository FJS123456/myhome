//
//  FJSHomeContext.h
//  Home
//
//  Created by fujisheng on 16/3/22.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJSUserProfile;

@interface FJSHomeContext : NSObject

@property (strong,nonatomic) FJSUserProfile *currentUserProfile;

+ (instancetype)shareContext;

@end
