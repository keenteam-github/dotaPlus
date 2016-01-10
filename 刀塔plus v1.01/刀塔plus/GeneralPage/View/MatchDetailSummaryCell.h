//
//  MatchDetailSummaryCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchDetailSummaryView.h"
#import "MatchDetailSummaryModel.h"
@interface MatchDetailSummaryCell : UITableViewCell

@property(nonatomic,strong)MatchDetailSummaryView *mdsView;

-(void)cellWithMathDetailSummaryModel:(MatchDetailSummaryModel *)model;

@end
