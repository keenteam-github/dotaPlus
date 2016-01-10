//
//  LadderViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/6/27.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "LadderViewController.h"
#import "LadderCell.h"
#import "DataParser.h"
#import "GeneralViewController.h"


@interface LadderViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>


@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,strong)EGORefreshTableHeaderView *egoHeader;

@property(nonatomic,strong)UIView *sifterView;
@property(nonatomic,assign)BOOL isListShow;
//    触摸屏幕的手势，如果下拉列表处于展开状态，给tableview添加手势；
//    触摸tbView后，下拉列表收起，移除手势
@property(nonatomic,strong)UITapGestureRecognizer *tap;

@end

@implementation LadderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray=[NSMutableArray new];
    
    _urlString=[NSString stringWithFormat:kLadderUrl,@""];
    [self createTitleViewWithText:@"LOL"];
    [self createBackBtn];
    [self createTableView];
    [self createList];//下拉列表
    [self downloadData];
}
//创建下拉列表
-(void)createList
{
    //    下拉视图
    _sifterView=[[UIView alloc]initWithFrame:CGRectMake(-90, 64, 90, 120)];
    [self.view addSubview:_sifterView];
    _sifterView.layer.cornerRadius=5;
    //    添加3个按钮，点击排序
    NSArray *titles=@[@"国服",@"东南亚服",@"美服",@"欧服"];
    for(int i=0;i<4;i++)
    {
        UIButton *btn=[Tools createBtnWithFrame:CGRectMake(0, 30*i, 90, 30) title:titles[i] titleColor:[UIColor whiteColor] target:self action:@selector(choose:)];
        btn.tag=100+i;
        btn.backgroundColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
        btn.layer.borderWidth=1;
        btn.layer.borderColor=[UIColor whiteColor].CGColor;
        [_sifterView addSubview:btn];
    }
    _sifterView.hidden=YES;
    
    //    list菜单按钮
    UIButton *listBtn=[Tools createBtnWithFrame:CGRectMake(80, 30, 40, 30) title:nil titleColor:nil target:self action:@selector(showList)];
    [self.view addSubview:listBtn];
    [listBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    listBtn.backgroundColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
}
//显示与隐藏下拉列表
-(void)showList
{
    __weak LadderViewController *waekSelf=self;
    _isListShow=!_isListShow;
    if(_isListShow)
    {
        waekSelf.sifterView.hidden=NO;
        [waekSelf.tbView addGestureRecognizer:waekSelf.tap];
        CGRect rect=CGRectMake(0, 64, 90, 120);
        [UIView animateWithDuration:0.5 animations:^{
            waekSelf.sifterView.frame=rect;
        }completion:^(BOOL finished) {
            waekSelf.sifterView.userInteractionEnabled=YES;
        }];
    }
    else
    {
        [waekSelf.tbView removeGestureRecognizer:waekSelf.tap];
        CGRect rect=CGRectMake(-90, 64, 90, 120);
        [UIView animateWithDuration:0.5 animations:^{
            waekSelf.sifterView.frame=rect;
        }completion:^(BOOL finished) {
            waekSelf.sifterView.userInteractionEnabled=NO;
            waekSelf.sifterView.hidden=YES;
        }];
    }
}
-(void)choose:(UIButton *)sender
{
    NSArray *classArray=@[[NSString stringWithFormat:kLadderUrl,@""],[NSString stringWithFormat:kLadderUrl,@"se_asia/"],[NSString stringWithFormat:kLadderUrl,@"americas/"],[NSString stringWithFormat:kLadderUrl,@"europe/"]];
    self.urlString=classArray[sender.tag-100];
    CGRect rect=CGRectMake(-90, 64, 90, 120);
    
    __weak LadderViewController *waekSelf=self;
    
    [UIView animateWithDuration:0.5 animations:^{
        waekSelf.sifterView.frame=rect;
    }completion:^(BOOL finished) {
        waekSelf.sifterView.userInteractionEnabled=NO;
        waekSelf.isListShow=NO;
        waekSelf.sifterView.hidden=YES;
        [waekSelf.tbView removeGestureRecognizer:waekSelf.tap];
    }];//    下载数据
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
//    创建手势
    _tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showList)];
}
//下载数据
-(void)downloadData
{
    _isLoading=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
//    异步下载数据
    
    __weak LadderViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:_urlString andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            //            下载新数据
            DataParser *parser=[DataParser paserWithData:receivedData];
            NSArray *array=[parser parseLadder];
            if(array.count>0)
            {
                //            清空之前的数据
                [weakSelf.dataArray removeAllObjects];
                //                添加新数据
                weakSelf.dataArray=[NSMutableArray arrayWithArray:array];
                //        刷新表格
                [weakSelf.tbView reloadData];
                //        结束刷新
                weakSelf.isLoading=NO;
                [weakSelf.egoHeader egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tbView];
            }
        }
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectiont
{
    if(_dataArray.count>0)
        return _dataArray.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"ladderCellID";
    LadderCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"LadderCell" owner:nil options:nil] lastObject];
    
    LadderModel *model=nil;
    if(_dataArray.count>0)
        model=_dataArray[indexPath.row];
    [cell cellWithLadderModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GeneralViewController *gvc=[[GeneralViewController alloc]init];
    LadderModel *model=nil;
    if(_dataArray.count>indexPath.row)
        model=_dataArray[indexPath.row];
    gvc.account_id=model.account_id;
    gvc.showsBackBtn=YES;
    
//    动画
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeMoveIn toward:PSBTransitionAnimationTowardFromBottom duration:0.3];
    [self.navigationController pushViewController:gvc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    head.backgroundColor=[UIColor lightGrayColor];
    NSArray *array=@[@"排名",@"玩家",@"胜利点数",@"所属战队"];
    for(int i=0;i<4;i++)
    {
        CGFloat xpos=(kWidth/4)*i;
        UILabel *lb=[Tools createLabelWithFrame:CGRectMake(xpos, 0, kWidth/4, 40) text:array[i] textColor:[UIColor blackColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
        [head addSubview:lb];
    }
    return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)dealloc
{
    _sifterView.hidden=YES;
    _sifterView=nil;
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
