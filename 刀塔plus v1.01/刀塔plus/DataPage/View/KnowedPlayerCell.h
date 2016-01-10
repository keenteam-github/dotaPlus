//
//  KnowedPlayerCell.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/2.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KonwedPlayer.h"

@interface KnowedPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankScore;
@property (weak, nonatomic) IBOutlet UILabel *teamScore;
@property (weak, nonatomic) IBOutlet UILabel *noTeamLabel;


-(void)cellWithKonwedPlayerModel:(KonwedPlayer *)model;

@end
