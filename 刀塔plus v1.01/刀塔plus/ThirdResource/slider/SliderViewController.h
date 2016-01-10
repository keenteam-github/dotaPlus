//
//  SliderViewController.h
//  TestSlider
//
//  Created by gaokunpeng on 15/4/11.
//  Copyright (c) 2015年 gaokunpeng. All rights reserved.
//

/*
 这是别人写的第三方库
 */

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController

@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,strong)NSMutableDictionary *controllersDict;
//左边滑动出来的范围默认值275
@property(nonatomic,assign)float LeftSContentOffset;
//左边内容页的偏移（没有什么作用）
@property(nonatomic,assign)float LeftContentViewSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;
//当左边滑动出来的时候右边缩小多少，0.77为默认值
@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;
//默认值为160（无实际意义）
@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;

@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;

@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;

@property(nonatomic,assign)BOOL canShowLeft;
@property(nonatomic,assign)BOOL canShowRight;

@property (nonatomic, copy) void(^changeLeftView)(CGFloat sca, CGFloat transX);
//单例
+ (SliderViewController*)sharedSliderController;
//释放单例
-(void)releaseClick;
- (void)showContentControllerWithModel:(NSString*)className;
//展现左边
- (void)showLeftViewController;
//展现右边
- (void)showRightViewController;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;
//关闭左边
- (void)closeSideBar;
//关闭左边，在动画结束的时候push一个页面，使用单例，然后调用navigationController，push一个界面出来
- (void)closeSideBarWithAnimate:(BOOL)bAnimate complete:(void(^)(BOOL finished))complete;

@end
