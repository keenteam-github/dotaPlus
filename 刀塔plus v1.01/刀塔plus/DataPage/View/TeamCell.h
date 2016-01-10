//
//  TeamCell.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/3.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamModel.h"

@interface TeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *teamIcon;
@property (weak, nonatomic) IBOutlet UILabel *scoreabel;
@property (weak, nonatomic) IBOutlet UILabel *winateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *winProgress;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)cellWithTeamModel:(TeamModel *)model;

@end
