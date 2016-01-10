//
//  ItemCell.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellWithItemModel:(ItemModel *)model cellType:(DataCellType)cellType
{
    [_itemImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"heroPlaceHolder"]];
    _itemImageView.layer.cornerRadius=5;
    _itemImageView.clipsToBounds=YES;
    
    _nameLabel.text=model.name;
    if(cellType==DataCellTypeItem)
    {
        _typeLabel.text=@"物品";
        _useLabel.text=[NSString stringWithFormat:@"%ld万次",(long)model.useCount.integerValue/10000];
        _winRateLabel.text=model.winRate;
    }
    else if(cellType==DataCellTypeHero)
    {
        _typeLabel.text=@"英雄";
        /*由于物品和英雄的使用次数和胜率正好相反，需要注意*/
        _useLabel.text=[NSString stringWithFormat:@"%ld万次",(long)model.winRate.integerValue/10000];
        _winRateLabel.text=model.useCount;
    }
}

@end
