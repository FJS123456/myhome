//
//  EtaMapper.h
//  WKDamo
//
//  Created by momo783 on 16/2/24.
//  Copyright © 2016年 momo783. All rights reserved.
//

#import <Eta/EtaClassMap.h>

typedef NS_ENUM(NSInteger, EtaModelType)
{
    EtaModelTypeBase                = 0,
    EtaModelTypeUserProfile         = 1,
    EtaModelTypeHome                = 2,
    EtaModelTypeAlbum               = 3,
    EtaModelTypeHomePhoto           = 4,
    EtaModelTypeVideoType           = 5,
    EtaModelTypeVideo               = 6,
};

@interface EtaMapper : EtaClassMap

@end
