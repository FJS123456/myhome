//
//  FJSVideoType.h
//  Home
//
//  Created by fujisheng on 16/4/29.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Eta/EtaModel.h>

@interface FJSVideoType : EtaModel

@property (assign,nonatomic) NSUInteger videoTypeId;
@property (copy,nonatomic) NSString *typeName;
@property (assign,nonatomic) NSTimeInterval createDate;
@property (copy,nonatomic) NSString *homeId;

@end
