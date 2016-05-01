//
//  FJSAddFolderCell.m
//  Home
//
//  Created by fujisheng on 16/4/15.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSAddFolderCell.h"
#import "UIView+FJSAdd.h"

@implementation FJSAddFolderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.addImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (UIImageView *)addImageView
{
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
        _addImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _addImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.addImageView.bottom,self.width,20)];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
