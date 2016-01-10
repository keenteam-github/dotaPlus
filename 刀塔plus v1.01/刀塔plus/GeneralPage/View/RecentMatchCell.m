//
//  RecentMatchCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "RecentMatchCell.h"

@implementation RecentMatchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithRecentMatch:(RecentMatch *)match
{
    [_heroImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:nil]];
    _heroImageView.layer.cornerRadius=5;
    _heroImageView.clipsToBounds=YES;
    _matchResultLabel.text=match.matchResult;
    if([match.matchResult isEqualToString:@"失败"])
        _matchResultLabel.textColor=[UIColor blackColor];
    else
        _matchResultLabel.textColor=[UIColor purpleColor];
    
    _timeLabel.text=match.time;
    _gameModalLabel.text=match.matchModal;
    _gameModalLabel.adjustsFontSizeToFitWidth=YES;
    _kdaLabel.text=match.kda;
}
@end
