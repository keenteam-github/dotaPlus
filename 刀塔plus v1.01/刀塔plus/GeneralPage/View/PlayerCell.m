
//
//  PlayerCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "PlayerCell.h"

@implementation PlayerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithPlayer:(Player *)player
{
    [_playerImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    _playerImageView.layer.cornerRadius=20;
    _playerImageView.clipsToBounds=YES;
    _nameLabel.text=player.playerName;
    _playerIDLabel.text=[NSString stringWithFormat:@"ID:%@",player.playerID];
}
@end
