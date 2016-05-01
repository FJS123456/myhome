//
//  FJSUserProfile.h
//  Home
//
//  Created by fujisheng on 16/3/22.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Eta/EtaModel.h>

@interface FJSUserProfile : EtaModel

@property (assign,nonatomic) NSUInteger     u_userProfileId;
@property (strong,nonatomic) NSString       *u_phoneNumber;
@property (strong,nonatomic) NSString       *u_password;
@property (strong,nonatomic) NSString       *u_realName;
@property (assign,nonatomic) NSTimeInterval u_registerDate;
@property (strong,nonatomic) NSString       *u_iconUrl;
@property (strong,nonatomic) NSString       *u_sex;
@property (assign,nonatomic) NSTimeInterval u_birthday;
@property (strong,nonatomic) NSString       *u_sign;

@end
