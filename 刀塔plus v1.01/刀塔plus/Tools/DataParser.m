//
//  DataParser.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "DataParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "ItemModel.h"
#import "LadderModel.h"
#import "KonwedPlayer.h"
#import "TeamModel.h"
#import "Player.h"
#import "DecorationModel.h"

@implementation DataParser

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
-(NSArray *)parseItems
{
    NSMutableArray *array=[NSMutableArray array];
    NSRange r1=[_contents rangeOfString:@"<tbody>"];
    NSString *s1=nil;
    if(r1.location!=NSNotFound)
        s1=[_contents substringFromIndex:r1.location];
   
    NSRange r2=[s1 rangeOfString:@"</tbody>"];
    NSString *s2=nil;
    if(r2.location!=NSNotFound)
        s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=nil;
    if(s2.length>0)
        parser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *tdArray=[parser searchWithXPathQuery:@"//td"];
//    每3个td节点对应一个模型
    
    for(int i=0;i<tdArray.count;i+=3)
    {
        if(tdArray.count>i+2)
        {
            ItemModel *model=[ItemModel item];
            TFHppleElement *ele1=[[tdArray[i] children] firstObject];
            model.icon=[ele1 attributes][@"src"];
            TFHppleElement *ele2=[[tdArray[i] children] lastObject];
            model.name=[ele2 content];
            
            model.useCount=[[[[tdArray[i+1] children] firstObject] content] stringByReplacingOccurrencesOfString:@"," withString:@""];
            model.winRate=[[[[tdArray[i+2] children]firstObject]content] stringByReplacingOccurrencesOfString:@"," withString:@""];
            if(model)
                [array addObject:model];
        }
    }
    return array;
}
//天梯
-(NSArray *)parseLadder
{
    NSMutableArray *array=[NSMutableArray array];
    NSRange r1=[_contents rangeOfString:@"<tbody>"];
    NSString *s1=nil;
    if(r1.location!=NSNotFound)
        s1=[_contents substringFromIndex:r1.location];
    
    NSRange r2=[s1 rangeOfString:@"</tbody>"];
    NSString *s2=nil;
    if(r2.location!=NSNotFound)
        s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=nil;
    if(s2.length>0)
        parser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *trArray=[parser searchWithXPathQuery:@"//tr"];
    for(TFHppleElement *elment in trArray)
    {
        LadderModel *model=[LadderModel ladder];
         //            steam id账号
        NSArray *tmpArray=[[elment attributes][@"onclick"] componentsSeparatedByString:@"/"];
        if(tmpArray.count>3)
            model.account_id=tmpArray[3];
        NSArray *tdArray=[elment children];
        //    每7个td节点构成一个模型数据
        for(int i=0;i<tdArray.count;i+=7)
        {
            if(trArray.count>i+7)
            {
                model.rank=[tdArray[i] content];
                model.score=[tdArray[i+2] content];
                TFHppleElement *e1=[[tdArray[i+3] children] firstObject];
                model.icon=[e1 attributes][@"src"];
                NSArray *notes=[tdArray[i+3]children];
                if(notes.count>=2)
                   model.name=[notes[1] content];
                if(!model.name)
                    model.name=[tdArray[i+3] content];
                model.team=[tdArray[i+4] content];
            }
        }
        if(model)
           [array addObject:model];
    }
    return array;
}
//知名玩家
-(NSArray *)parseKnowedPlayers
{
    NSMutableArray *array=[NSMutableArray array];
    NSRange r1=[_contents rangeOfString:@"<tbody>"];
    NSString *s1=nil;
    if(r1.location!=NSNotFound)
        s1=[_contents substringFromIndex:r1.location];
    NSRange r2=[s1 rangeOfString:@"</tbody>"];
    NSString *s2=nil;
    if(r2.location!=NSNotFound)
        s2=[s1 substringToIndex:r2.location];
    TFHpple *parser=[[TFHpple alloc]initWithHTMLData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *tdArray=[parser searchWithXPathQuery:@"//td"];
    for(int i=0;i<tdArray.count;i+=5)//每5个td节点对应一个模型数据
    {
        if(tdArray.count>i+5)
        {
            KonwedPlayer *player=[KonwedPlayer player];
            TFHppleElement *tmpNote1=[[tdArray[i] children]lastObject];
            TFHppleElement *iconNote=[[tmpNote1 children] firstObject];
            player.icon=[iconNote attributes][@"src"];
            NSArray *tmpArray=[tmpNote1 children];
            if(tmpArray.count>=2)
                player.name=[tmpArray[1] content];
            if(tmpArray.count>=3)
                
                player.account_id=[[[tmpArray[2] children] lastObject] content];
            
            player.state=[[[tdArray[i+1] children] lastObject] content];
            player.rankedScore=[[[tdArray[i+2] children] firstObject] content];
            player.teamedScore=[[[tdArray[i+3] children] firstObject] content];
            TFHppleElement *ele=[[[[tdArray[i+4] children] firstObject]children] firstObject];
            player.teamLogo=[ele attributes][@"src"];
           if(player)
              [array addObject:player];
        }
    }
    return array;
}
//解析战队列表数据
-(NSArray *)parseTeamList
{
    NSMutableArray *array=[NSMutableArray array];
    if(!_contents)
        return nil;
    NSRange range=[_contents rangeOfString:@" t style"];
    NSString *resultStr=_contents;
    if(range.location!=NSNotFound)
        resultStr=[_contents stringByReplacingOccurrencesOfString:@" t style" withString:@"tstyle"];
    TFHpple *parser=[[TFHpple alloc] initWithHTMLData:[resultStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *trNotes=[parser searchWithXPathQuery:@"//tr"];
    for(TFHppleElement *element in trNotes)
    {
//        team ID
        TeamModel *model=[TeamModel team];
        NSString *tmp=[element attributes][@"onclick"];
        NSArray *tmpArray=[tmp componentsSeparatedByString:@"="];
        if(tmpArray.count>=2)
        model.teamID=[tmpArray[1] stringByReplacingOccurrencesOfString:@"')" withString:@""];
        NSArray *tdNotes=[element children];
        for(int i=0;i<tdNotes.count;i+=7)//每7个td节点对应一个模型数据
        {
            if(tdNotes.count>i+6)
            {
                model.ranked=[tdNotes[i] content];
                TFHppleElement *e1=[[tdNotes[i+1] children] lastObject];
                model.teamIcon=[e1 attributes][@"src"];
                model.teamName=[tdNotes[i+2] content];
                model.teamMMR=[[[tdNotes[i+3] children] firstObject] content];
                model.winRate=[[[tdNotes[i+5] children] firstObject] content];
//                队员 每个队员对应一个player模型
                NSArray *aNotes=[tdNotes[i+6] children];
                for(TFHppleElement *ele in aNotes)
                {
                    Player *player=[Player player];
                    NSArray *idArray=[[ele attributes][@"href"] componentsSeparatedByString:@"/"];
                    if(idArray.count>2)
                        player.playerID=idArray[idArray.count-2];
                    TFHppleElement *e2=[[ele children] firstObject];
                    player.playerName=[e2 attributes][@"title"];
                    TFHppleElement *e3=[[[[ele children] lastObject] children]lastObject];
                    player.playIcon=[e3 attributes][@"src"];
                    if(player)
                        [model.memberArray addObject:player];
                }
                if(model)
                   [array addObject:model];
            }
        }
    }
    return array;
}
//解析饰品数据
-(NSArray *)decorationList
{
    NSMutableArray *array=[NSMutableArray array];
    
    NSRange range=[_contents rangeOfString:@"<div class=\"tbody \">"];
    NSString *tmp=nil;
    if(range.location!=NSNotFound)
        tmp=[_contents substringFromIndex:range.location];
    NSRange range2=[tmp rangeOfString:@"发布出售"];
    NSString *result=nil;
    if(range2.location!=NSNotFound)
        result=[tmp substringToIndex:range2.location];
    TFHpple *parser=nil;
    if(result.length>0)
        parser=[[TFHpple alloc] initWithHTMLData:[result dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *imgArray=[parser searchWithXPathQuery:@"//img"];
    if(imgArray.count>0)
    {
        for(TFHppleElement *imgElement in imgArray)
        {
            DecorationModel *model=[DecorationModel decoration];
            model.icon=[imgElement attributes][@"src"];
            if(model.icon.length>0)
                [array addObject:model];
        }
    }
    NSArray *spanArray=[parser searchWithXPathQuery:@"//span"];
    for(int i=0;i<imgArray.count*5;i+=5)
    {
        if(spanArray.count>=i+5)
        {
            if(array.count>0)
            {
                DecorationModel *model=array[i/5];
                model.quality=[spanArray[i] content];
                model.name=[spanArray[i+1] content];
                model.type=[spanArray[i+2] content];
            }
        }
    }
    NSArray *aArray=[parser searchWithXPathQuery:@"//a"];
    for(int i=0;i<imgArray.count*3;i+=3)
    {
        if(aArray.count>=i+3)
        {
            DecorationModel *model=array[i/3];
            TFHppleElement *ele=aArray[i];
            model.itemID=[[[ele attributes][@"href"] componentsSeparatedByString:@"="] lastObject];
        }
    }
    return array;
}

@end
