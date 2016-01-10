//
//  StatisticalViewController.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/14.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MostPlayedViewController.h"
#import "HistoryCell.h"
#import "RecentViewController.h"
#import "GeneralParser.h"
#import "HeroViewController.h"
#import "UIView+PSBTransitionAnimation.h"

@interface MostPlayedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //    排序按钮
    UIButton *_sortBtn;
}
@property(nonatomic,strong)UITableView *tbView;
//    右侧导航栏下拉列表视图
@property(nonatomic,strong)UIView *sifterView;
//    触摸屏幕的手势，如果下拉列表处于展开状态，给tableview添加手势；
//    触摸tbView后，下拉列表收起，排序的标题被设置为排序，并移除手势
@property(nonatomic,strong)UITapGestureRecognizer *tap;

@end

@implementation MostPlayedViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"英雄统计";
    [self createTitleView];
//    表视图
    [self createTableView];
    //    导航按钮
    [self createNavBtn];
    //    创建下拉列表
    [self createList];
}
//    标题视图
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-180, 10, 120, 54) text:@"英雄统计" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
    [self.view addSubview:lb];
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
//懒加载
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if(!_dataArray)
        _dataArray=[NSMutableArray array];
    _dataArray=dataArray;
}

-(void)createNavBtn
{
    //    右侧排序按钮
    _sortBtn=[Tools createBtnWithFrame:CGRectMake(kWidth-50, 29, 40, 26) title:@"排序" titleColor:[UIColor whiteColor] target:self action:@selector(showSifter:)];
    _sortBtn.backgroundColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    _sortBtn.layer.cornerRadius=5;
    _sortBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.view addSubview:_sortBtn];
}
//创建下拉列表
-(void)createList
{
    //    下拉视图
    _sifterView=[[UIView alloc]initWithFrame:CGRectMake(kWidth, 64, 90, 90)];
    [self.view addSubview:_sifterView];
    _sifterView.layer.cornerRadius=5;
    //    添加3个按钮，点击排序
    NSArray *titles=@[@"最少使用",@"胜率最低",@"最高KDA"];
    for(int i=0;i<3;i++)
    {
        UIButton *btn=[Tools createBtnWithFrame:CGRectMake(0, 30*i, 90, 30) title:titles[i] titleColor:[UIColor whiteColor] target:self action:@selector(sift:)];
        btn.backgroundColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
        btn.layer.borderWidth=1;
        btn.layer.borderColor=[UIColor whiteColor].CGColor;
        [_sifterView addSubview:btn];
    }
}
//显示下拉列表
-(void)showSifter:(UIButton *)sender
{
    __weak MostPlayedViewController *weakSelf=self;
    
    if([sender.currentTitle isEqualToString:@"排序"])
    {
        //        添加手势
        [weakSelf.tbView addGestureRecognizer:weakSelf.tap];
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        //         展开列表
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect=CGRectMake(kWidth-90, 64, 90, 90);
            weakSelf.sifterView.frame=rect;
        }];
    }
    else
    {
        [sender setTitle:@"排序" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect=CGRectMake(kWidth, 64, 90, 90);
            weakSelf.sifterView.frame=rect;
        }];
    }
}

//显示/隐藏下拉列表
-(void)sift:(UIButton *)sender
{
    if([sender.currentTitle isEqualToString:@"场数最多"])
    {
        [sender setTitle:@"最少使用" forState:UIControlStateNormal];
        
        [_dataArray sortUsingSelector:@selector(sortLestPlayed:)];
    }
    else if([sender.currentTitle isEqualToString:@"最少使用"])
    {
        [sender setTitle:@"场数最多" forState:UIControlStateNormal];
        [_dataArray sortUsingSelector:@selector(sortMostPlayed:)];
    }
    else if([sender.currentTitle isEqualToString:@"胜率最高"])
    {
        [sender setTitle:@"胜率最低" forState:UIControlStateNormal];
        [_dataArray sortUsingSelector:@selector(sortLowestWinRate:)];
    }
    else if([sender.currentTitle isEqualToString:@"胜率最低"])
    {
        [sender setTitle:@"胜率最高" forState:UIControlStateNormal];
        
        [_dataArray sortUsingSelector:@selector(sortHighestWinRate:)];
    }
    
    else if([sender.currentTitle isEqualToString:@"最高KDA"])
    {
        [sender setTitle:@"最低KDA" forState:UIControlStateNormal];
        [_dataArray sortUsingSelector:@selector(sortMinKDA:)];
        
    }
    else if([sender.currentTitle isEqualToString:@"最低KDA"])
    {
        [sender setTitle:@"最高KDA" forState:UIControlStateNormal];
        [_dataArray sortUsingSelector:@selector(sortMaxKDA:)];
    }
    [_sortBtn setTitle:@"排序" forState: UIControlStateNormal];
    //    移除手势
    [_tbView removeGestureRecognizer:_tap];
    
    __weak MostPlayedViewController *weakSelf=self;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=CGRectMake(kWidth, 64, 90, 90);
        weakSelf.sifterView.frame=rect;
    }];
    [weakSelf.tbView reloadData];
}

//创建表视图
-(void)createTableView
{
    _tbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStylePlain];
    _tbView.delegate=self;
    _tbView.dataSource=self;
//    背景图片
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:_tbView.bounds];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    _tbView.backgroundView=bgView;
    [self.view addSubview:_tbView];
//    初始化手势对象，先不添加到_tbView ，下拉列表展开时再添加
//    只有玩过的英雄才需要筛选
     _tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSortList)];
}
//点击屏幕的手势监听方法
-(void)hideSortList
{
    __weak MostPlayedViewController *weakSelf=self;
    //    隐藏下来列表
    [_sortBtn setTitle:@"排序" forState: UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=CGRectMake(kWidth, 64, 90, 120);
        weakSelf.sifterView.frame=rect;
    }];
    //    移除手势
    [_tbView removeGestureRecognizer:_tap];
}
#pragma mark-UITableViewDelegate协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedCellID=@"historyCellID";
    HistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedCellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:nil options:nil] lastObject];
    HeroWinRateModel *model=_dataArray[indexPath.row];
    [cell cellWithModel:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeroViewController *hero=[[HeroViewController alloc]init];
    HeroWinRateModel *model=nil;
    if(self.dataArray.count>0)
        model=self.dataArray[indexPath.row];
    hero.account_id=_account_id;
    hero.heroID=model.heroID;
    //        设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeOglFilp toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
    [self.navigationController pushViewController:hero animated:YES];
}
@end
