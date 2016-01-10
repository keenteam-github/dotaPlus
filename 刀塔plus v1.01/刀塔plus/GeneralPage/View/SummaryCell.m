//
//  SummaryCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "SummaryCell.h"

@implementation SummaryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _sView=[[SummaryView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        [self.contentView addSubview:_sView];
    }
    return self;
}
-(void)cellWithPaer:(SummaryModel *)model
{
    _sView.model=model;
}
@end
