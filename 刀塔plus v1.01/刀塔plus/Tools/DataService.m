//
//  DataService.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/2.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "DataService.h"

@implementation DataService

+(void)getDataWithUrlString:(NSString *)urlString andCallBackBlock:(void (^)(NSData *receivedData))callBackBlock
{
    dispatch_queue_t conCurrentQueue=dispatch_queue_create("globalQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(conCurrentQueue, ^{
        NSURL *url=[NSURL URLWithString:urlString];
        NSData *data=[NSData dataWithContentsOfURL:url];
        
//        下载完后 异步返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            callBackBlock(data);
        });
    });
}

@end
