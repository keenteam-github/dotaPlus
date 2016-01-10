//
//  ItemsViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemCell.h"
#import "DataParser.h"

@interface ItemsViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)EGORefreshTableHeaderView *egoHeader;
@property(nonatomic,assign)BOOL isLoading;

@end

@implementation ItemsViewController

-(NSMutableArray *)dataArray
{
    if(!_dataArray)
        _dataArray=[NSMutableArray array];
    return _dataArray;
}
-(UITableView *)tbView
{
    if(!_tbView)
    {
        _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
        _tbView.delegate=self;
        _tbView.dataSource=self;
         _tbView.separatorColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
        _egoHeader=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_tbView.frame.size.height, kWidth, _tbView.frame.size.height)];
        [_tbView addSubview:_egoHeader];
        _egoHeader.delegate=self;
        [self.view addSubview:_tbView];
    }
    return _tbView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTitleViewWithText:@"LOL物品"];
    [self createBackBtn];
    [self.view addSubview:self.tbView];
    [self downloadData];
}
//下载数据
-(void)downloadData
{
    _isLoading=YES;
//    指示器
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
//    异步请求数据
    __weak ItemsViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:kItemList andCallBackBlock:^(NSData *receivedData) {
        DataParser *parser=[DataParser paserWithData:receivedData];
        NSArray *array=[parser parseItems];
        if(array.count>0)
        {
//            清空之前的数据
            [weakSelf.dataArray removeAllObjects];
//            添加新的数据
            weakSelf.dataArray=[NSMutableArray arrayWithArray:array];
            [weakSelf.tbView reloadData];
        }
//        结束刷新
        weakSelf.isLoading=NO;
        [weakSelf.egoHeader egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
//        移除指示器
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
#pragma mark-UITableViewDelegate代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataArray.count>0)
        return self.dataArray.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"itemCellID";
    ItemCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:nil options:nil] lastObject];
    ItemModel *model=nil;
    if(self.dataArray.count>indexPath.row)
        model=_dataArray[indexPath.row];
    [cell cellWithItemModel:model cellType:DataCellTypeItem];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"本月统计";
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
