//
//  MyDownloader.h
//  block封装下载类
//
//  Created by 峰哥哥 on 15/6/12.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <Foundation/Foundation.h>
/**用来数据请求的类*/
@interface MyDownloader : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property(nonatomic,strong)void(^failed)(NSError *);
@property(nonatomic,strong)void(^success)(NSData *);

-(void)downloadWithUrlString:(NSString *)urlString successBlock:(void (^)(NSData *data))successBlock failedBlock:(void(^)(NSError *error))failedBlock;
+(instancetype)downloader;

@end
