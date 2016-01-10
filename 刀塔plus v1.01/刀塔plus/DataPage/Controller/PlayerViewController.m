//
//  PlayerViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "PlayerViewController.h"
#import "DataService.h"
#import "DataParser.h"
#import "KnowedPlayerCell.h"
#import "GeneralViewController.h"

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>


@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,strong)EGORefreshTableHeaderView *egoHeader;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    [self createTitleViewWithText:@"知名玩家"];
    [self createBackBtn];
    [self createTableView];
    [self downloadData];
}
//创建表视图
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
//下载数据
-(void)downloadData
{
    _isLoading=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    __weak PlayerViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:kKnowedPlayerUrl andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
    //        初始化解析器对象
            DataParser *parser=[[DataParser alloc]initWithData:receivedData];
            NSArray *array=[parser parseKnowedPlayers];
            if(array.count>0)
            {
    //            接收到数据后,清空之前的数据
                [weakSelf.dataArray removeAllObjects];
    //            添加新的数据
                weakSelf.dataArray=[NSMutableArray arrayWithArray:array];
                [weakSelf.tbView reloadData];
            }
    //        结束刷新
            weakSelf.isLoading=NO;
            [weakSelf.egoHeader egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
        }
        [GMDCircleLoader hideFromView:self.view animated:YES];
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
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"wellKnowCellID";
    KnowedPlayerCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"KnowedPlayerCell" owner:nil options:nil] lastObject];
    KonwedPlayer *player=nil;
    if(_dataArray.count>indexPath.row)
        player=_dataArray[indexPath.row];
    [cell cellWithKonwedPlayerModel:player];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    head.backgroundColor=[UIColor lightGrayColor];
    NSArray *array=@[@"昵称/ID/状态",@"单排积分/开黑积分",@"所属战队"];
    for(int i=0;i<3;i++)
    {
        CGFloat xpos=(kWidth/3)*i;
        UILabel *lb=[Tools createLabelWithFrame:CGRectMake(xpos, 0, kWidth/3, 40) text:array[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
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
    KonwedPlayer *player=nil;
    if(_dataArray.count>indexPath.row)
        player=_dataArray[indexPath.row];
    GeneralViewController *general=[[GeneralViewController alloc]init];
    general.account_id=player.account_id;
    general.showsBackBtn=YES;
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeFade toward:PSBTransitionAnimationTowardFromRight duration:0.3];
    [self.navigationController pushViewController:general animated:YES];
}
#pragma mark-EGORefresh协议方法
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
    {
        [self downloadData];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoHeader egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_egoHeader egoRefreshScrollViewDidScroll:scrollView];
}
@end
