
//
//  MyDownloader.m
//  block封装下载类
//
//  Created by 峰哥哥 on 15/6/12.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MyDownloader.h"

@implementation MyDownloader
{
    NSMutableData *_receiveData;
    NSURLConnection *_conn;
}
-(id)init
{
    if(self=[super init])
    {
        _receiveData=[NSMutableData data];
    }
    return self;
}
+(instancetype)downloader
{
    return [[[self class] alloc] init];
}
-(void)downloadWithUrlString:(NSString *)urlString successBlock:(void (^)(NSData *data))successBlock failedBlock:(void (^)(NSError *error))failedBlock
{
//    给block赋值
    if(_success!=successBlock)
    {
        _success=nil;
        _success=successBlock;
    }
    if(_failed!=failedBlock)
    {
        _failed=nil;
        _failed=failedBlock;
    }
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _conn=[NSURLConnection connectionWithRequest:request delegate:self];
}
#pragma mark-NSURLConnection代理方法
//下载失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    __weak MyDownloader *ws=self;
    if(ws.failed)
//        调用代
        ws.failed(error);
}
//接收到响应请求
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receiveData setLength:0];
}
//接收到数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}
//下载成功
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    __weak MyDownloader *ws=self;
    if(ws.success)
//        调用代码
        ws.success(_receiveData);
}
@end
