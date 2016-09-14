
//
//  MeViewController.m
//  Lebao
//
//  Created by David on 15/12/4.
//  Copyright © 2015年 David. All rights reserved.
//

#import "MeViewController.h"
#import "MeCell.h"
#import "EarnestMoneyViewController.h"
#import "CExpandHeader.h"
#import "XLDataService.h"
#import "UIImage+Color.h"
#import "CoreArchive.h"
#import "AppDelegate.h"
#import "BasicInformationViewController.h"
#import "MyGuanZhuVC.h"//我的关注
#import "MyFansVC.h"//我的粉丝
#import "MyDetialViewController.h"
#import "AuthenticationViewController.h"
#define cellH  40
#define PersonalURL [NSString stringWithFormat:@"%@user/index",HttpURL]
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MeViewModal
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end

@implementation MeViewController
{
    NSMutableArray *_meArray;
    UITableView    *_meTableView;
    CExpandHeader *_header;
    
    UIImageView *userIcon;
    UILabel *username;
    UILabel *descrip;
    
    MeViewModal *modal;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTabbarIndex:3];
//    UIView *head = allocAndInitWithFrame(UIView, frame(0, 0,APPWIDTH,  StatusBarHeight));
//    head.backgroundColor = AppMainColor;
//    [self.view addSubview:head];
    
    modal =[[MeViewModal alloc]init];
    modal.authen = 1;
    _meArray = [NSMutableArray new];

    NSArray *_sectionTwo =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"会员特权",@"name",@"VIP",@"image",@"1",@"show",@"",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"我的钱包",@"name",@"qianbao",@"image",@"1",@"show",@"EarnestMoneyViewController",@"viewController",nil], [NSDictionary dictionaryWithObjectsAndKeys:@"我的资料",@"name",@"zhiliao",@"image",@"1",@"show",@"BasicInformationViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"身份认证",@"name",@"shenfenrenzheng",@"image" ,@"1",@"show",@"AuthenticationViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"活跃值",@"name",@"huoyuezhi",@"image" ,@"1",@"show",@"ActiveValueViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"邀请好友",@"name",@"yaoqinghaoyou",@"image" ,@"1",@"show",@"InviteFriendsViewController",@"viewController",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"设置",@"name",@"shezhi",@"image" ,@"0",@"show",@"SettingViewController",@"viewController",nil],nil];
    



    [_meArray addObject:_sectionTwo];

    _meTableView =[[UITableView alloc]initWithFrame:frame(0, 0, APPWIDTH, APPHEIGHT  - 49) style:UITableViewStyleGrouped];
    _meTableView.delegate = self;
    _meTableView.dataSource = self;
    _meTableView.backgroundColor =AppViewBGColor;
    _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_meTableView];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth(_meTableView), 167 )];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth(customView), frameHeight(customView))];
    [imageView setImage:[UIImage imageNamed:@"wodeBG"]];
    
    //关键步骤 设置可变化背景view属性
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [customView addSubview:imageView];
    
    [self addHeadView:customView];
    
    _header = [CExpandHeader expandWithScrollView:_meTableView expandView:customView];
    

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self netWork];
}

#pragma mark
#pragma mark - headView
- (void)addHeadView:(UIView *)view
{
    //headIcon
    userIcon =allocAndInitWithFrame(UIImageView, frame((frameWidth(_meTableView) -53)/2.0,38, 60, 60));
    
    userIcon.backgroundColor =[UIColor clearColor];
    userIcon.userInteractionEnabled =YES;
    userIcon.contentMode = UIViewContentModeRedraw;
    userIcon.layer.borderWidth = 3;
    userIcon.layer.borderColor = rgba(255, 255, 255, 0.5).CGColor;
    userIcon.layer.masksToBounds =YES;
    userIcon.layer.cornerRadius = frameWidth(userIcon)/2.0;
    [view addSubview:userIcon];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconTap)];
    userIcon.image = [UIImage imageNamed:@"defaulthead"];
    tap.numberOfTapsRequired = 1;
    [userIcon addGestureRecognizer:tap];
    
    //userName
    username = [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(userIcon.frame)+ 13, frameWidth(_meTableView), 32.0*SpacedFonts) text:@"" fontSize:32.0*SpacedFonts textColor:WhiteColor textAlignment: NSTextAlignmentCenter inView:view];
    
    
    //descrip
    descrip =[UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(username.frame)+ 13, frameWidth(_meTableView), 28.0*SpacedFonts) text:@"钱包余额:00.00元" fontSize:28*SpacedFonts textColor:WhiteColor textAlignment: NSTextAlignmentCenter inView:view];
    
}
- (void)netWork
{
    NSMutableDictionary * parameter =[Parameter parameterWithSessicon];
    
    [XLDataService postWithUrl:PersonalURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
            MeViewModal * _modal =[MeViewModal mj_objectWithKeyValues:dataObj];
            modal         = _modal;
            if (modal.rtcode ==1) {
                
                [[ToolManager shareInstance] imageView:userIcon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeUserHead];
                username.text = modal.realname;
                descrip.text  = [NSString stringWithFormat:@"诚意金:%@元",modal.amount];
                [_meTableView  reloadData];
            }
            
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
    }];
    
}
#pragma mark
#pragma mark
- (void)userIconTap
{
    [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
        UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
        MyDetialViewController *myDetialVC = allocAndInit(MyDetialViewController);
//        myDetialVC.jjrID = modal.ID;
        modal.ID?[nav pushViewController:myDetialVC animated:YES]:[[ToolManager shareInstance] showInfoWithStatus:@"经纪人id不能为空"];
        
        
    }];
}
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *_sectionArray = _meArray[section];
    return _sectionArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _meArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        
        return 50;
    }
    
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_meTableView), 53));
        
        UIView  *attentionAndfensView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_meTableView), 43));
        attentionAndfensView.backgroundColor = WhiteColor;
        [view addSubview:attentionAndfensView];
        
        UILabel *line = allocAndInitWithFrame(UILabel , frame(frameWidth(_meTableView)/2.0 - 0.5, 7, 0.5, 29));
        line.backgroundColor = LineBg;
        [view addSubview:line];
        NSString *str = @"0";
        BaseButton *attention = [[BaseButton alloc]initWithFrame:frame(0, 0, frameWidth(attentionAndfensView)/2.0, frameHeight(attentionAndfensView)) setTitle:[NSString stringWithFormat:@"关注(%@)",modal.follownum?modal.follownum:str] titleSize:30*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:attentionAndfensView];
        //        __weak typeof(self) weakSelf = self;
        attention.didClickBtnBlock = ^
        {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
                UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
                UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
                MyGuanZhuVC *guanzhuVC=[[MyGuanZhuVC alloc]init];
                guanzhuVC.Numb=modal.follownum?modal.follownum:str;
                [nav pushViewController:guanzhuVC animated:YES];
                
            }];
            
            
            
        };
        
        BaseButton *fens = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(attention.frame), frameY(attention), frameWidth(attention), frameHeight(attention)) setTitle:[NSString stringWithFormat:@"粉丝(%@)",modal.fansnum?modal.fansnum:str] titleSize:30*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:attentionAndfensView];
        fens.didClickBtnBlock = ^
        {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
                UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
                UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
                MyFansVC *fansVC=[[MyFansVC alloc]init];
                fansVC.Numb=modal.fansnum?modal.fansnum:str;
                [nav pushViewController:fansVC animated:YES];

//                [nav pushViewController:allocAndInit(MyFansVC)animated:YES];
                
            }];
            
        };
        
        
        return view;
    }
    return allocAndInit(UIView);
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"MeCell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_meTableView)];
        
        
    }
    NSArray * _sectionArray = _meArray[indexPath.section];
    NSDictionary *dict = _sectionArray[indexPath.row];
    if ([dict[@"viewController"] isEqualToString:@"NotificationViewController"]) {
        cell.message.hidden = !modal.newmsg;
    }
    else
    {
        cell.message.hidden = YES;
    }
    if ([dict[@"viewController"] isEqualToString:@"MyKuaJieVC"]) {
        cell.detail.hidden = NO;
        cell.detail.text = modal.demandline;
    }
    else
    {
        cell.detail.hidden = YES;
    }
    if (indexPath.section ==1&&indexPath.row ==2) {
        
        cell.authen.hidden = NO;
        
        
        switch (modal.authen) {
            case AuthenTypeNo:
                cell.authen.text = @"未认证";
                break;
            case AuthenTypeIng:
                cell.authen.text = @"认证中";
                break;
            case AuthenTypeYes:
                cell.authen.text = @"已认证";
                break;
            case AuthenTypeOther:
                cell.authen.text = @"被驳回";
            default:
                break;
        }
    }
    else
    {
        
        cell.authen.hidden = YES;
    }
    
    [cell setLeftImage:dict[@"image"] Title:dict[@"name"] isShowLine:[dict[@"show"] boolValue]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * _sectionArray = _meArray[indexPath.section];
    NSDictionary *dict = _sectionArray[indexPath.row];
    
    if ([dict[@"viewController"] hasPrefix:@"http://"]) {
        
        return;
    }
    if (NSClassFromString(dict[@"viewController"])) {
        
        [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            UITabBarController *tabBar = (UITabBarController *)[ToolManager shareInstance].drawerController.centerViewController;
            UINavigationController *nav =(UINavigationController *)tabBar.viewControllers[getAppDelegate().mainTab.selectedIndex];
            
            if ([dict[@"viewController"] isEqualToString:@"AuthenticationViewController"]) {
                AuthenticationViewController *authen = allocAndInit(AuthenticationViewController);
                authen.authen = modal.authen;
                [nav pushViewController:authen animated:YES];
                return ;
            }
            [nav pushViewController:allocAndInit((NSClassFromString(dict[@"viewController"] )))animated:YES];
            
        }];
        
        
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
