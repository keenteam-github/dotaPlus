//
//  RecentMatch.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentMatch : NSObject

//英雄图标
@property(nonatomic,strong)NSString *heroImage;
//英雄名
//@property(nonatomic,strong)NSString *heroName;
//比赛结果
@property(nonatomic,strong)NSString *matchResult;
//比赛id
@property(nonatomic,strong)NSString *matchId;
//比赛时间
@property(nonatomic,strong)NSString *time;
//比赛模式
@property(nonatomic,strong)NSString *matchModal;
//kda
@property(nonatomic,strong)NSString *kda;

/**按比赛模式排序*/
-(NSComparisonResult)accendSortModal:(RecentMatch *)match;
-(NSComparisonResult)deccendSortModal:(RecentMatch *)match;
@end
