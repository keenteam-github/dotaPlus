//
//  RecentMatchCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentMatch.h"

@interface RecentMatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
//@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameModalLabel;
@property (weak, nonatomic) IBOutlet UILabel *kdaLabel;

-(void)cellWithRecentMatch:(RecentMatch *)match;

@end
