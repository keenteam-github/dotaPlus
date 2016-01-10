//
//  SummaryModel.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummaryModel : NSObject

//比赛场数
@property(nonatomic,strong)NSString *matchCount;
//总胜率
@property(nonatomic,strong)NSString *generalWinRate;
//天梯胜率
@property(nonatomic,strong)NSString *rankedWinRate;
//kda
@property(nonatomic,strong)NSString *kda;
//  玩家图像
@property(nonatomic,strong)NSString *poraitImageName;
//  玩家游戏昵称
@property(nonatomic,strong)NSString *playerName;
//steam account_id账号
@property(nonatomic,strong)NSString *account_id;

@end
