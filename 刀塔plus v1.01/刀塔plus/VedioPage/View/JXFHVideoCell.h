//
//  JXFHVideoCell.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/30.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXFHVideoModel.h"

@interface JXFHVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)cellWithJXFHModel:(JXFHVideoModel *)model;

@end
