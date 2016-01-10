//
//  JXFHVideoCell.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/30.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "JXFHVideoCell.h"

@implementation JXFHVideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithJXFHModel:(JXFHVideoModel *)model
{
    [_videoImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"d44.jpg"]];
    _videoImageView.layer.cornerRadius=5;
    _videoImageView.clipsToBounds=YES;
    
    
    _titleLabel.text=@"S5赛季";
    _titleLabel.textColor=[UIColor colorWithRed:38.0/255.0f green:91.0/255.0f blue:28.0/255.0f alpha:1.0f];
    _dateLabel.text=@"2015/10/24";
    _titleLabel.numberOfLines=0;
    _timeLabel.text=@"10:10";
}

@end
