//
//  FJSSlideView.h
//  自定义控件生成-001
//
//  Created by fujisheng on 16/3/31.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSSlideView;

@protocol FJSSlideViewDelegate <NSObject>

- (void)slideView:(FJSSlideView *)slideView didClickButtonIndex:(NSUInteger)selectedIndex;

@end

@interface FJSSlideView : UIView

@property (weak,nonatomic) id<FJSSlideViewDelegate> delegate;
@property (assign,nonatomic) NSUInteger slideX;
@property (assign,nonatomic) NSUInteger scrollToIndex;

+ (instancetype)slideViewWithTitleArray:(NSArray *)titleArray andWidth:(CGFloat)width;

@end
