//
//  FJSHomePhotoCell.m
//  Home
//
//  Created by fujisheng on 16/4/26.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSHomePhotoCell.h"
#import "UIImageView+WebCache.h"
#import "FJSUtil.h"

@interface FJSHomePhotoCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation FJSHomePhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setPhotoUrl:(NSString *)photoUrl
{
    NSURL *url = [FJSUtil transferToUrlWithUrlStr:photoUrl];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"homePhotoPlacehoder"]];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageView;
}

@end
