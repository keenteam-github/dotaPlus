//
//  MatchDetailSummaryView.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MatchDetailSummaryView.h"

@implementation MatchDetailSummaryView

-(void)setModel:(MatchDetailSummaryModel *)model
{
    _model=model;
    [self createUI];
}
-(void)createUI
{
    for(UIView *sub in self.subviews)
        [sub removeFromSuperview];//移除之前的视图
    NSArray *array=@[@"获胜阵容",@"比赛模式",@"结束时间",@"持续时间",_model.victoryTeam,_model.matchModal,_model.time,_model.duration];
    for(int i=0;i<array.count;i++)
    {
        int col=i%4;
        int row=i/4;
        CGFloat marginX=20.0;
        CGFloat lbWith=(self.bounds.size.width-10*2-marginX*3)/4;
        CGFloat xpos=10+(marginX+lbWith)*col;
        CGFloat ypos=30*row;
        CGRect rect=CGRectMake(xpos, ypos, lbWith, 30);
        UILabel *lb=[Tools createLabelWithFrame:rect text:array[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14]];
        [self addSubview:lb];
        if(i==4)
        {
            lb.font=[UIFont boldSystemFontOfSize:16];
            lb.textColor=[UIColor purpleColor];
        }
    }
}
@end
