//
//  TeamDetailViewController.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/3.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "BaseViewController.h"


@interface TeamDetailViewController : BaseViewController

@property(nonatomic,strong) NSArray *members;
@property(nonatomic,strong) NSString *teamID;
@property(nonatomic,strong) NSString *imageName;
@property(nonatomic,strong) NSString *name;


@end
