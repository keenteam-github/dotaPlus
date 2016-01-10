//
//  GeneralViewController.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralViewController : UIViewController

//纪录从搜索添加帐号传来的 account_id
@property(nonatomic,strong)NSString *tmp;

//第一次account_id是从搜索传过来的，之后是从持久化储存读取的，所以之后的tmp应该为空。
@property(nonatomic,strong)NSString *account_id;
//显示返回按钮
@property(nonatomic,assign)BOOL showsBackBtn;

@end
