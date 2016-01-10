
//
//  FirstLaunchViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/7.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "FirstLaunchViewController.h"
#import "MyTabBarController.h"

@implementation FirstLaunchViewController

{
    UIScrollView *_scrollView;
    NSArray *_imgs;
    UIPageControl *_control;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_scrollView];

    NSArray *imgs4s=@[@"6-1.jpg",@"6-2.jpg",@"6-3.jpg"];
    NSArray *imgs5s=@[@"6-1.jpg",@"6-2.jpg",@"6-3.jpg"];
    NSArray *imgs6=@[@"6-1.jpg",@"6-2.jpg",@"6-3.jpg"];
    NSArray *imgs6p=@[@"6-1.jpg",@"6-2.jpg",@"6-3.jpg"];
    if(kHeight==480.0)
        _imgs=imgs4s;
    else if(kHeight==568.0)
        _imgs=imgs5s;
    else if(kHeight==667.0)
        _imgs=imgs6;
    else
        _imgs=imgs6p;
    
    UIButton *jumpBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-100, kHeight-100, 60, 60)];
    [jumpBtn setTitle:@"进入" forState:UIControlStateNormal];
    jumpBtn.backgroundColor=[UIColor whiteColor];
    jumpBtn.layer.cornerRadius=30;
    [self.view addSubview:jumpBtn];
    [jumpBtn addTarget:self action:@selector(jumpToMainController) forControlEvents:UIControlEventTouchUpInside];
    [jumpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jumpBtn.titleLabel.font=[UIFont boldSystemFontOfSize:24];
    jumpBtn.layer.borderColor=[UIColor orangeColor].CGColor;
    jumpBtn.layer.borderWidth=2;
    
    for(int i=0;i<_imgs.count;i++)
    {
        UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        imv.image=[UIImage imageNamed:_imgs[i]];
        [_scrollView addSubview:imv];
        if(i==_imgs.count-1)
        {
            [imv addSubview:jumpBtn];
            imv.userInteractionEnabled=YES;
        }
    }
    _scrollView.contentSize=CGSizeMake(_imgs.count*kWidth, kHeight);
    _scrollView.delegate=self;
    
    _control=[[UIPageControl alloc]initWithFrame:CGRectMake(kWidth/2-50, kHeight-50, 100, 20)];
    _control.numberOfPages=3;
    _control.pageIndicatorTintColor=[UIColor yellowColor];
    _control.currentPageIndicatorTintColor=[UIColor purpleColor];
    
    [self.view addSubview:_control];
}
-(void)jumpToMainController
{
    MyTabBarController *tabbar=[[MyTabBarController alloc]init];
    tabbar.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:tabbar animated:YES completion:nil];
}
#pragma mark-UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset=_scrollView.contentOffset;
    NSInteger index=offset.x/kWidth;
    _control.currentPage=index;
    
    if(offset.x>2*kWidth)
    {
        MyTabBarController *tabbar=[[MyTabBarController alloc]init];
        tabbar.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:tabbar animated:YES completion:nil];
    }
}
@end
