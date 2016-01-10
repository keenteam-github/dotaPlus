//
//  MatchDetailSummaryCell.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MatchDetailSummaryCell.h"

@implementation MatchDetailSummaryCell

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
        
        _mdsView=[[MatchDetailSummaryView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        [self.contentView addSubview:_mdsView];
    }
    return self;
}
-(void)cellWithMathDetailSummaryModel:(MatchDetailSummaryModel *)model
{
//    调用setter方法
    self.mdsView.model=model;
}
@end
