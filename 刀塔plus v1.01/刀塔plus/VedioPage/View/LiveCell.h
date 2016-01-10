//
//  LiveCell.h
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/28.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveModel.h"

@interface LiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeHolder;
@property (weak, nonatomic) IBOutlet UIImageView *obImageView;
@property (weak, nonatomic) IBOutlet UILabel *obNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewerCountLabel;

-(void)cellWithLiveModel:(LiveModel *)model;

@end
