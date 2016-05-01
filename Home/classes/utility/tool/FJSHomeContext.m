//
//  FJSHomeContext.m
//  Home
//
//  Created by fujisheng on 16/3/22.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomeContext.h"
#import "FJSUserProfile.h"

@implementation FJSHomeContext

+ (instancetype)shareContext
{
    static FJSHomeContext *context = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        context = [[FJSHomeContext alloc] init];
    });
    
    return context;
}

- (FJSUserProfile *)currentUserProfile
{
    if (!_currentUserProfile) {
        _currentUserProfile = [[FJSUserProfile alloc] init];
    }
    
    return _currentUserProfile;
}

@end
