//
//  NewsModel.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong,setter=setDescription:)NSString *desc;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong,setter=setNewUrl:)NSString *newsURL;
@property(nonatomic,strong)NSArray *imgs;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
+(instancetype)newsWithDictionary:(NSDictionary *)dict;

@end
