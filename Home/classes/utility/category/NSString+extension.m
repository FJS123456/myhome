//
//  NSString+extension.m
//  Home
//
//  Created by fujisheng on 16/3/19.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

- (BOOL)isNotEmpty
{
    return [self isKindOfClass:[NSString class]] && self.length > 0;
}

@end
