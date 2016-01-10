//
//  DecorationModel.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/4.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecorationModel : NSObject

@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *quality;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *itemID;

+(instancetype)decoration;

@end
