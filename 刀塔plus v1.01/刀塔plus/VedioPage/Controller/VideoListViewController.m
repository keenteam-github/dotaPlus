//
//  VideoListViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/5.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "VideoListViewController.h"
#import "EGORefreshTableFooterView.h"
#import "JXFHVideoCell.h"
#import "PlayViewController.h"

@interface VideoListViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
{
    BOOL _isLoading;
    NSInteger _offset;//从第几条数据开始，每页显示10条数据
}

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)EGORefreshTableHeaderView *header;
@property(nonatomic,strong)EGORefreshTableFooterView *footer;
@property(nonatomic,assign)BOOL isLoading;

@end

@implementation VideoListViewController
//视图即将出现的时候，重置EGOfooter
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetEGOFooterFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _offset=0;
    _dataArray=[NSMutableArray array];
    [self createTitleView];
    [self createTableView];
    [self downloadData];
}

//标题视图
-(void)createTitleView
{
    //    CGRectMake(0, kWidth-64, kHeight, 64)
    UIColor *color=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-220, 20, 210, 30) text:self.authorName textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:26]];
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
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbView.separatorColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    [self.view addSubview:_tbView];
    
    _header=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_tbView.bounds.size.height, kWidth, _tbView.bounds.size.height)];
    _footer=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectZero];
    [_tbView addSubview:_header];
    [_tbView addSubview:_footer];
    _header.delegate=self;
    _footer.delegate=self;
}
-(void)resetEGOFooterFrame
{
    CGFloat height=MAX(_tbView.bounds.size.height, _tbView.contentSize.height);
    _footer.frame=CGRectMake(0, height, kWidth, 0);
}
-(void)downloadData
{
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading" animated:YES];
    _isLoading=YES;
    
//    创建一个弱引用，在代码块中使用
    __weak VideoListViewController *weakSelf=self;
    
    NSString *urlString=[NSString stringWithFormat:kExplainerVideoList,_authorID,(long)_offset];
//    NSLog(@"------------------------------------------------------");
//    NSLog(@"%@",urlString);

    [DataService getDataWithUrlString:urlString andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary=(NSDictionary *)result;
                NSArray *array=dictionary[@"videos"];
                if(array.count>0)
                {
//                  第一次下载或者下拉刷新，移除之前的数据
                    if(_offset==0)
                        [weakSelf.dataArray removeAllObjects];
                    
                    //                        开辟一个新的线程
                    dispatch_queue_t dataQueue=dispatch_queue_create("dataQueue", DISPATCH_QUEUE_CONCURRENT);
                    dispatch_async(dataQueue, ^{
                        for(NSDictionary *dict in array)
                        {
                            //                    kvo赋值
                            JXFHVideoModel *model=[JXFHVideoModel jxfhWithDict:dict];
                            //            解析出真正的URL地址
                            NSString *tmpStr=[NSString stringWithFormat:kJXFHVideoUrl,model.videoID];
                            

                                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpStr]];
                                id result=nil;
                                if(data.length>0)
                                    result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                if([result isKindOfClass:[NSDictionary class]])
                                {
                                    NSDictionary *dict=(NSDictionary *)result;
                                    model.realUrl=dict[@"url"];
                                }
                                if(model)
                                    [weakSelf.dataArray addObject:model];
                                
                                [weakSelf.tbView reloadData];
                                [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
                            
                        }
                    });
                }
            }
        }
        [weakSelf.header egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
        [weakSelf.footer egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
        [weakSelf resetEGOFooterFrame];
        weakSelf.isLoading=NO;
    }];
}
#pragma mark-UITableView
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
    static NSString *cellID=@"JXFHCellID";
    JXFHVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"JXFHVideoCell" owner:nil options:nil] lastObject];
    JXFHVideoModel *model=nil;
    if(_dataArray.count>0)
        model=_dataArray[indexPath.row];
    [cell cellWithJXFHModel:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController *play=[[PlayViewController alloc]init];
    JXFHVideoModel *model=_dataArray[indexPath.row];
    play.urlString=model.realUrl;
    play.videoTitle=model.title;
    //                    设置动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCameraIris toward:PSBTransitionAnimationTowardFromBottom duration:0.3];
    //    隐藏tabBar
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:play animated:YES];
    //    显示tabBar
    self.hidesBottomBarWhenPushed=NO;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.authorName;
}
#pragma mark-EGORefresh
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
        _offset=0;
        [self downloadData];
    }
    else if (aRefreshPos==EGORefreshFooter)
    {
        _offset+=10;
        [self downloadData];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_header egoRefreshScrollViewDidEndDragging:scrollView];
    [_footer egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_header egoRefreshScrollViewDidScroll:scrollView];
    [_footer egoRefreshScrollViewDidScroll:scrollView];
}
@end
