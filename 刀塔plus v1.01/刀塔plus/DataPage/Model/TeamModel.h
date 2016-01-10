//
//  TeamModel.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/3.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>
/**战队模型*/
@interface TeamModel : NSObject

@property(nonatomic,strong) NSString *ranked;
@property(nonatomic,strong) NSString *teamIcon;
@property(nonatomic,strong) NSString *teamName;
@property(nonatomic,strong) NSString *teamMMR;
@property(nonatomic,strong) NSString *winRate;

@property(nonatomic,strong) NSString *teamID;
@property(nonatomic,strong) NSMutableArray *memberArray;

+(TeamModel *)team;

@end
