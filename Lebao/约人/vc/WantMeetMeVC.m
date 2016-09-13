//
//  WantMeetMeVC.m
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WantMeetMeVC.h"
#import "MJRefresh.h"
#import "WantMeetTabCell.h"
#import "Parameter.h"
#import "XLDataService.h"
@interface WantMeetMeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,MeettingTableViewDelegate>
{
    UIScrollView * buttomScr;
}
@property (strong,nonatomic)UITableView *oprationTab;
@property (strong,nonatomic)UITableView *agreeTab;
@property (strong,nonatomic)UITableView *refuseTab;
@property (strong,nonatomic)UIButton *oprationBtn;
@property (strong,nonatomic)UIButton *agreeBtn;
@property (strong,nonatomic)UIButton *refuseBtn;
@property (nonatomic,strong)UIView *underLineV;//下划线v
@property (nonatomic,assign)int refusePage;
@property (nonatomic,assign)int oprationPage;
@property (nonatomic,assign)int agreePage;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSMutableArray *oprationArr;
@property (nonatomic,strong)NSMutableArray *agreeArr;
@property (nonatomic,strong)NSMutableArray *refuseArr;


@end

@implementation WantMeetMeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navViewTitleAndBackBtn:@"想约见我"];
    
    _refusePage=1;
    _agreePage=1;
    _oprationPage=1;
    _state=@"10";
    _oprationArr=[[NSMutableArray alloc]init];
    _agreeArr=[[NSMutableArray alloc]init];
    _refuseArr=[[NSMutableArray alloc]init];
    [self setButtomScr];
    [self addTheBtnView];
    
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO withState:_state andTabView:_oprationTab andArr:_oprationArr andPage:_oprationPage];
}
/**
 *  最下层的scrollview
 */
-(void)setButtomScr
{
    buttomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight + 36, SCREEN_WIDTH, SCREEN_HEIGHT-(StatusBarHeight + NavigationBarHeight + 36))];
    buttomScr.contentSize = CGSizeMake(SCREEN_WIDTH*3, frameHeight(buttomScr));
    buttomScr.backgroundColor = [UIColor clearColor];
    buttomScr.scrollEnabled = YES;
    buttomScr.delegate = self;
    buttomScr.alwaysBounceHorizontal = NO;
    buttomScr.alwaysBounceVertical = NO;
    buttomScr.showsHorizontalScrollIndicator = NO;
    buttomScr.showsVerticalScrollIndicator = NO;
    buttomScr.pagingEnabled = YES;
    buttomScr.bounces = NO;
    
    [self.view addSubview:buttomScr];
    [self addTheTab];
    
}
/**
 *  上面的3个按钮
 */
-(void)addTheBtnView
{
    _oprationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oprationBtn.frame = CGRectMake(0, 65, SCREEN_WIDTH/3, 35);
    [_oprationBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_oprationBtn setTitle:@"待操作" forState:UIControlStateNormal];
    [_oprationBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_oprationBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _oprationBtn.backgroundColor = [UIColor whiteColor];
    _oprationBtn.selected = YES;
    [_oprationBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_oprationBtn addTarget:self action:@selector(oprationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_oprationBtn];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(SCREEN_WIDTH/3, 65, SCREEN_WIDTH/3, 35);
    [_agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
    [_agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_agreeBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_agreeBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _agreeBtn.backgroundColor = [UIColor whiteColor];
    [_agreeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_agreeBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeBtn];
    
    _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refuseBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, 65, SCREEN_WIDTH/3, 35);
    [_refuseBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
    [_refuseBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_refuseBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [_refuseBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    _refuseBtn.backgroundColor = [UIColor whiteColor];
    [_refuseBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_refuseBtn addTarget:self action:@selector(refuseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refuseBtn];
    
    _underLineV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/3-50)/2, 65+35-2, 50, 2)];
    _underLineV.backgroundColor = [UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000];
    [self.view addSubview:_underLineV];
}
#pragma mark----3个tableview写在这里
-(void)addTheTab
{
    _oprationTab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, buttomScr.frame.size.height) style:UITableViewStyleGrouped];
    _oprationTab.dataSource = self;
    _oprationTab.delegate = self;
    _oprationTab.tableFooterView = [[UIView alloc]init];
    _oprationTab.backgroundColor = [UIColor clearColor];
    _oprationTab.tag = 1;
    _oprationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[ToolManager shareInstance] scrollView:_oprationTab headerWithRefreshingBlock:^{
        
        _oprationPage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:@"10" andTabView:_oprationTab andArr:_oprationArr andPage:_oprationPage];
        
    }];
    [[ToolManager shareInstance] scrollView:_oprationTab footerWithRefreshingBlock:^{
        _oprationPage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:@"10" andTabView:_oprationTab andArr:_oprationArr andPage:_oprationPage];
        
    }];
    
    
    [buttomScr addSubview:_oprationTab];
    
    _agreeTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, buttomScr.frame.size.height) style:UITableViewStyleGrouped];
    _agreeTab.dataSource = self;
    _agreeTab.delegate = self;
    _agreeTab.tableFooterView = [[UIView alloc]init];
    _agreeTab.backgroundColor = [UIColor clearColor];
    _agreeTab.tag = 2;
    _agreeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[ToolManager shareInstance] scrollView:_agreeTab headerWithRefreshingBlock:^{
        
        _agreePage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:@"20" andTabView:_agreeTab andArr:_agreeArr andPage:_agreePage];
        
    }];
    [[ToolManager shareInstance] scrollView:_agreeTab footerWithRefreshingBlock:^{
        _agreePage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:@"20" andTabView:_agreeTab andArr:_agreeArr andPage:_agreePage];
        
    }];
    
    
    [buttomScr addSubview:_agreeTab];
    
    _refuseTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, buttomScr.frame.size.height) style:UITableViewStyleGrouped];
    _refuseTab.dataSource = self;
    _refuseTab.delegate = self;
    
    _refuseTab.tableFooterView = [[UIView alloc]init];
    _refuseTab.backgroundColor = [UIColor clearColor];
    _refuseTab.tag = 3;
    _refuseTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [[ToolManager shareInstance] scrollView:_refuseTab headerWithRefreshingBlock:^{
        
        _refusePage =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES withState:@"99" andTabView:_refuseTab andArr:_refuseArr andPage:_refusePage];
        
    }];
    [[ToolManager shareInstance] scrollView:_refuseTab footerWithRefreshingBlock:^{
        _refusePage ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO withState:@"99" andTabView:_refuseTab andArr:_refuseArr andPage:_refusePage];
        
    }];
    
    
    [buttomScr addSubview:_refuseTab];
    
    
    //    _oprationTab.estimatedRowHeight=280;
    //    _oprationTab.rowHeight=UITableViewAutomaticDimension;
    
}

#pragma mark 请求数据
-(void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData withState:(NSString *)state andTabView:(UITableView *)tabView andArr:(NSMutableArray *)arr andPage:(int)page//加载数据
{
    
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:state forKey:@"state"];
    [param setObject:@(page) forKey:@"page"];
    
    NSLog(@"parem -------------%@",param);
    [XLDataService putWithUrl:WantMeetMeURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing:tabView];
            
        }if (isMoreLoadMoreData) {
            [[ToolManager shareInstance]endFooterWithRefreshing:tabView];
        }if (isShouldClearData) {
            [arr removeAllObjects];
        }
        
        NSLog(@"WantMeetMeURL========%@",dataObj);
        if (dataObj) {
            
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (page ==1) {
                [[ToolManager shareInstance] moreDataStatus:tabView];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:tabView];
                
            }
            
            if (modal.rtcode ==1) {
                
                for (MeetingData *data in modal.datas) {
                    if ([state isEqualToString:@"10"]) {
                        [arr addObject:[[WantMeetLayout alloc]initCellLayoutWithModel:data andBtn:YES]];
                    }else if ([state isEqualToString:@"10"]) {
                        [arr addObject:[[WantMeetLayout alloc]initCellLayoutWithModel:data andBtn:NO]];
                    }else if ([state isEqualToString:@"10"]) {
                        [arr addObject:[[WantMeetLayout alloc]initCellLayoutWithModel:data andBtn:NO]];
                    }
                    
                }
                [tabView reloadData];
                
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
    
}


#pragma mark - 头部3个按钮点击切换事件
-(void)oprationBtn:(UIButton *)sender//待操作
{
    sender.selected = YES;
    _agreeBtn.selected = NO;
    _refuseBtn.selected=NO;
    _state=@"10";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/3-50)/2, 65+35-2, 50, 2)];
        [buttomScr setContentOffset:CGPointMake(0, 0)];
    }];
    if (_oprationArr.count==0) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES withState:_state andTabView:_oprationTab andArr:_oprationArr andPage:_oprationPage];
    }
    
    
}

-(void)agreeBtn:(UIButton *)sender//已同意
{
    sender.selected = YES;
    _oprationBtn.selected = NO;
    _refuseBtn.selected=NO;
    _state=@"20";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/3-50)/2+SCREEN_WIDTH/3, 65+35-2, 50, 2)];
        [buttomScr setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }];
    if (_agreeArr.count==0) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES withState:_state andTabView:_agreeTab andArr:_agreeArr andPage:_agreePage];
        
    }
    
    
}

-(void)refuseBtn:(UIButton *)sender//已拒绝
{
    sender.selected = YES;
    _oprationBtn.selected = NO;
    _agreeBtn.selected=NO;
    _state=@"99";
    [UIView animateWithDuration:0.3f animations:^{
        [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/3-50)/2+SCREEN_WIDTH/3*2, 65+35-2, 50, 2)];
        [buttomScr setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0)];
    }];
    if (_refuseArr.count==0) {
        [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES withState:_state andTabView:_refuseTab andArr:_refuseArr andPage:_refusePage];
    }
    
    
}
#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _oprationTab) {
        WantMeetLayout*layout =(WantMeetLayout*)_oprationArr[indexPath.row];
        
        return layout.cellHeight;
    }else  if (tableView==_agreeTab) {
        
        WantMeetLayout*layout =(WantMeetLayout*)_agreeArr[indexPath.row];
        
        return layout.cellHeight;
    }else  if (tableView==_refuseTab){
        WantMeetLayout*layout =(WantMeetLayout*)_refuseArr[indexPath.row];
        
        return layout.cellHeight;
    }
    return 170;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _oprationTab) {
        return _oprationArr.count;
    }else  if (tableView==_agreeTab) {
        
        return _agreeArr.count;
    }else  if (tableView==_refuseTab){
        return _refuseArr.count;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WantMeetTabCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WMCell"];
    if (!cell) {
        cell=[[WantMeetTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WMCell"];
        cell.backgroundColor=[UIColor clearColor];
    }
    WantMeetLayout *layout;
    if (tableView == _oprationTab) {
        layout =self.oprationArr[indexPath.row];
        [cell.meetingBtn setTitle:@"操作" forState:UIControlStateNormal];
        
    }else  if (tableView==_agreeTab) {
        
        layout =self.agreeArr[indexPath.row];
        
    }else  if (tableView==_refuseTab){
        layout =self.refuseArr[indexPath.row];
    }
    
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
    [cell setDelegate:self];
    
    return cell;
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}

#pragma mark- scrollview代理方法
/**
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = buttomScr.contentOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        if ((int)point.x % (int)SCREEN_WIDTH == 0) {
            if (point.x/SCREEN_WIDTH ==0) {
                _agreeBtn.selected = NO;
                _oprationBtn.selected = YES;
                _refuseBtn.selected=NO;
                [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/3-50)/2, 65+35-2, 50, 2)];
            }else if(point.x/SCREEN_WIDTH ==1)
            {
                
                _agreeBtn.selected = YES;
                _oprationBtn.selected = NO;
                _refuseBtn.selected=NO;
                [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/3-50)/2+SCREEN_WIDTH/3, 65+35-2, 50, 2)];
            }
            else if(point.x/SCREEN_WIDTH ==2)
            {
                
                _agreeBtn.selected = NO;
                _oprationBtn.selected = NO;
                _refuseBtn.selected=YES;
                [_underLineV setFrame:CGRectMake((SCREEN_WIDTH/3-50)/2+SCREEN_WIDTH/3*2, 65+35-2, 50, 2)];
            }
            
        }
        
    }];
    
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
