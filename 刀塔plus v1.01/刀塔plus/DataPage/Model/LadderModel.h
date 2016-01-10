//
//  LadderModel.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LadderModel : NSObject

@property(nonatomic,strong)NSString * rank;//排名
@property(nonatomic,strong)NSString * score;//天梯积分
@property(nonatomic,strong)NSString * icon;//图像
@property(nonatomic,strong)NSString * team;//所属战队
@property(nonatomic,strong)NSString * name;//昵称
@property(nonatomic,strong)NSString * account_id;//steam id

+(instancetype)ladder;
@end
