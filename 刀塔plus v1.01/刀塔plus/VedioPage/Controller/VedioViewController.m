//
//  VedioViewController.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "VedioViewController.h"
#import "VedioParser.h"
#import "LiveCell.h"
#import "PlayViewController.h"
#import "DotaExPlainerModel.h"
//#import "LivePageViewController.h"
#import "JXFHVideoCell.h"
#import "VideoMenuCell.h"
#import "VideoListViewController.h"
//#import "EGORefreshTableFooterView.h"

@interface VedioViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate>


//    数据源数组
//@property(nonatomic,strong)NSMutableArray *liveArray;
@property(nonatomic,strong)NSMutableArray *dotaArray;
@property(nonatomic,strong)NSMutableArray *dota2Array;
@property(nonatomic,strong)NSMutableArray *jxfhDataArray;
//表视图
//@property(nonatomic,strong)UITableView *liveTableView;
@property(nonatomic,strong)UITableView *dTableView;
@property(nonatomic,strong)UITableView *d2TableView;
@property(nonatomic,strong)UITableView *jxfhTableView;
//    标记加载状态
//@property(nonatomic,assign)BOOL isLiveLoading;
@property(nonatomic,assign)BOOL isDLoding;
@property(nonatomic,assign)BOOL isD2Loding;
@property(nonatomic,assign)BOOL isJxfhLoading;

@property(nonatomic,strong)UILabel *flag;
@property(nonatomic,strong)UIButton *lastClassBtn;
@property(nonatomic,strong)UIScrollView *tableScrollView;

@property(nonatomic,strong)EGORefreshTableHeaderView *dheader;
//@property(nonatomic,strong)EGORefreshTableFooterView *dfooter;
@property(nonatomic,strong)EGORefreshTableHeaderView *d2header;
//@property(nonatomic,strong)EGORefreshTableFooterView *d2footer;
@property(nonatomic,strong)EGORefreshTableHeaderView *jxfhHeader;
//@property(nonatomic,strong)EGORefreshTableFooterView *jxfhFooter;

@end

@implementation VedioViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
//    [self resetEgoFooter];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
   
    [self createTitleView];
    [self createClassBtn];
    
//    _liveArray=[NSMutableArray array];
    _dotaArray=[NSMutableArray array];
    _dota2Array=[NSMutableArray array];
    _jxfhDataArray=[NSMutableArray array];
    [self createTableView];
    
//    [self downloadLiveData];
    [self downloadDotaList];
    [self downloadDota2List];
    [self downloadJxfhList];
}
//标题视图
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"视频plus" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:30]];
    [self.view addSubview:lb];
}
-(void)createClassBtn
{
    //    添加3个按钮，直播，Dota视频，Dota2视频，剑雪封喉
    NSArray *classBtnTitles=@[@"LOL视频",@"Dota视频",@"剑灵"/*,@"直播"*/];
    CGFloat classBtnWith=((kWidth-20*3)/3);
    for(int i=0;i<3;i++)
    {
        CGFloat xpos=10+i*(20+classBtnWith);
        UIButton *classBtn=[Tools createBtnWithFrame:CGRectMake(xpos, 70, classBtnWith, 20) title:classBtnTitles[i] titleColor:[UIColor blackColor] target:self action:@selector(changeClass:)];
    
        classBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        if(i==0)
        {
            [classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _lastClassBtn=classBtn;
        }
        classBtn.backgroundColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
        classBtn.tag=i+100;
        [self.view addSubview:classBtn];
    }
    //    标记
    _flag=[[UILabel alloc]initWithFrame:CGRectMake(10, 92, classBtnWith, 2)];
    _flag.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_flag];
}
//点击分类按钮的方法
-(void)changeClass:(UIButton *)sender
{
    CGFloat xpos=sender.frame.origin.x;
    
    __weak VedioViewController *weakSelf=self;
    
    [UIView animateWithDuration:0.5 animations:^{
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weakSelf.lastClassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//改变上一个点击按钮的颜色
        CGRect frame=weakSelf.flag.frame;
        frame.origin.x=xpos;
        weakSelf.flag.frame=frame;
        weakSelf.tableScrollView.contentOffset=CGPointMake(kWidth*(sender.tag-100), 0);
    }completion:^(BOOL finished) {
        weakSelf.lastClassBtn=sender;//当前按钮赋值给最后一次点击的按钮
    }];
}

////下载直播数据
//-(void)downloadLiveData
//{
//    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
//    _isLiveLoading=YES;
//    
//    __weak VedioViewController *weakSelf=self;
//    
//    [DataService getDataWithUrlString:kLiveUrl andCallBackBlock:^(NSData *receivedData) {
//            if(receivedData.length>0)
//            {
//            VedioParser *parser=[VedioParser paserWithData:receivedData];
//            NSArray *array=[parser parseLive];
//            if(array.count>0)
//            {
////                接收到数据后，清空之前的数据
//                [weakSelf.liveArray removeAllObjects];
////                添加新的数据
//                weakSelf.liveArray=[NSMutableArray arrayWithArray:array];
////                刷新表格
//                [weakSelf.liveTableView reloadData];
//            }
//        }
//        weakSelf.isLiveLoading=NO;
//        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
//    }];
//}
//下载Dota全部视频解说列表
-(void)downloadDotaList
{
    _isDLoding=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    
    __weak VedioViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:kVideoMenuListUrl andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary=(NSDictionary *)result;
                NSArray *array=dictionary[@"authors"];
                if(array.count>0)
                {
                    //                接收到数据后，清空之前的数据
                    [weakSelf.dotaArray removeAllObjects];
                    for(NSDictionary *dict in array)
                    {
                        VideoMenuModel *model=[VideoMenuModel modelWithDictionary:dict];
                        if(model)
                        {
                            if([model.name isEqualToString:@"LOL视频"]||[model.name isEqualToString:@"剑灵"])
                                continue;
                           [weakSelf.dotaArray addObject:model];
                        }
                    }
                }
            }
        }
        [weakSelf.dTableView reloadData];
        [weakSelf.dheader egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.dTableView];

        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
        weakSelf.isDLoding=NO;
    }];
}
//下载Dota2全部视频解说列表
-(void)downloadDota2List
{
    _isD2Loding=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    
    __weak VedioViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:kDota2List andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary=(NSDictionary *)result;
                NSArray *array=dictionary[@"videos"];
                if(array.count>0)
                {
                    dispatch_queue_t dataQueue=dispatch_queue_create("dataQueue", DISPATCH_QUEUE_CONCURRENT);
                    dispatch_async(dataQueue, ^{
                        
                        //                移除之前的数据
                        [weakSelf.dota2Array removeAllObjects];
                    
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
                                    [weakSelf.dota2Array addObject:model];
                        }
                    });
                }
            }
        }
        weakSelf.isD2Loding=NO;
        [weakSelf.d2TableView reloadData];
        [weakSelf.d2header egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.d2TableView];
     
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
//下载剑雪封喉的视频列表
-(void)downloadJxfhList
{
    _isJxfhLoading=YES;
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    
    __weak VedioViewController *weakSelf=self;
    
    [DataService getDataWithUrlString:kJXFHList andCallBackBlock:^(NSData *receivedData) {
        if(receivedData.length>0)
        {
            id result=[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
            if([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary=(NSDictionary *)result;
                NSArray *array=dictionary[@"videos"];
                if(array.count>0)
                {
                    dispatch_queue_t dataQueue=dispatch_queue_create("dataQueue", DISPATCH_QUEUE_CONCURRENT);
                    dispatch_async(dataQueue, ^{
                        //                移除之前的数据
                        [weakSelf.jxfhDataArray removeAllObjects];
                        
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
                                    [weakSelf.jxfhDataArray addObject:model];
                            
                        }
                    });
                }
            }
        }
        [weakSelf.jxfhTableView reloadData];
        
        [weakSelf.jxfhHeader egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.jxfhTableView];
       
        weakSelf.isJxfhLoading=NO;
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
}
//-(void)resetEgoFooter
//{
//    CGFloat jxfhHeight=MAX(_jxfhTableView.bounds.size.height, _jxfhTableView.contentSize.height);
//    _jxfhFooter.frame=CGRectMake(0, jxfhHeight, kWidth, 0);
//    
//    CGFloat dHeight=MAX(_dTableView.bounds.size.height, _dTableView.contentSize.height);
//    _dTableView.frame=CGRectMake(kWidth, dHeight, kWidth, 0);
//    
//    CGFloat d2Height=MAX(_d2TableView.bounds.size.height, _d2TableView.contentSize.height);
//    _d2TableView.frame=CGRectMake(2*kWidth, d2Height, kWidth, 0);
//}
//创建表视图
-(void)createTableView
{
//  滚动视图
    _tableScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kWidth, kHeight-100-49)];
    _tableScrollView.pagingEnabled=YES;
    _tableScrollView.showsHorizontalScrollIndicator=NO;
    _tableScrollView.contentSize=CGSizeMake(3*kWidth, kHeight-100-49);
    [self.view addSubview:_tableScrollView];
    _tableScrollView.delegate=self;
    
////    直播表视图
//    _liveTableView=[[UITableView alloc]initWithFrame:CGRectMake(3*kWidth, 0, kWidth, kHeight-100-49) style:UITableViewStyleGrouped];
//    _liveTableView.delegate=self;
//    _liveTableView.dataSource=self;
//    _liveTableView.separatorColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
////    _liveTableView.backgroundView=[self createBgView];
//    [_tableScrollView addSubview:_liveTableView];
    
//    Dota视屏解说表视图
    _dTableView=[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-100-49) style:UITableViewStyleGrouped];
    _dTableView.delegate=self;
    _dTableView.dataSource=self;
    _dTableView.separatorColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
//    _dTableView.backgroundView=[self createBgView];
    [_tableScrollView addSubview:_dTableView];
    
    _dheader=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_dTableView.bounds.size.height, kWidth, _dTableView.bounds.size.height)];
    [_dTableView addSubview:_dheader];
    _dheader.delegate=self;
   
    
//    Dota2视屏解说表
    _d2TableView=[[UITableView alloc]initWithFrame:CGRectMake(2*kWidth, 0, kWidth, kHeight-100-49) style:UITableViewStyleGrouped];
    _d2TableView.delegate=self;
    _d2TableView.dataSource=self;
    _d2TableView.separatorColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
//    _d2TableView.backgroundView=[self createBgView];
    [_tableScrollView addSubview:_d2TableView];
    
    _d2header=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_d2TableView.bounds.size.height, kWidth, _d2TableView.bounds.size.height)];
    [_d2TableView addSubview:_d2header];
    _d2header.delegate=self;
   
    
//    剑雪封喉解说的视频列表
    _jxfhTableView=[[UITableView alloc]initWithFrame:_tableScrollView.bounds style:UITableViewStyleGrouped];
    _jxfhTableView.delegate=self;
    _jxfhTableView.dataSource=self;
    _jxfhTableView.separatorColor=[UIColor colorWithRed:82/255.f green:192/255.f blue:29/255.f alpha:1];
//    _jxfhTableView.backgroundView=[self createBgView];
    [_tableScrollView addSubview:_jxfhTableView];
    
    _jxfhHeader=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -_jxfhTableView.bounds.size.height, kWidth, _jxfhTableView.bounds.size.height)];
    [_jxfhTableView addSubview:_jxfhHeader];
    _jxfhHeader.delegate=self;
    
}
#pragma mark-表视图协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(tableView==_liveTableView)
//    {
//        if(_liveArray.count>0)
//            return _liveArray.count;
//        return 0;
//    }
    if(tableView==_dTableView)
    {
        if(_dotaArray.count>0)
            return _dotaArray.count;
        return 2;
    }
    else if(tableView==_d2TableView)
    {
        if(_dota2Array.count>0)
            return _dota2Array.count;
        return 0;
    }
    else
    {
        if(_jxfhDataArray.count>0)
            return _jxfhDataArray.count;
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView==_liveTableView)
//        return 65;
    if(tableView==_dTableView)
        return 70;
    else if(tableView==_d2TableView)
        return 80;
    else
        return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView==_liveTableView)
//    {
//        static NSString *liveCellID=@"liveCellID";
//        LiveCell *cell=[tableView dequeueReusableCellWithIdentifier:liveCellID];
//        if(!cell)
//            cell=[[[NSBundle mainBundle] loadNibNamed:@"LiveCell" owner:nil options:nil] lastObject];
//        LiveModel *model=nil;
//        if(_liveArray.count>0)
//            model=_liveArray[indexPath.row];
//        [cell cellWithLiveModel:model];
//        cell.backgroundColor=[UIColor clearColor];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
////        cell.backgroundColor=[UIColor clearColor];
//        return cell;
//    }
    if(tableView==_dTableView)
    {
        static NSString *cellID=@"VideoMenuCellID";
        VideoMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell)
            cell=[[[NSBundle mainBundle] loadNibNamed:@"VideoMenuCell" owner:nil options:nil] lastObject];
        VideoMenuModel *model=nil;
        if(_dotaArray.count>indexPath.row)
            model=_dotaArray[indexPath.row];
        [cell cellWithVideoMenuModel:model atIndex:indexPath.row];
        
        return cell;
    }
    else if(tableView==_d2TableView)
    {
        static NSString *cellID=@"JXFHCellID";
        JXFHVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell)
            cell=[[[NSBundle mainBundle] loadNibNamed:@"JXFHVideoCell" owner:nil options:nil] lastObject];
        JXFHVideoModel *model=nil;
        if(_dota2Array.count>0)
            model=_dota2Array[indexPath.row];
        [cell cellWithJXFHModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellID=@"JXFHCellID";
        JXFHVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell)
            cell=[[[NSBundle mainBundle] loadNibNamed:@"JXFHVideoCell" owner:nil options:nil] lastObject];
        JXFHVideoModel *model=nil;
        if(_jxfhDataArray.count>0)
            model=_jxfhDataArray[indexPath.row];
        [cell cellWithJXFHModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView==_dTableView)
    {
        return @"Dota视频";
    }
    else if(tableView==_d2TableView)
    {
        return @"剑灵视频";
    }
    else
        return @"LOL视频";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView==_liveTableView)
//    {
//        NSString *urlString=nil;
//        LiveModel *model=nil;
//        if(_liveArray.count>0)
//            model=_liveArray[indexPath.row];
//        urlString=[NSString stringWithFormat:kLivePlayUrl,model.live_type,model.live_id];
//        LivePageViewController *page=[[LivePageViewController alloc]init];
//        page.urlString=urlString;
//        //    设置动画
//        [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromLeft duration:0.5];
//        //    隐藏tabBar
//        self.hidesBottomBarWhenPushed=YES;
//        //    导航推出
//        [self.navigationController pushViewController:page animated:YES];
//        //    显示tabBar
//        self.hidesBottomBarWhenPushed=NO;
//    }
    if(tableView==_dTableView)
    {
        VideoListViewController *list=[[VideoListViewController alloc]init];
        VideoMenuModel *model=nil;
        if(_dotaArray.count>indexPath.row)
            model=_dotaArray[indexPath.row];
        list.authorID=model.authorID;
        list.authorName=model.name;
        
        //    设置动画
        [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCube toward:PSBTransitionAnimationTowardFromLeft duration:0.3];
        //    导航推出
        [self.navigationController pushViewController:list animated:YES];
    }
    else if(tableView==_d2TableView)
    {
        PlayViewController *play=[[PlayViewController alloc]init];
        //        NSString *urlString=nil;
        //        [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
        JXFHVideoModel *model=nil;
        if(_dota2Array.count>indexPath.row)
        {
            model=_dota2Array[indexPath.row];
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
    }
    else if(tableView==_jxfhTableView)
    {
        PlayViewController *play=[[PlayViewController alloc]init];
//        NSString *urlString=nil;
      //  [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
        JXFHVideoModel *model=nil;
//        if(_jxfhDataArray.count>0)
//        {
//            model=_jxfhDataArray[indexPath.row];
//            play.urlString=model.realUrl;
//            play.videoTitle=model.title;
////                    设置动画
//           [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypeCameraIris toward:PSBTransitionAnimationTowardFromBottom duration:0.3];
//           //    隐藏tabBar
//         
//
//          
//           //    显示tabBar
//          
//        }
          self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:play animated:YES];
          self.hidesBottomBarWhenPushed=NO;
    }
    
}

#pragma mark-UIScrollViewDelegate协议方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_jxfhHeader egoRefreshScrollViewDidScroll:scrollView];
    [_dheader egoRefreshScrollViewDidScroll:scrollView];
    [_d2header egoRefreshScrollViewDidScroll:scrollView];
    
    __weak VedioViewController *weakSelf=self;
    
    CGPoint offset=_tableScrollView.contentOffset;
    NSInteger index=offset.x/kWidth;
    if(offset.x>120)//过滤掉Y方向
    {
        CGFloat classBtnWith=((kWidth-20*3)/3);
        //        动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_flag.frame;
            frame.origin.x=10+index*(20+classBtnWith);
            weakSelf.flag.frame=frame;
        }completion:^(BOOL finished) {
            
            for(UIView *sub in self.view.subviews)
            {
                if([sub isKindOfClass:[UIButton class]])
                {
                    UIButton *btn=(UIButton *)sub;
                    if(btn.tag>=100&&btn.tag<=102)
                    {
                        if(btn.tag==index+100)
                        {
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            weakSelf.lastClassBtn=btn;
                        }
                        else
                            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
        }];
    }
}
#pragma mark-EGOResfresh协议方法
-(BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
{
    return _isD2Loding||_isDLoding||_isJxfhLoading;
}
-(NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
{
    return [NSDate date];
}
-(void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if(aRefreshPos==EGORefreshHeader)
    {
        [self downloadJxfhList];
        [self downloadDotaList];
        [self downloadDota2List];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_jxfhHeader egoRefreshScrollViewDidEndDragging:scrollView];
    [_dheader egoRefreshScrollViewDidEndDragging:scrollView];
    [_d2header egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
