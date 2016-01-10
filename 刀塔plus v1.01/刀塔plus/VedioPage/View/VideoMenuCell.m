
//
//  VideoMenuCell.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/5.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "VideoMenuCell.h"

@implementation VideoMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithVideoMenuModel:(VideoMenuModel *)model atIndex:(NSInteger)index
{
     _icon.image=[UIImage imageNamed:@"defalutPlayerIcon.jpg"];
    if(index>1)
        [_icon setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    _icon.layer.cornerRadius=30;
    _icon.clipsToBounds=YES;
    _nameLabel.text=model.name;
    _dateLabel.text=model.detail;
}

@end
