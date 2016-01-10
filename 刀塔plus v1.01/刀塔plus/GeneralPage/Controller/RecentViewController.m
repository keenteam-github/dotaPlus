//
//  HeroStatisticalViewController.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/14.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentMatchCell.h"
#import "MatchDetailViewController.h"
#import "RecentMatchSectionHeaderView.h"
#import "GeneralParser.h"
#import "UIView+PSBTransitionAnimation.h"

@interface RecentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tbView;
    //    排序按钮
    UIButton *_sortBtn;
}
@end

@implementation RecentViewController
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
    self.title=@"比赛统计";
    [self createTitleView];
    //    表视图
    [self createTableView];
    //    导航按钮
    [self createNavBtn];
}
//    标题视图
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-180, 10, 120, 54) text:@"比赛统计" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
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

//创建表视图
-(void)createTableView
{
    _tbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:_tbView.bounds];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    _tbView.backgroundView=bgView;
    [self.view addSubview:_tbView];
}
-(void)createNavBtn
{
    //    右侧按钮
    _sortBtn=[Tools createBtnWithFrame:CGRectMake(kWidth-50, 29, 40, 26) title:@"模式" titleColor:[UIColor whiteColor] target:self action:@selector(sortLadderMatch)];
    _sortBtn.backgroundColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    _sortBtn.layer.cornerRadius=5;
    _sortBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.view addSubview:_sortBtn];
}
-(void)sortLadderMatch
{
    if([_sortBtn.currentTitle isEqualToString:@"模式"])
    {
        [self.dataArray sortUsingSelector:@selector(accendSortModal:)];
        [_sortBtn setTitle:@"全部" forState:UIControlStateNormal];
    }
    else
    {
        [self.dataArray sortUsingSelector:@selector(deccendSortModal:)];
        [_sortBtn setTitle:@"模式" forState:UIControlStateNormal];
    }
     [_tbView reloadData];
}
#pragma mark-UITableViewDelegate协议方法
//cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count>0)
        return _dataArray.count;
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
//cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedCellID=@"recentCellID";
    RecentMatchCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedCellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RecentMatchCell" owner:nil options:nil] lastObject];
    RecentMatch *match=_dataArray[indexPath.row];
    [cell cellWithRecentMatch:match];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
//最近比赛的分组头标题
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RecentMatchSectionHeaderView *hv=[[RecentMatchSectionHeaderView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
    return hv;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchDetailViewController *detail=[[MatchDetailViewController alloc]init];
    RecentMatch *match=_dataArray[indexPath.row];
    detail.matchID=match.matchId;
    //        设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeRippleEffect toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
