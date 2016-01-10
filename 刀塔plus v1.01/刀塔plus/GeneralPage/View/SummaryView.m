
//
//  SummaryView.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "SummaryView.h"

@implementation SummaryView

-(void)setModel:(SummaryModel *)model
{
    _model=model;
    [self createUI];
}
-(void)createUI
{
//    移除之前的视图
    for(UIView *sub in self.subviews)
        [sub removeFromSuperview];
//    比赛总场数
    if(_model)
    {
        NSArray *titles=@[@"比赛场数",@"平均KDA",@"总胜率",@"排位胜率",_model.matchCount,_model.kda,_model.generalWinRate,_model.rankedWinRate];
       
        for(int i=0;i<8;i++)
        {
            int col=i%4;
            int row=i/4;
            CGFloat marginX=20.0;
            CGFloat lbWith=(self.bounds.size.width-10*2-marginX*3)/4;
            CGFloat xpos=10+(marginX+lbWith)*col;
            CGFloat ypos=30*row;
            CGRect rect=CGRectMake(xpos, ypos, lbWith, 30);
            UILabel *lb=[self createLabelWithFrame:rect text:titles[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12]];
            [self addSubview:lb];
        }
    }
}
//创建Label
-(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color textAligment:(NSTextAlignment)aligment  font:(UIFont *)font;
{
    UILabel *lb=[[UILabel alloc]initWithFrame:frame];
    lb.text=text;
    lb.textColor=color;
    lb.textAlignment=aligment;
    lb.font=font;
    return lb;
}

@end
