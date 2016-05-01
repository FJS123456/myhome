//
//  EtaMapper.m
//  WKDamo
//
//  Created by momo783 on 16/2/24.
//  Copyright © 2016年 momo783. All rights reserved.
//

#import "EtaMapper.h"
#import "FJSUserProfile.h"
#import "FJSHome.h"
#import "FJSAlbum.h"
#import "FJSHomePhoto.h"
#import "FJSVideoType.h"
#import "FJSHomeVideo.h"

@implementation EtaMapper

+ (Class)classMap:(NSInteger)classType {
    
    switch (classType) {
        case EtaModelTypeUserProfile:
            return [FJSUserProfile class];
        case EtaModelTypeHome:
            return [FJSHome class];
        case EtaModelTypeAlbum:
            return [FJSAlbum class];
        case EtaModelTypeHomePhoto:
            return [FJSHomePhoto class];
        case EtaModelTypeVideoType:
            return [FJSVideoType class];
        case EtaModelTypeVideo:
            return [FJSHomeVideo class];
        default:
            break;
    }

    return nil;
}

@end
