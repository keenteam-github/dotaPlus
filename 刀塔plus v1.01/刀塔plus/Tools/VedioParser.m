//
//  VedioParser.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "VedioParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "LiveModel.h"
#import "DotaExPlainerModel.h"

@implementation VedioParser

-(instancetype)initWithData:(NSData *)data
{
    if(self=[super init])
    {
        self.contents=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return self;
}
+(instancetype)paserWithData:(NSData *)data
{
    return [[[self class]alloc]initWithData:data];
}
-(NSArray *)parseLive
{
    NSMutableArray *array=[NSMutableArray array];
//    回到顶部
//    Dotamax 直播
    NSRange r1=[_contents rangeOfString:@"Dotamax 直播"];
    if(r1.location==NSNotFound)
        return nil;
    NSString *s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"回到顶部"];
    if(r2.location==NSNotFound)
        return nil;
    NSString *s2=[s1 substringToIndex:r2.location];
    TFHpple *paser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *aNotes=[paser searchWithXPathQuery:@"//a"];
    for(TFHppleElement *ele in aNotes)
    {
        LiveModel *model=[LiveModel model];
        NSString *liveStr=[ele attributes][@"href"];
        NSRange rr1=[liveStr rangeOfString:@"live_type="];
        if(rr1.location!=NSNotFound)
        {
            NSString *ss1=[liveStr substringFromIndex:rr1.location+rr1.length];
            NSRange rr2=[ss1 rangeOfString:@"&"];
            if(rr2.location!=NSNotFound)
                model.live_type=[ss1 substringToIndex:rr2.location];
            NSRange rr3=[ss1 rangeOfString:@"live_id="];
            if(rr3.location!=NSNotFound)
            {
                NSString *ss2=[ss1 substringFromIndex:rr3.location+rr3.length];
                model.live_id=[[ss2 componentsSeparatedByString:@"\""] firstObject];
            }
        }
        TFHppleElement *elemet=[[[[ele children]firstObject] children]firstObject];
        model.placeHodler=[elemet attributes][@"src"];
        TFHppleElement *secondNode=[[ele children] lastObject];
        NSArray *tmp=[secondNode children];
        if(tmp.count>0)
        {
            TFHppleElement *tmpEle=[[tmp[0] children] firstObject];
            model.obImage=[tmpEle attributes][@"src"];
        }
        if(tmp.count>1)
            model.title=[[[tmp[1] children] lastObject] content];
        if(tmp.count>2)
        {
            TFHppleElement *tmpEle3=[[tmp[2] children] firstObject];
            model.obName=[tmpEle3 content];
        }
        [array addObject:model];
    }
//    解析观众数量
    NSArray *viewerCountArray=[self getViewerCount];
    for(int i=0;i<array.count;i++)
    {
        if(array.count>i)
        {
            LiveModel *model=array[i];
            if(viewerCountArray.count>i)
                model.viewerCount=viewerCountArray[i];
        }
    }
    return array;
}
//解析观众数量
-(NSArray *)getViewerCount
{
    NSMutableArray *array=[NSMutableArray array];
    NSString *part=_contents;
    while(1)
    {
        NSRange range=[part rangeOfString:@"<span class=\"glyphicon glyphicon-eye-open\"></span> "];
        if(range.location==NSNotFound)
            break;
        NSString *tmp1=[part substringFromIndex:range.location+range.length];
        NSString *tmp2=[tmp1 substringToIndex:10];
        NSRange nRange=[tmp2 rangeOfString:@"\n"];
        NSString *value=nil;
        if(nRange.location!=NSNotFound)
            value=[tmp2 substringToIndex:nRange.location];
        if(value.length>0)
           [array addObject:value];
        part=[part substringFromIndex:range.location+range.length];
    }
    return array;
}
//dota解说列表
-(NSArray *)parseDotaList
{
    NSMutableArray *array=[NSMutableArray array];
//    知名解说
    NSMutableArray *wellKnowArray=[NSMutableArray array];
//    美女解说
    NSMutableArray *beautyArray=[NSMutableArray array];
    NSRange r1=[self.contents rangeOfString:@"知名解说:"];
    NSString *s1=nil;
    if(r1.location!=NSNotFound)
        s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"美女解说:"];
    NSString *s2=nil;
    if(r2.location!=NSNotFound)
        s2=[s1 substringToIndex:r2.location];
    TFHpple *wellknowParser=nil;
    if(s2.length>0)
        wellknowParser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *aArray=[wellknowParser searchWithXPathQuery:@"//a"];
    if(aArray.count>0)
    {
        for(TFHppleElement *ele in aArray)
        {
            DotaExPlainerModel *model=[DotaExPlainerModel explainer];
            model.name=[ele content];
            model.dm_uid=[ele attributes][@"dm_uid"];
            [wellKnowArray addObject:model];
        }
        if(wellKnowArray.count>0)
           [array addObject:wellKnowArray];
    }
    
    NSRange range1=[_contents rangeOfString:@"美女解说:"];
    NSString *str1=nil;
    if(range1.location!=NSNotFound)
        str1=[_contents substringFromIndex:range1.location];
    NSRange range2=[_contents rangeOfString:@"热门视频"];
    NSString *str2=nil;
    if(range2.location!=NSNotFound)
        str2=[str1 substringToIndex:range2.location];
    TFHpple *beautyParser=nil;
    if(str2.length>0)
        beautyParser=[[TFHpple alloc]initWithHTMLData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *bArray=[beautyParser searchWithXPathQuery:@"//a"];
    if(bArray.count>0)
    {
        for(TFHppleElement *ele in bArray)
        {
            DotaExPlainerModel *model=[DotaExPlainerModel explainer];
            model.name=[ele content];
            model.dm_uid=[ele attributes][@"dm_uid"];
            [beautyArray addObject:model];
        }
        if(beautyArray.count>0)
            [array addObject:beautyArray];
    }
    return array;
}
//dota2解说列表
-(NSArray *)parseDota2List
{
    NSMutableArray *array=[NSMutableArray array];
//    知名解说 知名玩家 美女解说 热门赛事 热门视频
    NSMutableArray *wellExplianers=[NSMutableArray array];
    NSMutableArray *wellPlayers=[NSMutableArray array];
    NSMutableArray *beautys=[NSMutableArray array];
    NSMutableArray *hots=[NSMutableArray array];
    NSRange r1=[_contents rangeOfString:@"知名解说:"];
    NSString *s1=nil;
    if(r1.location!=NSNotFound)
        s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"知名玩家:"];
    NSString *s2=nil;
    if(r2.location!=NSNotFound)
        s2=[s1 substringToIndex:r2.location];
    TFHpple *explainParser=nil;
    if(s2.length>0)
        explainParser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *aArray=[explainParser searchWithXPathQuery:@"//a"];
    if(aArray.count>0)
    {
        for(TFHppleElement *ele in aArray)
        {
            DotaExPlainerModel *model=[DotaExPlainerModel explainer];
            model.name=[ele content];
            model.dm_uid=[ele attributes][@"dm_uid"];
            [wellExplianers addObject:model];
        }
        if(wellExplianers.count>0)
           [array addObject:wellExplianers];
    }
    
    NSRange r3=[_contents rangeOfString:@"美女解说:"];
    NSString *s3=nil;
    if(r3.location!=NSNotFound)
        s3=[_contents substringFromIndex:r3.location];
    NSRange r4=[s3 rangeOfString:@"热门赛事:"];
    NSString *s4=nil;
    if(r4.location!=NSNotFound)
        s4=[s3 substringToIndex:r4.location];
    TFHpple *beautyParser=nil;
    if(s4.length>0)
        beautyParser=[[TFHpple alloc]initWithHTMLData:[s4 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *bArray=[beautyParser searchWithXPathQuery:@"//a"];
    if(bArray.count>0)
    {
        for(TFHppleElement *ele in bArray)
        {
            DotaExPlainerModel *model=[DotaExPlainerModel explainer];
            model.name=[ele content];
            model.dm_uid=[ele attributes][@"dm_uid"];
            [beautys addObject:model];
        }
        if(beautys.count>0)
            [array addObject:beautys];
    }
    
    NSRange r5=[_contents rangeOfString:@"知名玩家:"];
    NSString *s5=nil;
    if(r5.location!=NSNotFound)
        s5=[_contents substringFromIndex:r5.location];
    NSRange r6=[s5 rangeOfString:@"美女解说:"];
    NSString *s6=nil;
    if(r6.location!=NSNotFound)
        s6=[s5 substringToIndex:r6.location];
    TFHpple *playerParser=nil;
    if(s6.length>0)
        playerParser=[[TFHpple alloc]initWithHTMLData:[s6 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *cArray=[playerParser searchWithXPathQuery:@"//a"];
    if(cArray.count>0)
    {
        for(TFHppleElement *ele in cArray)
        {
            DotaExPlainerModel *model=[DotaExPlainerModel explainer];
            model.name=[ele content];
            model.dm_uid=[ele attributes][@"dm_uid"];
            [wellPlayers addObject:model];
        }
        if(wellPlayers.count>0)
            [array addObject:wellPlayers];
    }
    
    NSRange r7=[_contents rangeOfString:@"热门赛事:"];
    NSString *s7=nil;
    if(r7.location!=NSNotFound)
        s7=[_contents substringFromIndex:r7.location];
    NSRange r8=[s7 rangeOfString:@"热门视频"];
    NSString *s8=nil;
    if(r8.location!=NSNotFound)
        s8=[s7 substringToIndex:r8.location];
    TFHpple *hotParser=nil;
    if(s8.length>0)
        hotParser=[[TFHpple alloc]initWithHTMLData:[s8 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *dArray=[hotParser searchWithXPathQuery:@"//a"];
    if(dArray.count>0)
    {
        for(TFHppleElement *ele in dArray)
        {
            DotaExPlainerModel *model=[DotaExPlainerModel explainer];
            model.name=[ele content];
            model.dm_uid=[ele attributes][@"dm_uid"];
            [hots addObject:model];
        }
        if(hots.count>0)
            [array addObject:hots];
    }
    return array;
}
@end
