//
//  MatchDetailSummaryModel.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchDetailSummaryModel : NSObject

@property(nonatomic,strong)NSString *victoryTeam;//获胜阵营
@property(nonatomic,strong)NSString *matchModal; //比赛模式
@property(nonatomic,strong)NSString *time;       //时间
@property(nonatomic,strong)NSString *duration;   //持续时间

@end
