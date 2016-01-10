//
//  MatchDetailCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MatchDetailCell.h"

@implementation MatchDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithDetailModel:(MatchDetailModel *)model
{
    _detailModel=model;
    
    [_heroIcon setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"110heroPlaceHolder"]];
    _heroIcon.layer.cornerRadius=5;
    _heroIcon.clipsToBounds=YES;
    if([model.playerIcon isEqualToString:@"http://cdn.dota2.com.cn/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg"])
        _playerIcon.image=[UIImage imageNamed:@"110heroPlaceHolder"];
    else
        [_playerIcon setImageWithURL:[NSURL URLWithString:model.playerIcon] placeholderImage:[UIImage imageNamed:@"110heroPlaceHolder"]];
    _playerIcon.layer.cornerRadius=20;
    _playerIcon.clipsToBounds=YES;
//    给玩家图像添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    _playerIcon.userInteractionEnabled=YES;
    [_playerIcon addGestureRecognizer:tap];
    
    NSArray *itemImageViews=@[_item1,_item2,_item3,_item4,_item5,_item6];
    for(int i=0;i<model.items.count;i++)
    {
        UIImageView *imv=itemImageViews[i];
        if([model.items[i] isEqualToString:@"http://cdn.dota2.com.cn/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg"])
            imv.image=[UIImage imageNamed:@"itemHolder"];
        else
            [imv setImageWithURL:[NSURL URLWithString:model.items[i]] placeholderImage:[UIImage imageNamed:@"itemHolder"]];
    }
    _playerLabel.text=model.player;
    _kdaLabel.text=[NSString stringWithFormat:@"KDA:%@",model.kda];
    _lastHitLabel.text=[NSString stringWithFormat:@"补兵:%@",model.lastHit];
    if(model.isMVP)
    {
        _mvpLabel.text=@"MVP";
        _mvpLabel.textColor=[UIColor redColor];
    }
    _warRateLabel.text=[NSString stringWithFormat:@"参战率:%@",model.rateOfWar];
    _damageLabel.text=[NSString stringWithFormat:@"伤害:%@",model.damageRate];
    _lvl.text=model.heroLevel;
    _lvl.layer.cornerRadius=7.5;
    _lvl.clipsToBounds=YES;
    _lvl.alpha=0.5;
    _expLabel.text=[NSString stringWithFormat:@"经验每分钟:%@",model.exp];
    _gxpLabel.text=[NSString stringWithFormat:@"金钱每分钟:%@",model.gxp];
}
/**点击玩家图片时调用该方法*/
-(void)tapAction:(UITapGestureRecognizer *)sender
{
    if(self.clickPlayerIcon)
        self.clickPlayerIcon(_detailModel.accountID.stringValue);
}
@end
