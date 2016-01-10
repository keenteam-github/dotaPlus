//
//  DataViewController.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "BaseViewController.h"

@interface DataViewController : BaseViewController

@property(nonatomic,copy) void(^updateDataBlock)(NSString *urlString);

@end
