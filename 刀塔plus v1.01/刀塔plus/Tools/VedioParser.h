//
//  VedioParser.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VedioParser : NSObject

//    html内容字符串
@property(nonatomic,strong)NSString *contents;

-(instancetype)initWithData:(NSData *)data;
+(instancetype)paserWithData:(NSData *)data;

/**解析直播*/
-(NSArray *)parseLive;
/**dota解说列表*/
-(NSArray *)parseDotaList;
/**dota2解说列表*/
-(NSArray *)parseDota2List;

@end
