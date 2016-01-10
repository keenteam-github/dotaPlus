//
//  NewsCell.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithNews:(NewsModel *)model
{
    if(model.imgs.count>0)
        [_newsImageView setImageWithURL:[NSURL URLWithString:model.imgs[0]]placeholderImage:[UIImage imageNamed:@"news.jpg"]];
    if(!_newsImageView.image)
        _newsImageView.image=[UIImage imageNamed:@"news.jpg"];
    _newsImageView.layer.cornerRadius=10;
    _newsImageView.clipsToBounds=YES;
    _newsImageView.contentMode=UIViewContentModeScaleAspectFit;
    _titleLabel.text=model.title;
    _desLabel.text=model.desc;
    _timeLabel.text=model.date;
}
@end
