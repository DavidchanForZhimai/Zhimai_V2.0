//
//  BasicInformationViewController.m
//  Lebao
//
//  Created by David on 16/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BasicInformationViewController.h"
#import "EditNameViewController.h"
#import "XLDataService.h"
#import "DWOptionView.h"
#import "GWLCustomPikerView.h"
#import "ProvinceModel.h"
#import "UpLoadImageManager.h"//上传头像和背景
#import "NSString+File.h"
#import "CoreArchive.h"
//获取位置详情 URL:appinterface/areainfo
#define AreainfoURL [NSString stringWithFormat:@"%@common/area-ios",HttpURL]

//我的URL ：appinterface/personal
#define MemberURL [NSString stringWithFormat:@"%@user/member",HttpURL]
#define SaveMemberURL [NSString stringWithFormat:@"%@user/save-member",HttpURL]
@interface BasicInformationViewController ()<UITableViewDataSource,UITableViewDelegate,GWLCustomPikerViewDataSource, GWLCustomPikerViewDelegate>
@property(nonatomic,strong)BaseButton *saveBtn;
@property(nonatomic,strong)BasicInfoModal *modal;
@property(nonatomic,strong)UITableView    *basicInfoTableView;
@property (nonatomic,strong ) GWLCustomPikerView *customPikerView;

@property (strong, nonatomic) NSArray            *citiesData;
@property (nonatomic,assign ) NSInteger          selectedProvince;
@property (nonatomic,assign ) NSInteger          selectedCity;
@property (strong, nonatomic) NSMutableArray            *personArray;
@property (strong, nonatomic) NSMutableArray            *personAndoptionalArray;
@property (strong, nonatomic) NSMutableArray            *recommendArray;
@property (strong, nonatomic) NSMutableArray            *optionalArray;
@end

@implementation BasicInfoModal


@end
@implementation BasicInformationViewController
{
    float footerHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    footerHeight = 220;
    [self navView];
    [self mainView];
}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"基本资料"];
    _saveBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"保存" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    _saveBtn.hidden = YES;
    __weak BasicInformationViewController *weakSelf = self;
    _saveBtn.didClickBtnBlock = ^
    {
        [weakSelf modity:weakSelf];
        
        
    };
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}

#pragma mark
#pragma mark - mainView
- (void)mainView
{
    _personArray = allocAndInit(NSMutableArray);
    _personAndoptionalArray = allocAndInit(NSMutableArray);
    _optionalArray = allocAndInit(NSMutableArray);
    _recommendArray = allocAndInit(NSMutableArray);
    
    _basicInfoTableView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - StatusBarHeight -NavigationBarHeight) style:UITableViewStyleGrouped];
    _basicInfoTableView.delegate = self;
    _basicInfoTableView.dataSource = self;
    _basicInfoTableView.backgroundColor =[UIColor clearColor];
    
    [self.view addSubview:_basicInfoTableView];
    
    [[ToolManager shareInstance] showWithStatus:@"获取信息..."];
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@"info" forKey:Conduct];
    [XLDataService postWithUrl:MemberURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
            _modal = [BasicInfoModal mj_objectWithKeyValues:dataObj];
            if (![_modal.mylabels isEqualToString:@""]) {
                [_personArray addObjectsFromArray:[_modal.mylabels componentsSeparatedByString:@","]];
                
            }
            if (![_modal.filllabels isEqualToString:@""]) {
                [_optionalArray addObjectsFromArray:[_modal.filllabels componentsSeparatedByString:@","]];
                
            }
            if (![_modal.relabls isEqualToString:@""]) {
                [_recommendArray addObjectsFromArray:[_modal.relabls componentsSeparatedByString:@","]];
                
            }
            
            [_personAndoptionalArray addObjectsFromArray:_personArray];
            [_personAndoptionalArray addObjectsFromArray:_optionalArray];
            if (![_personAndoptionalArray containsObject:@"+标签"]) {
                [_personAndoptionalArray addObject:@"+标签"];
            }
            if (_modal.rtcode ==1) {
                
                NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                NSString *createPath = [NSString stringWithFormat:@"%@/%@.plist",pathDocuments,[CoreArchive  strForKey:AddressNewVersion]];
                NSString *createDir = [NSString stringWithFormat:@"%@/%@_code.plist",pathDocuments,[CoreArchive  strForKey:AddressNewVersion]];
                // 判断文件夹是否存在，如果不存在，则创建
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
                    
                    NSDictionary *param = [Parameter parameterWithSessicon];
                    [XLDataService postWithUrl:AreainfoURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                        
                        if (dataObj) {
                            [[ToolManager shareInstance] dismiss];
                            if ([dataObj[@"rtcode"] intValue] ==1) {
                                
                                NSDictionary *code_datas = [NSDictionary new];
                                code_datas = dataObj[@"code_datas"];
                                BOOL fl = [code_datas writeToFile:createDir atomically:YES]; //写入
                                NSMutableArray * datas =[NSMutableArray new];
                                datas = dataObj[@"datas"];
                                BOOL fll = [datas writeToFile:createPath atomically:YES];
                                if (!fl&&!fll) {
                                    [[ToolManager shareInstance] showInfoWithStatus:@"地址数据获取失败"];
                                }
                                else
                                {
                                    [_basicInfoTableView reloadData];
                                }
                                
                            }
                            else
                            {
                                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                            }
                        }
                        else
                        {
                            [[ToolManager shareInstance] showInfoWithStatus:@"地址数据获取失败"];
                        }
                        
                    }];
                    
                    
                } else {
                    [[ToolManager shareInstance] dismiss];
                    [_basicInfoTableView reloadData];
                }
                
                
            }
            else
            {
                
                [[ToolManager shareInstance] showInfoWithStatus:_modal.rtmsg];;
            }
            
        }
        else{
            
            [[ToolManager shareInstance] showInfoWithStatus];
            
        }
        
        
        
    }];
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0f;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSMutableDictionary  *height = [self footerView];
    
    return [height[@"height"] floatValue];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSMutableDictionary  *view = [self footerView];
    
    return (UIView *)view[@"view"];
}


- (NSMutableDictionary *)footerView
{
    UIView *footerView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_basicInfoTableView), footerHeight));
    footerView.backgroundColor = [UIColor clearColor];
    
    UIView *recommendView;
    UIView *personView = allocAndInitWithFrame(UIView, frame(0, 10, frameWidth(footerView), 88));
    personView.backgroundColor = WhiteColor;
    [footerView addSubview:personView];
    
    [UILabel createLabelWithFrame:frame(10, 0, frameWidth(personView), 35) text:@"个人标签" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:personView];
    [UILabel CreateLineFrame:frame(10, 35, frameWidth(personView) - 20, 0.5) inView:personView];
    
    float titleX = 10;
    float titleY = 45;
    float titleW  =0;
    float titleH = 27;
    float titleXW = 10;
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i<_personAndoptionalArray.count; i++) {
        NSString *tille =_personAndoptionalArray[i];
        titleW = tille.length*28*SpacedFonts + 10;
        if (titleW>frameWidth(footerView) - 20) {
            titleW = frameWidth(footerView) - 20;
            
        }
        titleXW =titleW+titleX+10;
        if (titleXW>APPWIDTH) {
            titleY +=(10+titleH);
            titleX =10;
            titleXW = 10;
        }
        UIColor *titleColor;
        UIColor  *setBorder;
        if (i==_personAndoptionalArray.count-1) {
            
            titleColor = BlackTitleColor;
            setBorder =LineBg;
        }
        else
        {
            titleColor = BlackTitleColor;
            setBorder =LineBg;
            titleColor = AppMainColor;
            setBorder =AppMainColor;
        }
        
        BaseButton *_selectedTag = [[BaseButton alloc]initWithFrame:frame(titleX, titleY, titleW, titleH) setTitle:tille titleSize:28*SpacedFonts titleColor:titleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:personView];
        [_selectedTag setRadius:10];
        [_selectedTag setBorder:setBorder width:0.5];
        _selectedTag.didClickBtnBlock = ^
        {
            weakSelf.saveBtn.hidden = NO;
            if (i==_personAndoptionalArray.count-1) {
                EditNameViewController *edit = allocAndInit(EditNameViewController);
                
                edit.editPageTag =EditeTag;
                edit.textView =  @"标签";
                edit.editBlock = ^(NSString *text)
                {
                    
                    [_personAndoptionalArray insertObject:text atIndex:0];
                    [_optionalArray addObject:text];
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
            else
            {
                
                if ([_optionalArray containsObject:_personAndoptionalArray[i]]) {
                    [_optionalArray removeObject:_personAndoptionalArray[i]];
                }
                if ([_personArray containsObject:_personAndoptionalArray[i]]) {
                    [_personArray removeObject:_personAndoptionalArray[i]];
                }
                [_personAndoptionalArray removeObjectAtIndex:i];
                
                [_basicInfoTableView reloadData];
            }
            
        };
        
        titleX +=titleW + 10;
        personView.frame = frame(frameX(personView), frameY(personView), frameWidth(personView), titleY + titleH + 10);
        
    }
    
    
    recommendView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(personView.frame), frameWidth(footerView), 70));
    recommendView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:recommendView];
    
    [UILabel createLabelWithFrame:frame(10, 0, frameWidth(personView), 35) text:@"推荐标签" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:recommendView];
    
    float s_titleX = 10;
    float s_titleY = 35;
    float s_titleW  =0;
    float s_titleH = 27;
    float s_titleXW = 10;
    
    for (int i = 0; i<_recommendArray.count; i++) {
        NSString *tille =_recommendArray[i];
        s_titleW = tille.length*28*SpacedFonts + 10;
        if (s_titleW>frameWidth(recommendView) - 20) {
            s_titleW = frameWidth(recommendView) - 20;
            
        }
        s_titleXW =s_titleW+s_titleX+10;
        
        if (s_titleXW>APPWIDTH) {
            s_titleY +=(10+s_titleH);
            s_titleX =10;
            s_titleXW = 10;
        }
        UIColor *titleColor;
        UIColor  *setBorder;
        titleColor = BlackTitleColor;
        setBorder =LineBg;
        
        BaseButton *_selectedTag = [[BaseButton alloc]initWithFrame:frame(s_titleX, s_titleY , s_titleW, s_titleH) setTitle:tille titleSize:28*SpacedFonts titleColor:titleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:recommendView];
        [_selectedTag setRadius:10];
        [_selectedTag setBorder:setBorder width:0.5];
        _selectedTag.didClickBtnBlock = ^
        {
            
            if ([_personAndoptionalArray containsObject:weakSelf.recommendArray[i]]) {
                
                [[ToolManager shareInstance] showInfoWithStatus:@"重复选择！"];
                return ;
            }
            weakSelf.saveBtn.hidden = NO;
            [_personAndoptionalArray insertObject:weakSelf.recommendArray[i] atIndex:0];
            
            [_personArray addObject:weakSelf.recommendArray[i]];
            
            
            [_basicInfoTableView reloadData];
            
            
        };
        
        s_titleX +=s_titleW + 10;
        recommendView.frame = frame(frameX(recommendView),CGRectGetMaxY(personView.frame), frameWidth(recommendView), s_titleY + s_titleH + 10);
        
    }
    
    NSMutableDictionary *viewAndHeight = [NSMutableDictionary dictionaryWithObjectsAndKeys:footerView,@"view",@(CGRectGetMaxY(recommendView.frame) + 10),@"height", nil];
    return viewAndHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0 ) {
        return 50.0f;
    }
    else
    {
        return 40.0f;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"BasicInformationView";
    BasicInformationView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    float cellH;
    if (indexPath.row ==0) {
        cellH = 50.0f;
    }
    else
    {
        cellH = 40.0f;
    }
    if (!cell) {
        
        cell = [[BasicInformationView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_basicInfoTableView)];
    }
    
    switch (indexPath.row) {
        case 0:
            if (!_modal.imgurl) {
                _modal.imgurl =@"";
            }
            
            [cell  showTitle:@"头像" icon:_modal.imgurl bg:nil detail:nil canEdit:YES];
            break;
        case 1:
            [cell  showTitle:@"姓名" icon:nil bg:nil detail:_modal.realname canEdit:YES];
            break;
        case 2:
            if ([_modal.sex isEqualToString:@"1"]) {
                [cell  showTitle:@"性别" icon:nil bg:nil detail:@"男" canEdit:YES];
            }
            else
            {
                [cell  showTitle:@"性别" icon:nil bg:nil detail:@"女" canEdit:YES];
            }
            
            break;
        case 3:
            [cell  showTitle:@"手机" icon:nil bg:nil detail:_modal.tel  canEdit:NO];
            break;
        case 4:
            
        {
            NSString *address = _modal.area;
            if (!address||[address isEqualToString:@""]) {
                address =@"";
            }
            else
            {
                NSString *pro;
                NSString *city;
                NSArray *addressArray = [address componentsSeparatedByString:@"-"];
                if (addressArray.count>1) {
                    
                    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *createPath = [NSString stringWithFormat:@"%@/%@_code.plist",pathDocuments,[CoreArchive  strForKey:AddressNewVersion]];
                    
                    NSDictionary *citiesArray                 = [NSDictionary dictionaryWithContentsOfFile:createPath];
                    city = citiesArray[@"city"][[NSString stringWithFormat:@"%@",addressArray[1]]];
                    pro = citiesArray[@"province"][[NSString stringWithFormat:@"%@",addressArray[0]]];
                    address = [NSString stringWithFormat:@"%@-%@",pro,city];
                }
                
            }
            [cell  showTitle:@"地区" icon:nil bg:nil detail:address canEdit:YES];
        }
            break;
        case 5:
            
            [cell  showTitle:@"简介" icon:nil bg:nil detail:_modal.synopsis canEdit:YES];
            break;
        case 6:
            
            [cell  showTitle:@"公司" icon:nil bg:nil detail:_modal.address canEdit:YES];
            break;
        case 7:
            
            [cell  showTitle:@"从业年限" icon:nil bg:nil detail:_modal.workyears canEdit:YES];
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@"edit" forKey:Conduct];
    __weak BasicInformationViewController *weakSelf= self;
    if (indexPath.row ==0) {
        [[ToolManager shareInstance] seleteImageFormSystem:self seleteImageFormSystemBlcok:^(UIImage *image) {
            NSString *type;
            type =@"head";
            [[UpLoadImageManager shareInstance] upLoadImageType:type image:image imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                weakSelf.saveBtn.hidden = NO;
                _modal.imgurl = upLoadImageModal.abbr_imgurl;
                [_basicInfoTableView reloadData];
                
            }];
        }];
        
        
    }
    else
    {
        EditNameViewController *edit = allocAndInit(EditNameViewController);
        
        switch (indexPath.row) {
            case 1:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditNamePageTag;
                edit.textView =  _modal.realname;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.realname = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
            case 2:
            {
                DWOptionView  *view =[[DWOptionView alloc]initWithFrame:self.view.window.bounds block:^(BOOL isBoy) {
                    weakSelf.saveBtn.hidden = NO;
                    int tag;
                    if (isBoy) {
                        tag = 1;
                    }
                    else
                    {
                        tag =2;
                    }
                    
                    _modal.sex = [NSString stringWithFormat:@"%i",tag];
                    [_basicInfoTableView reloadData];
                    view.tag = 88;
                }];
                
            }
                break;
                
            case 4:
            {
                [self configureCustomPikerView];
            }
                break;
                
            case 5:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditIntroducePageTag;
                edit.textView =  _modal.synopsis;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.synopsis = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
            case 6:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditCompanyTag;
                edit.textView =  _modal.address;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.address = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
                
            case 7:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditWorkYearsPageTag;
                edit.textView =  _modal.workyears;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.workyears = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
                
            default:
                break;
        }
        
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)modity:(BasicInformationViewController *)weakSelf;
{
    
    [[ToolManager shareInstance] showWithStatus:@"修改中.."];
    NSMutableDictionary *parame =[Parameter parameterWithSessicon];
    [parame setObject:_modal.imgurl forKey:@"imgurl"];
    [parame setObject:_modal.sex forKey:@"sex"];
    [parame setObject:_modal.area forKey:@"area"];
    [parame setObject:_modal.realname forKey:@"realname"];
    [parame setObject:_modal.synopsis forKey:@"synopsis"];
    [parame setObject:_modal.tel forKey:@"tel"];
    [parame setObject:_modal.address forKey:@"address"];
    [parame setObject:_modal.workyears forKey:@"workyears"];
    
    if ([_personArray mj_JSONString]) {
        [parame setObject:[_personArray mj_JSONString] forKey:@"mylabels"];
    }
    if ([_optionalArray mj_JSONString]) {
        [parame setObject:[_optionalArray mj_JSONString] forKey:@"filllabels"];
    }
    
    //    NSLog(@"parame =%@",parame);
    [XLDataService postWithUrl:SaveMemberURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                weakSelf.saveBtn.hidden = YES;
                [[ToolManager shareInstance] showSuccessWithStatus:@"修改成功"];
                PopView(weakSelf);
            }
            else
            {
                weakSelf.saveBtn.hidden = NO;
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
            
        }
        else
        {
            weakSelf.saveBtn.hidden = NO;
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
        
    }];
}

- (void)configureCustomPikerView {
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@.plist",pathDocuments, [CoreArchive  strForKey:AddressNewVersion]];
    
    if (!_citiesData) {
        
        NSArray *citiesArray                 = [NSArray arrayWithContentsOfFile:createPath];
        
        if (!citiesArray) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"获取不到数据，请稍等再试！！"];
            
            return;
        }
        
        NSMutableArray *provinceModelArrayM  = [NSMutableArray array];
        for (NSDictionary *dict in citiesArray) {
            ProvinceModel *provinceModel         = [ProvinceModel provinceModelWithDict:dict];
            [provinceModelArrayM addObject:provinceModel];
        }
        _citiesData                          = provinceModelArrayM;
        //        NSLog(@"_citiesData =%@",_citiesData);
    }
    
    
    if (!self.customPikerView) {
        self.customPikerView   = [[GWLCustomPikerView alloc]init];
        self.customPikerView.frame = CGRectMake(0, APPHEIGHT, self.view.bounds.size.width, 220);
        [UIView animateWithDuration:0.5 animations:^{
            self.customPikerView.frame = CGRectMake(0, APPHEIGHT  -220, self.view.bounds.size.width, 220);
        }];
        
        self.customPikerView.dataSource           = self;
        self.customPikerView.delegate             = self;
        self.customPikerView.titleLabelText       = @"请选择地址";
        self.customPikerView.titleLabelColor      = AppMainColor;
        self.customPikerView.titleButtonText      = @"确定";
        self.customPikerView.titleButtonTextColor = AppMainColor;
        self.customPikerView.indicatorColor       = AppMainColor;
        [self.view addSubview:self.customPikerView];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.customPikerView.frame = CGRectMake(0, APPHEIGHT  -220, self.view.bounds.size.width, 220);
        }];
        
    }
    
}

#pragma mark - GWLCustomPikerViewDataSource
- (NSInteger)numberOfComponentsInCustomPikerView:(GWLCustomPikerView *)customPickerView {
    return 2;
}

- (NSInteger)customPickerView:(GWLCustomPikerView *)customPickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.citiesData.count;
    }else {
        ProvinceModel *provinceModel         = self.citiesData[_selectedProvince];
        return provinceModel.citys.count;
    }
}

- (NSString *)customPickerView:(GWLCustomPikerView *)customPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        ProvinceModel *provinceModel         = self.citiesData[row];
        return provinceModel.name;
    }else {
        ProvinceModel *provinceModel         = self.citiesData[_selectedProvince];
        return provinceModel.citys[row][@"name"];
    }
}


#pragma mark - GWLCustomPikerViewDelegate
- (void)customPikerViewDidSelectedComponent:(NSInteger)component row:(NSInteger)row {
    if (component == 0) {
        _selectedProvince                    = row;
        [self.customPikerView reloadComponent:1];
        _selectedCity                        = 0;
    }else if (component == 1) {
        _selectedCity                        = row;
    }
    
    //    ProvinceModel *provinceModel         = self.citiesData[_selectedProvince];
    
}

- (void)customPikerViewCompleteSelectedRows:(NSArray *)rows {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.customPikerView.frame = CGRectMake(0, APPHEIGHT, self.view.bounds.size.width, 220);
    }];
    ProvinceModel *provinceModel         = self.citiesData[[rows[0] integerValue]];
    
    _modal.area = [NSString stringWithFormat:@"%@-%@",provinceModel.code,provinceModel.citys[[rows[1] integerValue]][@"code"]];
    _saveBtn.hidden = NO;
    [_basicInfoTableView reloadData];
    
    
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


@implementation BasicInformationView
{
    UIImageView *assorry;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _title =[UILabel createLabelWithFrame:frame(15, 0, cellWidth/2.0, cellHeight) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        _detailTitle =[UILabel createLabelWithFrame:frame(100*ScreenMultiple, 0, cellWidth -100*ScreenMultiple - 35, cellHeight) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:self];
        _detailTitle.hidden = YES;
        
        _userIcon = allocAndInitWithFrame(UIImageView, frame(cellWidth - 73, 6, 38, 38));
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = frameWidth(_userIcon)/2.0;
        _userIcon.hidden = YES;
        _userIcon.image = [UIImage imageNamed:@"ditu"];
        [self addSubview:_userIcon];
        
        _userBg = allocAndInitWithFrame(UIImageView, frame(cellWidth - 85, 6, 50, 38));
        _userBg.hidden = YES;
        _userBg.image = [UIImage imageNamed:@"defaulthead"];
        [self addSubview:_userBg];
        
        UIImage *image =[UIImage imageNamed:@"option"];
        assorry =allocAndInitWithFrame(UIImageView, frame(cellWidth - 13 - image.size.width, (cellHeight - image.size.width)/2.0, image.size.width, image.size.height));
        assorry.image = image;
        assorry.hidden = YES;
        [self addSubview:assorry];
        
        //        [UILabel CreateLineFrame:frame(0, cellHeight , cellWidth, 0.5) inView:self];
        
        
    }
    
    return self;
}
- (void)showTitle:(NSString *)title icon:(NSString *)icon bg:(NSString *)bg detail:(NSString *)detail canEdit:(BOOL)canEdit
{
    assorry.hidden = !canEdit;
    
    if (title) {
        _title.text =title;
        _title.hidden = NO;
    }
    else
    {
        _title.hidden = YES;
    }
    if (icon) {
        
        [[ToolManager shareInstance] imageView:_userIcon setImageWithURL:icon placeholderType:PlaceholderTypeUserHead];
        _userIcon.hidden = NO;
    }
    else
    {
        _userIcon.hidden = YES;
    }
    if (bg) {
        
        [[ToolManager shareInstance] imageView:_userBg setImageWithURL:bg placeholderType:PlaceholderTypeUserBg];
        _userBg.hidden = NO;
    }
    else
    {
        _userBg.hidden = YES;
    }
    if (detail) {
        _detailTitle.text =detail;
        _detailTitle.hidden = NO;
    }
    else
    {
        _detailTitle.hidden = YES;
    }
    
}
@end
