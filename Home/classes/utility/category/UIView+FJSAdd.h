//
//  UIView+FJSAdd.h
//  Home
//
//  Created by fujisheng on 16/3/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FJSScreenWidth [UIScreen mainScreen].bounds.size.width
#define FJSScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UIView (FJSAdd)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

@end
