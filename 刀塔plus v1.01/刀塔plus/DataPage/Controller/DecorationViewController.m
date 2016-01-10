
//
//  DecorationViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "DecorationViewController.h"
#import "EGORefreshTableFooterView.h"
#import "DataParser.h"
#import "DecorationCell.h"
#import "ChooseViewController.h"
#import "DecorationDetailViewController.h"

@interface DecorationViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>

@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,strong)EGORefreshTableHeaderView *header;
@property(nonatomic,strong)EGORefreshTableFooterView *footer;
@property(nonatomic,assign)NSInteger page;//页数
@property(nonatomic,copy)NSString *rarity;//稀有度
@property(nonatomic,copy)NSString *qulity;//品质
@property(nonatomic,copy)NSString *rarityValue;
@property(nonatomic,copy)NSString *qulityValue;


@end

@implementation DecorationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetEGOFooterFrame];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTitleViewWithText:@"LOL饰品"];
//    初始化变量
    _dataArray=[NSMutableArray array];
    _page=1;
    _rarity=@"全部";
    _qulity=@"全部";
    _rarityValue=@"";
    _qulityValue=@"";
    [self createChooseBtn];
    [self createBackBtn];
    [self createTableView];
    [self downloadData];
}
//分类按钮
-(void)createChooseBtn
{
    UIButton *btn=[Tools createBtnWithFrame:CGRectMake(kWidth/2-30, 20, 40, 40) title:@"分类" titleColor:[UIColor whiteColor] target:self action:@selector(gotoChoose)];
    btn.layer.cornerRadius=20;
    btn.layer.borderColor=[UIColor whiteColor].CGColor;
    btn.layer.borderWidth=2;
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    btn.backgroundColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
    [self.view addSubview:btn];
}
//筛选
-(void)gotoChoose
{
    ChooseViewController *choose=[[ChooseViewController alloc]init];
    
    __weak DecorationViewController *weakSelf=self;
    
    choose.chooseDidFinishBlock=^(NSString *rarity,NSString *qulity,NSString *rarityValue,NSString *qulityValue){
        weakSelf.rarity=rarity;
        weakSelf.qulity=qulity;
        weakSelf.rarityValue=rarityValue;
        weakSelf.qulityValue=qulityValue;
        weakSelf.page=1;
        
        [weakSelf downloadData];
    };
    choose.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:choose animated:YES completion:nil];
}
-(void)downloadData
{
    _isLoading=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    NSString *urlString=[NSString stringWithFormat:kDecorationUrl,_rarityValue,_qulityValue,(long)_page];
    
    __weak DecorationViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:urlString andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            DataParser *parser=[[DataParser alloc]initWithData:receivedData];
            NSArray *array=[parser decorationList];
            if(array.count>0)
            {
//                第一次加载，或者下拉刷新，移除之前的数据
                if(weakSelf.page==1)
                    [weakSelf.dataArray removeAllObjects];
//                添加新的数据
                for(DecorationModel *model in array)
                    [weakSelf.dataArray addObject:model];
//                刷新表格
                [weakSelf.tbView reloadData];
            }
        }
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
        [weakSelf.header egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
        [weakSelf.footer egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
//        重置footer
        [weakSelf resetEGOFooterFrame];
        weakSelf.isLoading=NO;
    }];
}
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tbView.separatorColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    [self.view addSubview:_tbView];
    
    _header=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_tbView.frame.size.height, kWidth, _tbView.frame.size.height)];
    _footer=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectZero];
    [_tbView addSubview:_header];
    [_tbView addSubview:_footer];
    _header.delegate=self;
    _footer.delegate=self;
}
//重置上拉加载的frame
-(void)resetEGOFooterFrame
{
    CGFloat height=MAX(_tbView.frame.size.height, _tbView.contentSize.height);
    _footer.frame=CGRectMake(0, height, kWidth, 0);
}
#pragma mark-TableView
#pragma mark-
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
    static NSString *cellID=@"decorationCellID";
    DecorationCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"DecorationCell" owner:nil options:nil] lastObject];
    DecorationModel *model=nil;
    if(_dataArray.count>indexPath.row)
        model=_dataArray[indexPath.row];
    [cell cellWithDecorationModel:model];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *s1=_rarity;
    if([_rarity isEqualToString:@"全部"])
        s1=@"全部";
    NSString *s2=_qulity;
    if([_qulity isEqualToString:@"全部"])
        s2=@"全部";
    NSString *result=[NSString stringWithFormat:@"稀有度:%@\t品质:%@",s1,s2];
    if([_rarity isEqualToString:@"全部"]&&[_qulity isEqualToString:@"全部"])
        result=@"全部饰品";
    return result;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationDetailViewController *detail=[DecorationDetailViewController new];
    DecorationModel *model=nil;
    if(_dataArray.count>indexPath.row)
        model=_dataArray[indexPath.row];
    detail.name=model.name;
    detail.icon=model.icon;
    
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCameraIris toward:PSBTransitionAnimationTowardFromLeft duration:0.2];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
#pragma mark-EGORefresh
#pragma mark-
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
        _page=1;
        [self downloadData];
    }
    else if(aRefreshPos==EGORefreshFooter)
    {
        _page++;
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
