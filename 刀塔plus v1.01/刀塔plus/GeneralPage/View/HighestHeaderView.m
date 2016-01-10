//
//  HighestHeaderView.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "HighestHeaderView.h"

@implementation HighestHeaderView

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array
{
    if(self=[super initWithFrame:frame])
    {
        for(UIView *sub in self.subviews)//移除之前的视图
           [sub removeFromSuperview];
        for(int i=0;i<4;i++)
        {
            CGFloat marginX=40;
            CGFloat lbWith=(self.frame.size.width-3*marginX)/2;
            CGFloat col=i%2;
            CGFloat row=i/2;
            CGFloat xpos=marginX+col*(lbWith+marginX);
            CGFloat ypos=20*row;
            UILabel *label=[Tools createLabelWithFrame:CGRectMake(xpos, ypos, lbWith, 20) text:array[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:12]];
            [self addSubview:label];
        }
    }
    return self;
}
@end

