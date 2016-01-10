//
//  DotaExPlainerModel.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/29.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>
/**解说模型*/
@interface DotaExPlainerModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *dm_uid;

+(instancetype)explainer;

@end
