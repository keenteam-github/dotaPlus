//
//  DataService.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/2.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//
/**异步请求数据，请求完后返回主线程*/
#import <Foundation/Foundation.h>

@interface DataService : NSObject

+(void)getDataWithUrlString:(NSString *)urlString andCallBackBlock:(void (^)(NSData *receivedData))callBackBlock;

@end
