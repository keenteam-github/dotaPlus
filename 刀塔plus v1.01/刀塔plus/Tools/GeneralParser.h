//
//  HTMLParser.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.

// HTML解析类

#import <Foundation/Foundation.h>
#import "SummaryModel.h"
#import "MatchDetailSummaryModel.h"

@interface GeneralParser : NSObject
{
//    玩家id的数组
    NSMutableArray *_accountArray;
}
//    html内容字符串
@property(nonatomic,strong)NSString *contents;

//综合数据
-(instancetype)initWithData:(NSData *)data;

//解析基础数据玩
-(SummaryModel *)parseBasicMessage;
//解析常玩的英雄
-(NSArray *)parseMostPlayedHeros;
//解析最近玩的英雄
-(NSArray *)parseRecentMatch;
//解析最高纪录数据
-(NSArray *)parseHighestRecords;
//比赛统计
-(NSArray *)matchStatistical;
//英雄统计
-(NSArray *)heroStatistical;
//解析单个英雄的所有比赛
-(NSArray *)allMatchesWithSingleHero;
//比赛详情摘要
-(MatchDetailSummaryModel *)parseMatchDetailSummary;
//比赛详情
-(NSArray *)matchDetailWithMatchID:(NSString *)matchID;

@end
