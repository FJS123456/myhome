//
//  FJSHomePhoto.h
//  Home
//
//  Created by fujisheng on 16/4/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Eta/EtaModel.h>

@interface FJSHomePhoto : EtaModel

@property (assign,nonatomic) NSUInteger photoId;
@property (strong,nonatomic) NSString *photoUrl;
@property (assign,nonatomic) NSTimeInterval uploadDate;
@property (assign,nonatomic) NSUInteger userProfileId;
@property (assign,nonatomic) NSUInteger albumId;
@property (assign,nonatomic) CGFloat photoWidth;
@property (assign,nonatomic) CGFloat photoHeight;

@end
