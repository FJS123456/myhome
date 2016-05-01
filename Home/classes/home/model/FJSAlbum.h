//
//  FJSAlbum.h
//  Home
//
//  Created by fujisheng on 16/4/15.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Eta/EtaModel.h>

@interface FJSAlbum : EtaModel

@property (assign,nonatomic) NSUInteger albumId;
@property (copy,nonatomic) NSString *albumName;
@property (assign,nonatomic) NSTimeInterval createDate;
@property (copy,nonatomic) NSString *homeId;

@end
