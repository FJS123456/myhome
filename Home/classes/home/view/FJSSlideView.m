//
//  FJSSlideView.m
//  自定义控件生成-001
//
//  Created by fujisheng on 16/3/31.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSSlideView.h"
#import "UIView+FJSAdd.h"

static const CGFloat kSlideViewH = 40;

@interface FJSSlideView()

@property (strong,nonatomic) NSMutableArray<UIButton *> *btnArray;
@property (strong,nonatomic) UIView *bottomSlideView;
@property (assign,nonatomic) NSUInteger selectedIndex;


@end

@implementation FJSSlideView

- (void)setSlideX:(NSUInteger)slideX
{
    self.bottomSlideView.left = slideX;
}

- (void)setScrollToIndex:(NSUInteger)scrollToIndex
{
    UIButton *selectedBtn = [self.btnArray objectAtIndex:_selectedIndex];
    selectedBtn.selected = NO;
    UIButton *btn = self.btnArray[scrollToIndex];
    btn.selected = YES;
    
    _selectedIndex = scrollToIndex;
}

- (NSMutableArray<UIButton *> *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

+ (instancetype)slideViewWithTitleArray:(NSArray *)titleArray andWidth:(CGFloat)width
{
    FJSSlideView *slideView = [[FJSSlideView alloc] init];
    
    slideView.width = width;
    slideView.height = kSlideViewH;
    slideView.backgroundColor = [UIColor whiteColor];
    
    [slideView configUIWithTitleArray:titleArray];
    
    return slideView;
}

- (void)configUIWithTitleArray:(NSArray *)titleArray
{
    if (![titleArray isKindOfClass:[NSArray class]] || titleArray.count <= 0) {
        return;
    }
    //1.添加button
    CGFloat btnW = self.width / titleArray.count;
    for (NSUInteger i = 0; i < titleArray.count; ++i) {
        
        NSString *buttonName = titleArray[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn setTitle:buttonName forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        btn.width = btnW;
        btn.height = self.height;
        btn.top = 0;
        btn.left = btnW * i;
        
        if (i == 0) {
            [btn setSelected:YES];
            _selectedIndex = 0;
        }
        
        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }
    
    //2.添加滑动条
    UIView *bottomSlideView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 4, btnW, 4)];
    bottomSlideView.backgroundColor = [UIColor blueColor];
    _bottomSlideView = bottomSlideView;
    [self addSubview:bottomSlideView];
    
    //3.添加底部线条
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
}

- (void)btnClick:(UIButton *)btn
{
    UIButton *selectedBtn = self.btnArray[_selectedIndex];
    selectedBtn.selected = NO;
    
    btn.selected = YES;
    NSUInteger selectedIndex = [self.btnArray indexOfObject:btn];
    CGFloat bottomSlideViewX = btn.width * selectedIndex;
    _selectedIndex = selectedIndex;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomSlideView.left = bottomSlideViewX;
        if ([self.delegate respondsToSelector:@selector(slideView:didClickButtonIndex:)]) {
            [self.delegate slideView:self didClickButtonIndex:_selectedIndex];
        }
    }];
}

@end
