//
//  DataViewController.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "DataViewController.h"
#import "ItemsViewController.h"
#import "DecorationViewController.h"
#import "PlayerViewController.h"
#import "LadderViewController.h"
#import "DotaHeroViewController.h"
#import "TeamViewController.h"

@interface DataViewController ()


@end

@implementation DataViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createTitleViewWithText:@"数据plus"];
    [self createUI];
}

-(void)createUI
{
    NSArray *titleArray=@[@"物品",@"饰品",@"玩家",@"S5",@"英雄",@"战队"];
//    NSArray *nameArray=@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    NSArray *imgArray=@[@"d11.jpg",@"d2.jpg",@"d33.jpg",@"d44.jpg",@"d5.jpg",@"d6.jpg"];
    for(int i=0;i<6;i++)
    {
        int col=i%2;
        int row=i/2;
        CGFloat margin=20;
        CGFloat iWidth=(kWidth-3*margin)/2;
        CGFloat iHeirht=(kHeight-64-49-4*margin)/3;
        CGFloat xpos=margin+col*(iWidth+margin);
        CGFloat ypos=margin+row*(iHeirht+margin)+64;
        UIView *iView=[[UIView alloc]initWithFrame:CGRectMake(xpos, ypos, iWidth, iHeirht)];
        
        iView.backgroundColor=[UIColor clearColor];
        UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iWidth, iHeirht)];
        imv.image=[UIImage imageNamed:imgArray[i]
                   ];
        imv.contentMode=UIViewContentModeScaleAspectFill;
        imv.tag=i+1;
        imv.layer.cornerRadius=10;
        imv.clipsToBounds=YES;
//        imv.backgroundColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
        imv.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
        [imv addGestureRecognizer:tap];
//        imv.contentMode=UIViewContentModeScaleAspectFit;
        [iView addSubview:imv];
        
        UILabel *titleLabel=[Tools createLabelWithFrame:CGRectMake(iWidth-60, iHeirht-25, 40, 20) text:titleArray[i] textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:20]];
        [iView addSubview:titleLabel];
        
        [self.view addSubview:iView];
    }
}
//点击图片的方法
-(void)tapImageAction:(UITapGestureRecognizer *)sender
{
    NSArray *controllerArray=@[@"ItemsViewController",@"DecorationViewController",@"PlayerViewController",@"LadderViewController",@"DotaHeroViewController",@"TeamViewController"];
    NSInteger index=sender.view.tag-1;
    Class clsName=NSClassFromString(controllerArray[index]);
    UIViewController *controller=[[clsName alloc]init];
    
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypePageCurl toward:PSBTransitionAnimationTowardFromBottom duration:0.2];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
