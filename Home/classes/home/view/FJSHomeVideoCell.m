//
//  FJSHomeVideoCell.m
//  Home
//
//  Created by fujisheng on 16/4/30.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomeVideoCell.h"
#import "UIView+FJSAdd.h"
#import "UIImageView+WebCache.h"
#import "FJSHomeVideo.h"
#import "FJSUtil.h"

static const CGFloat kMargin = 7;

@interface FJSHomeVideoCell()

@property (strong,nonatomic) UIImageView *thumbView;    //缩略图视图
@property (strong,nonatomic) UIButton *playBtn;         //播放按钮
@property (strong,nonatomic) UILabel *descLabel;        //视频描述   desc如果为空则显示上传时间
@property (strong,nonatomic) UILabel *totalTimeLabel;   //总时长
@property (strong,nonatomic) UILabel *playNumberLabel;  //播放次数
@property (strong,nonatomic) UIButton *likeBtn;         //点赞按钮
@property (strong,nonatomic) UILabel *likeNumberLabel;  //点赞数量

@property (strong,nonatomic) FJSHomeVideo *video;

@end

@implementation FJSHomeVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.thumbView];
        [self.contentView addSubview:self.playBtn];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.totalTimeLabel];
        [self.contentView addSubview:self.playNumberLabel];
        [self.contentView addSubview:self.likeNumberLabel];
        [self.contentView addSubview:self.likeBtn];
    }
    return self;
}

#pragma mark - layout UI
- (UIImageView *)thumbView
{
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 135)];
    }
    return _thumbView;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *playIcon = [UIImage imageNamed:@"video_play"];
        [_playBtn setBackgroundImage:playIcon forState:UIControlStateNormal];
        _playBtn.size = playIcon.size;
        _playBtn.center = self.thumbView.center;
        
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playBtn;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin,self.thumbView.bottom + kMargin, self.contentView.width - kMargin, 16)];
        _descLabel.textColor = [UIColor blackColor];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.font = [UIFont systemFontOfSize:15];
    }
    return _descLabel;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.descLabel.left, self.descLabel.bottom + 7, 70, 12)];
        _totalTimeLabel.textColor = [UIColor lightGrayColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
        _totalTimeLabel.font = [UIFont systemFontOfSize:10];
    }
    return _totalTimeLabel;
}

- (UILabel *)playNumberLabel
{
    if (!_playNumberLabel) {
        _playNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.totalTimeLabel.right + 20 , self.totalTimeLabel.top, 70,12)];
        _playNumberLabel.textColor = [UIColor lightGrayColor];
        _playNumberLabel.textAlignment = NSTextAlignmentLeft;
        _playNumberLabel.font = [UIFont systemFontOfSize:10];
    }
    return _playNumberLabel;
}

-(UILabel *)likeNumberLabel
{
    if (!_likeNumberLabel) {
        _likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _likeNumberLabel.width = 15;
        _likeNumberLabel.height = 12;
        _likeNumberLabel.right = self.contentView.width - kMargin;
        _likeNumberLabel.centerY = self.totalTimeLabel.centerY;
        _likeNumberLabel.textColor = [UIColor lightGrayColor];
        _likeNumberLabel.textAlignment = NSTextAlignmentLeft;
        _likeNumberLabel.font = [UIFont systemFontOfSize:10];
        
    }
    
    return _likeNumberLabel;
}

- (UIButton *)likeBtn
{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *likeImage = [UIImage imageNamed:@"icon_like"];
        UIImage *dislikeImage = [UIImage imageNamed:@"like_disable"];
        [_likeBtn setBackgroundImage:dislikeImage forState:UIControlStateNormal];
        [_likeBtn setBackgroundImage:likeImage forState:UIControlStateSelected];
        _likeBtn.size = dislikeImage.size;
        _likeBtn.right = self.likeNumberLabel.left - 5;
//        _likeBtn.top = self.totalTimeLabel.top;
        _likeBtn.centerY = self.totalTimeLabel.centerY;
        
    }
    return _likeBtn;
}

#pragma mark - 刷新数据
- (void)refreshCellWithHomeVideo:(FJSHomeVideo *)video
{
    _video = video;
    
    NSURL *url = [FJSUtil transferToUrlWithUrlStr:video.thumbUrl];
    [self.thumbView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"homePhotoPlacehoder"]];
    self.descLabel.text = video.desc;
    self.totalTimeLabel.text = [self getTotalTimeText:video.totalTime];
    self.playNumberLabel.text = [NSString stringWithFormat:@"观看 %d",video.playNumber];
    self.likeNumberLabel.text = @"赞";
}

- (NSString *)getTotalTimeText:(NSUInteger)totalTime
{
    NSUInteger minute = totalTime / 60;
    NSUInteger second = totalTime - minute * 60;
    if (minute == 0) {
        return [NSString stringWithFormat:@"时长 %d秒",second];
    }
    return [NSString stringWithFormat:@"时长 %d分%d秒",minute,second];
}

#pragma mark - 事件交互
- (void)playVideo
{
    if ([self.delegate respondsToSelector:@selector(homeVideoCellDidClickPlayBtn:)]) {
        [self.delegate homeVideoCellDidClickPlayBtn:self.video];
    }
}

@end
