//
//  FJSRequestParam.h
//  Home
//
//  Created by fujisheng on 16/3/17.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJSRequestParam : NSObject

@property (weak,nonatomic) id target;
@property (assign,nonatomic) SEL okSelector;       //成功时的回调
@property (assign,nonatomic) SEL errorSelector;    //系统调用失败时的回调
@property (assign,nonatomic) SEL failSelector;     //服务器调用失败时的回调
@property (strong,nonatomic) NSMutableDictionary *bodyDict;   //请求体

@property (strong,nonatomic) NSString *urlStr;


@end
