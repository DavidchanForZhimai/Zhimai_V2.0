//
//  MeetingVC.m
//  Lebao
//
//  Created by adnim on 16/8/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetingVC.h"
#import "MJRefresh.h"
#import "MeetingTVCell.h"
#import "MeetHeadV.h"
#import "CoreArchive.h"
#import "ViewController.h"
@interface MeetingVC ()<UITableViewDelegate,UITableViewDataSource,MeetHeadVDelegate>
@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,strong)UIButton *yrBtn;
@property (nonatomic,strong)MeetHeadV *headView;
@end

@implementation MeetingVC
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    _headView.startAndStopTimerBlock = ^(NSTimer *timer1,NSTimer *timer2,NSTimer *timer3)
    {
        [timer1 fire];
        [timer2 fire];
        [timer3 fire];
    };
    if ([CoreArchive strForKey:@"isread"]) {
        [self.homePageBtn setImage:[UIImage imageNamed:@"xingxi"] forState:UIControlStateNormal];
    }
    else
    {
        [self.homePageBtn setImage:[UIImage imageNamed:@"xingxi"] forState:UIControlStateNormal];
    }

    self.homePageBtn.hidden = NO;
    [self shakeToShow:_yrBtn];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _headView.startAndStopTimerBlock = ^(NSTimer *timer1,NSTimer *timer2,NSTimer *timer3)
    {
        [timer1 invalidate];
        [timer2 invalidate];
        [timer3 invalidate];
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitle:@"约见"];
    [self.view addSubview:self.homePageBtn];
    [self setTabbarIndex:0];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [self addTabView];
    [self addYrBtn];
    [self navLeftAddressBtn];
}


-(void)addYrBtn
{
    _yrBtn=[[UIButton alloc]init];
    _yrBtn.frame=CGRectMake(APPWIDTH-30-50, APPHEIGHT-124, 60, 60);
    [_yrBtn setBackgroundImage:[UIImage imageNamed:@"youkong"] forState:UIControlStateNormal];
    
    [_yrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _yrBtn.clipsToBounds=YES;
    _yrBtn.layer.cornerRadius=_yrBtn.width/2.0;
    _yrBtn.tag=1000;
    [_yrBtn addTarget:self action:@selector(_yrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yrBtn];
    
    
}
-(void)addTabView
{
    _yrTab=[[UITableView alloc]init];
    _yrTab.frame=CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight + TabBarHeight));
    _yrTab.delegate=self;
    _yrTab.dataSource=self;
    _yrTab.backgroundColor=[UIColor clearColor];
    _yrTab.tableFooterView=[[UIView alloc]init];
    _yrTab.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    _yrTab.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        
        [_yrTab.mj_header endRefreshing];
    }];
    
    _yrTab.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreXS)];
    
    [self.view addSubview:_yrTab];
    
    
    _headView=[[MeetHeadV alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, 254)];
    _headView.delegate = self;
    self.yrTab.tableHeaderView=_headView;

    
}
#pragma mark
#pragma mark -MeetHeadV 代理方法
- (void)pushView:(UIViewController *)viewC userInfo:(id)userInfo
{
    PushView(self, viewC);
    
}
- (void) shakeToShow:(UIView*)aView//放大缩小动画
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

-(void)_yrBtnClick:(UIButton *)sender
{
    [self shakeToShow:_yrBtn];
    if (sender.tag==1000) {
        _yrBtn.tag=1001;
        [_yrBtn setBackgroundImage:[UIImage imageNamed:@"yiyoukong"] forState:UIControlStateNormal];
    }else{
        sender.tag=1000;
        [_yrBtn setBackgroundImage:[UIImage imageNamed:@"youkong"] forState:UIControlStateNormal];
    }
    
}

#pragma mark----tableview代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 170;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yrCell"];
    cell=[[MeetingTVCell alloc]initWithFrame:CGRectMake(0, 0, _yrTab.size.width, 160)];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}
#pragma mark - 选择地址
-(void)navLeftAddressBtn
{
    if (![CoreArchive strForKey:AddressID]) {
        [CoreArchive setStr:@"全国" key:LocationAddress];
        [CoreArchive setStr:@"0" key:AddressID];
        
    }
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    UILabel *lbUp = allocAndInit(UILabel);
    CGSize sizeUp = [lbUp sizeWithContent:[CoreArchive strForKey:LocationAddress] font:[UIFont systemFontOfSize:28*SpacedFonts]];
    float sizeW = sizeUp.width;
    if (sizeUp.width>=140*SpacedFonts) {
        sizeW = 160*SpacedFonts;
    }
    _selectedAddress  =[[BaseButton alloc]initWithFrame:frame(0, StatusBarHeight, sizeW + 15 + upImage.size.width, NavigationBarHeight) setTitle:[CoreArchive strForKey:LocationAddress] titleSize:28*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:upImage highlightImage:nil setTitleOrgin:CGPointMake( (NavigationBarHeight -28*SpacedFonts)/2.0 ,10-(upImage.size.width)) setImageOrgin:CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15) inView:self.view];
    __weak MeetingVC *weakSelf =self;
    _selectedAddress.didClickBtnBlock =^
    {
        ViewController *vc=[[ViewController alloc]init];
        
        [vc returnText:^(NSString *cityname,NSString *cityID) {
            
            [weakSelf.selectedAddress setTitle:cityname forState:UIControlStateNormal];
            //            [weakSelf resetSeletedAddressFrame];
            
            //            xspageNumb = 1;
            //            if (weakSelf.xsJsonArr.count >0) {
            //                [weakSelf.xsJsonArr removeAllObjects];
            //            }
            //
            //            [weakSelf.xsTab reloadData];
            //            [weakSelf getxsJson];
            
            
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
