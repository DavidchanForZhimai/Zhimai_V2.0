//
//  WBHomePageVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/11.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "WBHomePageVC.h"
#import "XSCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "JJRDetailVC.h"
#import "XianSuoDetailVC.h"
#import "JingJiRenVC.h"
#import "AppDelegate.h"
#import "MyXSDetailVC.h"
#import "MyLQDetailVC.h" 
#import "ToolManager.h"
#import "CoreArchive.h"
#import "CALayer+Transition.h"
#import "ViewController.h"//选择地址
#import "LoCationManager.h"

#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "GallopUtils.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "PublishDynamicVC.h"//发布动态
#import "DynamicDetailsViewController.h"//动态详情
#define kToolBarH 44
#define kTextFieldH 30
#define xsTabTag  110
#define jjrTabTag 120
@interface WBHomePageVC ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView * buttomScr;
    UIButton * xsBtn;
    UIButton * jjrBtn;
    UIView * xhxV;
    int xspageNumb;
    int jjrpageNumb;
    
    UIImageView *_toolBar;
    UITextField *_textField;
    UIButton  *_sendBtn;
}
@property (strong,nonatomic)NSMutableArray * xsJsonArr;
@property (strong,nonatomic)NSMutableArray * jjrJsonArr;
@property (strong,nonatomic)NSMutableArray * fakeDatasource;
@property (strong,nonatomic)UITableView *xsTab;
@property (strong,nonatomic)UITableView *dtTab;
@property (nonatomic,strong) NSString* replayid;//评论中的rep_brokerid
@property (nonatomic,strong) NSString* dynamicID;//动态ID
@property (nonatomic,strong) NSString* commentType;//评论值为：comment； 回复值为：replay
@property (nonatomic,strong)TableViewCell *commentCell;
@property (nonatomic,strong)NSIndexPath *commentIndex;
@property (strong,nonatomic)BaseButton  *selectedIndustryBg;
@property (strong,nonatomic)NSString  *hyStr;
@property (strong,nonatomic) BaseButton *selectedBtn;
@end

@implementation WBHomePageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CoreArchive strForKey:@"isread"]) {
       [self.homePageBtn setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    }
    else
    {
        [self.homePageBtn setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - KeyboardNotifications

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setTabbarIndex:0];
    [self navViewTitle:@""];
    [self navLeftAddressBtn];
    
    self.homePageBtn.hidden = NO;
    [self.view addSubview:self.homePageBtn];
    
    xspageNumb = 1;
    jjrpageNumb = 1;
    _xsJsonArr = [[NSMutableArray alloc]init];
    _jjrJsonArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
    [self addTheBtnView];
    [self setButtomScr];
    [self getxsJson];
    [self getjjrJson];
    
    //新版本提示
    [[ToolManager shareInstance]update];
    //选择行业
    [self selectIndustry];
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    _selectedBtn =[[BaseButton alloc]initWithFrame:frame((APPWIDTH - (64*SpacedFonts + 5 + upImage.size.width))/2.0, StatusBarHeight, 64*SpacedFonts + 5 + upImage.size.width, NavigationBarHeight)  setTitle:@"全部" titleSize:34*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:upImage highlightImage:nil setTitleOrgin:CGPointMake((NavigationBarHeight - 34*SpacedFonts)/2.0,-upImage.size.width ) setImageOrgin:CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,64*SpacedFonts + 5) inView:self.view];
     __weak WBHomePageVC *weakSelf =self;
    _selectedBtn.shouldAnmial = NO;
    _selectedBtn.didClickBtnBlock = ^
    {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectedIndustryBg.hidden = !weakSelf.selectedIndustryBg.hidden;
        }];

        
    };
    
    //评论
    [self addToolBar];
}


//选择地址
- (void)navLeftAddressBtn
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
    __weak WBHomePageVC *weakSelf =self;
    _selectedAddress.didClickBtnBlock =^
    {
        ViewController *vc=[[ViewController alloc]init];
        
        [vc returnText:^(NSString *cityname,NSString *cityID) {
        
            [weakSelf.selectedAddress setTitle:cityname forState:UIControlStateNormal];
            [weakSelf resetSeletedAddressFrame];
            
            xspageNumb = 1;
            if (weakSelf.xsJsonArr.count >0) {
                [weakSelf.xsJsonArr removeAllObjects];
            }
            
            [weakSelf.xsTab reloadData];
            [weakSelf getxsJson];
        
            
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    

    
}
//选择行业
- (void)selectIndustry
{

    _selectedIndustryBg = [[BaseButton alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT -(StatusBarHeight + NavigationBarHeight + TabBarHeight) ) setTitle:nil titleSize:0 titleColor:WhiteColor textAlignment:0 backgroundColor: rgba(0, 0, 0, 0.3) inView:self.view];
    _selectedIndustryBg.hidden = YES;
    __weak typeof(self) weakSelf =self;
    _selectedIndustryBg.didClickBtnBlock = ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectedIndustryBg.hidden = !weakSelf.selectedIndustryBg.hidden;
        }];
        
        
        
    };
    //四个行业
    UIView *hangye = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_selectedIndustryBg), 60));
    hangye.backgroundColor = WhiteColor;
    [_selectedIndustryBg addSubview:hangye];
    NSMutableArray *arrayHY =[NSMutableArray arrayWithObjects:@"保险",@"金融",@"房产",@"车行", nil];
    float hangyeBtnW = (APPWIDTH - 75)/4.0;
    float hangyeBtnH = 30;
    float hangyeBtnX = 15;
    float hangyeBtnY = 15;
    NSMutableArray *hangyeBtns = allocAndInit(NSMutableArray);
    for (int i =0; i<arrayHY.count; i++) {
        
        BaseButton *hangyeBtn = [[BaseButton alloc]initWithFrame:frame(hangyeBtnX +( hangyeBtnW + hangyeBtnX)*i , hangyeBtnY, hangyeBtnW, hangyeBtnH) setTitle:arrayHY[i] titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:hangye];
        [hangyeBtn setRoundWithfloat:2];
        [hangyeBtn setBorder:LineBg width:0.5];
        
       hangyeBtn.didClickBtnBlock = ^
        {
            [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectedIndustryBg.hidden = YES;
            }];
            
            
            if (![weakSelf.hyStr isEqualToString:@"全部"]) {
                weakSelf.hyStr = arrayHY[i];
            }
            else
            {
                weakSelf.hyStr = @"";
            }
            
            
            [arrayHY addObject:[weakSelf.selectedBtn titleForState:UIControlStateNormal]];
            
            [weakSelf.selectedBtn setTitle:arrayHY[i] forState:UIControlStateNormal];
            
            [arrayHY removeObject:[weakSelf.selectedBtn titleForState:UIControlStateNormal]];
            
            if ([arrayHY containsObject:@"全部"]) {
                [arrayHY removeObject:@"全部"];
                [arrayHY insertObject:@"全部" atIndex:0];
            }
            
            for (int i = 0;i<arrayHY.count;i++) {
                BaseButton *btn = hangyeBtns[i];
                [btn setTitle:arrayHY[i] forState:UIControlStateNormal];
            }
           
            xspageNumb = 1;
            if (_xsJsonArr.count >0) {
            [_xsJsonArr removeAllObjects];
            }
            [_xsTab reloadData];
            
            [self getxsJson];
            
            jjrpageNumb = 1;
               if (_jjrJsonArr.count >0) {
                    [_jjrJsonArr removeAllObjects];
            }
            [_dtTab reloadData];

            [self getjjrJson];
            
            
        };
        
        [hangyeBtns addObject:hangyeBtn];
    }
    
}
//选择地址重新设置frame
- (void)resetSeletedAddressFrame
{
    UILabel *lbUp =allocAndInit(UILabel);
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    CGSize sizeUp = [lbUp sizeWithContent:[CoreArchive strForKey:LocationAddress] font:Size(28)];
    float sizeW = sizeUp.width;
    if (sizeUp.width>=140*SpacedFonts) {
        sizeW = 160*SpacedFonts;
    }
    self.selectedAddress.frame = frame(frameX(self.selectedAddress), frameY(self.selectedAddress), sizeW + 15 + upImage.size.width, frameHeight(self.selectedAddress));
    self.selectedAddress.imagePoint = CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15);
}

//动态数据加载
-(void)getjjrJson
{
  
    [[HomeInfo shareInstance]getHomePageDT:jjrpageNumb brokerid:nil andcallBack:^(BOOL issucced, NSString* info, NSDictionary* jsonDic) {
        if (issucced == YES) {
            
            StatusModel *model = [StatusModel mj_objectWithKeyValues:jsonDic];
            [[ToolManager shareInstance]dismiss];
            if (model.datas.count > 0) {
                
                for (NSInteger i = 0; i < model.datas.count; i ++) {
                    StatusDatas *data = model.datas[i];
                    data.imgurl = [[ToolManager shareInstance] urlAppend:data.imgurl];
                    for (int i =0; i<data.pic.count;i++) {
                        StatusPic *pic = data.pic[i];
                        pic.imgurl = [[ToolManager shareInstance] urlAppend:pic.imgurl];
                        pic.abbre_imgurl = [[ToolManager shareInstance] urlAppend: pic.abbre_imgurl];
                        [data.pic replaceObjectAtIndex:i withObject:pic];
                        
                    }
                    for (int i =0; i<data.like.count;i++) {
                         StatusLike *like = data.like[i];
                         like.imgurl = [[ToolManager shareInstance] urlAppend:like.imgurl];
                         [data.like replaceObjectAtIndex:i withObject:like];
                    }
                    
                    data.type = @"image";
                    LWLayout* layout = [self layoutWithStatusModel:data index:i];
                    [self.jjrJsonArr addObject:layout];
                }
                [_dtTab reloadData];
            }else
            {
                [[ToolManager shareInstance] showAlertMessage:@"没有更多数据了"];
          
            }
            
        }else
        {
             [[ToolManager shareInstance] showAlertMessage:info];
      
        }

    }];
}

/****************************************************************************/
/**
 *  在这里生成LWAsyncDisplayView的模型。
 */
/****************************************************************************/

- (CellLayout *)layoutWithStatusModel:(StatusDatas *)statusModel index:(NSInteger)index {
    //生成Layout
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel index:index isDetail:NO];
    return layout;
}


//线索数据加载
-(void)getxsJson
{
    NSString *cityID =[CoreArchive strForKey:AddressID];
    [[HomeInfo shareInstance]getHomePageXianSuo:xspageNumb andCityID:cityID.intValue  andhangye:_hyStr andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_xsJsonArr addObject:dic];
                }
                [_xsTab reloadData];
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:@"没有更多数据了"];
            }
            
        }else
        {
             [[ToolManager shareInstance]showAlertMessage:info];
        }
    }];
}
/**
 *  最下层的scrollview
 */
-(void)setButtomScr
{
    buttomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight + 36, SCREEN_WIDTH, SCREEN_HEIGHT-(StatusBarHeight + NavigationBarHeight + 36 + TabBarHeight))];
    buttomScr.contentSize = CGSizeMake(SCREEN_WIDTH*2, frameHeight(buttomScr));
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
 *  上面的两个按钮
 */
-(void)addTheBtnView
{
    xsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xsBtn.frame = CGRectMake(0, 65, SCREEN_WIDTH/2, 35);
    [xsBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [xsBtn setTitle:@"线索" forState:UIControlStateNormal];
    [xsBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [xsBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    xsBtn.backgroundColor = [UIColor whiteColor];
    xsBtn.selected = YES;
    [xsBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [xsBtn addTarget:self action:@selector(xsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xsBtn];
    
    jjrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jjrBtn.frame = CGRectMake(SCREEN_WIDTH/2, 65, SCREEN_WIDTH/2, 35);
    [jjrBtn setTitle:@"动态" forState:UIControlStateNormal];
    [jjrBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [jjrBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [jjrBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    jjrBtn.backgroundColor = [UIColor whiteColor];
     [jjrBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [jjrBtn addTarget:self action:@selector(jjrBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jjrBtn];
    
    xhxV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
    xhxV.backgroundColor = [UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000];
    [self.view addSubview:xhxV];
}
/**
 *  点击线索btn的方法
 *
 *  @param sender <#sender description#>
 */
-(void)xsBtnAction:(UIButton *)sender
{
    sender.selected = YES;
    jjrBtn.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [xhxV setFrame:CGRectMake((SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
        [buttomScr setContentOffset:CGPointMake(0, 0)];
    }];
}
/**
 *  点击经纪人的方法
 *
 *  @param sender <#sender description#>
 */
-(void)jjrBtnAction:(UIButton *)sender
{
    sender.selected = YES;
    xsBtn.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [xhxV setFrame:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
        [buttomScr setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }];
}
#pragma mark - Getter

/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(APPWIDTH, frameHeight(buttomScr), APPWIDTH, kToolBarH);
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor= LineBg.CGColor;
    bgView.backgroundColor = WhiteColor ;
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    
    [buttomScr addSubview:bgView];
    
    UIView *textView = allocAndInitWithFrame(UIView,frame(10*ScreenMultiple, 8, APPWIDTH - 80*ScreenMultiple, 28));
    textView.userInteractionEnabled  =YES;
    textView.backgroundColor = WhiteColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor= LineBg.CGColor;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 3.0;
    [_toolBar addSubview:textView];
    
    _textField = [[UITextField alloc] init];
    _textField.userInteractionEnabled  =YES;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.enablesReturnKeyAutomatically = YES;
    
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.frame = frame(10, 0, frameWidth(textView) - 40, frameHeight(textView));
    _textField.placeholder = @"请输入";
    _textField.font = Size(28);
    _textField.delegate = self;
    [textView addSubview:_textField];
    
    _sendBtn = [UIButton createButtonWithfFrame:frame(CGRectGetMaxX(textView.frame)+15*ScreenMultiple, 8, 40*ScreenMultiple, 28) title:@"发送" backgroundImage:nil iconImage:nil highlightImage:nil tag:0 inView:bgView];
    _sendBtn.titleLabel.font = Size(28);
    [_sendBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3.0;
    _sendBtn.backgroundColor = AppMainColor;
    [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendAction:(UIButton *)sender
{
  
    [self postComment];
}
#pragma mark----两个tableview写在这里
-(void)addTheTab
{
    _xsTab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, buttomScr.frame.size.height)];
    _xsTab.dataSource = self;
    _xsTab.delegate = self;
    _xsTab.tableFooterView = [[UIView alloc]init];
    _xsTab.backgroundColor = [UIColor clearColor];
    _xsTab.tag = xsTabTag;
    _xsTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _xsTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        xspageNumb = 1;
        if (_xsJsonArr.count >0) {
            [_xsJsonArr removeAllObjects];
        }
        [_xsTab reloadData];
        [_xsTab.mj_header endRefreshing];
       
        [self getxsJson];
    }];
   
    _xsTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreXS)];
    _xsTab.footer.automaticallyHidden = NO;
    [buttomScr addSubview:_xsTab];
    
    _dtTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, buttomScr.frame.size.height)];
    _dtTab.dataSource = self;
    _dtTab.delegate = self;
    _dtTab.tableHeaderView = [self addJJRTopV];
    _dtTab.tableFooterView = [[UIView alloc]init];
    _dtTab.backgroundColor = [UIColor clearColor];
    _dtTab.tag = jjrTabTag;
    _dtTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dtTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        jjrpageNumb = 1;
        if (_jjrJsonArr.count >0) {
            [_jjrJsonArr removeAllObjects];
        }
        [_dtTab reloadData];
        [_dtTab.mj_header endRefreshing];
        
        [self getjjrJson];
    }];
    
    _dtTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreJJR)];
    _dtTab.footer.automaticallyHidden = NO;
    [buttomScr addSubview:_dtTab];
  
}
/**
 *  发布动态
 */
-(UIView *)addJJRTopV
{
    UIView *topV = allocAndInitWithFrame(UIView , frame(SCREEN_WIDTH, 0, SCREEN_WIDTH, 55));
    topV.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"dongtai_bianjie"];
    BaseButton *topBtn= [[BaseButton alloc]initWithFrame:frame(10, 10, SCREEN_WIDTH-20, 35) setTitle:@"分享你的新鲜事" titleSize:26*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:image highlightImage:image setTitleOrgin:CGPointMake((35 -26*SpacedFonts)/2.0 , 10 -image.size.width) setImageOrgin:CGPointMake((35 -image.size.height)/2.0 , SCREEN_WIDTH -image.size.width - 30) inView:topV];
    topBtn.shouldAnmial = NO;
    topBtn.didClickBtnBlock = ^
    
    {   PublishDynamicVC *publishDynamicVC  =  allocAndInit(PublishDynamicVC);
        publishDynamicVC.faBuSucceedBlock = ^
        {
//            NSLog(@"faBuSucceedBlock");
            jjrpageNumb = 1;
            if (_jjrJsonArr.count >0) {
                [_jjrJsonArr removeAllObjects];
            }
            [_dtTab reloadData];
        
            [self getjjrJson];
        };
        PushView(self, publishDynamicVC);
    };
    topBtn.backgroundColor  = [UIColor whiteColor];
   
    return topV;

}

/**
 *  此处查找页面跳转
 */
-(void)chazhaoAction
{
    JingJiRenVC * jjr = [JingJiRenVC new];
    [self.navigationController pushViewController:jjr animated:YES];
}
/**
 *  加载更多线索
 */
-(void)loadMoreXS
{
    xspageNumb ++;
    [self getxsJson];
    [_xsTab.mj_footer endRefreshing];
}
/**
 *  加载更多经纪人
 */
-(void)loadMoreJJR
{
    jjrpageNumb ++;
    [self getjjrJson];
    [_dtTab.mj_footer endRefreshing];
}
#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView.tag == xsTabTag) {
     
        return 280;
    }else
    { 
        if (self.jjrJsonArr.count >= indexPath.row) {
            CellLayout* layout = self.jjrJsonArr[indexPath.row];
            return layout.cellHeight;
        }
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == xsTabTag) {
        return _xsJsonArr.count;
    }else
    {
        return _jjrJsonArr.count;
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == xsTabTag) {
        static NSString * idenfStr = @"xsCell";
        XSCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[XSCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
            cell.backgroundColor = [UIColor clearColor];
            NSString * imgUrl;
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_xsJsonArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_xsJsonArr[indexPath.row]objectForKey:@"imgurl"]];
            }
            cell.renzhImg.image = [[_xsJsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
            [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
           
            cell.userNameLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"realname"];
            cell.positionLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"area"];
            NSString * timStr = [_xsJsonArr[indexPath.row] objectForKey:@"createtime"];
            NSTimeInterval time=[timStr doubleValue];
            NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
            cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * sjcStr = [self intervalSinceNow:cell.timeLab.text];
            if ([sjcStr integerValue] <=60) {
                cell.timeLab.text = @"刚刚";
            }else if ([sjcStr integerValue]<=3600)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld分钟前",[sjcStr integerValue]/60];
            }else if ([sjcStr integerValue]<=60*60*24)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld小时前",[sjcStr integerValue]/(60*60)];
            }else if ([sjcStr integerValue]<=60*60*24*3)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld天前",[sjcStr integerValue]/(60*60*24)];
            }else
            {
                cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
            }
            cell.lookLab.text = [NSString stringWithFormat:@"查看:%@",[_xsJsonArr[indexPath.row] objectForKey:@"readcount"]];
            cell.commentLab.text = [NSString stringWithFormat:@"评论:%@",[_xsJsonArr[indexPath.row] objectForKey:@"commentnum"]];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                [cell.hanyeBtn setTitle:@"保险" forState:UIControlStateNormal];
            }else if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                [cell.hanyeBtn setTitle:@"金融" forState:UIControlStateNormal];
            }else if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                [cell.hanyeBtn setTitle:@"房产" forState:UIControlStateNormal];
            }else if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                [cell.hanyeBtn setTitle:@"车行" forState:UIControlStateNormal];
            }

            
            cell.titLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"title"];
            cell.moneyLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"cost"];
             cell.blueV.tag = 1000+indexPath.row;
            UITapGestureRecognizer * blueVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blueVAction:)];
            blueVTap.numberOfTapsRequired =1;
            blueVTap.numberOfTouchesRequired = 1;
           
            [cell.blueV addGestureRecognizer:blueVTap];
            NSString * xqStr;
            NSString * qdStr = @"需求强度: ";
            NSString * qdStr2;
            if ([[_xsJsonArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 3) {
                qdStr2 = [NSString stringWithFormat:@"很强"];
            }else if ([[_xsJsonArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 2)
            {
                qdStr2 = [NSString stringWithFormat:@"强"];
            }else
            {
                qdStr2 = [NSString stringWithFormat:@"一般"];
            }
            xqStr = [qdStr stringByAppendingString:qdStr2];
            NSMutableAttributedString * xqqdAtr = [[NSMutableAttributedString alloc]initWithString:xqStr];
            [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([qdStr length], [qdStr2 length])];
            [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0,[qdStr length])];
            cell.xqqdLab.attributedText = xqqdAtr;
            NSString * lq1 = [NSString stringWithFormat:@"%@人领取",[_xsJsonArr[indexPath.row]objectForKey:@"coopnum"] ];
            NSString * lq2 = [NSString stringWithFormat:@""];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"iscoop"]intValue ]==1) {
                lq2 = [NSString stringWithFormat:@"(已领取)"];
            }
           
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"state"]intValue ]>20) {
                 lq2 = [NSString stringWithFormat:@"(已合作)"];
            }
            
            NSString * lqStr = [lq1 stringByAppendingString:lq2];
            NSMutableAttributedString * lqAtr = [[NSMutableAttributedString alloc]initWithString:lqStr];
            [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [lq1 length])];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"iscoop"]intValue ]==1||[[_xsJsonArr[indexPath.row]objectForKey:@"state"]intValue ]>20) {
                [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([lq1 length], [lq2 length])];
            }else
            {
                [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange([lq1 length], [lq2 length])];
            }
            cell.lqLab.attributedText = lqAtr;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnVAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            cell.btnV.tag = 200+indexPath.row;
            [cell.btnV addGestureRecognizer:tap];
            
        }
        return cell;
    }else
    {
        static NSString* cellIdentifier = @"cellIdentifier";
        TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        if (self.jjrJsonArr.count >= indexPath.row) {
            CellLayout* cellLayout = self.jjrJsonArr[indexPath.row];
            cell.cellLayout = cellLayout;
        }
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView ==_dtTab) {
         CellLayout* cellLayout = self.jjrJsonArr[indexPath.row];
        DynamicDetailsViewController*dynamicDetailsViewController = allocAndInit(DynamicDetailsViewController);
        dynamicDetailsViewController.dynamicdID = [NSString stringWithFormat:@"%ld",cellLayout.statusModel.ID];
        dynamicDetailsViewController.jjrJsonArr = [NSMutableArray new];
        [dynamicDetailsViewController.jjrJsonArr addObject:_jjrJsonArr[indexPath.row]];
        dynamicDetailsViewController.deleteDynamicDetailSucceed = ^(BOOL succeed,CellLayout *cellLayout)
        {
            if (succeed) {
                [_jjrJsonArr removeObjectAtIndex:indexPath.row];
                [_dtTab reloadData];
            }
            else
            {
                
                    CellLayout *currentLayout =_jjrJsonArr[indexPath.row];
                    
                    [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:currentLayout.statusModel index:indexPath.row]];
                    [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        };
        PushView(self, dynamicDetailsViewController);
        
        
    }
    
}
//点击进入动态详情
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithDTID:(NSString *)DTID atIndexPath:(NSIndexPath *)indexPath
{
    DynamicDetailsViewController*dynamicDetailsViewController = allocAndInit(DynamicDetailsViewController);
    dynamicDetailsViewController.dynamicdID = DTID;
    dynamicDetailsViewController.jjrJsonArr = allocAndInit(NSMutableArray);
     [dynamicDetailsViewController.jjrJsonArr addObject:_jjrJsonArr[indexPath.row]];
    dynamicDetailsViewController.deleteDynamicDetailSucceed = ^(BOOL succeed,CellLayout *cellLayout)
    {
        if (succeed) {
            [_jjrJsonArr removeObjectAtIndex:indexPath.row];
            [_dtTab reloadData];
        }
        else
        {
        
                CellLayout *currentLayout =_jjrJsonArr[indexPath.row];
                [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:currentLayout.statusModel index:indexPath.row]];
                [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

        
    };

    PushView(self, dynamicDetailsViewController);
}
#pragma mark----线索那边的头像那块view的点击事件
-(void)btnVAction:(UITapGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_xsJsonArr[sender.view.tag-200] objectForKey:@"brokerid"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(void)blueVAction:(UITapGestureRecognizer *)sender
{
    if ([[_xsJsonArr[sender.view.tag-1000] objectForKey:@"iscoop"] intValue] == 1) {
        //跳转我的领取线索详情
        MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
        myLqV.xiansuoID = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
       [self.navigationController pushViewController:myLqV animated:YES];
        return;
    }
    if ([[_xsJsonArr[sender.view.tag-1000] objectForKey:@"isself"] intValue] == 1) {
        //跳转我的发布线索详情
        MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
        myxiansuoV.xiansuoID = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
        [self.navigationController pushViewController:myxiansuoV animated:YES];

        return;
    }
    XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
    xiansuoV.xs_id = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
    [self.navigationController pushViewController:xiansuoV animated:YES];
}
/**
 *  scrollview代理方法
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = buttomScr.contentOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        if ((int)point.x % (int)SCREEN_WIDTH == 0) {
            if (point.x/SCREEN_WIDTH ==1) {
                  //               NSLog(@"第二页");
                jjrBtn.selected = YES;
                xsBtn.selected = NO;
                [xhxV setFrame:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
            }else if(point.x/SCREEN_WIDTH ==0)
            {
                //               NSLog(@"第一页");
                jjrBtn.selected = NO;
                xsBtn.selected = YES;
                 [xhxV setFrame:CGRectMake((SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
            }
        }
        
    }];
    
}


/***  点击评论 ***/
- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath {
    [_textField becomeFirstResponder];
    _textField.placeholder =@"评论";
    _dynamicID =[NSString stringWithFormat:@"%ld",layout.statusModel.ID];
    _commentType = @"comment";
    _replayid = @"0";
    _commentCell =cell;
    _commentIndex = indexPath;
}
#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [buttomScr setPagingEnabled:YES];
    [self postComment];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  
     [buttomScr setPagingEnabled:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [buttomScr setPagingEnabled:NO];
    return YES;
}


/***  发表评论 ***/
- (void)postComment {
    
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
   
    UIImage* screenshot = [GallopUtils screenshotFromView:_commentCell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.dtTab convertRect:_commentCell.frame toView:self.dtTab]];
    imgView.image = screenshot;
    [self.dtTab addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
    if (_textField.text.length==0) {
        
        [[ToolManager shareInstance] showInfoWithStatus:@"输入必须大于一个字符"];
        return;
    }
    CellLayout* layout =  _commentCell.cellLayout;
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.comment];
    [[HomeInfo shareInstance] addDynamicComment:_dynamicID replayid:_replayid type:_commentType content:_textField.text andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        _textField.text = @"";
        [_textField resignFirstResponder];
        if (issucced) {
            if (jsonDic[@"datas"]) {
                 StatusComment *newComment = allocAndInit(StatusComment);
                 newComment.ID = [jsonDic[@"datas"][@"id"] integerValue];
                 newComment.me = [jsonDic[@"datas"][@"self"] boolValue];
                StatusInfo *info = allocAndInit(StatusInfo);
                 info.brokerid = [jsonDic[@"datas"][@"brokerid"] integerValue];
                 info.realname = jsonDic[@"datas"][@"realname"];
                 info.rep_brokerid = [jsonDic[@"datas"][@"rep_brokerid"] integerValue];
                 info.rep_realname = jsonDic[@"datas"][@"rep_realname"];
                 info.content = jsonDic[@"datas"][@"content"];
                newComment.info = info;
                     [newCommentLists addObject:newComment];
        
                     StatusDatas* statusModel = layout.statusModel;
                     statusModel.comment = newCommentLists;
                 
                 
                     [self.jjrJsonArr replaceObjectAtIndex:_commentIndex.row withObject:[self layoutWithStatusModel:statusModel index:_commentIndex.row]];
                 
                     [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_commentIndex.row inSection:0]]
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus:info];
        }
        
    }];

    
}
/***  点赞 ***/
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeWithCellLayout:(CellLayout *)layout atIndexPath:(NSIndexPath *)indexPath {
    
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.dtTab convertRect:cell.frame toView:self.dtTab]];
    imgView.image = screenshot;
    [self.dtTab addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    self.view.userInteractionEnabled = NO;
    [[HomeInfo shareInstance ]dynamicIsLike:[NSString stringWithFormat:@"%li",layout.statusModel.ID] islike:layout.statusModel.islike andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        self.view.userInteractionEnabled = YES;
        if (issucced == YES) {
            if (jsonDic[@"datas"]) {
//                NSLog(@"jsonDic =%@",jsonDic);
                StatusLike *like = [StatusLike mj_objectWithKeyValues:jsonDic[@"datas"]];
            
                like.imgurl =[[ToolManager shareInstance] urlAppend:like.imgurl];
                
            if (!layout.statusModel.islike) {
                [[ToolManager shareInstance] showSuccessWithStatus:@"点赞成功"];
                NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.like];
                if (![newLikeList containsObject:like]) {
                    [newLikeList insertObject:like atIndex:0];
                }
                
                StatusDatas* statusModel =layout.statusModel;
                statusModel.like = newLikeList;
                statusModel.islike = [jsonDic[@"datas"][@"islike"] boolValue];
                statusModel.ID =[jsonDic[@"datas"][@"id"] integerValue];
                
                [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:statusModel index:indexPath.row]];
                [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                 [[ToolManager shareInstance] showSuccessWithStatus:@"取消赞成功"];
                NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.like];
                for (StatusLike *statusLike in layout.statusModel.like) {
                    if (statusLike.brokerid ==like.brokerid) {
                        [newLikeList removeObject:statusLike];
                    }
                }
                
                StatusDatas* statusModel = layout.statusModel;
                statusModel.like = newLikeList;
                statusModel.islike = [jsonDic[@"datas"][@"islike"] boolValue];
                statusModel.ID =[jsonDic[@"datas"][@"id"] integerValue];
            
                [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:statusModel index:indexPath.row]];
                [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
            }

            
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }

       
    }];
    }

/***  点击图片 ***/
- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout atIndex:(NSInteger)index {
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:layout.statusModel.pic[i].abbre_imgurl]
                                                                                     HDURL:[NSURL URLWithString:layout.statusModel.pic[i].imgurl]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}
/***  点击链接 ***/
- (void)tableViewCell:(TableViewCell *)cell  cellLayout:(CellLayout *)layout  atIndexPath:(NSIndexPath *)indexPath didClickedLinkWithData:(id)data {

    if ([data isKindOfClass:[StatusComment class]]) {
       
        StatusComment* commentModel = (StatusComment *)data;
        if (commentModel.me) {
            
            [[ToolManager shareInstance] showAlertViewTitle:@"删除？" contentText:@"删除此评论？" showAlertViewBlcok:^{
                
                /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
                 延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
                UIImage* screenshot = [GallopUtils screenshotFromView:cell];
                UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.dtTab convertRect:cell.frame toView:self.dtTab]];
                imgView.image = screenshot;
                [self.dtTab addSubview:imgView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imgView removeFromSuperview];
                });
                self.view.userInteractionEnabled = NO;
                [[HomeInfo shareInstance ] deleteDynamicComment:[NSString stringWithFormat:@"%ld",commentModel.ID] andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
                 
                    self.view.userInteractionEnabled = YES;
                    if (issucced == YES) {
                
                NSMutableArray* newcommentList = [[NSMutableArray alloc] initWithArray:layout.statusModel.comment];
                for (StatusComment*statusComment in layout.statusModel.comment) {
                if (statusComment.ID ==commentModel.ID) {
                    [newcommentList removeObject:statusComment];
                    }
                    
                StatusDatas* statusModel = layout.statusModel;
                statusModel.comment = newcommentList;
                                
               [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:statusModel index:indexPath.row]];
                [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
                                
                        
                    }
                        
                        
                    }else
                    {
                        [[ToolManager shareInstance]showAlertMessage:info];
                    }
                    
                    
                }];

                
            }];
        }
        else
        {
            [_textField becomeFirstResponder];
             _textField.placeholder =[NSString stringWithFormat:@"回复%@:",commentModel.info.realname];
            _dynamicID =[NSString stringWithFormat:@"%ld",layout.statusModel.ID];
            _commentType = @"replay";
            _replayid = [NSString stringWithFormat:@"%ld",commentModel.info.brokerid];
             _commentCell =cell;
            _commentIndex = indexPath;
        }

    } else  {
        if ([data isKindOfClass:[NSString class]]) {
            
            JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
            jjrV.jjrID = data;
            [self.navigationController pushViewController:jjrV animated:YES];
  
        }
        else if ([data isKindOfClass:[NSDictionary class]])
        {
            if ([data[@"key"] isEqualToString:@"查看更多"]) {
                
                DynamicDetailsViewController*dynamicDetailsViewController = allocAndInit(DynamicDetailsViewController);
                dynamicDetailsViewController.dynamicdID = data[@"id"];
                dynamicDetailsViewController.jjrJsonArr = allocAndInit(NSMutableArray);
                [dynamicDetailsViewController.jjrJsonArr addObject:_jjrJsonArr[indexPath.row]];
                dynamicDetailsViewController.deleteDynamicDetailSucceed = ^(BOOL succeed,CellLayout *cellLayout)
                {
                    if (succeed) {
                        [_jjrJsonArr removeObjectAtIndex:indexPath.row];
                        [_dtTab reloadData];
                    }
                    else
                    {
                        CellLayout *currentLayout =_jjrJsonArr[indexPath.row];
                        
                        [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:currentLayout.statusModel index:indexPath.row]];
                        [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }

                    
                };


                PushView(self, dynamicDetailsViewController);
            }
        }
    }
}
//点击点赞头像
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithJJRId:(NSString *)JJRId{

    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = JJRId;
    [self.navigationController pushViewController:jjrV animated:YES];
    
}
//更多按钮事件
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsSelf:(BOOL)isSelf andDynamicID:(NSString *)andDynamicID atIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index
{   

    if (isSelf) {
        self.view.userInteractionEnabled = NO;
        [[HomeInfo shareInstance ]deleteDynamic:andDynamicID andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
            self.view.userInteractionEnabled = YES;
            if (issucced == YES) {
               
                [self.jjrJsonArr removeObjectAtIndex:indexPath.row];
                
                [self.dtTab reloadData];
                
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:info];
            }
            
            
        }];
        
        
    }
    else
    {
        if (index ==0) {
            
            CellLayout *cell = _jjrJsonArr[indexPath.row];
            [[HomeInfo shareInstance]guanzhuTargetID:cell.statusModel.brokerid andIsFollow:cell.statusModel.isfollow andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonArr) {
                if (jsonArr) {
                    cell.statusModel.isfollow = [jsonArr[@"isfollow"] boolValue];
                    [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:cell.statusModel index:indexPath.row]];
                    [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
                }
                
                if (issucced == YES) {
                    
                    if (cell.statusModel.isfollow ) {
                        [[ToolManager shareInstance] showSuccessWithStatus:@"取消关注成功"];
                    }
                    else
                    {
                         [[ToolManager shareInstance] showSuccessWithStatus:@"关注成功"];
                    }
                    
                    
                    
                }else
                {
                    HUDText(info);
                }
                
            }];

        }
        else
        {
            [[ToolManager shareInstance] showSuccessWithStatus:@"举报成功"];
        }
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//转换时间戳
-(NSString *)getDateStringWithDate:(NSDate *)date
                        DateFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    //     NSLog(@"date: %@", dateString);
    
    return dateString;
}
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    
    timeString = [NSString stringWithFormat:@"%f", cha];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@", timeString];
    
    return timeString;
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
