//
//  LiveCell.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/28.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "LiveCell.h"

@implementation LiveCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithLiveModel:(LiveModel *)model
{
    [_placeHolder setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"d44.jpg"]];
    _placeHolder.contentMode=UIViewContentModeScaleAspectFit;
    [_obImageView setImageWithURL:[NSURL URLWithString:model.obImage] placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    _obImageView.layer.cornerRadius=20;
    _obImageView.clipsToBounds=YES;
    
    _titleLabel.text=model.title;
    _titleLabel.textColor=[UIColor colorWithRed:38.0/255.0f green:91.0/255.0f blue:28.0/255.0f alpha:1.0f];
    _liveTypeLabel.text=[NSString stringWithFormat:@"%@直播",model.live_type];
    if([model.live_type isEqualToString:@"douyu"])
        _liveTypeLabel.text=@"斗鱼直播";
    if([model.live_type isEqualToString:@"zhanqi"])
        _liveTypeLabel.text=@"战旗TV";
    if([model.live_type isEqualToString:@"huomaotv"])
        _titleLabel.text=@"火猫TV";
    _viewerCountLabel.text=[NSString stringWithFormat:@"观看人数:%@",model.viewerCount];
    
    _obNameLabel.text=model.obName;
}

@end
