//
//  VideoMenuModel.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/5.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoMenuModel : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *detail;
@property(nonatomic,strong,setter=setId:) NSString *authorID;
@property(nonatomic,strong) NSString *icon;

+(instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
/*
 "authors": [
 {
 "name": "最近更新",
 "url": "http://dotaly.com",
 "detail": "2015-06-12",
 "pop": -1,
 "youku_id": "none",
 "id": "all",
 "icon": "http://tp2.sinaimg.cn/3083660057/180/5661924594/1"
 },
 */