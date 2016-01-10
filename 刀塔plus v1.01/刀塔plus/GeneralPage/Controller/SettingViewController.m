//
//  SettingViewController.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/14.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//
#define Color   [UIColor colorWithRed:151.0/255.0f green:199.0/255.0f blue:250.0/255.0f alpha:1.0]
#import "SettingViewController.h"
#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>
#import "FGGImageCacheCleaner.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    UITableView *_tbv;
    NSMutableArray *_dataArray;
//    保存清除缓存的cell
//    UITableViewCell *_clearCell;
    UIAlertView *_mAlert;
}
@end
/*
 解除绑定,清除缓存，  评分，反馈意见，分享,   关于（版本）
 */
@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=NO;
    
    self.view.backgroundColor=[UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"设置";
//    [self createBgView];
    [self createTitleView];
    [self createData];
    [self createTableView];
}
//背景图片
-(void)createBgView
{
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49)];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    [self.view addSubview:bgView];
}
// 标题
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *label=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"设置" textColor:Color textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:label];
    //    返回按钮
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

// 返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//数据
-(void)createData
{
    NSArray *settingItems1=@[@"解除绑定",@"清除缓存"];
    NSArray *settingItems2=@[@"意见反馈",@"分享"];
    NSArray *settingItems3=@[@"关于"];
    _dataArray=[NSMutableArray arrayWithObjects:settingItems1,settingItems2,settingItems3, nil];
}
//表视图
-(void)createTableView
{
    _tbv=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbv.delegate=self;
    _tbv.dataSource=self;
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:_tbv.bounds];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    _tbv.backgroundView=bgView;
    _tbv.separatorColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [self.view addSubview:_tbv];
}
#pragma mark-UITableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedCellID=@"settingCellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedCellID];
    if(!cell)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedCellID];
    cell.textLabel.text=_dataArray[indexPath.section][indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image=[UIImage imageNamed:cell.textLabel.text];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
//    清楚缓存的cell
    if(indexPath.section==0&&indexPath.row==1)
    {
//        计算缓存大小
        cell.detailTextLabel.text=[[FGGImageCacheCleaner currentCleaner] caculateCacheSize];
    }
    return cell;
}
//选中cell时
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[_tbv cellForRowAtIndexPath:indexPath];
    NSString *title=cell.textLabel.text;
    if([title isEqualToString:@"解除绑定"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"确认解除绑定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=1;
        [alert show];
    }
    else if([title isEqualToString:@"清除缓存"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"确认清楚缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=2;
        [alert show];
    }
//    else if([title isEqualToString:@"评分"])
//    {
//        NSLog(@"跳转Appstore评分");
//    }
    else if([title isEqualToString:@"意见反馈"])
    {
//        跳转发送邮件给我的页面
        MFMailComposeViewController *mailView=[[MFMailComposeViewController alloc]init];
//        设置代理
        mailView.mailComposeDelegate=self;
//        邮件主题
        [mailView setSubject:@"关于LOL的意见反馈"];
//        收件人地址
        [mailView setToRecipients:@[kMailAddress]];
        [self presentViewController:mailView animated:YES completion:nil];
        
    }
    else if([title isEqualToString:@"分享"])
    {
////        获取当前ios设备的型号(真机 模拟器)
    //    NSString *modelName=[[UIDevice currentDevice] model];
////        NSLog(@"%@",modelName);
//        /*如果是模拟器 modelName为：iPhone Simulator*/
//        if([modelName isEqualToString:@"iPhone Simulator"])
//        {
//            _mAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"模拟器没有发送短信功能,请真机测试"delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            //            弹出提示
//            [_mAlert show];
//            //            2秒后消失
//            [self performSelector:@selector(dismissMAlert) withObject:nil afterDelay:2];
//        }
//        else
//        {
//        /*真机才行，模拟器会崩溃*/
//    //        跳转软件分享界面
//            MFMessageComposeViewController *messageView=[[MFMessageComposeViewController alloc]init];
//            messageView.messageComposeDelegate=self;
//    //        短信内容
//            [messageView setBody:@"我正在使用\"LOL\"软件,S5 战绩，精彩解说，一览无余！快来看看吧！"];
//            [self presentViewController:messageView animated:YES completion:nil];
//        }
        NSString *context=@"我正在使用\"LOL \"软件,S5 战绩，精彩解说，一览无余！快来看看吧!";
        
        //        分享的内容
        NSArray *contentArray=@[context,[UIImage imageNamed:@"share"]];
        UIActivityViewController *activty=[[UIActivityViewController alloc]initWithActivityItems:contentArray applicationActivities:nil];
        
        //模拟器下，点击短信分享，会导致崩溃，短信只有真机才行
        //        获取当前ios设备的型号(真机 模拟器)
        NSString *modelName=[[UIDevice currentDevice] model];
        /*如果是模拟器 modelName为：iPhone Simulator*/
        if([modelName isEqualToString:@"iPhone Simulator"])
            activty.excludedActivityTypes=@[UIActivityTypeMessage];
        else
            activty.excludedActivityTypes=nil;
        
        [self presentViewController:activty animated:YES completion:nil];
    }
    else//关于
    {
        AboutViewController *about=[AboutViewController new];
//        设置动画
        [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypePageCurl toward:PSBTransitionAnimationTowardFromBottom duration:0.3];
        [self.navigationController pushViewController:about animated:YES];
    }
}
-(void)dismissMAlert
{
      [_mAlert dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark-UIAlertViewDelegate协议方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        if(alertView.tag==1)
        {
    //        移除账号的绑定
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account_id"];
    //        调用代码块
            if(self.unbunding)
                _unbunding();
        }
        if(alertView.tag==2)
        {
//        清除缓存
            [GMDCircleLoader setOnView:self.view withTitle:@"正在清除缓存..." animated:YES];
            [[FGGImageCacheCleaner currentCleaner] clearImageCache];
//            刷新表格
            [_tbv reloadData];
            [GMDCircleLoader hideFromView:self.view animated:YES];
        }
    }
}
#pragma mark-MFMailComposeViewControllerDelegate协议方法
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-MFMessageComposeViewControllerDelegate协议方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end