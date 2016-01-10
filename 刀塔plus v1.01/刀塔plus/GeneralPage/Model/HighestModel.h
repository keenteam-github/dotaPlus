//
//  HighestModel.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/18.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighestModel : NSObject

@property(nonatomic,strong)NSString *matchID;    //比赛ID
@property(nonatomic,strong)NSString *heroName;   //最高项目英雄
@property(nonatomic,strong)NSString *heroImage;  //英雄图像
@property(nonatomic,strong)NSString *itemName;   //最高项目名
@property(nonatomic,strong)NSString *itemValue;  //最高项目的值
@property(nonatomic,strong)NSString *matchResult;//比赛结果

@end
