//
//  JingJiRenVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/18.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "JingJiRenVC.h"
#import "JJRCell.h"
#import "MJRefresh.h"
#import "JJRDetailInfo.h"
#import "HomeInfo.h"
#import "ToolManager.h"
#import "JJRDetailVC.h"
#import "CoreArchive.h"
#import "ViewController.h"//选择地址
@interface JingJiRenVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *buttomV;
@property (weak, nonatomic) IBOutlet UIButton *baoxianBtn;
@property (weak, nonatomic) IBOutlet UIButton *jinrongBtn;
@property (weak, nonatomic) IBOutlet UIButton *fanchangBtn;
@property (strong,nonatomic)UIView * btmBlueV;
@property (weak, nonatomic) IBOutlet UIButton *chehangBtn;
@property (weak, nonatomic) IBOutlet UITableView *jjrTab;
@property (assign,nonatomic)int pageNumb;
@property (strong,nonatomic)NSMutableArray * jsonArr;
@property (strong,nonatomic)NSString * typeName;
@property (nonatomic,assign) CGPoint imagePoint;
@property(nonatomic, strong)BaseButton *selectedAddress;
- (IBAction)baoxianAction:(id)sender;
- (IBAction)jinrongAction:(id)sender;
- (IBAction)fancAction:(id)sender;
- (IBAction)chehangAction:(id)sender;


@end

@implementation JingJiRenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumb = 1;
    _jsonArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BACKCOLOR;
    [self setNav];
    [self addTheBtmBlueV];
    _typeName = @"insurance";
    _jjrTab.tableFooterView = [[UIView alloc]init];
    
    _jjrTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumb = 1;
        if (_jsonArr.count > 0) {
            [_jsonArr removeAllObjects];
        }
        [_jjrTab reloadData];
        [self getJsonWithType:_typeName];
        [_jjrTab.mj_header endRefreshing];
      //  NSLog(@"刷新经纪人");
        
    }];
    _jjrTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreJJR)];
    _jjrTab.footer.automaticallyHidden = NO;
    [self getJsonWithType:_typeName];
}
-(void)getJsonWithType:(NSString *)type
{
    NSString *cityID =[CoreArchive strForKey:AddressID];
    [[JJRDetailInfo shareInstance]lookForjjrWithType:type andPage:_pageNumb andcityID:cityID.intValue andCallback:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                 [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_jsonArr addObject:dic];
                }
                
                [_jjrTab reloadData];
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
-(void)loadMoreJJR
{
    _pageNumb ++;
    [self getJsonWithType:_typeName];
    [_jjrTab.mj_footer endRefreshing];
    

}
-(void)setNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
   
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    backBtn.imageView.contentMode = UIViewContentModeLeft;
    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    UILabel *lbUp = allocAndInit(UILabel);
    CGSize sizeUp = [lbUp sizeWithContent:[CoreArchive strForKey:LocationAddress] font:[UIFont systemFontOfSize:28*SpacedFonts]];
    float sizeW = sizeUp.width;
    if (sizeUp.width>=140*SpacedFonts) {
        sizeW = 160*SpacedFonts;
    }

    _selectedAddress  =[[BaseButton alloc]initWithFrame:frame(SCREEN_WIDTH-70, 20, sizeW + 15 + upImage.size.width, NavigationBarHeight) setTitle:[CoreArchive strForKey:LocationAddress] titleSize:28*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:upImage highlightImage:nil setTitleOrgin:CGPointMake( (NavigationBarHeight -28*SpacedFonts)/2.0 ,10-(upImage.size.width)) setImageOrgin:CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15) inView:self.view];

    self.selectedAddress.frame = frame(SCREEN_WIDTH-(sizeW + 15 + upImage.size.width+10), frameY(self.selectedAddress), sizeW + 15 + upImage.size.width, frameHeight(self.selectedAddress));
    self.selectedAddress.imagePoint = CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15);
     __weak JingJiRenVC *weakSelf =self;
    _selectedAddress.didClickBtnBlock =^
    {
        ViewController *vc=[[ViewController alloc]init];
        
        [vc returnText:^(NSString *cityname,NSString *cityID) {
            
            [weakSelf.selectedAddress setTitle:cityname forState:UIControlStateNormal];
            [weakSelf resetSeletedAddressFrame];
            
            _pageNumb = 1;
            if (weakSelf.jsonArr.count >0) {
                [weakSelf.jsonArr removeAllObjects];
            }
            [weakSelf.jjrTab reloadData];
            [weakSelf getJsonWithType:weakSelf.typeName];
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };

 
    [navView addSubview:_selectedAddress];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"经纪人";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
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
    self.selectedAddress.frame = frame(SCREEN_WIDTH-(sizeW + 15 + upImage.size.width+10), frameY(self.selectedAddress), sizeW + 15 + upImage.size.width, frameHeight(self.selectedAddress));
    self.selectedAddress.imagePoint = CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15);
}
-(void)addTheBtmBlueV
{
    _btmBlueV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-20)/2, 29, 20, 1)];
    _btmBlueV.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    [_buttomV addSubview:_btmBlueV];
    _baoxianBtn.selected = YES;
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)sender
{
    ViewController *vc=[[ViewController alloc]init];
    __weak JingJiRenVC *weakSelf =self;
    [vc returnText:^(NSString *cityname,NSString *cityID) {
        
        [sender setTitle:cityname forState:UIControlStateNormal];
        _pageNumb = 1;
        if (weakSelf.jsonArr.count >0) {
            [weakSelf.jsonArr removeAllObjects];
        }
        [weakSelf.jjrTab reloadData];
        [weakSelf getJsonWithType:_typeName];
    }];
    [self.navigationController pushViewController:vc animated:NO];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _jsonArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idenfStr = @"jjrCell";
    JJRCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
    if (!cell) {
        cell = [[JJRCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
        cell.backgroundColor = [UIColor clearColor];
        NSString * imgUrl;
        if ([[_jsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
            imgUrl = [_jsonArr[indexPath.row] objectForKey:@"imgurl"];
        }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_jsonArr[indexPath.row]objectForKey:@"imgurl"]];
        }
        [[ToolManager shareInstance]imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
   
        cell.renzhImg.image = [[_jsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
        cell.userNameLab.text = [_jsonArr[indexPath.row] objectForKey:@"realname"];
        cell.positionLab.text = [_jsonArr[indexPath.row]objectForKey:@"area"];
        if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
            cell.hanyeLab.text = @"保险";
        }else if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
        {
            cell.hanyeLab.text = @"金融";
        }else if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
        {
            cell.hanyeLab.text = @"房产";
        }else if ([[_jsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
        {
            cell.hanyeLab.text = @"车行";
        }

        cell.fuwuLab.text = [NSString stringWithFormat:@"服务:%@",[_jsonArr[indexPath.row]objectForKey:@"servernum"]];
        
        cell.fansLab.text = [NSString stringWithFormat:@"粉丝:%@",[_jsonArr[indexPath.row]objectForKey:@"fansnum"]];
        if ([[_jsonArr[indexPath.row]objectForKey:@"isfollow"] intValue] == 1) {
            cell.guanzhuBtn.selected = YES;
            if ([[_jsonArr[indexPath.row]objectForKey:@"mutual"]intValue] == 1) {
                [cell.guanzhuBtn setTitle:@"已互关注" forState:UIControlStateSelected];
            }
        }else
        {
            cell.guanzhuBtn.selected = NO;
        }

        cell.guanzhuBtn.tag = 100+indexPath.row;
        [cell.guanzhuBtn addTarget:self action:@selector(guanzhuAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jjrAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        cell.nextV.tag = 500+indexPath.row;
        [cell.nextV addGestureRecognizer:tap];

    }
    if (![cell.guanzhuBtn.titleLabel.text isEqualToString:@"关注Ta"]) {
        cell.guanzhuBtn.layer.borderColor=[UIColor colorWithWhite:0.651 alpha:1.000].CGColor;
    }
    return cell;
}
-(void)jjrAction:(UIGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_jsonArr[sender.view.tag-500] objectForKey:@"id"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void)guanzhuAction:(UIButton *)sender
{
    NSString * target_id = [_jsonArr[sender.tag-100] objectForKey:@"id"];
    //isfollow:1代表取消关注,0代表关注
    int isfollow;
    if (sender.selected == YES) {
        isfollow = 1;
    }else
    {
        isfollow = 0;
    }
    [[HomeInfo shareInstance]guanzhuTargetID:[target_id intValue] andIsFollow:isfollow andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonArr) {
        if (issucced == YES) {
            sender.selected = !sender.selected;
            if (sender.selected == YES) {
                sender.layer.borderColor=[UIColor colorWithWhite:0.651 alpha:1.000].CGColor;
            }
            else if (sender.selected == NO) {
                sender.layer.borderColor=[UIColor colorWithRed:0.239 green:0.553 blue:0.996 alpha:1.000].CGColor;
            }

        }else
        {
            [[ToolManager shareInstance] showAlertMessage:info];
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

- (IBAction)baoxianAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _baoxianBtn.selected = YES;
        _jinrongBtn.selected = NO;
        _fanchangBtn.selected = NO;
        _chehangBtn.selected = NO;
        [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/4-20)/2, 29, 20, 1)];
    }];
    if (_jsonArr.count > 0) {
        [_jsonArr removeAllObjects];
    }
    [_jjrTab reloadData];
    _typeName = @"insurance";
    [self getJsonWithType:_typeName];

}

- (IBAction)jinrongAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _baoxianBtn.selected = NO;
        _jinrongBtn.selected = YES;
        _fanchangBtn.selected = NO;
        _chehangBtn.selected = NO;
        [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/4-20)/2+SCREEN_WIDTH/4, 29, 20, 1)];
    }];
    if (_jsonArr.count > 0) {
        [_jsonArr removeAllObjects];
    }
    [_jjrTab reloadData];
    _typeName = @"finance";
    [self getJsonWithType:_typeName];

}

- (IBAction)fancAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _baoxianBtn.selected = NO;
        _jinrongBtn.selected = NO;
        _fanchangBtn.selected = YES;
        _chehangBtn.selected = NO;
        [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/4-20)/2+SCREEN_WIDTH/4*2, 29, 20, 1)];
    }];
    if (_jsonArr.count > 0) {
        [_jsonArr removeAllObjects];
    }
    [_jjrTab reloadData];
    _typeName = @"property";
    [self getJsonWithType:_typeName];
}

- (IBAction)chehangAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _baoxianBtn.selected = NO;
        _jinrongBtn.selected = NO;
        _fanchangBtn.selected = NO;
        _chehangBtn.selected = YES;
        [_btmBlueV setFrame:CGRectMake((SCREEN_WIDTH/4-20)/2+SCREEN_WIDTH/4*3, 29, 20, 1)];
    }];
    if (_jsonArr.count > 0) {
        [_jsonArr removeAllObjects];
    }
    [_jjrTab reloadData];
    _typeName = @"car";
    [self getJsonWithType:_typeName];
}
@end
