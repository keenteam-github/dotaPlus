//
//  SettingViewController.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/14.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

//定义一个代码块变量传递参数给主视图，
//若解除了绑定，就让主界面添加_savedBtn
@property(nonatomic,strong) void (^unbunding)(void);

@end
