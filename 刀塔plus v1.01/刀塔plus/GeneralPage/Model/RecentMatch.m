//
//  RecentMatch.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "RecentMatch.h"

@implementation RecentMatch

-(NSComparisonResult)accendSortModal:(RecentMatch *)match
{
    return [self.matchModal compare:match.matchModal];
}
-(NSComparisonResult)deccendSortModal:(RecentMatch *)match
{
    NSComparisonResult result=[self accendSortModal:match];
    if(result==NSOrderedAscending)
        return NSOrderedDescending;
    else if(result==NSOrderedDescending)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}
@end
