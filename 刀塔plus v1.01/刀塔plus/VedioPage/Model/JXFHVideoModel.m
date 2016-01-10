//
//  JXFHVideoModel.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/30.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "JXFHVideoModel.h"

@implementation JXFHVideoModel

+(instancetype)jxfhWithDict:(NSDictionary *)dict
{
    JXFHVideoModel *model=[[[self class] alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
