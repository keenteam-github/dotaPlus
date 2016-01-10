//
//  AboutViewController.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/14.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//
#define COLOR [UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f]
#import "AboutViewController.h"
#import "Tools.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=NO;
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"关于";
    [self createTitleView];
    [self createView];
}
-(void)createView
{
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49)];
    bgView.image=[UIImage imageNamed:@"bg.jpg"];//@"bg3.jpg"
    [self.view addSubview:bgView];
    UIImageView *imv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share"]];
    [self.view addSubview:imv];
    imv.frame=CGRectMake((kWidth-60)/2, 200, 60, 60);
    
    UILabel *label=[Tools createLabelWithFrame:CGRectMake((kWidth-120)/2, 260, 120, 40) text:@"LOL-v1.0" textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label];
    
    UILabel *label_qq=[Tools createLabelWithFrame:CGRectMake((kWidth-120)/2, 310, 120, 40) text:@"QQ:812144991" textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label_qq];

}
-(void)createTitleView
{
    UIColor *color=COLOR;
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *label=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"关于" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
    [self.view addSubview:label];
    //    返回按钮
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
