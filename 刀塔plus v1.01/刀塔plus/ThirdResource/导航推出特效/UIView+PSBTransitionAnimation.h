//
//  UIView+PSBTransitionAnimation.h
//  day16-ViewCotroller1-Period
//
//  Created by 潘松彪 on 14-8-28.
//  Copyright (c) 2014年 PSB. All rights reserved.
//


/**
    使用该类别需要添加QuartzCore.framework
*/

#import <UIKit/UIKit.h>

/**动画效果*/
typedef enum
{
    PSBTransitionAnimationTypeCameraIris,
    //相机
    PSBTransitionAnimationTypeCube,
    //立方体
    PSBTransitionAnimationTypeFade,
    //淡入
    PSBTransitionAnimationTypeMoveIn,
    //移入
    PSBTransitionAnimationTypeOglFilp,
    //翻转
    PSBTransitionAnimationTypePageCurl,
    //翻去一页
    PSBTransitionAnimationTypePageUnCurl,
    //添上一页
    PSBTransitionAnimationTypePush,
    //平移
    PSBTransitionAnimationTypeReveal,
    //移走
    PSBTransitionAnimationTypeRippleEffect,
    PSBTransitionAnimationTypeSuckEffect
}PSBTransitionAnimationType;

/**动画方向*/
typedef enum
{
    PSBTransitionAnimationTowardFromLeft,
    PSBTransitionAnimationTowardFromRight,
    PSBTransitionAnimationTowardFromTop,
    PSBTransitionAnimationTowardFromBottom
}PSBTransitionAnimationToward;

@interface UIView (PSBTransitionAnimation)


//为当前视图添加切换的动画效果
//参数是动画类型和方向
//如果要切换两个视图，应将动画添加到父视图
- (void)setTransitionAnimationType:(PSBTransitionAnimationType)transtionAnimationType toward:(PSBTransitionAnimationToward)transitionAnimationToward duration:(NSTimeInterval)duration;

@end








