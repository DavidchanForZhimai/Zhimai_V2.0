//
//  MeetingTVCell.m
//  Lebao
//
//  Created by adnim on 16/8/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetingTVCell.h"
#import "Parameter.h"
#import "NSString+Extend.h"
#import "BaseButton.h"
#import "ImgAndLabView.h"

@implementation MeetingTVCell
{
    UIView *customV;
    UIView *lineView;
    UIView *lineView1;
    UILabel *productLab;
    UILabel *resourceLab;
    UIImageView *woshouImgV;
    UIView *imgLabview1;
    UIView *imgLabview2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    return self;
}

-(void)customView
{
    customV=[[UIView alloc]init];
    customV.backgroundColor=[UIColor whiteColor];

    customV.userInteractionEnabled=YES;
    [self addSubview:customV];
    [self addTopUI];
}

-(void)addTopUI
{
    _headImgV=[[UIImageView alloc]init];
    _headImgV.contentMode=UIViewContentModeScaleAspectFill;
    _headImgV.clipsToBounds=YES;
    [customV addSubview:_headImgV];
    
    _nameLab=[[UILabel alloc]init];
    _nameLab.font=[UIFont systemFontOfSize:15];
    _nameLab.textColor=[UIColor blackColor];
    _nameLab.textAlignment=NSTextAlignmentLeft;

    [customV addSubview:_nameLab];
    
    _certifyImg=[[UIImageView alloc]init];
    _certifyImg.image=[UIImage imageNamed:@"weirenzhen"];
     [customV addSubview:_certifyImg];
    
    _companyLab=[[UILabel alloc]init];
    _companyLab.font=[UIFont systemFontOfSize:12];
    _companyLab.textColor=[UIColor lightGrayColor];
    _companyLab.textAlignment=NSTextAlignmentLeft;
  
  
    [customV addSubview:_companyLab];
    

    _meetingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    _meetingBtn.backgroundColor=AppMainColor;
    [_meetingBtn setTitle:@"约见" forState:UIControlStateNormal];
    [_meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _meetingBtn.layer.cornerRadius=12;

    [customV addSubview:_meetingBtn];
    
    lineView=[[UIView alloc]init];

    lineView.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [customV addSubview:lineView];
    
    productLab=[[UILabel alloc]init];
    productLab.font=[UIFont systemFontOfSize:12];
    productLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    productLab.textAlignment=NSTextAlignmentLeft;
    productLab.text=@"产品服务";
    [customV addSubview:productLab];
    

    resourceLab=[[UILabel alloc]init];
    
    resourceLab.font=[UIFont systemFontOfSize:12];
    resourceLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    resourceLab.textAlignment=NSTextAlignmentLeft;
    resourceLab.text=@"资源特点";
    [customV addSubview:resourceLab];
    
    imgLabview2=[[UIView alloc]init];
    [customV addSubview:imgLabview2];
    
    lineView1=[[UIView alloc]init];
    
    lineView1.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [customV addSubview:lineView1];

    _distanceAndtimerLab=[[UILabel alloc]init];
    
    _distanceAndtimerLab.font=[UIFont systemFontOfSize:12];
    _distanceAndtimerLab.textColor=[UIColor lightGrayColor];
    _distanceAndtimerLab.textAlignment=NSTextAlignmentRight;


    [customV addSubview:_distanceAndtimerLab];

    
    woshouImgV=[[UIImageView alloc]init];
   
    woshouImgV.image=[UIImage imageNamed:@"pipeidu"];
    [customV addSubview:woshouImgV];
    
    _woNumLab=[[UILabel alloc]init];
    
    _woNumLab.textColor=[UIColor orangeColor];
    _woNumLab.textAlignment=NSTextAlignmentLeft;

    _woNumLab.font=[UIFont systemFontOfSize:13];
    [customV addSubview:_woNumLab];
    
}

-(void)configCellWithObjiect:(LayoutMeetingModal *)layout
{
    
     MeetingData *data = layout.data;
    
    [imgLabview1 removeFromSuperview];
    [imgLabview2 removeFromSuperview];
    
     customV.frame = layout.customVFrame;
    
    _headImgV.frame = layout.headImgVFrame;
    [[ToolManager shareInstance] imageView:_headImgV setImageWithURL:data.imgurl placeholderType:PlaceholderTypeUserHead];
    
    _nameLab.frame = layout.nameLabFrame;
    _nameLab.text=data.realname;
    
    _certifyImg.frame = layout.certifyImgFrame;
    if ([data.authen isEqualToString:@"3"]) {
        _certifyImg.image=[UIImage imageNamed:@"renzhen"];
    }
    
    
    _companyLab.frame = layout.companyLabFrame;
    _companyLab.text=[NSString stringWithFormat:@"%@  从业%@年",[Parameter industryForChinese:data.industry],data.workyears];
    
    _meetingBtn.frame = layout.meetingBtnFrame;
    
    lineView.frame = layout.lineViewFrame;
    
    productLab.frame = layout.productLabFrame;
    resourceLab.frame = layout.resourceLabFrame;
    imgLabview2.frame = layout.imgLabview2Frame;
    lineView1.frame = layout.lineView1Frame;
    

    _distanceAndtimerLab.frame = layout.distanceLabFrame;
    float distance=[data.distance floatValue]/1000.00;
    _distanceAndtimerLab.text=[NSString stringWithFormat:@"%.2lfkm·%@",distance,[data.time updateTime]];
    woshouImgV.frame = layout.woshouImgVFrame;
    _woNumLab.frame = layout.woNumLabFrame;
    _woNumLab.text = data.match;
    
     UIImage *img=[UIImage imageNamed:@"biaoqian"];
    if (layout.productsFrame.count>0) {
        imgLabview1=[[UIView alloc]init];
        imgLabview1.frame = layout.imgLabview1Frame;
        [customV addSubview:imgLabview1];
        
        
        NSArray *productArr=[data.service componentsSeparatedByString:@"/"];
        for (int i=0; i<layout.productsFrame.count; i++) {
        CGRect frame = CGRectFromString(layout.productsFrame[i]);
         BaseButton *imgLabV = [[BaseButton alloc]initWithFrame:frame setTitle:productArr[i] titleSize:24*SpacedFonts titleColor:[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000] backgroundImage:nil iconImage:img highlightImage:img setTitleOrgin:CGPointMake((frame.size.height - 24*SpacedFonts)/2.0, 3) setImageOrgin:CGPointMake((frame.size.height - img.size.height)/2.0, 0) inView:imgLabview1];
            imgLabV = nil;
        }
        
    }
    if (layout.resourcesFrame.count>0) {
       
        imgLabview2=[[UIView alloc]init];
        imgLabview2.frame = layout.imgLabview2Frame;
        [customV addSubview:imgLabview2];
        
        NSArray *resourceArr=[data.resource componentsSeparatedByString:@"/"];
        for (int i=0; i<layout.resourcesFrame.count; i++) {
            CGRect frame = CGRectFromString(layout.resourcesFrame[i]);
            BaseButton *imgLabV = [[BaseButton alloc]initWithFrame:frame setTitle:resourceArr[i] titleSize:24*SpacedFonts titleColor:[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000] backgroundImage:nil iconImage:img highlightImage:img setTitleOrgin:CGPointMake((frame.size.height - 24*SpacedFonts)/2.0, 3) setImageOrgin:CGPointMake((frame.size.height - img.size.height)/2.0, 0) inView:imgLabview2];
            imgLabV = nil;
        }

        
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
