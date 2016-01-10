

//
//  MatchDetailViewController.m
//  TestHTML_Parser
//
//  Created by 峰哥哥-.- on 15/6/14.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "MatchDetailViewController.h"
#import "MatchDetailSummaryCell.h"
#import "MatchDetailCell.h"
#import "GeneralParser.h"
#import "GeneralViewController.h"
#import "UIView+PSBTransitionAnimation.h"

@interface MatchDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MatchDetailViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"比赛详情";
    [self createTitleView];
    _dataArray=[NSMutableArray array];
    [self createTableView];
    [self downloadData];
 
}
//    标题视图
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"比赛详情" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
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

//下载数据
-(void)downloadData
{
    __weak MatchDetailViewController *weakSelf=self;
    
    NSString *urlString=[NSString stringWithFormat:kDetailUrl,_matchID];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    
    [DataService getDataWithUrlString:urlString andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            GeneralParser *parser=[[GeneralParser alloc]initWithData:receivedData];
            
            dispatch_queue_t aQueue=dispatch_queue_create("aQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(aQueue, ^{
                
                MatchDetailSummaryModel *model=[parser parseMatchDetailSummary];//包含同步解析数据
                
                [_dataArray addObject:@[model]];
                NSArray *detailArray=[parser matchDetailWithMatchID:weakSelf.matchID];
                NSMutableArray *radiantHeros=[NSMutableArray array];
                NSMutableArray *direHeros=[NSMutableArray array];
                for(int i=0;i<5;i++)
                    [radiantHeros addObject:detailArray[i]];
                for(int i=5;i<10;i++)
                    [direHeros addObject:detailArray[i]];
                
                [weakSelf.dataArray addObject:radiantHeros];
                [weakSelf.dataArray addObject:direHeros];
                [weakSelf.tbView reloadData];
                [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
            });
        }
    }];
    [[MyDownloader downloader] downloadWithUrlString:urlString successBlock:^(NSData *data) {
        
    } failedBlock:^(NSError *error) {
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:_tbView.bounds];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    _tbView.backgroundView=bgView;
    _tbView.separatorColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [self.view addSubview:_tbView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else
        return [_dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 60;
    else
        return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        static NSString *cellID=@"detailSummaryCellID";
        MatchDetailSummaryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell)
            cell=[[MatchDetailSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        MatchDetailSummaryModel *model=_dataArray[indexPath.section][indexPath.row];
        [cell cellWithMathDetailSummaryModel:model];
//         cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else
    {
        static NSString *reuseCellID=@"detailMatchCellID";
        MatchDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseCellID];
        if(!cell)
            cell=[[[NSBundle mainBundle] loadNibNamed:@"MatchDetailCell" owner:nil options:nil] lastObject];
        MatchDetailModel *model=_dataArray[indexPath.section][indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell cellWithDetailModel:model];
        __weak MatchDetailViewController *weakself=self;
//        给cell的代码块赋值
        
        cell.clickPlayerIcon=^(NSString *acountID){
            if(acountID.length>0)
            {
                GeneralViewController *general=[[GeneralViewController alloc]init];
                general.account_id=acountID;
                general.showsBackBtn=YES;
//                动画
                [weakself.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeRippleEffect toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
                [weakself.navigationController pushViewController:general animated:YES];
            }
        };
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return @"概览";
    else if(section==1)
        return @"天辉";
    else
        return @"夜魇";
}
@end
