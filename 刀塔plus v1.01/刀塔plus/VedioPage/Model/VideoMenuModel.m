//
//  VideoMenuModel.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/5.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "VideoMenuModel.h"

@implementation VideoMenuModel

+(instancetype)modelWithDictionary:(NSDictionary *)dict
{
    VideoMenuModel *model=[[VideoMenuModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
