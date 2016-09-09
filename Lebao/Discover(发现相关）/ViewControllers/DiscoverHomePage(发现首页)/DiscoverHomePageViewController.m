//
//  DiscoverHomePageViewController.m
//  Lebao
//
//  Created by David on 16/5/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DiscoverHomePageViewController.h"
#import "DiscoverViewController.h"//精选文章
#import "RedpacketsforwardingViewController.h"//红包转发
#import "ReadhotViewController.h"//热门阅读
#import "AlreadysentproductViewController.h"//已发产品
#import "ReadMeMostViewController.h"//读我最多
#import "JinJiRenViewController.h"//经纪人
#import "ReaderAttributesViewController.h"
#import "XLDataService.h"
#import "MeCell.h"
#import "CoreArchive.h"

//发现轮播图
#import "WHC_Banner.h"
#define RID  @"rid"
#define LibraryHome [NSString stringWithFormat:@"%@library/home",HttpURL]

@interface DiscoverHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
//@property(nonatomic,strong)BaseButton *dicoverBtn;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)WHC_Banner *banner;
@property(nonatomic,strong)UILabel *redLabel;
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong) NSMutableArray *meArray;
@end

@implementation DiscoverHomePageModal


+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"DiscoverHomePageData",
             };
    
}

@end
@implementation DiscoverHomePageData


@end
@implementation DiscoverHomePageViewController


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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![CoreArchive strForKey:RID]) {
        [CoreArchive setStr:@"0" key:RID];
    }
    [self setTabbarIndex:2];
    [self navViewTitle:@"发现" ];
    
    [self.view addSubview:self.homePageBtn];
    [self mainView];
    [self netWork];

}

- (void)mainView{
  
    _meArray = allocAndInit(NSMutableArray);
    ;
    NSArray *title1 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"线索",@"name",@"xiansuo",@"image",@"1",@"show",@"WBHomePageVC",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"红包转发",@"name",@"hongbao",@"image",@"0",@"show",@"ReadhotViewController",@"viewController", nil], nil];
    NSArray *title2 =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"封装文章",@"name",@"fengzhuanglianjie",@"image",@"1",@"show",@"",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"自编辑文章",@"name",@"liaoku",@"image",@"1",@"show",@"",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"文章数据",@"name",@"shuju",@"image",@"0",@"show", @"",@"viewController",nil], nil];
   
    [_meArray addObject:title1];
    [_meArray addObject:title2];
    
    _tabView=[[UITableView alloc]initWithFrame:frame(0,StatusBarHeight + NavigationBarHeight, APPWIDTH,APPHEIGHT -(StatusBarHeight + NavigationBarHeight + TabBarHeight)) style:UITableViewStyleGrouped];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.backgroundColor =AppViewBGColor;
    _tabView.tableHeaderView =allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 0.4*APPWIDTH));
    [[ToolManager shareInstance] scrollView:_tabView headerWithRefreshingBlock:^{
        [self netWork];
        
    }];
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabView];

}
- (void)netWork//广告
{
    __weak typeof(self) weakSelf =self;
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
    [XLDataService postWithUrl:LibraryHome param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [[ToolManager shareInstance] endHeaderWithRefreshing:_tabView];

        if (dataObj) {
            DiscoverHomePageModal *modal = [DiscoverHomePageModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode) {
                [[ToolManager shareInstance]dismiss];
                if ([[CoreArchive strForKey:RID] intValue]== modal.rid) {
                    _redLabel.hidden = YES;
                }
                else
                {
                    _redLabel.hidden = NO;
                }
             
                if (modal.isdefault) {
                    if (!_headImageView) {
                        _headImageView = allocAndInitWithFrame(UIImageView, frame(0, 0, frameWidth(self.view), 0.4*frameWidth(self.view)));
                        _headImageView.backgroundColor = WhiteColor;
                        _tabView.tableHeaderView =_headImageView;
                        
                    }
                    
                    [[ToolManager shareInstance] imageView:_headImageView setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeImageUnProcessing];
                    
                }
                else
                {
                       [_banner removeFromSuperview];
                        _banner = nil;
                        _banner = [[WHC_Banner alloc] initWithFrame:frame(0, 0, frameWidth(self.view), 0.4*frameWidth(self.view))];
                        _tabView.tableHeaderView =_banner;
                        _banner.backgroundColor = WhiteColor;
                        _banner.imageUrls  = allocAndInit(NSMutableArray);
                        _banner.imageTitles = allocAndInit(NSMutableArray);
                
                    for (DiscoverHomePageData *data in modal.datas) {
                        [_banner.imageUrls addObject:data.foundimg];
                        if (data.istitle) {
                            [_banner.imageTitles addObject:data.foundtitle];
                        }
                        else
                        {
                            [_banner.imageTitles addObject:@""];
                        }
                    }
                    
                    [_banner setNetworkLoadingImageBlock:^(UIImageView *imageView, NSString *url, NSInteger index) {
                        
                        
                        [[ToolManager shareInstance] imageView:imageView setImageWithURL:url placeholderType:PlaceholderTypeImageUnProcessing];
                    }];
                    [_banner setDidClickImageBlock:^(UIImageView *imageView, NSString *url, NSInteger index) {
                        DiscoverHomePageData *data = modal.datas[index];
                    //    NSLog(@"%@",data.foundlink);
                        [[ToolManager shareInstance] loadWebViewWithUrl:data.foundlink title:weakSelf.banner.imageTitles[index] pushView:weakSelf rightBtn:nil];
                    }];
                    
                    [_banner startBanner];
                }
                
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
    
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"MeCell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:40 cellWidth:frameWidth(_tabView)];
        
        
    }
    NSArray * _sectionArray = _meArray[indexPath.section];
    NSDictionary *dict = _sectionArray[indexPath.row];
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
        
        
        [self.navigationController pushViewController:allocAndInit((NSClassFromString(dict[@"viewController"] )))animated:YES];
        
        
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
