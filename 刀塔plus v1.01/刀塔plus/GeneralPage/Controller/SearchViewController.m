//
//  SearchViewController.m
//  刀塔plus
//
//  Created by 峰哥哥 on 15/6/19.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//
#define Color   [UIColor colorWithRed:151.0/255.0f green:199.0/255.0f blue:250.0/255.0f alpha:1.0]
#import "SearchViewController.h"
#import "GeneralViewController.h"
#import "Tools.h"
#import "PlayerCell.h"
#import "TFHpple.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UISearchBar *_searchBar;
}
@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIAlertView *alert;
@property(nonatomic,strong)UIAlertView *existAlertView;

@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataArray=[NSMutableArray array];
    self.navigationController.navigationBar.hidden=YES;
    if(_dataArray)
    {
        //           [_dataArray removeAllObjects];
        [_tbView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"搜索绑定";
    [self createSearchBar];
    [self createUI];
}
//创建搜索框
-(void)createSearchBar
{
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kWidth, 44)];
    [self.view addSubview:_searchBar];
    _searchBar.placeholder=@"输入国服LOL账号ID或昵称";
    _searchBar.barStyle=UISearchBarStyleDefault;
    _searchBar.delegate=self;
    
//    searchBar的辅助输入视图  inputAccessoryView=tool
    UIToolbar *tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 35)];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *itemsArray=@[spaceItem,doneItem];
    tool.items=itemsArray;
    _searchBar.inputAccessoryView=tool;
}
//隐藏键盘
-(void)doneAction
{
    [self.view endEditing:YES];
}
-(void)createUI
{
    UILabel *label=[Tools createLabelWithFrame:CGRectMake(40, 200, kWidth-80, 80) text:@"您需要在LOL客户端中打开\"共享我的比赛数据\"！" textColor:[UIColor whiteColor] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:16]];
    label.alpha=0.5;
    label.layer.cornerRadius=10;
    label.numberOfLines=0;
    label.clipsToBounds=YES;
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64+44, kWidth, kHeight-64-44)];
    bgView.image=[UIImage imageNamed:@"bg3.jpg"];
    [self.view addSubview:bgView];
    [self.view addSubview:label];
    
//    标题视图
    [self createTitleView];
//    表视图
    [self createTableView];
    
}
-(void)createTitleView
{
    UIColor *color=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    titleLabel.backgroundColor=color;
    [self.view addSubview:titleLabel];
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(kWidth-130, 10, 120, 54) text:@"搜索" textColor:Color textAligment:NSTextAlignmentRight andBgColor:color font:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:lb];
    //    返回按钮
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-UISearchBarDelegate协议方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton=YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton=NO;
    _searchBar.text=nil;
    [_searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [_dataArray removeAllObjects];
    //    将搜索关键字编码成UTF-8格式
    NSString *keyword=[_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString=[NSString stringWithFormat:kSearchUrl,keyword];
    //    提示标签
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    __weak SearchViewController *weakSelf=self;
    
    [[MyDownloader downloader] downloadWithUrlString:urlString successBlock:^(NSData *data) {
        NSString *contents=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if(!contents)
        {
            weakSelf.existAlertView=[[UIAlertView alloc]initWithTitle:@"错误" message:@"账号不存在!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [weakSelf.existAlertView show];
            [weakSelf performSelector:@selector(dismissExistAlertView) withObject:nil afterDelay:2];
            [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
            return;
        }
        NSRange range1=[contents rangeOfString:@">玩家:"];
        if(range1.location==NSNotFound)
        {
            weakSelf.alert=[[UIAlertView alloc]initWithTitle:@"错误" message:@"此账号没有开启共享比赛数据！您需要在LOL客户端中打开”共享我的比赛数据“" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [weakSelf.alert show];
            [weakSelf performSelector:@selector(dismissAlertView) withObject:nil afterDelay:2];
            [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
            return;
        }
        NSString *tmp1=[contents substringFromIndex:range1.location+range1.length];
        NSRange range2=[tmp1 rangeOfString:@"</table>"];
        NSString *tmp2=[tmp1 substringToIndex:range2.location];
        
        TFHpple *paser=[[TFHpple alloc]initWithHTMLData:[tmp2 dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray *root1=[paser searchWithXPathQuery:@"//td"];
        for(TFHppleElement *elment in root1)
        {
            Player *player=[Player player];
            TFHppleElement *ele=[[elment children] firstObject];//img
            player.playIcon=[ele attributes][@"src"];
            player.playerName=[[[[[elment children]lastObject]children] firstObject] content];
            player.playerID=[[[[[[elment children]lastObject]children] lastObject] content] stringByReplacingOccurrencesOfString:@" " withString:@""];
            [weakSelf.dataArray addObject:player];
        }
        [weakSelf.tbView reloadData];
        //    加载完后消失
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    } failedBlock:^(NSError *error) {
        [GMDCircleLoader hideFromView:weakSelf.view animated:YES];
    }];
   }
//让警告视图消失
-(void)dismissAlertView
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)dismissExistAlertView
{
    [_existAlertView dismissWithClickedButtonIndex:0 animated:YES];
}
//创建表视图
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kWidth, kHeight-64-44-49) style:UITableViewStylePlain];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    _tbView.backgroundColor=[UIColor clearColor];
    _tbView.separatorColor=[UIColor colorWithRed:129.0/255.0f green:43.0/255.0f blue:196.0/255.0f alpha:1.0f];
    [self.view addSubview:_tbView];
}
#pragma mark -表视图协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count==0)
        return nil;
    static NSString *reuseCellID=@"playerCellID";
    PlayerCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseCellID];
    if(!cell)
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PlayerCell" owner:nil options:nil] lastObject];
    Player *player=_dataArray[indexPath.row];
    [cell cellWithPlayer:player];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *player=_dataArray[indexPath.row];
    if(self.sendValue)
        self.sendValue(player.playerID,NO);
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

