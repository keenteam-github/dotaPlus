//
//  HighestRecordCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/18.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "HighestRecordCell.h"

@implementation HighestRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithHighestModel:(HighestModel *)model
{
    [_heroImageView setImageWithURL:[NSURL URLWithString:model.heroImage] placeholderImage:[UIImage imageNamed:@"heroPlaceHolder"]];
    _heroImageView.layer.cornerRadius=5;
    _heroImageView.clipsToBounds=YES;
    if([model.itemName isEqualToString:@"最高每分钟经验"])
        model.itemName=@"最高EXP";
    if([model.itemName isEqualToString:@"最高每分钟金钱"])
        model.itemName=@"最高GXP";
    _itemNaemLabel.text=model.itemName;
    
    _heroNameLabel.text=model.heroName;
    _itemValueLabel.text=model.itemValue;
    _matchResultLabel.text=model.matchResult;
    if([model.matchResult isEqualToString:@"胜利"])
        _matchResultLabel.textColor=[UIColor purpleColor];
}

@end
