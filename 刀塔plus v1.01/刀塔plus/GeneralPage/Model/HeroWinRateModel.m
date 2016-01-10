//
//  HeroWinRateModel.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/12.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "HeroWinRateModel.h"

@implementation HeroWinRateModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"heroname-%@-heroIcon-%@-totalmaches-%@-winrate-%@-kda-%@",_heroName,_heroIcon,_totalMatches,_winRate,_kda];
}
//按使用次数升序排列
-(NSComparisonResult)sortMostPlayed:(HeroWinRateModel *)model
{
    if(_totalMatches.intValue<model.totalMatches.intValue)
        return NSOrderedAscending;
    else if(_totalMatches.intValue>model.totalMatches.intValue)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
//按使用次数降序排列
-(NSComparisonResult)sortLestPlayed:(HeroWinRateModel *)model
{
    if(_totalMatches.intValue<model.totalMatches.intValue)
        return NSOrderedDescending;
    else if(_totalMatches.intValue>model.totalMatches.intValue)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}
//按胜率升序排列
-(NSComparisonResult)sortHighestWinRate:(HeroWinRateModel *)model
{
    NSString *rate1=[self.winRate substringToIndex:self.winRate.length-1];
    NSString *rate2=[model.winRate substringToIndex:model.winRate.length-1];
    return [@(rate1.floatValue) compare:@(rate2.floatValue)];
}
//按胜率降序排列
-(NSComparisonResult)sortLowestWinRate:(HeroWinRateModel *)model
{
    NSString *rate1=[self.winRate substringToIndex:self.winRate.length-1];
    NSString *rate2=[model.winRate substringToIndex:model.winRate.length-1];
    if([rate1 compare:rate2]==NSOrderedAscending)
        return NSOrderedDescending;
    else if([rate1 compare:rate2])
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}
//KDA排序升序排列
-(NSComparisonResult)sortMaxKDA:(HeroWinRateModel *)model
{
    return [@(self.kda.floatValue) compare:@(model.kda.floatValue)];
}
//KDA降序排列
-(NSComparisonResult)sortMinKDA:(HeroWinRateModel *)model
{
    NSComparisonResult result=[@(self.kda.floatValue) compare:@(model.kda.floatValue)];
    if(result==NSOrderedAscending)
        return NSOrderedDescending;
    else if(result==NSOrderedDescending)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}
@end
