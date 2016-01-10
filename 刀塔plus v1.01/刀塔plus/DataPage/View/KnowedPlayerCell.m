//
//  KnowedPlayerCell.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/2.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "KnowedPlayerCell.h"

@implementation KnowedPlayerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithKonwedPlayerModel:(KonwedPlayer *)model
{
    [_playerIcon setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    if(!model.teamLogo)
        _noTeamLabel.hidden=NO;
    else
        [_teamLogo setImageWithURL:[NSURL URLWithString:model.teamLogo] placeholderImage:[UIImage imageNamed:@"heroPlaceHolder"]];
    
    _playerIcon.layer.cornerRadius=30;
    _playerIcon.clipsToBounds=YES;
    _teamLogo.layer.cornerRadius=10;
    _teamLogo.clipsToBounds=YES;
    
    _nameLabel.text=model.name;
    _idLabel.text=model.account_id;
    _stateLabel.text=@"-";
    if(model.state.length>0)
        _stateLabel.text=model.state;
    _rankScore.text=model.rankedScore;
    _teamScore.text=model.teamedScore;
}


@end
