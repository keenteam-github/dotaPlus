//
//  HighestRecordCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/18.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighestModel.h"

@interface HighestRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNaemLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;

-(void)cellWithHighestModel:(HighestModel *)model;

@end
