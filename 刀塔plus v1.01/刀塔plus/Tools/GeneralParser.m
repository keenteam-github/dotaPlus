
//
//  HTMLParser.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "GeneralParser.h"
#import "HeroWinRateModel.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "RecentMatch.h"
#import "HighestModel.h"
#import "MatchDetailModel.h"

@implementation GeneralParser

-(instancetype)initWithData:(NSData *)data
{
    if(self=[super init])
    {
        _accountArray=[NSMutableArray array];
        self.contents=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return self;
}

-(void)setContents:(NSString *)contents
{
    if(contents.length>0)
        _contents=contents;
}
//解析概要数据
-(SummaryModel *)parseBasicMessage
{
    SummaryModel *model=[[SummaryModel alloc]init];
//    昵称
//    title:"碰碰胡杠上开花 －dotamax.com",
    NSRange r1=[_contents rangeOfString:@"title:\""];
    if(r1.location==NSNotFound)
        return nil;
    NSString *s1=[_contents substringFromIndex:r1.location+r1.length];
    NSRange r2=[s1 rangeOfString:@"－dotamax.com\""];
    if(r2.location!=NSNotFound)
        model.playerName=[[s1 substringToIndex:r2.location] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    家头像url
//    circle-img
    NSString *s3=nil;
    NSRange r3=[_contents rangeOfString:@"circle-img"];
    if(r3.location!=NSNotFound)
        s3=[_contents substringFromIndex:r3.location];
    NSString *s4=nil;
    NSRange r4=[s3 rangeOfString:model.playerName];
    if(r4.location!=NSNotFound)
        s4=[s3 substringToIndex:r4.location];
    NSString *s5=nil;
    NSRange r5=[s4 rangeOfString:@"http"];
    if(r5.location!=NSNotFound)
        s5=[s4 substringFromIndex:r5.location];
    NSRange r6=[s5 rangeOfString:@"jpg"];
    if(r6.location!=NSNotFound)
        model.poraitImageName=[s5 substringToIndex:r6.location+r6.length];
    /*
     全部比赛
     </div><div style="font-size: 11px;color:#777;">
     1489场
     */
//    比赛总场数
    NSRange rr1=[_contents rangeOfString:@"全部比赛"];
    NSString *ss1=[_contents substringFromIndex:rr1.location+rr1.length];
    NSRange rr2=[ss1 rangeOfString:@"场"];
    NSString *ss2=[ss1 substringToIndex:rr2.location];
    NSArray *tArray=[ss2 componentsSeparatedByString:@"\n"];
    model.matchCount=[[tArray lastObject] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
//    解析总胜率
    NSRange indicator02Range=[_contents rangeOfString:@"indicatorContainer02"];
    NSString *indicatorStr=[_contents substringFromIndex:indicator02Range.location+indicator02Range.length];
    NSRange indicator02Range2=[indicatorStr rangeOfString:@"indicatorContainer02"];
    NSString *indicatorStr2=[indicatorStr substringFromIndex:indicator02Range2.location];
    NSRange valueRange=[indicatorStr2 rangeOfString:@"initValue:"];
    NSString *valueStr=[indicatorStr2 substringFromIndex:valueRange.location+valueRange.length];
    NSRange dotRange=[valueStr rangeOfString:@","];
    model.generalWinRate=[[valueStr substringToIndex:dotRange.location] stringByAppendingString:@"%"];
//    kda
    NSRange i03Range=[_contents rangeOfString:@"indicatorContainer03"];
    NSString *i03Str=[_contents substringFromIndex:i03Range.location+i03Range.length];
    NSRange i03Range2=[i03Str rangeOfString:@"indicatorContainer03"];
    NSString *i03Str2=[i03Str substringFromIndex:i03Range2.location];
    NSRange returnRange=[i03Str2 rangeOfString:@"return"];
    NSString *kdaStr=[i03Str2 substringFromIndex:returnRange.location+returnRange.length];
    NSRange flagRange=[kdaStr rangeOfString:@";"];
    NSString *kdaStr2=[kdaStr substringToIndex:flagRange.location];
    model.kda=[kdaStr2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    解析天梯胜率
    NSRange t2Range=[_contents rangeOfString:@"indicatorContainer02t"];
    NSString *t2Str=[_contents substringFromIndex:t2Range.location+t2Range.length];
    NSRange t2Range2=[t2Str rangeOfString:@"indicatorContainer02t"];
    NSString *t2Str2=[t2Str substringFromIndex:t2Range2.location];
    NSRange rRange1=[t2Str2 rangeOfString:@"initValue:"];
    NSString *rateStr1=[t2Str2 substringFromIndex:rRange1.location+rRange1.length];
    NSRange dRange=[rateStr1 rangeOfString:@","];
    model.rankedWinRate=[[rateStr1 substringToIndex:dRange.location] stringByAppendingString:@"%"];
    
//    解析account_id
    NSRange idRange=[_contents rangeOfString:@"steam_id="];
    NSString *idStr1=[_contents substringFromIndex:idRange.location+idRange.length];
    NSRange idRange2=[idStr1 rangeOfString:@"'"];
    model.account_id=[idStr1 substringToIndex:idRange2.location];
    return model;
}
//解析最近玩的比赛
-(NSArray *)parseRecentMatch
{
    NSMutableArray *array=[NSMutableArray array];
    
    NSRange r1=[_contents rangeOfString:@">最近比赛<"];
    NSString *s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"最高纪录"];
    NSString *s2=[s1 substringToIndex:r2.location];
    NSRange r3=[s2 rangeOfString:@"<tbody"];
    NSString *s3=[s2 substringFromIndex:r3.location];
    NSRange r4=[s3 rangeOfString:@"</tbody>"];
    NSString *s4=[s3 substringToIndex:r4.location];
    TFHpple *parser=[[TFHpple alloc] initWithHTMLData:[s4 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *eleArray=[parser searchWithXPathQuery:@"//td"];
    for(int i=0;i<eleArray.count;i+=6)
    {
        RecentMatch *match=[[RecentMatch alloc]init];
        TFHppleElement *ele1=[[eleArray[i] children] lastObject];
        TFHppleElement *tmpEle=[[ele1 children]lastObject];
        //    英雄图像
        match.heroImage=[tmpEle attributes][@"src"];;
        //    英雄名字
//        match.heroName=[ele1 content];
        //    比赛模式
        match.matchModal=[[[eleArray[i+1] children] lastObject] content];
        if(match.matchModal.integerValue>0)
            match.matchModal=[[[[[eleArray[i+1] children] lastObject] children]lastObject] content];
        //    比赛id
        TFHppleElement *tmpEle2=eleArray[i+1];
        match.matchId=[tmpEle2 attributes][@"sorttable_customkey"];
        //    比赛时间
        match.time=[[[eleArray[i+2] children] lastObject] content];
        //    比赛结果
        match.matchResult=[[[eleArray[i+3] children] lastObject] content];
        //    kda
        NSString *tmp=[eleArray[i+4] content];
        NSRange rr1=[tmp rangeOfString:@"("];
        NSString *tmpp=[tmp substringFromIndex:rr1.location+1];
        match.kda=[tmpp substringToIndex:tmpp.length-1];
        [array addObject:match];
    }
    return array;
}
//解析常用英雄
-(NSArray *)parseMostPlayedHeros
{
    NSMutableArray *array=[NSMutableArray array];
    NSRange r1=[_contents rangeOfString:@"常用英雄"];
    NSString *s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@">最近比赛<"];
    NSString *s2=[s1 substringToIndex:r2.location];
    NSRange r3=[s2 rangeOfString:@"<tbody"];
    NSString *s3=[s2 substringFromIndex:r3.location];
    NSRange r4=[s3 rangeOfString:@"</tbody>"];
    NSString *s4=[s3 substringToIndex:r4.location];
    TFHpple *parser=[[TFHpple alloc]initWithHTMLData:[s4 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *eleArray=[parser searchWithXPathQuery:@"//td"];
    for(int i=0;i<eleArray.count;i+=5)
    {
        //    英雄名字
        HeroWinRateModel *model=[[HeroWinRateModel alloc]init];
        TFHppleElement *ele1=[[eleArray[i] children] lastObject];
        model.heroName=[ele1 content];
        NSString *tmp1=[ele1 attributes][@"href"];
        NSRange rr1=[tmp1 rangeOfString:@"hero="];
        //    英雄ID
        model.heroID=[tmp1 substringFromIndex:rr1.location+rr1.length];
        TFHppleElement *ele2=[[ele1 children]lastObject];
        //    英雄的图片
        model.heroIcon=[ele2 attributes][@"src"];
        //    比赛总场数
        model.totalMatches=[[[eleArray[i+1] children] firstObject] content];
        //    英雄胜率
        model.winRate=[[[eleArray[i+2] children] firstObject] content];
        //    KDA
        model.kda=[[[eleArray[i+3] children]firstObject] content];
        //<div>3.48<div style="float:right;"> (12.1 / 5.5 / 6.9)</div>
        [array addObject:model];
    }
    return array;
}
//解析最高纪录
-(NSArray *)parseHighestRecords
{
    NSMutableArray *array=[NSMutableArray array];
    
    //    最高连胜场数: 9\n</div>
    //    最高连败场数: 8\n</div>
    NSRange r1=[_contents rangeOfString:@"Steam 好友"];
    if(r1.location==NSNotFound)
        return nil;
    NSString *tmp1=[_contents substringFromIndex:r1.location];
    NSRange ttRange=[tmp1 rangeOfString:@"最高连败"];
    if(ttRange.location==NSNotFound)
        return nil;
    NSString *valuePart=[tmp1 substringToIndex:ttRange.location];
    TFHpple *parser=[[TFHpple alloc]initWithHTMLData:[valuePart dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *nodesArray=[parser searchWithXPathQuery:@"//span"];
    NSString *longestWinningStreak=nil;
    if(nodesArray.count>0)
        longestWinningStreak=[nodesArray[0] content];//最高连胜
    NSString *longestLosingStreak=nil;
    if(nodesArray.count>1)
        longestLosingStreak=[nodesArray[1] content];//最高连败
    NSArray *streakArray=@[@"最高连胜场数",@"最高连败场数",longestWinningStreak,longestLosingStreak];
    [array addObject:streakArray];
    
    
    NSRange range2=[_contents rangeOfString:@"最高纪录"];
    NSString *s3=[_contents substringFromIndex:range2.location];
    NSRange range3=[s3 rangeOfString:@"</tbody>"] ;
    NSString *s4=[s3 substringToIndex:range3.location];
    //    NSLog(@"%@\n",s4);
    //    解析器对象
    TFHpple *paser=[[TFHpple alloc]initWithHTMLData:[s4 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *imgNotesArray=[paser searchWithXPathQuery:@"//img"];
    for(TFHppleElement *ele in imgNotesArray)
    {
        HighestModel *model=[[HighestModel alloc]init];
        model.heroImage=[ele attributes][@"src"];
        [array addObject:model];
    }
    NSArray *tdNotesArray=[paser searchWithXPathQuery:@"//td"];
    //    每个最高纪录包含5td节点,分别是itemName matchID matchResult heroName itemValue
    for(int i=0;i<tdNotesArray.count;i+=5)
    {
        HighestModel *model=array[i/5+1];//第一个元素是词典
        model.itemName=[tdNotesArray[i] content]; //最高纪录项目的名字
        model.matchID=[[[tdNotesArray[i+1] children]lastObject]content];//最高纪录项目的比赛id
        model.matchResult=[[[tdNotesArray[i+2] children]lastObject]content];//最高纪录项目的比赛结果
        model.heroName=[[[tdNotesArray[i+3] children]lastObject]content];
        model.itemValue=[tdNotesArray[i+4] content];//最高纪录项目的值
    }
    return array;
}
//比赛统计
-(NSArray *)matchStatistical
{
    NSMutableArray *array=[NSMutableArray array];
  
    NSRange r1=[_contents rangeOfString:@"<tbody"];
    if(r1.location==NSNotFound)
        return nil;
    NSString *s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"</tbody>"];
    NSString *s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=[[TFHpple alloc] initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *eleArray=[parser searchWithXPathQuery:@"//td"];
    for(int i=0;i<eleArray.count;i+=7)
    {
        RecentMatch *match=[[RecentMatch alloc]init];
        TFHppleElement *ele1=[[eleArray[i] children] lastObject];
        TFHppleElement *tmpEle=[[ele1 children]lastObject];
        //    英雄图像
        match.heroImage=[tmpEle attributes][@"src"];;
        //    英雄名字
//        match.heroName=[ele1 content];
        //    比赛模式
        match.matchModal=[[[eleArray[i+1] children] lastObject] content];
        if(match.matchModal.integerValue>0)
            match.matchModal=[[[[[eleArray[i+1] children] lastObject] children]lastObject] content];
        //    比赛id
        TFHppleElement *tmpEle2=eleArray[i+1];
        match.matchId=[tmpEle2 attributes][@"sorttable_customkey"];
        //    比赛时间
        match.time=[[[eleArray[i+2] children] lastObject] content];
        //    比赛结果
        match.matchResult=[[[eleArray[i+3] children] lastObject] content];
        //    kda
        NSString *tmp=[eleArray[i+4] content];
        NSRange rr1=[tmp rangeOfString:@"("];
        NSString *tmpp=[tmp substringFromIndex:rr1.location+1];
        match.kda=[tmpp substringToIndex:tmpp.length-1];
        [array addObject:match];
    }
    return array;
}
//英雄统计
-(NSArray *)heroStatistical
{
    NSMutableArray *array=[NSMutableArray array];
    
    NSRange r1=[_contents rangeOfString:@"<tbody"];
    if(r1.location==NSNotFound)
        return nil;
    NSString *s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"</tbody>"];
    NSString *s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=[[TFHpple alloc] initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *eleArray=[parser searchWithXPathQuery:@"//td"];
    for(int i=0;i<eleArray.count;i+=7)
    {
        //    英雄名字
        HeroWinRateModel *model=[[HeroWinRateModel alloc]init];
        TFHppleElement *ele1=[[eleArray[i] children] lastObject];
        model.heroName=[ele1 content];
        NSString *tmp1=[ele1 attributes][@"href"];
        NSRange rr1=[tmp1 rangeOfString:@"hero="];
        //    英雄ID
        model.heroID=[tmp1 substringFromIndex:rr1.location+rr1.length];
        TFHppleElement *ele2=[[ele1 children]lastObject];
        //    英雄的图片
        model.heroIcon=[ele2 attributes][@"src"];
        //    比赛总场数
        model.totalMatches=[[[eleArray[i+1] children] firstObject] content];
        //    英雄胜率
        model.winRate=[[[eleArray[i+2] children] firstObject] content];
        //    KDA
        model.kda=[[[eleArray[i+3] children]firstObject] content];
        //<div>3.48<div style="float:right;"> (12.1 / 5.5 / 6.9)</div>
        [array addObject:model];
    }
    return array;
}
-(NSArray *)allMatchesWithSingleHero
{
    NSMutableArray *array=[NSMutableArray array];
    NSRange r1=[_contents rangeOfString:@"<tbody"];
    NSString *s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"</tbody>"];
    NSString *s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=[[TFHpple alloc] initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *eleArray=[parser searchWithXPathQuery:@"//td"];
    for(int i=0;i<eleArray.count;i+=7)
    {
        RecentMatch *match=[[RecentMatch alloc]init];
        TFHppleElement *ele1=[[eleArray[i] children] lastObject];
        TFHppleElement *tmpEle=[[ele1 children]lastObject];
        //    英雄图像
        match.heroImage=[tmpEle attributes][@"src"];;
        //    英雄名字
//        match.heroName=[ele1 content];
        //    比赛模式
        match.matchModal=[[[eleArray[i+1] children] lastObject] content];
        if(match.matchModal.integerValue>0)
            match.matchModal=[[[[[eleArray[i+1] children] lastObject] children]lastObject] content];
        //    比赛id
        TFHppleElement *tmpEle2=eleArray[i+1];
        match.matchId=[tmpEle2 attributes][@"sorttable_customkey"];
        //    比赛时间
        match.time=[[[eleArray[i+2] children] lastObject] content];
        //    比赛结果
        match.matchResult=[[[eleArray[i+3] children] lastObject] content];
        //    kda
        NSString *tmp=[eleArray[i+4] content];
        NSRange rr1=[tmp rangeOfString:@"("];
        NSString *tmpp=[tmp substringFromIndex:rr1.location+1];
        match.kda=[tmpp substringToIndex:tmpp.length-1];
        [array addObject:match];
    }
    return array;
}
//比赛详情的摘要数据
-(MatchDetailSummaryModel *)parseMatchDetailSummary
{
    MatchDetailSummaryModel *model=[[MatchDetailSummaryModel alloc]init];
    NSRange r1=[_contents rangeOfString:@"<td>比赛模式</td>"];
    NSString *s1=[_contents substringFromIndex:r1.location+r1.length];
    NSRange r2=[s1 rangeOfString:@"</p>"];
    NSString *s2=[s1 substringToIndex:r2.location+4];

    TFHpple *parser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    TFHppleElement *p=[[parser searchWithXPathQuery:@"//p"] lastObject];
    NSArray *tmpArray=[p children];
    if(tmpArray.count>0)
       model.victoryTeam=@"天辉";
    else
        model.victoryTeam=@"夜魇";
    NSArray *tdArray=[parser searchWithXPathQuery:@"//td"];
    model.time=[tdArray[1] content];
    model.duration=[tdArray[2] content];
    model.matchModal=[tdArray[6] content];
    return model;
}
//比赛 详情
-(NSArray *)matchDetailWithMatchID:(NSString *)matchID
{
    [self getAccountIDsWithMatchID:matchID];
    
    NSMutableArray *array=[NSMutableArray array];
    /*
     @property(nonatomic,strong)NSArray  *items;     //物品
     */
    NSString *s1=nil;
    NSRange r1=[_contents rangeOfString:@"英雄治疗"];
    if(r1.location!=NSNotFound)
        s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"技能加点 - 天辉"];
    NSString *s2=nil;
    if(r2.location!=NSNotFound)
        s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=nil;
    if(s2.length>0)
        parser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *trArray=[parser searchWithXPathQuery:@"//tr"];
    if(trArray.count>0)
    {
        for(int i=0;i<10;i++)
        {
            TFHppleElement *element=trArray[i];
            NSArray *tdArray=[element children];//每个MatchDetail模型包含13个td节点
            MatchDetailModel *model=[[MatchDetailModel alloc] init];
            TFHppleElement *ele0=[[[[tdArray[0] children]lastObject]children]lastObject];
            model.playerIcon=[ele0 attributes][@"src"];
            model.player=[[[tdArray[1] children] lastObject] content];
            TFHppleElement *ele2=[[[[tdArray[2] children]firstObject]children]lastObject];
            /**判断是否是MVP*/
            NSArray *tmpArray=[[[tdArray[2] children]lastObject]children];
            if(tmpArray.count>0)
            {
                TFHppleElement *mvpNote=tmpArray[0];
                if([[mvpNote content] isEqualToString:@"MVP"])
                model.isMVP=YES;
            }
            model.heroIcon=[ele2 attributes][@"src"];
            model.heroLevel=[[[tdArray[2] children]firstObject] content];
            model.kda=[tdArray[3] content];
            model.rateOfWar=[tdArray[4] content];
            model.damageRate=[tdArray[5] content];
            model.lastHit=[tdArray[7] content];
            model.exp=[tdArray[8] content];
            model.gxp=[tdArray[9] content];
            NSArray *aAarry=[tdArray[12] children];
            NSMutableArray *itemArray=[NSMutableArray array];
            for(int k=0;k<aAarry.count;k++)
            {
                TFHppleElement *ele=[[aAarry[k] children]lastObject];
                [itemArray addObject:[ele attributes][@"src"]];
            }
            model.items=itemArray;
            if(_accountArray.count>0)
                model.accountID=_accountArray[i];//玩家id
            [array addObject:model];
        }
    }
    return array;
}
-(void)getAccountIDsWithMatchID:(NSString *)matchID
{
    
//    dispatch_queue_t queue=dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
    
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:kDetailJSONUrl,matchID]]];
    
        if(data.length>0)
        {
            NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array=dictionary[@"result"][@"players"];
            for(NSDictionary *dict in array)
                [_accountArray addObject:dict[@"account_id"]];
        }
        
//    });
}
@end
