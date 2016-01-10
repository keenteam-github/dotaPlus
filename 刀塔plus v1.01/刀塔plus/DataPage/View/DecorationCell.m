//
//  DecorationCell.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/4.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "DecorationCell.h"

@implementation DecorationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellWithDecorationModel:(DecorationModel *)model
{
    [_icon setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"decorationHolder"]];
    _icon.layer.cornerRadius=5;
    _icon.clipsToBounds=YES;
    
    _nameLabel.text=model.name;
    _typeLabel.text=model.type;
    _qualityLabel.text=model.quality;
}
@end
