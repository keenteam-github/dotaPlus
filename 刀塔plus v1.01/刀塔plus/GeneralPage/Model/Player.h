//
//  Player.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property(nonatomic,strong)NSString *playerName;
@property(nonatomic,strong)NSString *playerID;
@property(nonatomic,strong)NSString *playIcon;

+(instancetype)player;

@end
