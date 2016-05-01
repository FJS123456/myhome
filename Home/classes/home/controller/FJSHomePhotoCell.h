//
//  FJSHomePhotoCell.h
//  Home
//
//  Created by fujisheng on 16/4/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJSHomePhotoCell : UICollectionViewCell

@property (copy,nonatomic) NSString *photoUrl;
@property (strong, nonatomic,readonly) UIImageView *imageView;

@end
