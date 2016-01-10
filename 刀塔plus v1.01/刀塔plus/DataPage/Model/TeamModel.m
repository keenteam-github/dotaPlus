//
//  TeamModel.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/3.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "TeamModel.h"

@implementation TeamModel

+(TeamModel *)team
{
    TeamModel *team=[[TeamModel alloc]init];
    team.memberArray=[NSMutableArray array];
    return team;
}

@end
