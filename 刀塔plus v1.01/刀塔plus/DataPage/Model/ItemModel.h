//
//  ItemModel.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * useCount;
@property(nonatomic,strong)NSString * winRate;

+(instancetype)item;


@end
