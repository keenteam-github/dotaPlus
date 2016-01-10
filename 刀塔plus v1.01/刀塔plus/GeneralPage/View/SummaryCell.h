//
//  SummaryCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryModel.h"
#import "SummaryView.h"

@interface SummaryCell : UITableViewCell

@property(nonatomic,strong)SummaryView *sView;

//显示cell
-(void)cellWithPaer:(SummaryModel *)model;

@end
