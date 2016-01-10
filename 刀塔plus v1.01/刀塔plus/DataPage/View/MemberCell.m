//
//  MemberCell.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/4.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithPlayer:(Player *)player
{
    [_icon setImageWithURL:[NSURL URLWithString:player.playIcon] placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    _icon.layer.cornerRadius=30;
    _icon.clipsToBounds=YES;
    _nameLabel.text=player.playerName;
    _idLabel.text=player.playerID;
}

@end
