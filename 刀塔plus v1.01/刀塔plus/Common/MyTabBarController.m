//
//  MyTabBarController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/7.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MyTabBarController.h"
#import "GeneralViewController.h"
#import "DataViewController.h"
#import "NewsViewController.h"
#import "VedioViewController.h"

@implementation MyTabBarController
-(instancetype)init
{
    if(self=[super init])
    {
        [self createViewControllers];
    }
    return self;
}
-(void)createViewControllers
{
    NSArray *controllerNames=@[@"GeneralViewController",@"DataViewController",@"NewsViewController",@"VedioViewController"];
    NSArray *imageNames=@[@"home",@"status",@"news",@"vedio"];
    NSArray *titleNames=@[@"战绩",@"数据",@"新闻",@"视频"];
    
    NSMutableArray *array=[NSMutableArray array];
    
    for(int i=0;i<controllerNames.count;i++)
    {
        Class className=NSClassFromString(controllerNames[i]);
        UIViewController *controller=[[className alloc]init];
        controller.view.backgroundColor=[UIColor whiteColor];
        controller.tabBarItem.image=[UIImage imageNamed:imageNames[i]];
        controller.title=titleNames[i];
        UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:controller];
        [array addObject:navi];
    }
    self.viewControllers=array;
}
@end
