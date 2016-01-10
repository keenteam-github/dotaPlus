//
//  Const.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/22.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#ifndef __plus_Const_h
#define __plus_Const_h



#define kWidth ([UIScreen mainScreen].bounds.size.width)
#define kHeight (self.view.frame.size.height)
//默认的账号id//230175666//144629129//90045009
#define kDeflautAccountID @"90045009"

//崩溃收集id
#define kCrashCollectID @"900004395"

//综合数据接口
#define kGeneralUrl @"http://dotamax.com/player/detail/%@/"
//比赛统计
#define kMatchUrl @"http://dotamax.com/player/match/%@/?ladder=%@"
//英雄统计
#define kHeroUrl @"http://dotamax.com/player/hero/%@/?ladder=%@"
//英雄统计_单个英雄所有比赛
#define kSingleHeroUrl @"http://dotamax.com/player/match/%@/?hero=%@&p=%ld"
//比赛详情接口
#define kDetailUrl @"http://dotamax.com/match/detail/%@/"
#define kDetailJSONUrl @"https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=%@&key=241C8848BAF371F8CFAF1645A18807F1"
//搜索接口
#define kSearchUrl @"http://dotamax.com/search/?q=%@"
//反馈邮箱
#define kMailAddress (@"newbox0512@yahoo.com")
//新闻接口
#define kNewsURL (@"http://news.maxjia.com/todaynews/?offset=%ld&limit=20&phone_num=00000000000&pkey=randpkey&os_type=iOS&version=1.0.0")
//直播接口
#define kLiveUrl (@"http://dotamax.com/live/")
//播放直播接口
#define kLivePlayUrl (@"http://dotamax.com/live_detail/?live_type=%@&live_id=%@")

#define kDotaListUrl @"http://dotamax.com/video/users/dota/"
#define kDota2ListUrl @"http://dotamax.com/video/users/dota2/"

//剑雪封喉视频
//#define kJXFHUrl @"http://i.youku.com/u/UMzA1OTQ5NjY0/videos"

//剑雪封喉list
#define kJXFHList @"http://api.dotaly.com/api/v1/shipin/latest?author=jxfh&iap=0&ident=6189AB13-2ED2-4BA2-BA3D-2B784DF2B8A7&jb=0&limit=50&offset=0&token=ff3b68bec8f10216c598789a3b833a4e"


#define kDotaExplainerUrl @"http://dotamax.com/video/users/dota/?type=&dm_uid=%@&p=%ld#recent_videos"

#define kDota2ExplainerUrl @"http://dotamax.com/video/users/dota2/?type=&dm_uid=%@&p=%ld#recent_videos"

#define kFormedPlayerUrl @"http://dotamax.com/video/users/dota2/?type=steam_id&dm_uid=%@&p=%ld#recent_videos"
//热门赛事
#define kHotUrl @"http://dotamax.com/video/users/dota2/?type=league_id&dm_uid=%@&p=%ld#recent_videos"
//剑雪封喉 视频播放接口   //填空参数vid=%@为VideoMenuModel的id属性
#define kJXFHVideoUrl @"http://api.dotaly.com/api/v1/getvideourl?iap=0&ident=6189AB13-2ED2-4BA2-BA3D-2B784DF2B8A7&jb=0&token=dd8faec11bcfeabf0cb1c327aef83581&type=mp4&vid=%@"

//物品
#define kItemList @"http://dotamax.com/item/"
//英雄
#define kHeroList @"http://dotamax.com/hero/rate/"
//天梯
#define kLadderUrl @"http://dotamax.com/ladder/%@"
//知名玩家
#define kKnowedPlayerUrl @"http://dotamax.com/player/"
//职业战队数据
#define kTeamListUrl @"http://dotamax.com/match/tour_famous_team_list/"
//饰品列表
#define kDecorationUrl @"http://dota2.vpgame.com/market/item.html?SteamItem%%5Brarity%%5D=%@&SteamItem%%5Bquality%%5D=%@&SteamItem_page=%ld"

//综合视频列表
#define kVideoMenuListUrl @"http://api.dotaly.com/api/v1/authors?iap=0&ident=A3857C45-BCF0-418F-8A01-C0F12BE4DE1C&jb=0&nc=3667235233&tk=2c1b948ad85abfd88bc2410fcd0a9df0"

//解说员视频列表
/*填空参数author=%@为VideoMenuModel的id属性
 offset=%ld 从第offset个视频开始
 */
#define kExplainerVideoList @"http://api.dotaly.com/api/v1/shipin/latest?author=%@&iap=0&ident=6189AB13-2ED2-4BA2-BA3D-2B784DF2B8A7&jb=0&limit=10&offset=%ld&token=ff3b68bec8f10216c598789a3b833a4e"
#define kDota2List @"http://api.dotaly.com/api/v1/shipin/latest?author=videodota2&iap=0&ident=6189AB13-2ED2-4BA2-BA3D-2B784DF2B8A7&jb=0&limit=50&offset=0&token=ff3b68bec8f10216c598789a3b833a4e"

#endif
