//
//  ChooseViewController.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/4.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseViewController : BaseViewController

@property(nonatomic,copy) void(^chooseDidFinishBlock)(NSString *rarity,NSString *qulity,NSString *rarityValue,NSString *qulityValue);

@end
