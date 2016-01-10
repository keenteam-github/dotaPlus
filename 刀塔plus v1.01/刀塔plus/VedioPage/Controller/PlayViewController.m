//
//  PlayViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/28.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MyToolBar.h"

@interface PlayViewController ()
{
//    MPMoviePlayerViewController *_payeController;
}
@property (nonatomic,strong)MPMoviePlayerController *moviePlay;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *item;
@property(nonatomic,strong)NSString *totalTime;
@property(nonatomic,assign)BOOL isPlaying;
@property(nonatomic,strong)id timeObserver;
@property(nonatomic,strong)UIProgressView *progress;

@property(nonatomic,strong)UISlider *slider;      //进度slider
@property(nonatomic,strong)UISlider *volumeSlider;//音量slider

@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)id playbackTimeObserver;

@property(nonatomic,strong)UILabel *volumeLabel;//调节音量时显示当前音量
@property(nonatomic,strong)UIButton *shareBtn;//分享

@end


@implementation PlayViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
    self.view.backgroundColor=[UIColor blackColor];

   // NSLog(@"-->%@",self.urlString);
    if (!_moviePlay) {
        NSURL*url=[[NSBundle mainBundle]URLForResource:@"dzs.mp4"  withExtension:nil];
    _item=[[AVPlayerItem alloc]initWithURL:url];
    _player=[[AVPlayer alloc]initWithPlayerItem:_item];
    
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_item];
    
    AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:_player];
    layer.videoGravity=AVLayerVideoGravityResizeAspect;
    layer.frame=CGRectMake(0, 0, kHeight, kWidth);
    layer.backgroundColor=[UIColor clearColor].CGColor;
    
    [self.view.layer addSublayer:layer];
    
    //    标题
    [self createTitleView];
    //    界面
    [self createUI];
    
//    旋转视图
//    self.view.transform=CGAffineTransformMakeRotation(3*M_PI_2);
//    layer.transform=CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    self.view.layer.transform=CATransform3DMakeRotation(3*M_PI_2, 0, 0, 1);
    
//     添加一个手势 隐藏与显示进度条
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shiftStatus)];
    [self.view addGestureRecognizer:tap];
    
//    增加音量的手势
    UISwipeGestureRecognizer *increaseGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(increaseVolume:)];
    increaseGesture.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:increaseGesture];
//    减小音量的手势
    UISwipeGestureRecognizer *decreaseGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(decreaseVolume:)];
    decreaseGesture.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:decreaseGesture];
 }
}

/**
 *  向上滑动增加音量
 *
 *  @param sender 滑动手势
 */
-(void)increaseVolume:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction==UISwipeGestureRecognizerDirectionUp)
    {
        if(_player.volume>=1.0)
            return;
        _player.volume+=0.1;
//        NSLog(@"+++++音量:%f++++++",10*_player.volume);
    
        __weak PlayViewController *weakSelf=self;
        _volumeLabel.text=[NSString stringWithFormat:@"音量:%d",(int)ceilf(_player.volume*10)];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.volumeLabel.alpha=1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.volumeLabel.alpha=0.0;
            }];
        }];
    }
}
/**
 *  向下滑动减小音量
 *
 *  @param sender 滑动手势对象
 */
-(void)decreaseVolume:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction==UISwipeGestureRecognizerDirectionDown)
    {
        if(_player.volume<=0.0)
            return;
        _player.volume-=0.1;
//        NSLog(@"------音量:%f------",10*_player.volume);
    
        __weak PlayViewController *weakSelf=self;
        _volumeLabel.text=[NSString stringWithFormat:@"音量:%d",(int)ceilf(_player.volume*10)];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.volumeLabel.alpha=1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.volumeLabel.alpha=0.0;
            }];
        }];
    }
}
//界面
-(void)createUI
{
    _playBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 20, 60, 40)];
    [_playBtn setTitle:@"Play" forState:UIControlStateNormal];
    [_playBtn setTitle:@"Pause" forState:UIControlStateSelected];
    [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _playBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.backgroundColor=[UIColor clearColor];
    [self.view  addSubview:_playBtn];
    _progress=[[UIProgressView alloc]initWithFrame:CGRectMake(110, 41, kHeight-230, 2)];
    //    设置轨道颜色，将要走到的路径的颜色
    _progress.trackTintColor=[UIColor whiteColor];
    //    设置进度颜色,已经走过的路径
    _progress.progressTintColor=[UIColor blueColor];
    
    _slider=[[UISlider alloc]initWithFrame:CGRectMake(110, 26,kHeight-230, 31)];
    [_slider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    _slider.minimumTrackTintColor=[UIColor blueColor];//设置左边颜色
    _slider.maximumTrackTintColor=[UIColor clearColor];//设置右边颜色
    _slider.continuous=NO;
    [_slider addTarget:self action:@selector(sliderDidSlided:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:_progress];
    [self.view addSubview:_slider];
    
    _timeLabel=[Tools createLabelWithFrame:CGRectMake(kHeight-130, 30, 110, 20) text:nil textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14]];
    _timeLabel.text=@"--:--/--:--";
    [self.view addSubview:_timeLabel];
    
    //    音量label
    _volumeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kHeight-100, kWidth/2-20, 80, 40)];
    _volumeLabel.text=[NSString stringWithFormat:@"音量:%d",(int)ceil(_player.volume)*10];
    _volumeLabel.alpha=0.0;
    _volumeLabel.backgroundColor=[UIColor clearColor];
    _volumeLabel.font=[UIFont boldSystemFontOfSize:22];
    _volumeLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:_volumeLabel];
    
//    分享按钮
    MyToolBar *toolBar=[[MyToolBar alloc]initWithFrame:CGRectMake(0, kWidth-40, kHeight, 40)];
    /**
     *  UIToolBar的背景颜色不能直接修改，需要定义它的一个子类，重新实现drawRect方法（空实现即可）
        然后去实例化一个自定义类的toolBar，就可以修改它的背景颜色了。
     */
    toolBar.backgroundColor=[UIColor clearColor];
    
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    shareItem.tintColor=[UIColor whiteColor];
    toolBar.items=@[spaceItem,shareItem];
    [self.view addSubview:toolBar];
}
/**
 *  分享按钮
 */
-(void)shareAction
{
    NSString *context=[NSString stringWithFormat:@"wo正在使用刀塔Plus，观看%@，历史战绩，精彩解说，刀塔要闻，一览无余！快来试试吧！",self.videoTitle];
    UIImage *image=[UIImage imageNamed:@"share"];
    UIActivityViewController *activity=[[UIActivityViewController alloc]initWithActivityItems:@[context,image] applicationActivities:nil];
    //模拟器下，点击短信分享，会导致崩溃，短信只有真机才行
    //        获取当前ios设备的型号(真机 模拟器)
    NSString *modelName=[[UIDevice currentDevice] model];
    /*如果是模拟器 modelName为：iPhone Simulator*/
    if([modelName isEqualToString:@"iPhone Simulator"])
        activity.excludedActivityTypes=@[UIActivityTypeMessage];
    else
        activity.excludedActivityTypes=nil;
    [self presentViewController:activity animated:YES completion:nil];
    
}
//标题视图
-(void)createTitleView
{
    UILabel *titleLabel=[Tools createLabelWithFrame:CGRectMake(50, 10, kHeight-100, 20) text:self.videoTitle textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:12]];
    [self.view addSubview:titleLabel];
    titleLabel.tag=111;
    
    //    返回按钮
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
//返回
-(void)backAction
{   
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  滑动进度条时执行该方法
 *
 *  @param sender slider对象
 */
-(void)sliderDidSlided:(UISlider *)sender
{
    if(_player.status==AVPlayerStatusReadyToPlay)
    {
        CGFloat value=sender.value;
        [_item seekToTime:CMTimeMake(value, 1)];
    }
}
//隐藏上方的条条
-(void)hideStatusLabels
{
    __weak PlayViewController *weakSelf=self;
    
    if(!_isPlaying)
        return;
    UILabel *label=(UILabel *)[self.view viewWithTag:111];
    [UIView animateWithDuration:0.5 animations:^{
//        自动播放视频
        [weakSelf.player play];
        weakSelf.isPlaying=YES;
        
        label.alpha=0;
        weakSelf.timeLabel.alpha=0;
        weakSelf.slider.alpha=0;
        weakSelf.progress.alpha=0;
        weakSelf.playBtn.alpha=0;
    } completion:^(BOOL finished) {
        
    }];
}
//显示上方的条条
-(void)showStatusLabels
{
    __weak PlayViewController *weakSelf=self;
    
    UILabel *label=(UILabel *)[self.view viewWithTag:111];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        weakSelf.timeLabel.alpha=1;
        weakSelf.slider.alpha=1;
        weakSelf.progress.alpha=1;
        weakSelf.playBtn.alpha=1;
        label.alpha=1;
    } completion:^(BOOL finished) {
    
    }];
}
//手势点击屏幕触发的方法
-(void)shiftStatus
{
    if(_playBtn.alpha==0)
    {
//        显示上方条条
       [self performSelector:@selector(showStatusLabels) withObject:nil];
//        6秒后 自动隐藏上方条条
        [self performSelector:@selector(hideStatusLabels) withObject:nil afterDelay:6];
    }
    else
//        隐藏条条
        [self performSelector:@selector(hideStatusLabels) withObject:nil];
    
}
/**
 *  点击播放按钮时执行的方法
 *
 *  @param sender 播放按钮
 */
-(void)playAction:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if(_isPlaying)
    {
        [_player pause];
        [_playBtn setTitle:@"Play" forState:UIControlStateNormal];
    }
    else
    {
        [_player play];
        [_playBtn setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    _isPlaying=!_isPlaying;
}
/**
 *  收到播放完毕的通知时执行该方法
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification
{
   // NSLog(@"Play end");
    [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished)
     {
        [self updateVideoSlider:0.0];
        [_playBtn setTitle:@"Play" forState:UIControlStateNormal];
    }];
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    AVPlayerItem *playerItem = (AVPlayerItem *)object;

    if ([keyPath isEqualToString:@"status"])
    {
    
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
        {
          
            //NSLog(@"AVPlayerStatusReadyToPlay");
//            开始播放视频
            [_player play];
//            播放状态置为YES
            _isPlaying=YES;
//            将按钮的标题由Play改为Pause
            [_playBtn setTitle:@"Pause" forState:UIControlStateNormal];
//            隐藏上方的条条
            [self hideStatusLabels];
//            隐藏加载指示器
            [GMDCircleLoader hideFromView:self.view animated:YES];
            
            CMTime duration = _item.duration;// 获取视频总长度
    
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
          
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
          
            [self customVideoSlider:duration];
          
           // NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
         
            [self monitoringPlayback:_item];// 监听播放状态
        
        }
        else if ([playerItem status] == AVPlayerStatusFailed)
        {
           
           // NSLog(@"AVPlayerStatusFailed");
            [GMDCircleLoader hideFromView:self.view animated:YES];
        }
    
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
     
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
     
//        NSLog(@"Time Interval:%f",timeInterval);
    
        CMTime duration = _item.duration;
     
        CGFloat totalDuration = CMTimeGetSeconds(duration);
//      设置进度处理器的进度值
        [_progress setProgress:timeInterval / totalDuration animated:YES];
    
    }
}
/**
 *  获取缓冲总进度
 *
 *  @return 缓冲总进度
 */
- (NSTimeInterval)availableDuration
{
  
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
  
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
   
    float startSeconds = CMTimeGetSeconds(timeRange.start);
   
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
  
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度

    return result;
}
/**
 *  将视频播放的当前时间和总时间，格式化显示在界面上
 *
 *  @param second 播放器的当前时间
 *
 *  @return 格式化后的显示时间
 */
- (NSString *)convertTime:(CGFloat)second
{
  
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 
    if (second/3600 >= 1)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
   
    return showtimeNew;
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    __weak PlayViewController  *weakSelf=self;
    
    self.playbackTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time)
    {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        [weakSelf updateVideoSlider:currentSecond];
        NSString *timeString = [weakSelf convertTime:currentSecond];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,weakSelf.totalTime];
    }];
}
- (void)customVideoSlider:(CMTime)duration
{
 
    _slider.maximumValue = CMTimeGetSeconds(duration);
 
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
 
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}
/**
 *  更行滑块的值
 *
 *  @param currentSecond 当前的播放时间
 */
- (void)updateVideoSlider:(CGFloat)currentSecond
{
    [_slider setValue:currentSecond animated:YES];
}
/**
 *  视图即将消失时移除观察者对象，注销通知，如果播放器在播放，让其暂停，让播放器指向nil
 *
 *  @param animated 动画效果
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_item removeObserver:self forKeyPath:@"status" context:nil];
    [_item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_item];
    [_player removeTimeObserver:self.playbackTimeObserver];
    if(_isPlaying)
    {
        [_player pause];
        _player=nil;
    }
}

@end
