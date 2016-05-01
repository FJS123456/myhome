//
//  FJSHome.h
//  Home
//
//  Created by fujisheng on 16/3/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Eta/EtaModel.h>

@class FJSUserProfile;

@interface FJSHome : EtaModel

@property (strong,nonatomic) NSString           *h_homeId;
@property (strong,nonatomic) NSString           *h_announcement;        //通告
@property (assign,nonatomic) NSInteger          h_createrId;            //房间创建者id
@property (assign,nonatomic) NSTimeInterval     h_createDate;
@property (assign,nonatomic) NSInteger          h_score;
@property (strong,nonatomic) NSString           *h_sign;
@property (strong,nonatomic) NSString           *h_homeName;

@end
