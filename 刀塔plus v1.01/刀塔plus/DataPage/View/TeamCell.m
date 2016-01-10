//
//  TeamCell.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/3.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "TeamCell.h"

@implementation TeamCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithTeamModel:(TeamModel *)model
{
    [_teamIcon setImageWithURL:[NSURL URLWithString:model.teamIcon] placeholderImage:[UIImage imageNamed:@"heroPlaceHolder.png"]];
    _teamIcon.layer.cornerRadius=5;
    _teamIcon.clipsToBounds=YES;
    _scoreabel.text=model.teamMMR;
    _winateLabel.text=model.winRate;
    _nameLabel.text=model.teamName;
    _rankLabel.text=model.ranked;
    _winProgress.progress=[[model.winRate stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue]/100.0f;
}


@end
