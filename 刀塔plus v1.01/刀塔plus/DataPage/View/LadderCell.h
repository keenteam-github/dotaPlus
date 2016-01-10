//
//  LadderCell.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LadderModel.h"


@interface LadderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

-(void)cellWithLadderModel:(LadderModel *)model;

@end
