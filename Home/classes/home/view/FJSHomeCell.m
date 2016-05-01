//
//  FJSHomeCell.m
//  Home
//
//  Created by fujisheng on 16/3/29.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomeCell.h"
#import "UIView+FJSAdd.h"
#import "FJSHome.h"

@interface FJSHomeCell()

@property (strong,nonatomic) UIImageView *headView;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *descLabel;
@property (strong,nonatomic) UIView *bottomLine;

@end

@implementation FJSHomeCell

+ (instancetype)homeCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"homeCell";
    
    FJSHomeCell *homeCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (homeCell == nil) {
        homeCell = [[FJSHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return homeCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.bottomLine];
    }
    
    return self;
}

#pragma mark UI布局
- (UIImageView *)headView
{
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _headView.image = [UIImage imageNamed:@"home_placehoder"];
        _headView.layer.cornerRadius = 5;
        _headView.layer.masksToBounds = YES;
    }
    
    return _headView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right + 15, _headView.top + 5,FJSScreenWidth - _headView.right - 10, 18)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 12, _titleLabel.width, 15)];
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descLabel;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bottom + 10 - 0.3, FJSScreenWidth, 0.3)];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}

#pragma mark - 刷新数据
- (void)refreshCellWithHome:(FJSHome *)home
{
    self.titleLabel.text = home.h_homeName;
    self.descLabel.text = home.h_sign;
}

@end
