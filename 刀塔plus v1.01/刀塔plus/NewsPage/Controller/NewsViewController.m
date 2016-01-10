//
//  NewsViewController.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "NewsViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "NewsCell.h"
#import "UIView+PSBTransitionAnimation.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()<EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,assign)NSInteger newsIndex;
@property(nonatomic,strong)EGORefreshTableHeaderView *header;
@property(nonatomic,strong)EGORefreshTableFooterView *footer;


@end

@implementation NewsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self resetFooterFrame];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _newsIndex=0;
    _dataArray=[NSMutableArray array];
    [self createTitleViewWithText:@"新闻plus"];
    [self downloadData];
    [self createTableView];
}
//标题
-(void)createTitleViewWithText:(NSString *)text
{
    UIColor *color=[UIColor colorWithRed:48/255.f green:134/255.f blue:242/255.f alpha:1];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:text textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
    [self.view addSubview:lb];
}

-(void)downloadData
{
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    _isLoading=YES;
    
    NSString *urlString=[NSString stringWithFormat:kNewsURL,(long)_newsIndex];
    
    __weak NewsViewController *weakSelf=self;
    
    [[MyDownloader downloader] downloadWithUrlString:urlString successBlock:^(NSData *data) {
        id object=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary=object;
            NSArray *array=dictionary[@"result"];
            if(array.count>0)
            {
                //    下拉刷新或者第一次加载，清空数据源数组
                if(weakSelf.newsIndex==0)
                    [weakSelf.dataArray removeAllObjects];
                
                for(NSDictionary *dict in array)
                {
                    NewsModel *model=[NewsModel newsWithDictionary:dict];
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tbView reloadData];
                //        结束刷新
                //    结束刷新
                [weakSelf.header egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
                [weakSelf.footer egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
                [self resetFooterFrame];
                weakSelf.isLoading=NO;
                [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
            }
        }
    } failedBlock:^(NSError *error) {
        weakSelf.isLoading=NO;
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
        NSLog(@"%@",error);
    }];
}
//重置_footer的frame
-(void)resetFooterFrame
{
    CGFloat height=MAX(_tbView.bounds.size.height, _tbView.contentSize.height);
    _footer.frame=CGRectMake(0, height, _tbView.bounds.size.width, 0);
}
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStylePlain];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    _tbView.backgroundColor=[UIColor clearColor];
    _tbView.separatorColor=[UIColor colorWithRed:48/255.f green:134/255.f blue:242/255.f alpha:1];
    [self.view addSubview:_tbView];
    //    下拉刷新
    _header=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_tbView.bounds.size.height, _tbView.bounds.size.width, _tbView.bounds.size.height)];
    _footer=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectZero];
    _header.delegate=self;
    _footer.delegate=self;
    [_tbView addSubview:_header];
    [_tbView addSubview:_footer];
}
#pragma mark-UITableViewDelegate协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count>0)
        return _dataArray.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *newsCellID=@"newsCellID";
    NewsCell *cell=[tableView dequeueReusableCellWithIdentifier:newsCellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil] lastObject];
    NewsModel *model=nil;
    if(_dataArray.count>0)
        model=_dataArray[indexPath.row];
    [cell cellWithNews:model];
//    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController *detail=[[NewsDetailViewController alloc]init];
    NewsModel *model=nil;
    if(_dataArray.count>0)
        model=_dataArray[indexPath.row];
    detail.urlString=model.newsURL;
//    隐藏tabBar
    self.hidesBottomBarWhenPushed=YES;
//    隐藏导航
    detail.navigationController.navigationBarHidden=YES;
//    设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
    [self.navigationController pushViewController:detail animated:YES];
//    显示tabBar
    self.hidesBottomBarWhenPushed=NO;
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
        _newsIndex=0;
        [self downloadData];
    }
    else if (aRefreshPos==EGORefreshFooter)
    {
        _newsIndex+=20;
        [self downloadData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_header egoRefreshScrollViewDidScroll:scrollView];
    [_footer egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_header egoRefreshScrollViewDidEndDragging:scrollView];
    [_footer egoRefreshScrollViewDidEndDragging:scrollView];
}
@end
