//
//  MeetingVC.m
//  Lebao
//
//  Created by adnim on 16/8/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetingVC.h"
#import "MJRefresh.h"
#import "MeettingTableViewCell.h"
#import "MeetHeadV.h"
#import "CoreArchive.h"
#import "ViewController.h"
#import "XLDataService.h"
#import "Parameter.h"
#import "LoCationManager.h"
#import "EjectView.h"
#import "MeetNumModel.h"

#import "NSString+Extend.h"
@interface MeetingVC ()<UITableViewDelegate,UITableViewDataSource,MeetHeadVDelegate,EjectViewDelegate,MeettingTableViewDelegate>

@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,strong)UIButton *yrBtn;
@property (nonatomic,strong)MeetHeadV *headView;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearByManArr;
@property (nonatomic,strong)NSMutableArray *headimgArr;
@property (nonatomic,assign)BOOL isopen;
@end

@implementation MeetingVC
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
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

-(NSMutableArray *)nearByManArr
{
    if (!_nearByManArr) {
        _nearByManArr=[[NSMutableArray alloc]init];
    }
    return _nearByManArr;
}
-(NSMutableArray *)headimgArr
{
    if (!_headimgArr) {
        _headimgArr=[[NSMutableArray alloc]init];
    }
    return _headimgArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //新版本提示
    [[ToolManager shareInstance]update];

    [self navViewTitle:@"约见"];
    [self.view addSubview:self.homePageBtn];
    [self setTabbarIndex:0];
    self.view.backgroundColor=AppViewBGColor;
    [self addTabView];
    [self addYrBtn];
    [self navLeftAddressBtn];
     _page = 1;
    _isopen=NO;

    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];

    
}
- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
   
//    [[LoCationManager shareInstance] creatLocationManager];
//    [LoCationManager shareInstance].callBackLocation = ^(CLLocationCoordinate2D location)
//    {
        //测试用,要删掉
    
    
    
    
        CLLocationCoordinate2D location;
        location.latitude=24.491534;
        location.longitude=118.180851;
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
    
        [XLDataService putWithUrl:WantURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            NSLog(@"dataobj%@",dataObj);
             if (dataObj) {
                 
                 MeetNumModel *modal = [MeetNumModel mj_objectWithKeyValues:dataObj];
                 
                 [_headView.meWantBtn setTitle:[NSString stringWithFormat:@"%d\n我想约见",modal.invited] forState:UIControlStateNormal];
                 NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:_headView.meWantBtn.titleLabel.text];
                 [text1 addAttribute:NSFontAttributeName value:Size(40) range:[_headView.meWantBtn.titleLabel.text rangeOfString:[NSString stringWithFormat:@"%d",modal.invited]]];
                 [_headView.meWantBtn setAttributedTitle:text1 forState:UIControlStateNormal];
                 _headView.meWantBtn.titleLabel.numberOfLines = 0;
                 
                 [_headView.wantMeBtn setTitle:[NSString stringWithFormat:@"%d\n想约见我",modal.beinvited] forState:UIControlStateNormal];
                 NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_headView.wantMeBtn.titleLabel.text];
                 [text addAttribute:NSFontAttributeName value:Size(40) range:[_headView.wantMeBtn.titleLabel.text rangeOfString:[NSString stringWithFormat:@"%d",modal.beinvited]]];
                 [_headView.wantMeBtn setAttributedTitle:text forState:UIControlStateNormal];
                 _headView.wantMeBtn.titleLabel.numberOfLines = 0;

                 }
         }];
        [param setObject:[NSString stringWithFormat:@"%.6f",location.latitude] forKey:@"latitude"];
        [param setObject:[NSString stringWithFormat:@"%.6f",location.longitude] forKey:@"longitude"];
        [param setObject:@(_page) forKey:@"page"];
         NSLog(@"param===========%@",param);
        [XLDataService putWithUrl:MeetMainURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
           
            if (isRefresh) {
                
               
                [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
            }
            if (isMoreLoadMoreData) {
                [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
            }
            if (isShouldClearData) {
                [self.nearByManArr removeAllObjects];
                [self.headimgArr removeAllObjects];
            }
            if (dataObj) {
    
                 MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
                if (_page ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_yrTab];;
                }
                if (!modal.datas||modal.datas.count==0) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_yrTab];
                    
                }
                
                if (modal.rtcode ==1) {
                    int i = 0;
                    for (MeetingData *data in modal.datas) {
                        
                        if (i==1||i==4) {
                             data.service= @"d/jf/khjdg/dgdgdgdgf/dg/d/g/dgd/fgdf/gdgdfghgggdfgdfg/dfgdfgdg/dgdgdf/dgdg/d/gdg/ddg/dgdfg/dfgdfg";
                        }
                        
                        if (i==2||i==3) {
                             data.resource= @"djfkgkhjdfgkhjdg/dgdgdfgdfgdfgdgf/dgdgdgdfgdfgdgdfgdfgdfg/dfgdfgdgdgdgdf/dgdgdgdgddg/dgdfgd/fghfh/ghfghfg/fgfgyfyh";
                        }
                        i++;
                        
                       
                        
                        
                        [self.nearByManArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data]];
                        if (data.imgurl!=nil) {
                            [self.headimgArr addObject:data.imgurl];
                        }
                        
                       
                        
                    }

                    _headView.headimgsArr=[NSArray arrayWithArray:self.headimgArr];
                    [_headView addEightImgView];
                    _headView.nearManLab.text=[NSString stringWithFormat:@"最近有空 %d人",modal.count];
                    _headView.midBtn.titleLabel.text=[NSString stringWithFormat:@"可约\n%d\n位经纪人",modal.count];
                    _headView.midBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
                    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:_headView.midBtn.titleLabel.text];
                    [str addAttribute:NSFontAttributeName value:Size(60) range:[_headView.midBtn.titleLabel.text rangeOfString:[NSString stringWithFormat:@"%d",modal.count]]];
                    [_headView.midBtn setAttributedTitle:str forState:UIControlStateNormal];
                    _headView.midBtn.titleLabel.numberOfLines=0;
                    [_yrTab reloadData];
                    
                }
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:modal.rtmsg];
                }
                
            }
            else
            {
              [[ToolManager shareInstance] showInfoWithStatus];
            }
            
            }];

//    };
    
   
    
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
//    [_yrTab registerClass:[MeetingTVCell class] forCellReuseIdentifier:@"yrCell"];
    _yrTab.frame=CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight + TabBarHeight));
    _yrTab.delegate=self;
    _yrTab.dataSource=self;
    _yrTab.backgroundColor=[UIColor clearColor];
    _yrTab.tableFooterView=[[UIView alloc]init];
    _yrTab.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    
    
    [[ToolManager shareInstance] scrollView:_yrTab headerWithRefreshingBlock:^{
        
        _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];
        
    }];
    [[ToolManager shareInstance] scrollView:_yrTab footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
        
    }];
    

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

#pragma mark 有空按钮
-(void)_yrBtnClick:(UIButton *)sender
{
    [self shakeToShow:_yrBtn];
    if (sender.tag==1000) {
        _yrBtn.tag=1001;
        [_yrBtn setBackgroundImage:[UIImage imageNamed:@"yiyoukong"] forState:UIControlStateNormal];
        [sender setEnabled:NO];
        
        [[LoCationManager shareInstance] creatLocationManager];
        [LoCationManager shareInstance].callBackLocation = ^(CLLocationCoordinate2D location)
        {
            NSMutableDictionary *param = [Parameter parameterWithSessicon];
            [param setObject:[NSString stringWithFormat:@"%.6f",location.latitude] forKey:@"latitude"];
            [param setObject:[NSString stringWithFormat:@"%.6f",location.longitude] forKey:@"longitude"];
            

        [XLDataService putWithUrl:MeetAppendURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
                NSLog(@"dataobj=%@",dataObj);
                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                
                if (model.rtcode ==1) {
                    _isopen=YES;
                    NSLog(@"可约人,吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼");
                }
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                }
                [sender setEnabled:YES];
                
            }else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                [sender setEnabled:YES];
                [_yrBtn setBackgroundImage:[UIImage imageNamed:@"youkong"] forState:UIControlStateNormal];
            }
        }];
        
        };
    }else{
        sender.tag=1000;
        [_yrBtn setBackgroundImage:[UIImage imageNamed:@"youkong"] forState:UIControlStateNormal];
    }
    
}

#pragma mark----tableview代理

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

     MeetingCellLayout*layout =(MeetingCellLayout*)_nearByManArr[indexPath.row];
    
    return layout.cellHeight;

 }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return self.nearByManArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellID =@"MeettingTableViewCellID";
    
    MeettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MeettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor=[UIColor clearColor];
        
    }
    
    MeetingCellLayout *layout=self.nearByManArr[indexPath.row];
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
    [cell setDelegate:self];
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}
#pragma mark 
#pragma mark - MeettingTableViewCellDelegate
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath
{
    //do something
    
    CGFloat dilX = 25;
    CGFloat dilH = 250;
    EjectView *alertV = [[EjectView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.navigationController.view];
    alertV.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
    alertV.delegate = self;
    alertV.titleStr = @"提示";
    alertV.title2Str=@"您需要打赏一定的约见费";
    NSLog(@"弹出");
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
//                        [weakSelf resetSeletedAddressFrame];
//            
//                        xspageNumb = 1;
//                        if (weakSelf.xsJsonArr.count >0) {
//                            [weakSelf.xsJsonArr removeAllObjects];
//                        }
//            
//                        [weakSelf.xsTab reloadData];
//                        [weakSelf getxsJson];
            
            
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    
}
//#pragma mark 约见按钮地点击
//-(void)meetBtnClick:(UIButton *)sender
//{
//    
//    CGFloat dilX = 25;
//    CGFloat dilH = 250;
//    EjectView *alertV = [[EjectView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.navigationController.view];
//    alertV.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
//    alertV.delegate = self;
//    alertV.titleStr = @"提示";
//    alertV.title2Str=@"您需要打赏一定的约见费";
//    NSLog(@"弹出");
//    
//}
#pragma mark - YXCustomAlertViewDelegate
- (void) customAlertView:(EjectView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        [customAlertView dissMiss];
        customAlertView = nil;
        
        NSLog(@"取消");
        
    }else
    {
        NSLog(@"确认");
    }
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
