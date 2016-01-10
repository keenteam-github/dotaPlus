//
//  MatchDetailCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/23.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchDetailModel.h"

@interface MatchDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *heroIcon;
@property (weak, nonatomic) IBOutlet UIImageView *playerIcon;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *kdaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastHitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *item1;
@property (weak, nonatomic) IBOutlet UIImageView *item2;
@property (weak, nonatomic) IBOutlet UIImageView *item3;
@property (weak, nonatomic) IBOutlet UIImageView *item4;
@property (weak, nonatomic) IBOutlet UIImageView *item5;
@property (weak, nonatomic) IBOutlet UIImageView *item6;
@property (weak, nonatomic) IBOutlet UILabel *warRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *damageLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *gxpLabel;
@property (weak, nonatomic) IBOutlet UILabel *mvpLabel;
@property (weak, nonatomic) IBOutlet UILabel *lvl;

@property(nonatomic,strong)MatchDetailModel *detailModel;
//点击玩家图片时调用的代码块
@property(nonatomic,copy) void(^clickPlayerIcon)(NSString *accoutID);

-(void)cellWithDetailModel:(MatchDetailModel *)model;

@end
