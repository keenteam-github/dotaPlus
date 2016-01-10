//
//  HistoryCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/13.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroWinRateModel.h"

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *victoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *winRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *kdaLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *winRateProgress;

-(void)cellWithModel:(HeroWinRateModel *)model;
@end
