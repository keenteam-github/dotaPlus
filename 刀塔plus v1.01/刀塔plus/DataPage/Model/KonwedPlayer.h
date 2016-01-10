//
//  KonwedPlaey.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/2.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KonwedPlayer : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *account_id;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *rankedScore;
@property(nonatomic,strong) NSString *teamedScore;
@property(nonatomic,strong) NSString *teamLogo;

+(instancetype)player;
@end
