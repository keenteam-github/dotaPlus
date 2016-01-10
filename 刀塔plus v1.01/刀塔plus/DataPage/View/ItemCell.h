//
//  ItemCell.h
//  刀塔plus
//
//  Created by 峰哥哥 on 15/7/1.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

typedef NS_ENUM(NSInteger, DataCellType) {
    DataCellTypeItem,
    DataCellTypeHero,
};

@interface ItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *winRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

-(void)cellWithItemModel:(ItemModel *)model cellType:(DataCellType)cellType;

@end
