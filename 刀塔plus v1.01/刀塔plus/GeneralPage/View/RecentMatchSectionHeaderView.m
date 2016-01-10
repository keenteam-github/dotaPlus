//
//  RecentMatchSectionHeaderView.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/17.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "RecentMatchSectionHeaderView.h"

@implementation RecentMatchSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    //        移除之前的视图
    for(UIView *sub in self.subviews)
        [sub removeFromSuperview];
    
    NSArray *array=@[@"最近比赛",@"比赛结果",@"时间",@"类型",@"KDA数据"];
    for(int i=0;i<5;i++)
    {
        CGFloat maring_x=10;
        CGFloat labelWith=((kWidth-6*maring_x)/5);
        CGFloat xpos=maring_x+i*(labelWith+maring_x);
        UILabel *lb=[Tools createLabelWithFrame:CGRectMake(xpos, 10, labelWith, 10) text:array[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:nil font:[UIFont systemFontOfSize:12]];
        [self addSubview:lb];
    }
}

@end
