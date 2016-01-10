//
//  GeneralViewController.m
//  刀塔plus
//
//  http://lolmax.com/hero/gold/
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "GeneralViewController.h"
#import "HistoryCell.h"
#import "SummaryView.h"
#import "SummaryCell.h"
#import "SummaryModel.h"
#import "SettingViewController.h"
#import "MostPlayedViewController.h"
#import "RecentViewController.h"
#import "SearchViewController.h"
#import "RecentMatchCell.h"
#import "RecentMatchSectionHeaderView.h"
#import "HighestRecordCell.h"
#import "TFHpple.h"
#import "HighestModel.h"
#import "HighestHeaderView.h"
#import "MatchDetailViewController.h"
#import "GeneralParser.h"
#import "HeroViewController.h"

@interface GeneralViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate>
{
    UIImageView *_playerImageView;          //    玩家图像
    UIView *_summaryView;                   //    概要视图
    UIButton *_backBtn;                     //    返回按钮

    NSString *_ladder;
    UIAlertView *_alert;                    //    警告视图
    UILabel *_tipLabel;                     //    提示绑定账号label
}
@property(nonatomic,strong)UIButton *saveBtn;//   绑定账号的按钮
@property(nonatomic,strong)UITableView *generalTableView;
@property(nonatomic,strong)UITableView *highestTableView;
@property(nonatomic,strong)NSMutableArray *generalDataArray;
@property(nonatomic,strong)NSMutableArray *highestRecordArray;
@property(nonatomic,strong)GeneralParser *htmlParser;//    HTML解析对象

@property(nonatomic,strong)UIButton *lastClassBtn;  //    上一次点击的分类按钮
@property(nonatomic,strong)UILabel *flag;           //    标记
@property(nonatomic,strong)UIScrollView *scrollView;//滚动视图

@property(nonatomic,strong)UILabel *loadingLabel;

@property(nonatomic,strong)SummaryModel *smodel;

@property(nonatomic,strong)NSArray *matchArrary;
@property(nonatomic,strong)NSArray *heroStatisticalArray;
@property(nonatomic,strong)NSArray *highArray;


@end

@implementation GeneralViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createBackgroundImageView];
    self.title=@"返回";
    [self initVaribles];    //    初始化数据元状态
    if(!self.account_id)    //    若accout_id为空，则从持久化存储获取
        self.account_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"];
    
//    如果为空的话，就用默认
    if(self.account_id.length==0)
        self.account_id=kDeflautAccountID;
    
    [self createSummaryView];//    添加概要视图
    [self createTableView];  //    创建表视图
    
    [self downloadData];//  下载数据
 
}
//    标题
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 40) text:@"LOL" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:28]];
    [_summaryView addSubview:lb];
}

//背景图片
-(void)createBackgroundImageView
{
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 160, kWidth, kHeight-160-49)];
    bgImageView.image=[UIImage imageNamed:@"bg3.jpg"];
    [self.view addSubview:bgImageView];
}
/**
 *  如果网页内容为空则弹出错误提示，并返回
 */
-(void)checkError
{
    if(!_htmlParser.contents)
    {
        _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"账号错误或网络状态错误，请输入有效账号或检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alert show];
    }
}

////让警告视图延时2秒消失
//-(void)dismissAlertViewWithTwoSecondsDelay:(UIAlertView *)alertView
//{
//    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:2];
//}
////让警告视图消失
//-(void)dismissAlertView:(UIAlertView *)alertView
//{
//    [alertView dismissWithClickedButtonIndex:0 animated:YES];
//}
/**
 *  初始化成员变量
 */
-(void)initVaribles
{
    _generalDataArray=[NSMutableArray array];
    _highestRecordArray=[NSMutableArray array];
    _tmp=_account_id;//    存储_account_id
    _ladder=@"all";

}
/**
 *  下载数据
 */
-(void)downloadData
{
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];//指示器
    
    NSString *urlString_summary=[NSString stringWithFormat:kGeneralUrl,_account_id];
    NSURL *url_summsry=[NSURL URLWithString:urlString_summary];
    
    NSString *urlString_recent=[NSString stringWithFormat:kMatchUrl,_account_id,_ladder];
    NSURL *url_recent=[NSURL URLWithString:urlString_recent];
    
    NSString *urlString_hero=[NSString stringWithFormat:kHeroUrl,_account_id,_ladder];
    NSURL *url_hero=[NSURL URLWithString:urlString_hero];

    __weak GeneralViewController *weakSelf=self;
    
    dispatch_queue_t myQueue=dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myQueue, ^{
        
        NSData *data=[NSData dataWithContentsOfURL:url_summsry];
        weakSelf.htmlParser=[[GeneralParser alloc]initWithData:data];//    初始化解析对象
        [weakSelf checkError];//  如果网页内容为空则弹出错误提示
            
    });
    /**
     *  先用最近比赛的网页内容初始化解析器对象，才能继续下面的线程下载
     */
    dispatch_barrier_async(myQueue, ^{
        NSLog(@"Barrier-------------------------------------------------------------");
    });
    dispatch_async(myQueue, ^{
//        组
        dispatch_group_t myGroup=dispatch_group_create();
//        异步队列
        dispatch_queue_t concurrent=dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
        //    解析摘要数据
        dispatch_group_async(myGroup, concurrent, ^{
            weakSelf.smodel=nil;
            if(weakSelf.htmlParser.contents.length>0)
                weakSelf.smodel=[weakSelf.htmlParser parseBasicMessage];
        });
        //    解析最近比赛数据
        dispatch_group_async(myGroup, concurrent, ^{
            NSData *data=[NSData dataWithContentsOfURL:url_recent];
            if(data.length>0)
            {
                GeneralParser *parser=[[GeneralParser alloc]initWithData:data];
                if(parser.contents.length>0)
                {
                    weakSelf.matchArrary=[parser matchStatistical];
                }
            }
        });
        //    解析常用英雄数据
        dispatch_group_async(myGroup, concurrent, ^{
            NSData *data_hero=[NSData dataWithContentsOfURL:url_hero];
            if(data_hero.length>0)
            {
                GeneralParser *parser_hero=[[GeneralParser alloc] initWithData:data_hero];
                
                if(parser_hero.contents.length>0)
                {
                    weakSelf.heroStatisticalArray=[parser_hero heroStatistical];
                }
            }
        });
        //    解析最高纪录数据
        dispatch_group_async(myGroup, concurrent, ^{
            if(weakSelf.htmlParser.contents.length>0)
            {
                weakSelf.highArray=[weakSelf.htmlParser parseHighestRecords];
            }
        });
        /**
         *  解析完所有数据后按照顺序添加到数据源数组
         */
        dispatch_group_notify(myGroup, concurrent, ^{
            //        移除之前的所有数据
            [weakSelf.generalDataArray removeAllObjects];
            //        添加新的数据
            if(weakSelf.smodel)
                [weakSelf.generalDataArray addObject:@[weakSelf.smodel]];
            if(weakSelf.matchArrary.count>0)
                [weakSelf.generalDataArray addObject:weakSelf.matchArrary];
            if(weakSelf.generalDataArray.count>0)
                [weakSelf.generalDataArray addObject:weakSelf.heroStatisticalArray];
            //        移除之前的所有数据
            [weakSelf.highestRecordArray removeAllObjects];
            //        添加新的数据
            if(weakSelf.highArray.count>0)
                weakSelf.highestRecordArray=[NSMutableArray arrayWithArray:weakSelf.highArray];
            
            //        如果没有数据，弹出警告
            if(weakSelf.generalDataArray.count==0)
            {
                [self showLoadingLabel];
                [self dismissLoadingLabelAfterFailed];
            }
            /**
             *  回到主线程刷新UI
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf refreshSummaryView];
                [weakSelf.generalTableView reloadData];
                [weakSelf.highestTableView reloadData];
                //        移除指示器
                [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
            });
        });
    });
}

#pragma mark-概要视图
//    添加概要视图
-(void)createSummaryView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    //    概要视图
    _summaryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
    _summaryView.backgroundColor=color;
    [self.view addSubview:_summaryView];
//    标题视图
    [self createTitleView];
//    头像
    _playerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-30, 30, 60, 60)];
    _playerImageView.image=[UIImage imageNamed:@"defalutPlayerIcon.jpg"];
    _playerImageView.layer.cornerRadius=30;
    _playerImageView.clipsToBounds=YES;
    //    添加一个手势，点击进入设置界面
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSettings)];
    [_playerImageView addGestureRecognizer:tap];
    _playerImageView.userInteractionEnabled=YES;
    [_summaryView addSubview:_playerImageView];
    for(int i=0;i<2;i++)
    {
        UILabel *label=[Tools createLabelWithFrame:CGRectMake(kWidth/2-60, 90+20*i, 120, 20) text:nil textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter andBgColor:color font:[UIFont systemFontOfSize:12]];
        label.tag=200+i;
        [_summaryView addSubview:label];
    }
    //    绑定按钮
    _saveBtn=[Tools createBtnWithFrame:CGRectMake(kWidth-50, 60, 40, 20) title:@"绑定" titleColor:[UIColor whiteColor] target:self action:@selector(saveAccountID)];
    _saveBtn.backgroundColor=color;
    _saveBtn.layer.borderWidth=0;
    _saveBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20];
        [_summaryView addSubview:_saveBtn];
    _saveBtn.hidden=YES;
    //    设置按钮
    UIButton *settingBtn=[Tools createBtnWithFrame:CGRectMake(10, 80, 60, 60) title:nil titleColor:nil target:self action:@selector(gotoSettings)];
    [settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    settingBtn.backgroundColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [_summaryView addSubview:settingBtn];
    //    进入搜索
    UIButton *searchBtn=[Tools createBtnWithFrame:CGRectMake(kWidth-60, 80, 60, 60) title:nil titleColor:nil target:self action:@selector(showSearchPage)];
    searchBtn.layer.borderWidth=0;
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchBtn.backgroundColor=color;
    [_summaryView addSubview:searchBtn];
    //    添加2个按钮，综合数据，最高纪录
    NSArray *classBtnTitles=@[@"综合数据",@"最高纪录"];
    CGFloat classBtnWith=((kWidth-60*3)/2);
    for(int i=0;i<2;i++)
    {
        CGFloat xpos=60+i*(60+classBtnWith);
        UIButton *classBtn=[Tools createBtnWithFrame:CGRectMake(xpos, 130, classBtnWith, 20) title:classBtnTitles[i] titleColor:[UIColor lightGrayColor] target:self action:@selector(changeClass:)];
        classBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        if(i==0)
        {
            [classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _lastClassBtn=classBtn;
        }
        classBtn.backgroundColor=color;
        classBtn.layer.borderWidth=0;
        classBtn.tag=i+100;
        [_summaryView addSubview:classBtn];
    }
    //    标记
    _flag=[[UILabel alloc]initWithFrame:CGRectMake(60, 154, classBtnWith, 2)];
    _flag.backgroundColor=[UIColor whiteColor];
    [_summaryView addSubview:_flag];
//    返回按钮
    _backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    _backBtn.backgroundColor=color;
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_summaryView addSubview:_backBtn];
    _backBtn.hidden=!self.showsBackBtn;
}
//  点击 综合数据，最高纪录 按钮
-(void)changeClass:(UIButton *)sender
{
    __weak GeneralViewController *weakSelf=self;
    //    xpos=80+i*(80+classBtnWith);
    CGFloat xpos=sender.frame.origin.x;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame=weakSelf.flag.frame;
        frame.origin.x=xpos;
        weakSelf.flag.frame=frame;
        weakSelf.scrollView.contentOffset=CGPointMake(kWidth*(sender.tag-100), 0);
    }completion:^(BOOL finished) {
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weakSelf.lastClassBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];//改变上一个点击按钮的颜色
        weakSelf.lastClassBtn=sender;//当前按钮赋值给最后一次点击的按钮
        
    }];
}
//保存账号
-(void)saveAccountID
{
    //    保存accountID,写入持久化存储
    [[NSUserDefaults standardUserDefaults] setObject:self.account_id forKey:@"account_id"];
    //    保存之后移除绑定按钮
    _saveBtn.hidden=YES;
}
//进入搜索界面
-(void)showSearchPage
{
    SearchViewController *search=[[SearchViewController alloc]init];
    
    __weak GeneralViewController *weakSelf=self;
    search.sendValue=^(NSString *accoundID,BOOL showsBackBtn){
        weakSelf.account_id=accoundID;
        [weakSelf refreshUI];
    };
//    设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromRight duration:0.3];
    [self.navigationController pushViewController:search animated:YES];
}
//刷新UI
-(void)refreshUI
{
    if(self.account_id.length>0)
       [_tipLabel removeFromSuperview];
    [self refreshSummaryView];
    [self downloadData];
}
//刷新summary视图
-(void)refreshSummaryView
{
    //    头像
    SummaryModel *model=nil;
    if(_generalDataArray.count>0)
        model=_generalDataArray[0][0];
    if(model.poraitImageName.length>0)
        [_playerImageView setImageWithURL:[NSURL URLWithString:model.poraitImageName] placeholderImage:[UIImage imageNamed:@"defalutPlayerIcon.jpg"]];
    else
        _playerImageView.image=[UIImage imageNamed:@"defalutPlayerIcon.jpg"];
    if(model)
    {
        UILabel *nameLabel=(UILabel *)[_summaryView viewWithTag:200];
        nameLabel.text=model.playerName;
        UILabel *idLabel=(UILabel *)[_summaryView viewWithTag:201];
        idLabel.text=model.account_id;
    }
    NSString *accout=[[NSUserDefaults standardUserDefaults] objectForKey:@"account_id"];
    //    若果搜索传递过来的值不为空，且没有保存的账号，则显示绑定按钮
    if(self.account_id.length>0&&![accout isEqualToString:self.account_id])
        _saveBtn.hidden=NO;
}
//点击头像，跳转设置界面
-(void)gotoSettings
{
    SettingViewController *setting=[[SettingViewController alloc]init];
    __weak GeneralViewController *weak_self=self;
    //    给设置的代码块属性赋值
    setting.unbunding=^{
        //        将保存的账号从持久化存储删除
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account_id"];
        weak_self.saveBtn.hidden=NO;
    };
//    设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypePush toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
    [self.navigationController pushViewController:setting animated:YES];
}
//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//创建表视图
-(void)createTableView
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 160, kWidth, kHeight-160-49)];
    
    _generalTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-160-49) style:UITableViewStyleGrouped];
    _generalTableView.delegate=self;
    _generalTableView.dataSource=self;
    _generalTableView.separatorColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    _generalTableView.backgroundColor=[UIColor clearColor];
    _generalTableView.showsVerticalScrollIndicator=NO;
    [_scrollView addSubview:_generalTableView];
    
    _highestTableView=[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-160-49) style:UITableViewStyleGrouped];
    _highestTableView.delegate=self;
    _highestTableView.dataSource=self;
    _highestTableView.separatorColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    _highestTableView.backgroundColor=[UIColor clearColor];
    _highestTableView.showsVerticalScrollIndicator=NO;
    [_scrollView addSubview:_highestTableView];
    
    _scrollView.contentSize=CGSizeMake(kWidth*2, _generalTableView.contentSize.height);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.bounces=NO;//不回弹
    [self.view addSubview:_scrollView];
    if(self.account_id.length==0)
        [self createTipLabel];
}
//提示标签
-(void)createTipLabel
{
    if(_generalDataArray.count==0)
    {
        _tipLabel=[Tools createLabelWithFrame:CGRectMake(40, 200, kWidth-80, 80) text:@"请将手机语言改为中文，搜索绑定国服LOL账号" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:16]];
        [self.view addSubview:_tipLabel];
        _tipLabel.numberOfLines=0;
    }
}
#pragma mark-UITableViewDelegate协议方法
//分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_generalTableView)
        return 3;
    else
        return 1;
}
//分组的cell个数
//不全部显示，点击footer时查看全部
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_generalTableView)
    {
        if(_generalDataArray.count>0)
        {
            if(section==0)
                return 1;
            else
            {
                if(_generalDataArray.count>section&&[_generalDataArray[section] count]>0)
                {
                    if([_generalDataArray[section] count]>6)
                        return 5;
                    else
                        return [_generalDataArray[section] count];
                }
                else
                    return 0;
            }
        }
        else
            return 0;
    }
    else
        if(_highestRecordArray.count>0)
            return _highestRecordArray.count-1;//第一个元素放在头部显示
    else
        return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_generalTableView)
    {
        if(indexPath.section==0)
            return 60;
        else
            return 44;
    }
    else
        return 44;
}
//cell显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_generalTableView)
    {
        //    摘要
        if(indexPath.section==0)
        {
            static NSString *summaryCellID=@"summaryID";
            SummaryCell *cell=[tableView dequeueReusableCellWithIdentifier:summaryCellID];
            if(!cell)
                cell=[[SummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:summaryCellID];
            SummaryModel *model=nil;
            id obj=_generalDataArray[indexPath.section][indexPath.row];
            if([obj isKindOfClass:[SummaryModel class]])
                model=obj;
            [cell cellWithPaer:model];
         
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
        //    最近比赛
        else if(indexPath.section==1)
        {
            static NSString *cellReusedID=@"recentCellID";
            RecentMatchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellReusedID];
            if(!cell)
                cell=[[[NSBundle mainBundle] loadNibNamed:@"RecentMatchCell" owner:nil options:nil] lastObject];
            RecentMatch *match=nil;
            id obj=_generalDataArray[indexPath.section][indexPath.row];
            if([obj isKindOfClass:[RecentMatch class]])
                match=obj;
            [cell cellWithRecentMatch:match];

            cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            return cell;
            
        }
        //    常用英雄
        else
        {
            static NSString *cellReuseID=@"historyCellID";
            HistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellReuseID];
            if(!cell)
                cell=[[[NSBundle mainBundle]loadNibNamed:@"HistoryCell" owner:nil options:nil] lastObject];
            HeroWinRateModel *model=nil;
            id obj=_generalDataArray[indexPath.section][indexPath.row];
            if([obj isKindOfClass:[HeroWinRateModel class]])
                model=obj;
            [cell cellWithModel:model];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            return cell;
        }
    }
    else
    {
        static NSString *kHighestCellID=@"kHighestRecordCellID";
        HighestRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:kHighestCellID];
        if(!cell)
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HighestRecordCell" owner:nil options:nil] lastObject];
        HighestModel *model=_highestRecordArray[indexPath.row+1];//从第二个元素开始取，第一个在头部显示，不在cell中显示
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell cellWithHighestModel:model];
        return cell;
    }
}
//分组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView==_generalTableView)
    {
        if(_generalDataArray.count>0)
        {
            if(section==0)
                return @"账号摘要";
            else if(section==1)
                return @"最近比赛";
            else
                return @"常用英雄";
        }
        else
            return nil;
    }
    else
        return nil;
}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_generalTableView)
    {
        
        if(indexPath.section==1)
        {

        }
        if(indexPath.section==2)
        {
            HeroViewController *hero=[[HeroViewController alloc]init];
            HeroWinRateModel *model=_generalDataArray[indexPath.section][indexPath.row];
            hero.account_id=_account_id;
            hero.heroID=model.heroID;
            //        设置动画
            [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
            
            [self.navigationController pushViewController:hero animated:YES];
        }
    }
    else//最高纪录表视图的cell选中时执行下面的代码
    {
        MatchDetailViewController *detail=[[MatchDetailViewController alloc]init];
        HighestModel *model=_highestRecordArray[indexPath.row+1];
        detail.matchID=model.matchID;
        //        设置动画
        [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
/*
 分组的头高度和脚高度需要同时设置
 */
//分组的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==_generalTableView)
        return 30.0;
    else
        return 40;
}
//分组的脚高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView==_generalTableView)
    {
        if(section==0)
            return 0;
        else
            return 40.0;
    }
    else
        return 0;
}
//最近比赛的分组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView==_generalTableView)
    {
        if(_generalDataArray.count>0)
        {
            if(section==1)
            {
                RecentMatchSectionHeaderView *hv=[[RecentMatchSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
                return hv;
            }
            else
                return nil;
        }
        else
            return nil;
    }
    else
    {
        if(_highestRecordArray.count>0)
        {
            NSArray *array=_highestRecordArray[0];
            HighestHeaderView *hv=[[HighestHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40) withArray:array];
            hv.backgroundColor=[UIColor clearColor];
            return hv;
        }
        else
            return nil;
    }
}
//footer的视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tableView==_generalTableView)
    {
        if(_generalDataArray.count>0)
        {
            if(section==0)
                return nil;
            UIControl *footControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
            footControl.backgroundColor=[UIColor clearColor];
            footControl.tag=section;
            //    给点击分组叫标题添加一个监听方法
            [footControl addTarget:self action:@selector(showMoreData:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-80, 0, 60, 40) text:@"查看全部" textColor:[UIColor blackColor] textAligment:NSTextAlignmentRight andBgColor:nil font:[UIFont systemFontOfSize:12]];
            [footControl addSubview:lb];
            footControl.tag=section;
            return footControl;
        }
        else
            return nil;
    }
    else
        return nil;
}
//查看全部数据
-(void)showMoreData:(UIControl *)sender
{
    //    显示更多最近玩的英雄
    if(sender.tag==1)
    {
        RecentViewController *recent=[[RecentViewController alloc]init];
        recent.account_id=_account_id;
        if(_generalDataArray.count>1)
            recent.dataArray=_generalDataArray[1];
//        设置动画
        [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypePush toward:PSBTransitionAnimationTowardFromRight duration:0.3];
        [self.navigationController pushViewController:recent animated:YES];
    }
    //    显示更多常玩的英雄
    else if(sender.tag==2)
    {
        MostPlayedViewController *mostPlayed=[[MostPlayedViewController alloc]init];
        mostPlayed.account_id=_account_id;
        if(_generalDataArray.count>2)
            mostPlayed.dataArray=_generalDataArray[2];
        //        设置动画
        [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypePush toward:PSBTransitionAnimationTowardFromRight duration:0.3];
        [self.navigationController pushViewController:mostPlayed animated:YES];
    }
}
#pragma mark-UIScrollViewDelegate协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    __weak GeneralViewController *weakSelf=self;
    
    CGFloat kw=self.view.frame.size.width;
    CGPoint offset=_scrollView.contentOffset;
    NSInteger index=offset.x/kw;
    if(offset.x>120)//过滤掉Y方向
    {
        CGFloat classBtnWith=((kWidth-60*3)/2);
        //        动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=weakSelf.flag.frame;
            frame.origin.x=60+index*(60+classBtnWith);
            weakSelf.flag.frame=frame;
        }completion:^(BOOL finished) {
            for(UIView *sub in self.view.subviews)
            {
                if([sub isKindOfClass:[UIButton class]])
                {
                    UIButton *btn=(UIButton *)sub;
                    if(btn.tag==100||btn.tag==101)
                    {
                        if(btn.tag==index+100)
                        {
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            weakSelf.lastClassBtn=btn;
                        }
                        else
                            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    }
                }
            }
        }];
    }
}
///加载时弹出的Label
-(void)showLoadingLabel
{
    _loadingLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80, kHeight/2, 160, 60)];
    _loadingLabel.text=@"获取不到数据!";
    _loadingLabel.font=[UIFont systemFontOfSize:20];
    _loadingLabel.textColor=[UIColor whiteColor];
    _loadingLabel.textAlignment=NSTextAlignmentCenter;
    _loadingLabel.backgroundColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
    [self.view addSubview:_loadingLabel];
    _loadingLabel.layer.cornerRadius=5;
    _loadingLabel.clipsToBounds=YES;
    _loadingLabel.alpha=0;
    [UIView animateWithDuration:1 animations:^{
        _loadingLabel.alpha=1.0;
    }];
}
//加载成功，移除加载标签
-(void)dismissLoadingLabel
{
    if(_loadingLabel)
    {
        [UIView animateWithDuration:1 animations:^{
            _loadingLabel.alpha=0;
        } completion:^(BOOL finished) {
            [_loadingLabel removeFromSuperview];
            _loadingLabel=nil;
        }];
    }
}
//加载失败移除提示label的方法
-(void)dismissLoadingLabelAfterFailed
{
    if(_loadingLabel)
    {
        _loadingLabel.text=@"加载失败";
        [UIView animateWithDuration:1 animations:^{
            _loadingLabel.alpha=0;
        } completion:^(BOOL finished) {
            [_loadingLabel removeFromSuperview];
            _loadingLabel=nil;
        }];
    }
}
@end
