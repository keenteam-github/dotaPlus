//
//  DecorationDetailViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/4.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "DecorationDetailViewController.h"
#import <Social/Social.h>
#import "MyToolBar.h"

@interface DecorationDetailViewController ()

@property(nonatomic,strong)MyToolBar *toolBar;

@end

@implementation DecorationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self createUI];
    self.view.transform=CGAffineTransformRotate(self.view.transform, 3*M_PI_2);
}
-(void)createUI
{
    UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeight, kWidth)];
    [imv setImageWithURL:[NSURL URLWithString:_icon]];
    [self.view addSubview:imv];
    imv.tag=100;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideToolBar)];
    [imv addGestureRecognizer:tap];
    imv.userInteractionEnabled=YES;
    
//    工具栏
    _toolBar=[[MyToolBar alloc]initWithFrame:CGRectMake(0, 0, kHeight, 64)];
//    返回
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
//    保存
    UIButton *saveBtn=[Tools createBtnWithFrame:CGRectMake(0, 0, 80, 64) title:@"保存至相册" titleColor:[UIColor colorWithRed:48/255.f green:134/255.f blue:242/255.f alpha:1] target:self action:@selector(savePic)];
    saveBtn.backgroundColor=[UIColor clearColor];
    saveBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    UIBarButtonItem *saveItem=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
//    名字
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 64)];
    nameLabel.text=_name;
    nameLabel.textAlignment=NSTextAlignmentRight;
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.textColor=[UIColor orangeColor];
    UIBarButtonItem *nameItem=[[UIBarButtonItem alloc]initWithCustomView:nameLabel];
    
//    空白
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    分享
    UIButton *shareBtn=[Tools createBtnWithFrame:CGRectMake(10, 10, 40, 40) title:@"分享" titleColor:[UIColor colorWithRed:48/255.f green:134/255.f blue:242/255.f alpha:1] target:self action:@selector(shareAction)];
    shareBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    shareBtn.backgroundColor=[UIColor clearColor];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
//    将这些按钮添加至工具栏上
    _toolBar.items=@[backItem,spaceItem,nameItem,spaceItem,shareItem,spaceItem,saveItem];
    [self.view addSubview:_toolBar];
    _toolBar.backgroundColor=[UIColor clearColor];
}
//隐藏/显示ToolBar
-(void)hideToolBar
{
    __weak DecorationDetailViewController *weakSelf=self;
    
    [UIView animateWithDuration:1 animations:^{
        
        weakSelf.toolBar.alpha=1-weakSelf.toolBar.alpha;
        
    } completion:^(BOOL finished) {
        
    }];
}
//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//保存至相册
-(void)savePic
{
    UIImageView *imv=(UIImageView *)[self.view viewWithTag:100];
    UIImage *image=imv.image;
//    保存到相册
    if(image)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"保存成功!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlertViewLatter:) withObject:alert afterDelay:1];
    }
}
//消除警告视图
-(void)dismissAlertViewLatter:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
//分享
-(void)shareAction
{
    UIImageView *imv=(UIImageView *)[self.view viewWithTag:100];
    UIImage *image=imv.image;
    NSString *message=@"我正在使用\"LOLplus\"软件,历史战绩，精彩解说，一览无余！快来看看吧！";
    if(image)
    {
//        分享的内容
        NSArray *contentArray=@[message,image];
//        分享到那些网站
//        NSArray *socialArray=@[UIActivityTypeMail,UIActivityTypeMessage, UIActivityTypePostToWeibo];
        
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

//    判断新浪微博是否可用
//    BOOL available=[SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo];
//    if(available)
//    {
//        SLComposeViewController *compose=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//        SLComposeViewControllerCompletionHandler completHandler=^(SLComposeViewControllerResult reslut){
//            if(reslut==SLComposeViewControllerResultCancelled)
//                NSLog(@"取消");
//            else
//                NSLog(@"完成");
//            [compose dismissViewControllerAnimated:YES completion:nil];
//        };
//        compose.completionHandler=completHandler;
//        
//        [compose setInitialText:message];
//        [compose addImage:image];
//        [compose addURL:[NSURL URLWithString:@"www.hao123.com"]];
//        [self presentViewController:compose animated:YES completion:nil];
//    }
//    else
//        NSLog(@"微博不可用");
}
@end
