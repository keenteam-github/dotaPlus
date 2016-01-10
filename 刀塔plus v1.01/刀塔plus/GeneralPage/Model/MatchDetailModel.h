//
//  MatchDetailModel.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchDetailModel : NSObject

@property(nonatomic,strong)NSString *player;    //玩家名字
@property(nonatomic,strong)NSString *playerIcon;//玩家图标
@property(nonatomic,strong)NSString *heroIcon;  //英雄图标
@property(nonatomic,strong)NSString *heroLevel; //英雄等级
@property(nonatomic,strong)NSString *kda;       //k-d-a
@property(nonatomic,strong)NSString *rateOfWar; //参战率
@property(nonatomic,strong)NSString *damageRate;//输出伤害占比
@property(nonatomic,strong)NSString *lastHit;   //正反补
@property(nonatomic,strong)NSArray  *items;     //物品
@property(nonatomic,strong)NSString *exp;       //经验每分钟
@property(nonatomic,strong)NSString *gxp;       //金钱每分钟
@property(nonatomic,assign)BOOL isMVP;          //是否是MVP

@property(nonatomic,strong)NSNumber *accountID; //玩家id
@end
