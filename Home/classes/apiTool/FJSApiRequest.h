//
//  FJSApiRequest.h
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJSApiRequest : NSObject

+ (void)postRequestWithUrl:(NSString *)urlStr bodyDict:(NSDictionary *)bodyDict tagert:(id)tagert okSel:(SEL)okSel errorSel:(SEL)errorSel failSel:(SEL)failSel;

@end
