
//
//  LadderCell.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "LadderCell.h"

@implementation LadderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithLadderModel:(LadderModel *)model
{
    [_iconImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    _iconImageView.layer.cornerRadius=20;
    _iconImageView.clipsToBounds=YES;
    _nameLabel.text=model.name;
    _scoreLabel.text=model.score;
    if(!model.team)
        _teamLabel.text=@"-";
    else
        _teamLabel.text=model.team;

    _rankLabel.text=model.rank;
}

@end
