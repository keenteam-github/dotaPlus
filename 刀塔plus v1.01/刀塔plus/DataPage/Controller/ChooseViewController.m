//
//  ChooseViewController.m
//  刀塔plus
//
//  Created by 峰哥哥-.- on 15/7/4.
//  Copyright (c) 2015年 峰哥哥-.-. All rights reserved.
//

#import "ChooseViewController.h"

@interface ChooseViewController ()
{
    UILabel *_rarityLabel;
    UILabel *_qulityLabel;
    NSString *_rarity;
    NSString *_qulity;
    
    NSString *_rarityValue;
    NSString *_qulityValue;
}
@end

@implementation ChooseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rarity=@"全部";
    _qulity=@"全部";
    
    _rarityValue=@"";
    _qulityValue=@"";
    
    [self createTitleViewWithText:@"饰品分类"];
    [self createBackBtn];
    [self createRarityList];
    [self createQulityList];
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createRarityList
{
    UIColor *mainColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
//    稀有度
    NSArray *rarityArray=@[@"全部",@"普通",@"罕见",@"稀有",@"神话",@"传说",@"远古",@"不朽",@"至宝"];
    /*-----------------------------------------------------------------*/
    _rarityLabel=[Tools createLabelWithFrame:CGRectMake(20, 70, 160, 30) text:[NSString stringWithFormat:@"稀有度:%@",_rarity] textColor:mainColor textAligment:NSTextAlignmentLeft andBgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:24]];
        [self.view addSubview:_rarityLabel];
//    分割线
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 108, kWidth-40, 2)];
    lineLabel.backgroundColor=[UIColor purpleColor];
    [self.view addSubview:lineLabel];
//    若干稀有度按钮
    for(int i=0;i<rarityArray.count;i++)
    {
        CGFloat marginX=10;
        CGFloat marginY=10;
        NSInteger col=i%5;
        NSInteger row=i/5;
        CGFloat btnWidth=(kWidth-40-4*marginX)/5;
        CGFloat btnHeight=20;
        CGFloat xpos=20+col*(marginX+btnWidth);
        CGFloat ypos=120+row*(marginY+btnHeight);
        
        UIButton *btn=[Tools createBtnWithFrame:CGRectMake(xpos, ypos, btnWidth, btnHeight) title:rarityArray[i] titleColor:[UIColor blackColor] target:self action:@selector(clickRarityBtn:)];
        btn.layer.cornerRadius=10;
        btn.titleLabel.font=[UIFont systemFontOfSize:11];
        btn.layer.borderColor=mainColor.CGColor;
        btn.layer.borderWidth=1;
        btn.tag=100+i;
        [self.view addSubview:btn];
        if(i==0)
            btn.backgroundColor=mainColor;
    }
}
//选择稀有度
-(void)clickRarityBtn:(UIButton *)sender
{
    NSArray *rarityArray=@[@"全部",@"普通",@"罕见",@"稀有",@"神话",@"传说",@"远古",@"不朽",@"至宝"];
    NSArray *rarityValuesArray=@[@"",@"common",@"uncommon",@"rare",@"mythical",@"legendary",@"ancient",@"immortal",@"arcana"];
    sender.backgroundColor=[UIColor colorWithRed:230.0/255.0f green:46.0/255.0f blue:37.0/255.0f alpha:1.0f];
    _rarity=sender.currentTitle;
    _rarityLabel.text=[NSString stringWithFormat:@"稀有度:%@",_rarity];
    NSInteger index=[rarityArray indexOfObject:_rarity];
    _rarityValue=[rarityValuesArray objectAtIndex:index];
    for(int i=0;i<rarityArray.count;i++)
    {
        UIButton *btn=(UIButton *)[self.view viewWithTag:100+i];
        if(i!=sender.tag-100)
            btn.backgroundColor=[UIColor whiteColor];
    }
}
-(void)createQulityList
{
    UIColor *mainColor=[UIColor colorWithRed:92.0/255.0f green:192.0/255.0f blue:29.0/255.0f alpha:1.0f];
    //    品质
    NSArray *qulityArray=@[@"全部",@"基础",@"纯正",@"上古",@"独特",@"标准",@"社区",@"Valve",@"自制",@"自定义",@"铭刻",@"完整",@"凶煞",@"英雄传世",@"青睐",@"传奇",@"亲笔签名",@"绝版",@"尊享",@"冻人",@"冥灵",@"吉祥"];
    /*-----------------------------------------------------------------*/
    _qulityLabel=[Tools createLabelWithFrame:CGRectMake(20, 180, 200, 30) text:[NSString stringWithFormat:@"品质:%@",_qulity] textColor:mainColor textAligment:NSTextAlignmentLeft andBgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:24]];
    [self.view addSubview:_qulityLabel];
    //    分割线
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 218, kWidth-40, 2)];
    lineLabel.backgroundColor=[UIColor purpleColor];
    [self.view addSubview:lineLabel];
    
    
    CGFloat marginX=10;
    CGFloat marginY=10;
    CGFloat btnWidth=(kWidth-40-4*marginX)/5;
    CGFloat btnHeight=20;
    //    若干稀有度按钮
    for(int i=0;i<qulityArray.count;i++)
    {
        NSInteger col=i%5;
        NSInteger row=i/5;
        CGFloat xpos=20+col*(marginX+btnWidth);
        CGFloat ypos=230+row*(marginY+btnHeight);
        
        UIButton *btn=[Tools createBtnWithFrame:CGRectMake(xpos, ypos, btnWidth, btnHeight) title:qulityArray[i] titleColor:[UIColor blackColor] target:self action:@selector(clickQulityBtn:)];
        btn.layer.cornerRadius=10;
        btn.layer.borderColor=mainColor.CGColor;
        btn.layer.borderWidth=1;
        btn.titleLabel.font=[UIFont systemFontOfSize:11];
        btn.tag=200+i;
        [self.view addSubview:btn];
        if(i==0)
            btn.backgroundColor=mainColor;
    }
//    确定按钮
    UIButton *doneBtn=[Tools createBtnWithFrame:CGRectMake(kWidth-60, 390, 40, 40) title:@"完成" titleColor:[UIColor blackColor] target:self action:@selector(doneAction)];
//    doneBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    doneBtn.layer.cornerRadius=20;
    doneBtn.layer.borderColor=[UIColor blueColor].CGColor;
    doneBtn.layer.borderWidth=1;
    [self.view addSubview:doneBtn];
}
//选择品质
-(void)clickQulityBtn:(UIButton *)sender
{
    NSArray *qulityArray=@[@"全部",@"基础",@"纯正",@"上古",@"独特",@"标准",@"社区",@"Valve",@"自制",@"自定义",@"铭刻",@"完整",@"凶煞",@"英雄传世",@"青睐",@"传奇",@"亲笔签名",@"绝版",@"尊享",@"冻人",@"冥灵",@"吉祥"];
    NSArray *qulityValuesArray=@[@"",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    sender.backgroundColor=[UIColor colorWithRed:92.0/255.0f green:192.0/255.0f blue:29.0/255.0f alpha:1.0f];
    _qulity=sender.currentTitle;
    _qulityLabel.text=[NSString stringWithFormat:@"品质:%@",_qulity];
    NSInteger index=[qulityArray indexOfObject:_qulity];
    _qulityValue=[qulityValuesArray objectAtIndex:index];
    for(int i=0;i<qulityArray.count;i++)
    {
        UIButton *btn=(UIButton *)[self.view viewWithTag:200+i];
        if(i!=sender.tag-200)
            btn.backgroundColor=[UIColor whiteColor];
    }
}
//确定
-(void)doneAction
{
    if(_rarityValue.length>0||_qulityValue.length>0)
    {
        if(self.chooseDidFinishBlock)
            self.chooseDidFinishBlock(_rarity,_qulity,_rarityValue,_qulityValue);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
