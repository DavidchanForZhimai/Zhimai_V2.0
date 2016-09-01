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

#import "CoreArchive.h"
//发现轮播图
#import "WHC_Banner.h"
#define RID  @"rid"
#define LibraryHome [NSString stringWithFormat:@"%@library/home",HttpURL]

@interface DiscoverHomePageViewController ()
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)BaseButton *dicoverBtn;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)WHC_Banner *banner;
@property(nonatomic,strong)UILabel *redLabel;
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
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight + 49)));
    _mainScrollView.alwaysBounceVertical = YES;
    [[ToolManager shareInstance] scrollView:_mainScrollView headerWithRefreshingBlock:^{
        [self netWork];
        
    }];
    
    NSArray *title = @[@"  经纪人",@"红包转发",@"精选文章",@"热门阅读",@"已发产品",@"已发文章",@"读者属性",@"读我最多",@""];
     NSArray *imageName = @[@"jingjiren",@"iconfont-hongbao",@"iconfont-jxwenzhang",@"iconfont-chaye",@"iconfont-yfchanpin",@"iconfont-tushuziliaoku",@"yueduzuidu",@"iconfont-yikezaixianduiyi12",@""];
    
    for (int i =0; i<imageName.count; i++) {
        UIImage *image = [UIImage imageNamed:imageName[i]];
        
        _dicoverBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH/3.0*(i%3),0.4*frameWidth(self.view)+10 + (85*ScreenMultiple + 10)*(i/3), APPWIDTH/3.0-0.5, 85*ScreenMultiple) setTitle:title[i] titleSize:24*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(28*ScreenMultiple + image.size.height, (APPWIDTH/3.0 - 4*24*SpacedFonts)/2.0 - image.size.width) setImageOrgin:CGPointMake(17*ScreenMultiple, (APPWIDTH/3.0 - image.size.width)/2.0) inView:_mainScrollView];
        if (i==1) {
            
            _redLabel = allocAndInitWithFrame(UILabel, frame(frameWidth(_dicoverBtn)/2.0 + 10*ScreenMultiple, 15*ScreenMultiple, 8, 8));
            [_redLabel setRound];
            _redLabel.backgroundColor = [UIColor redColor];
            _redLabel.hidden = YES;
            [_dicoverBtn addSubview:_redLabel];
        }

        _dicoverBtn.shouldAnmial = NO;
        _dicoverBtn.backgroundColor = WhiteColor;
        if (i!=2&&i!=5&&i!=8) {
            
           UILabel *lineb=  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_dicoverBtn.frame), frameY(_dicoverBtn), 0.5, frameHeight(_dicoverBtn)) text:@"" fontSize:0 textColor:LineBg textAlignment:0 inView:_mainScrollView];
            lineb.backgroundColor = LineBg;
        }
        
        __weak DiscoverHomePageViewController *weakSelf = self;
        _dicoverBtn.didClickBtnBlock = ^
        {
            if (![title[i] isEqualToString:@""]) {
                
                switch (i) {
                    case 0:
                    
                    {
                        PushView(weakSelf, allocAndInit(JinJiRenViewController));
//                        redLabel.hidden = YES;
                    }
                        break;

                    case 1:
                        PushView(weakSelf, allocAndInit(RedpacketsforwardingViewController));
                        weakSelf.redLabel.hidden = YES;
                        break;
                    case 2:
                        PushView(weakSelf, allocAndInit(DiscoverViewController));
                        break;
                    case 3:
                        PushView(weakSelf, allocAndInit(ReadhotViewController));
                        break;
                    case 4:
                        PushView(weakSelf, allocAndInit(AlreadysentproductViewController));
                        break;
                    case 5:
                    { AlreadysentproductViewController *article  = allocAndInit(AlreadysentproductViewController);
                        article.isArticle = YES;
                        PushView(weakSelf, article);
                        break;
                    }
                    case 6:
                        PushView(weakSelf, allocAndInit(ReaderAttributesViewController));
                        break;
                    case 7:
                        PushView(weakSelf, allocAndInit(ReadMeMostViewController));
                        break;
                    

                    default:
                        break;
                }
                
            }
           
        };
        if (CGRectGetMaxY(_dicoverBtn.frame) + 10>frameHeight(_mainScrollView)) {
            _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_dicoverBtn.frame) + 10);
        }
    }
    [self.view addSubview:_mainScrollView];
}
- (void)netWork
{
    __weak typeof(self) weakSelf =self;
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
    [XLDataService postWithUrl:LibraryHome param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [[ToolManager shareInstance] endHeaderWithRefreshing:_mainScrollView];

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
                        _headImageView = allocAndInitWithFrame(UIImageView, frame(0, 0, frameWidth(_mainScrollView), 0.4*frameWidth(_mainScrollView)));
                        _headImageView.backgroundColor = WhiteColor;
                        [_mainScrollView addSubview:_headImageView];
                        
                    }
                    
                    [[ToolManager shareInstance] imageView:_headImageView setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeImageUnProcessing];
                    
                }
                else
                {
                       [_banner removeFromSuperview];
                        _banner = nil;
                        _banner = [[WHC_Banner alloc] initWithFrame:frame(0, 0, frameWidth(_mainScrollView), 0.4*frameWidth(_mainScrollView))];
                        [_mainScrollView addSubview:_banner];
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
