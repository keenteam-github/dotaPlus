//
//  JXFHVideoModel.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/30.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>
/**剑雪封喉视频模型*/
@interface JXFHVideoModel : NSObject

@property(nonatomic,strong)NSString *thumb;//视频的placeHolder image
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong,setter=setId:)NSString *videoID;
//真实的视频播放地址
@property(nonatomic,strong)NSString *realUrl;

+(instancetype)jxfhWithDict:(NSDictionary *)dict;

@end