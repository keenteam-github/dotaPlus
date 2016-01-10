//
//  TeamDetailViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/3.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "GeneralViewController.h"
#import "DataParser.h"
#import "MemberCell.h"

@interface TeamDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tbView;
    NSMutableArray *_dataArray;
}
@end

@implementation TeamDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    [self createTitleViewWithText:@"战队详情"];
    [self createBackBtn];
    [self createTableView];
}
-(void)createTableView
{
    _tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStyleGrouped];
    _tbView.separatorColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    [self.view addSubview:_tbView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_members.count>0)
        return _members.count;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"memberCellID";
    MemberCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MemberCell" owner:nil options:nil] lastObject];
    Player *player=nil;
    if(_members.count>indexPath.row)
        player=_members[indexPath.row];
    [cell cellWithPlayer:player];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *player=nil;
    if(_members.count>indexPath.row)
        player=_members[indexPath.row];
    GeneralViewController *general=[[GeneralViewController alloc]init];
    general.account_id=player.playerID;
    general.showsBackBtn=YES;
    
    [self.view.superview setTransitionAnimationType:PSBTransitionAnimationTypePush toward:PSBTransitionAnimationTowardFromRight duration:0.3];
    [self.navigationController pushViewController:general animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70)];
    UIImageView *teamLogView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 100, 60)];
    [teamLogView setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:[UIImage imageNamed:@"heroPlaceHolder.png"]];
    teamLogView.layer.cornerRadius=10;
    teamLogView.clipsToBounds=YES;
    [hView addSubview:teamLogView];
    
    UILabel *lb=[Tools createLabelWithFrame:CGRectMake(140, 15, kWidth-160, 40) text:self.name textColor:[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f] textAligment:NSTextAlignmentCenter andBgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:30]];
    [hView addSubview:lb];
    return hView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
@end
