//
//  NewsDetailViewController.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createTitleView];
    [self createWebView];
}
-(void)createTitleView
{
     UIColor *color=[UIColor colorWithRed:48/255.f green:134/255.f blue:242/255.f alpha:1];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"新闻详细" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
    [self.view addSubview:lb];
//    返回按钮
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createWebView
{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _webView.scalesPageToFit=YES;
    [self.view addSubview:_webView];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    __weak NewsDetailViewController *weakSelf=self;
    [[MyDownloader downloader] downloadWithUrlString:_urlString successBlock:^(NSData *data) {
//        加载网页内容
        [weakSelf.webView loadData:data MIMEType:nil textEncodingName:@"utf-8" baseURL:nil];
         [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    } failedBlock:^(NSError *error) {
         [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
@end
