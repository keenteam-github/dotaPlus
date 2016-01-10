//
//  HeroWinRateModel.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/12.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroWinRateModel : NSObject
//英雄图标
@property(nonatomic,copy)NSString *heroIcon;
//英雄名字
@property(nonatomic,copy)NSString *heroName;

//比赛总场次
@property(nonatomic,copy)NSString *totalMatches;
//胜率
@property(nonatomic,copy)NSString *winRate;

//kda
@property(nonatomic,copy)NSString *kda;

@property(nonatomic,copy)NSString *heroID;

-(NSComparisonResult)sortMostPlayed:(HeroWinRateModel *)model;
-(NSComparisonResult)sortLestPlayed:(HeroWinRateModel *)model;
-(NSComparisonResult)sortHighestWinRate:(HeroWinRateModel *)model;
-(NSComparisonResult)sortLowestWinRate:(HeroWinRateModel *)model;

//KDA排序升序排列
-(NSComparisonResult)sortMaxKDA:(HeroWinRateModel *)model;
//KDA降序排列
-(NSComparisonResult)sortMinKDA:(HeroWinRateModel *)model;
@end
