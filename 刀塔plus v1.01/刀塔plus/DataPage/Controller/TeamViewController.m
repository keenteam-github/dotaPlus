//
//  TeamViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamCell.h"
#import "DataParser.h"
#import "TeamDetailViewController.h"

@interface TeamViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,strong)EGORefreshTableHeaderView *egoHeader;

@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    
    [self createTitleViewWithText:@"LOL战队"];
    [self createBackBtn];
    [self createTableView];
    [self downloadData];
}
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbView.separatorColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    _egoHeader=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_tbView.frame.size.height, kWidth, _tbView.frame.size.height)];
    [_tbView addSubview:_egoHeader];
    _egoHeader.delegate=self;
    [self.view addSubview:_tbView];
}
-(void)downloadData
{
    _isLoading=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    __weak TeamViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:kTeamListUrl andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            DataParser *parser=[[DataParser alloc]initWithData:receivedData];
            NSArray *array=[parser parseTeamList];
            if(array.count>0)
            {
//                清除之前的数据
                [weakSelf.dataArray removeAllObjects];
//                添加新的数据
                weakSelf.dataArray=[NSMutableArray arrayWithArray:array];
                
                [weakSelf.tbView reloadData];
            }
        }
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
        weakSelf.isLoading=NO;
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count>0)
        return _dataArray.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"teamCellID";
    TeamCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"TeamCell" owner:nil options:nil] lastObject];
    TeamModel *model=nil;
    if(_dataArray.count>indexPath.row)
        model=_dataArray[indexPath.row];
    [cell cellWithTeamModel:model];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    head.backgroundColor=[UIColor lightGrayColor];
    NSArray *array=@[@"本月数据",@"队名",@"MMR",@"胜率",@"排名"];
    for(int i=0;i<5;i++)
    {
        CGFloat xpos=(kWidth/5)*i;
        UILabel *lb=[Tools createLabelWithFrame:CGRectMake(xpos, 0, kWidth/4, 40) text:array[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
        [head addSubview:lb];
    }
    return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamModel *model=nil;
    if(_dataArray.count>indexPath.row)
        model=_dataArray[indexPath.row];
    TeamDetailViewController *detail=[[TeamDetailViewController alloc]init];
    detail.members=model.memberArray;
    detail.teamID=model.teamID;
    detail.imageName=model.teamIcon;
    detail.name=model.teamName;
    
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromRight duration:0.2];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark-EGO协议
-(BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
{
    return _isLoading;
}
-(NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
{
    return [NSDate date];
}
-(void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if(aRefreshPos==EGORefreshHeader)
       [self downloadData];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoHeader egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_egoHeader egoRefreshScrollViewDidScroll:scrollView];
}

@end
