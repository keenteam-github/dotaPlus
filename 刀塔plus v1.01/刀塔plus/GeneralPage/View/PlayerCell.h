//
//  PlayerCell.h
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/16.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"


@interface PlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerIDLabel;

-(void)cellWithPlayer:(Player *)player;

@end
