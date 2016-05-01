//
//  FJSHomeVideoCell.h
//  Home
//
//  Created by fujisheng on 16/4/30.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSHomeVideo,FJSHomeVideoCell;

@protocol FJSHomeVideoCellDelegate <NSObject>

- (void)homeVideoCellDidClickPlayBtn:(FJSHomeVideo *)video;

@end

@interface FJSHomeVideoCell : UICollectionViewCell

- (void)refreshCellWithHomeVideo:(FJSHomeVideo *)video;
@property (weak,nonatomic) id<FJSHomeVideoCellDelegate> delegate;

@end
