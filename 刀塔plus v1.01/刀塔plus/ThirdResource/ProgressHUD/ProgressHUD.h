//
//  ProgressHUD.h
//  Kitchen
//
//  Created by qianfeng on 14-10-22.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView

+ (void)showOnView:(UIView *)view;

+ (void)hideAfterSuccessOnView:(UIView *)view;

+ (void)hideAfterFailOnView:(UIView *)view;

+ (void)hideOnView:(UIView *)view;

@end
