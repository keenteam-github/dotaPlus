//
//  VideoMenuCell.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/5.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoMenuModel.h"

@interface VideoMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void)cellWithVideoMenuModel:(VideoMenuModel *)model atIndex:(NSInteger)index;

@end
