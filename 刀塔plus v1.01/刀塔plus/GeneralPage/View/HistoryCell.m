//
//  HistoryCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell
{
    float _winRate;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithModel:(HeroWinRateModel *)model
{
    [_heroImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"heroPlaceHolder"]];
    _heroImageView.layer.cornerRadius=5;
    _heroImageView.clipsToBounds=YES;
    _heroNameLabel.text=model.heroName;
    if([model.heroName isEqualToString: @"食人魔魔法师"])
        _heroNameLabel.text=@"法师";
     _totalLabel.text=[NSString stringWithFormat:@"场次:%@",model.totalMatches];
    _victoryLabel.text=[NSString stringWithFormat:@"胜场:%ld",(long)[self calculateWin_countsWithModel:model]];
    _winRateLabel.text=[NSString stringWithFormat:@"胜率:%@",model.winRate];
    _winRateProgress.progress=_winRate;
    _kdaLabel.text=[NSString stringWithFormat:@"KDA:%@",model.kda];
    
}
//根据胜率和总场数计算胜场数
-(NSInteger)calculateWin_countsWithModel:(HeroWinRateModel *)model
{
    NSString *winRateString=[model.winRate substringToIndex:model.winRate.length-1];
    _winRate=winRateString.floatValue/100.0;
    /*
     向上取整函数：NSLog(@"%f",ceil(2.1));---->3.0000
     NSLog(@"%f",ceil(2.0));---->2.0000
     */
    NSInteger win_counts=(NSInteger)ceil(model.totalMatches.floatValue*_winRate);
    return win_counts;
}
@end
