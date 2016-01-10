//
//  LiveModel.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>
/**直播项目模型*/
@interface LiveModel : NSObject

@property(nonatomic,strong)NSString *live_type;

@property(nonatomic,strong)NSString *live_id;
//视频placeHolder
@property(nonatomic,strong)NSString *placeHodler;
//解说头像
@property(nonatomic,strong)NSString *obImage;
//解说人昵称
@property(nonatomic,strong)NSString *obName;
//直播标题
@property(nonatomic,strong)NSString *title;
//观众数量
@property(nonatomic,strong)NSString *viewerCount;


+(instancetype)model;

@end
