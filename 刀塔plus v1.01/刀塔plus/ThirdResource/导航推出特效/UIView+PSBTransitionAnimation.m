//
//  UIView+PSBTransitionAnimation.m
//  day16-ViewCotroller1-Period
//
//  Created by 潘松彪 on 14-8-28.
//  Copyright (c) 2014年 PSB. All rights reserved.
//

#import "UIView+PSBTransitionAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (PSBTransitionAnimation)

- (void)setTransitionAnimationType:(PSBTransitionAnimationType)transtionAnimationType toward:(PSBTransitionAnimationToward)transitionAnimationToward duration:(NSTimeInterval)duration
{
    CATransition * transition = [CATransition animation];
    transition.duration = duration;
    NSArray * animations = @[@"cameraIris",
                             @"cube",
                             @"fade",
                             @"moveIn",
                             @"oglFlip",
                             @"pageCurl",
                             @"pageUnCurl",
                             @"push",
                             @"reveal",
                             @"rippleEffect",
                             @"suckEffect"];
    NSArray * subTypes = @[@"fromLeft", @"fromRight", @"fromTop", @"fromBottom"];
    transition.type = animations[transtionAnimationType];
    transition.subtype = subTypes[transitionAnimationToward];
    
    [self.layer addAnimation:transition forKey:nil];
}

@end






