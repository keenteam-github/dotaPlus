//
//  DataParser.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

//    html内容字符串
@property(nonatomic,strong)NSString *contents;

-(instancetype)initWithData:(NSData *)data;
+(instancetype)paserWithData:(NSData *)data;


-(NSArray *)parseItems;
-(NSArray *)parseLadder;
-(NSArray *)parseKnowedPlayers;
-(NSArray *)parseTeamList;
-(NSArray *)decorationList;

@end
