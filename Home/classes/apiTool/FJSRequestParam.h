//
//  FJSRequestParam.h
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FJSSuccessBlock)(id responseData);
typedef void (^FJSFailBlock)(NSError *error);

@interface FJSRequestParam : NSObject

@property (strong,nonatomic) NSMutableDictionary *bodyDict;   //请求体
@property (strong,nonatomic) NSString *urlStr;

@property (copy,nonatomic) FJSSuccessBlock successBlock;
@property (copy,nonatomic) FJSFailBlock failBlock;

@end
