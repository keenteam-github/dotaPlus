//
//  HeroViewController.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/22.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "HeroViewController.h"
#import "GeneralParser.h"
#import "RecentMatchCell.h"
#import "MatchDetailViewController.h"
#import "RecentMatchSectionHeaderView.h"


@interface HeroViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;

@end


@implementation HeroViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"英雄统计";
//    标题视图
    [self createTitleView];
    _page=1;
    [self downloadData];
    //    表视图
    [self createTableView];
}
//    标题视图
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"英雄统计" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
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

-(void)downloadData
{
    __weak HeroViewController *weakSelf=self;
    
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    NSString *urlString=[NSString stringWithFormat:kSingleHeroUrl,_account_id,_heroID,(long)_page];
    [[MyDownloader downloader] downloadWithUrlString:urlString successBlock:^(NSData *data) {
        GeneralParser *parser=[[GeneralParser alloc]initWithData:data];
        weakSelf.dataArray=[NSMutableArray arrayWithArray:[parser allMatchesWithSingleHero]];
        [weakSelf.tbView reloadData];
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    } failedBlock:^(NSError *error) {
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
-(void)createTableView
{
    _tbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbView.delegate=self;
    _tbView.dataSource=self;
//    背景图片
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:_tbView.bounds];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    _tbView.backgroundView=bgView;
    
    [self.view addSubview:_tbView];
}
#pragma mark-表视图协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"recentCellID";
    RecentMatchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RecentMatchCell" owner:nil options:nil] lastObject];
    RecentMatch *match=_dataArray[indexPath.row];
    [cell cellWithRecentMatch:match];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchDetailViewController *detail=[[MatchDetailViewController alloc]init];
    RecentMatch *match=_dataArray[indexPath.row];
    detail.matchID=match.matchId;
    //        设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeRippleEffect toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
    [self.navigationController pushViewController:detail animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RecentMatchSectionHeaderView *hv=[[RecentMatchSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    hv.backgroundColor=[UIColor clearColor];
    
    return hv;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
@end
