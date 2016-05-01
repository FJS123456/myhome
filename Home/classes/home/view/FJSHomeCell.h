//
//  FJSHomeCell.h
//  Home
//
//  Created by fujisheng on 16/3/29.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSHome;

@interface FJSHomeCell : UITableViewCell

+ (instancetype)homeCellWithTableView:(UITableView *)tableView;

- (void)refreshCellWithHome:(FJSHome *)home;

@end
