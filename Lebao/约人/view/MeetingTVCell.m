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
    customV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, self.frame.size.height-10)];
    customV.backgroundColor=[UIColor whiteColor];

    customV.userInteractionEnabled=YES;
    [self addSubview:customV];
     [self addTopUI];
}

-(void)addTopUI
{
    _headImgV=[[UIImageView alloc]init];
    _headImgV.frame=CGRectMake(10, 13, 44, 44);
    _headImgV.contentMode=UIViewContentModeScaleAspectFill;
    [[ToolManager shareInstance] imageView:_headImgV setImageWithURL:@"" placeholderType:PlaceholderTypeUserHead];
    _headImgV.layer.cornerRadius=_headImgV.width/2.0;
    _headImgV.clipsToBounds=YES;
    [customV addSubview:_headImgV];
    
    _nameLab=[[UILabel alloc]init];
    _nameLab.frame=CGRectMake(CGRectGetMaxX(_headImgV.frame)+10,12, 55, 25);
    _nameLab.font=[UIFont systemFontOfSize:15];
    _nameLab.textColor=[UIColor blackColor];
    _nameLab.textAlignment=NSTextAlignmentLeft;
    _nameLab.text=@"知脉君";
    [customV addSubview:_nameLab];
    
    _certifyImg=[[UIImageView alloc]init];
    _certifyImg.frame=CGRectMake(CGRectGetMaxX(_nameLab.frame)+5, _nameLab.y+(_nameLab.height - 14)/2.0, 14, 14);
    _certifyImg.image=[UIImage imageNamed:@"weirenzhen"];
     [customV addSubview:_certifyImg];
    
    _companyLab=[[UILabel alloc]init];
    _companyLab.frame=CGRectMake(CGRectGetMinX(_nameLab.frame), CGRectGetMaxY(_nameLab.frame)+5, 22, 14);
    _companyLab.font=[UIFont systemFontOfSize:12];
    _companyLab.textColor=[UIColor lightGrayColor];
    _companyLab.textAlignment=NSTextAlignmentLeft;
    _companyLab.text=@"知脉";
  
  
    [customV addSubview:_companyLab];
    
    _jobLab=[[UILabel alloc]init];
    _jobLab.frame=CGRectMake(CGRectGetMaxX(_companyLab.frame)+5, _companyLab.y, 55, 14);
    _jobLab.font=[UIFont systemFontOfSize:12];
    _jobLab.textColor=[UIColor lightGrayColor];
    _jobLab.textAlignment=NSTextAlignmentLeft;
    _jobLab.text=@"知脉科技";
      [customV addSubview:_jobLab];
    
    _yearLab=[[UILabel alloc]init];
    _yearLab.frame=CGRectMake(CGRectGetMaxX(_jobLab.frame)+5, _companyLab.y, 55, 14);
    _yearLab.font=[UIFont systemFontOfSize:12];
    _yearLab.textColor=[UIColor lightGrayColor];
    _yearLab.textAlignment=NSTextAlignmentLeft;
    _yearLab.text=@"从业1000年";
       [customV addSubview:_yearLab];
    
    _meetingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _meetingBtn.frame=CGRectMake(customV.width-70, 20, 60, 30);
    _meetingBtn.backgroundColor=AppMainColor;
    [_meetingBtn setTitle:@"约见" forState:UIControlStateNormal];
    [_meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _meetingBtn.layer.cornerRadius=12;

    [customV addSubview:_meetingBtn];
    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, CGRectGetMaxY(_yearLab.frame)+10, customV.width, 1);
    lineView.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [customV addSubview:lineView];
    
    productLab=[[UILabel alloc]init];
    productLab.frame=CGRectMake(_companyLab.x, CGRectGetMaxY(lineView.frame)+10, 50, 14);
    productLab.font=[UIFont systemFontOfSize:12];
    productLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    productLab.textAlignment=NSTextAlignmentLeft;
    productLab.text=@"产品服务";
    [customV addSubview:productLab];
    
   
    
    resourceLab=[[UILabel alloc]init];
    resourceLab.frame=CGRectMake(productLab.x, CGRectGetMaxY(productLab.frame)+10, 50, 14);
    resourceLab.font=[UIFont systemFontOfSize:12];
    resourceLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    resourceLab.textAlignment=NSTextAlignmentLeft;
    resourceLab.text=@"资源特点";
    [customV addSubview:resourceLab];
    
    imgLabview2=[[UIView alloc]init];
    imgLabview2.frame=CGRectMake(CGRectGetMaxX(resourceLab.frame)+10, resourceLab.y, 0, 0);
    [customV addSubview:imgLabview2];
    
    lineView1=[[UIView alloc]init];
    lineView1.frame=CGRectMake(0, CGRectGetMaxY(resourceLab.frame)+10, customV.width, 1);
    lineView1.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [customV addSubview:lineView1];

    _timerLab=[[UILabel alloc]init];
    _timerLab.frame=CGRectMake(customV.width-65, lineView1.y+10, 60, 14);
    _timerLab.font=[UIFont systemFontOfSize:12];
    _timerLab.textColor=[UIColor lightGrayColor];
    _timerLab.textAlignment=NSTextAlignmentRight;
    _timerLab.text=@"在1000年以后";
  
    [customV addSubview:_timerLab];
    
    _distanceLab=[[UILabel alloc]init];
    _distanceLab.frame=CGRectMake(0, lineView1.y+10, 50, 14);
    _distanceLab.textColor=[UIColor lightGrayColor];
    _distanceLab.textAlignment=NSTextAlignmentRight;
    _distanceLab.font=[UIFont systemFontOfSize:12];
    _distanceLab.text=@"0.0000km·";
       [customV addSubview:_distanceLab];
    
    woshouImgV=[[UIImageView alloc]init];
    woshouImgV.frame=CGRectMake(10, lineView1.y+8, 16, 16);
    woshouImgV.image=[UIImage imageNamed:@"pipeidu"];
    [customV addSubview:woshouImgV];
    
    _woNumLab=[[UILabel alloc]init];
    _woNumLab.frame=CGRectMake(CGRectGetMaxX(woshouImgV.frame)+8, lineView1.y+10, 60, 14);
    _woNumLab.textColor=[UIColor orangeColor];
    _woNumLab.textAlignment=NSTextAlignmentLeft;
    _woNumLab.text=@"999999";
    _woNumLab.font=[UIFont systemFontOfSize:13];
    [customV addSubview:_woNumLab];
    
    customV.frame=CGRectMake(0, 0, customV.width, CGRectGetMaxY(_woNumLab.frame)+10);
}

-(void)configCellWithObjiect:(LayoutMeetingModal *)layout
{
    
    MeetingData *data = layout.data;
    [imgLabview1 removeFromSuperview];
    [imgLabview2 removeFromSuperview];
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
   
    
      [[ToolManager shareInstance] imageView:_headImgV setImageWithURL:data.imgurl placeholderType:PlaceholderTypeUserHead];
    _nameLab.text=data.realname;
    
    if ([data.authen isEqualToString:@"3"]) {
        _certifyImg.image=[UIImage imageNamed:@"renzhen"];
    }
    _companyLab.text=[Parameter industryForChinese:data.industry];
    _yearLab.text=[NSString stringWithFormat:@"从业%@年",data.workyears];
    
    _timerLab.text= [data.time updateTime];
    
    float distance=[data.distance floatValue]/1000.00;
    
    _distanceLab.text=[NSString stringWithFormat:@"%.2lfkm·",distance];

    
    CGSize expectSize=[_nameLab.text sizeWithFont:Size(30) maxSize:CGSizeMake(100, _nameLab.height)];
    _nameLab.frame=CGRectMake(_nameLab.x, _nameLab.y, expectSize.width, expectSize.height);
    _certifyImg.frame=CGRectMake(CGRectGetMaxX(_nameLab.frame)+3, _nameLab.y+(_nameLab.height - 14)/2.0+1, 14, 14);
    //关键语句
    
    expectSize = [_companyLab sizeThatFits:maximumLabelSize];
    _companyLab.frame = CGRectMake(CGRectGetMinX(_nameLab.frame), CGRectGetMaxY(_nameLab.frame)+5, expectSize.width, expectSize.height);
    //关键语句
    expectSize = [_jobLab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    _jobLab.frame = CGRectMake(CGRectGetMaxX(_companyLab.frame)+5, _companyLab.y, expectSize.width, expectSize.height);

//
//    if (data.service&&![data.service isEqualToString:@""]) {
//        CGFloat wid1=0;
//        CGFloat height1=0;
//        NSArray *productArr=[data.service componentsSeparatedByString:@"/"];
////        productArr=@[@"天王",@"盖地虎",@"宝塔镇河妖",@"    ",@"我真帅",@"吼吼吼",@"乌拉拉",@"哇啦啦啦"];
//        imgLabview1=[[UIView alloc]init];
//        imgLabview1.frame=CGRectMake(0, 0, 100, 100);
//        [customV addSubview:imgLabview1];
//        
//        for (int i=0; i<productArr.count; i++) {
//           
//            if([productArr[i] length]==0){
//                continue;
//            }else{
//                NSString *trimedString = [productArr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                if([trimedString length]==0){
//                     continue;
//                }
//            }
//            
////            CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
//            UIView *imgLabV=[[UIView alloc]init];
//            UIImage *img=[UIImage imageNamed:@"biaoqian"];
//            UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
//            imgView.frame=CGRectMake(0, (productLab.height-img.size.height)/2.0, img.size.width, img.size.width);
//            [imgLabV addSubview:imgView];
//            UILabel *lab=[[UILabel alloc]init];
//            lab.text=productArr[i];
//            lab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
//            lab.font=[UIFont systemFontOfSize:12];
//            CGSize expectSize = [productArr[i] sizeWithFont:Size(24) maxSize:CGSizeMake(1000,900)];
//            lab.frame=CGRectMake(imgView.width+3, (productLab.height-expectSize.height)/2.0, expectSize.width, expectSize.height);
//            [imgLabV addSubview:lab];
//            
//            imgLabV.frame=CGRectMake(wid1,height1,CGRectGetMaxX(lab.frame),productLab.height);
//            [imgLabview1 addSubview:imgLabV];
//            wid1+=(imgLabV.width+10);
//            if (wid1>customV.width-10-productLab.x-productLab.width) {
//                wid1=(imgLabV.width+10);
//                height1+=10+productLab.height;
//                imgLabV.frame=CGRectMake(0,height1,imgLabV.width,productLab.height);
//            }
//           
//            imgLabview1.frame=CGRectMake(CGRectGetMaxX(productLab.frame)+10, productLab.y, customV.width-CGRectGetMaxX(productLab.frame), CGRectGetMaxY(imgLabV.frame));
//        }
//        
//        resourceLab.frame=CGRectMake(productLab.x, CGRectGetMaxY(productLab.frame)+10+height1, 50, 14);
//    }else{
//        
//        resourceLab.frame=CGRectMake(productLab.x, CGRectGetMaxY(productLab.frame)+10, 50, 14);
//    }
//
//    
//    
//
//    if (data.resource&&![data.resource isEqualToString:@""]) {
//        
//        CGFloat wid2=0;
//        CGFloat height2=0;
//        NSArray *productArr=[data.resource componentsSeparatedByString:@"/"];
////        productArr=@[@"天王",@"盖地虎",@"宝塔镇河妖",@"哈",@"我真帅",@"吼吼吼",@"乌拉拉",@"哇啦啦啦"];
//        
//        
//        imgLabview2=[[UIView alloc]init];
//        imgLabview2.frame=CGRectMake(0, 0, 100, 100);
//        [customV addSubview:imgLabview2];
//        for (int i=0; i<productArr.count; i++) {
//            if([productArr[i] length]==0){
//                continue;
//            }else{
//                NSString *trimedString = [productArr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                if([trimedString length]==0){
//                    continue;
//                }
//            }
//
//            CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
//            UIView *imgLabV=[[UIView alloc]init];
//            UIImage *img=[UIImage imageNamed:@"biaoqian"];
//            UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
//            imgView.frame=CGRectMake(0, (resourceLab.height-img.size.height)/2.0, img.size.width, img.size.width);
//            [imgLabV addSubview:imgView];
//            UILabel *lab=[[UILabel alloc]init];
//            lab.text=productArr[i];
//            lab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
//            lab.font=[UIFont systemFontOfSize:12];
//            CGSize expectSize = [lab sizeThatFits:maximumLabelSize];
//            lab.frame=CGRectMake(imgView.width+3, (resourceLab.height-expectSize.height)/2.0, expectSize.width, expectSize.height);
//            [imgLabV addSubview:lab];
//            
//            imgLabV.frame=CGRectMake(wid2,height2,CGRectGetMaxX(lab.frame),resourceLab.height);
//            [imgLabview2 addSubview:imgLabV];
//            wid2+=(imgLabV.width+10);
//            if (wid2>customV.width-10-resourceLab.x-resourceLab.width) {
//                wid2=(imgLabV.width+10);
//                height2+=10+resourceLab.height;
//                imgLabV.frame=CGRectMake(0,height2,imgLabV.width,resourceLab.height);
//            }
//            
//            imgLabview2.frame=CGRectMake(CGRectGetMaxX(resourceLab.frame)+10, resourceLab.y, customV.width-CGRectGetMaxX(resourceLab.frame), CGRectGetMaxY(imgLabV.frame));
//        }
//        
//        lineView1.frame=CGRectMake(0, CGRectGetMaxY(resourceLab.frame)+10+height2,customV.width,1);
//    }else{
//        
//        lineView1.frame=CGRectMake(0, CGRectGetMaxY(resourceLab.frame)+10,customV.width,1);
//    }
    
    woshouImgV.frame=CGRectMake(10, lineView1.y+8, 16, 16);
    expectSize=[_yearLab sizeThatFits:maximumLabelSize];
    _yearLab.frame=CGRectMake(CGRectGetMaxX(_jobLab.frame)+5, _companyLab.y, expectSize.width, expectSize.height);
     _woNumLab.frame=CGRectMake(CGRectGetMaxX(woshouImgV.frame)+8, lineView1.y+10, 60, 14);
    expectSize=[_timerLab sizeThatFits:maximumLabelSize];
    _timerLab.frame=CGRectMake(customV.width-expectSize.width-10, lineView1.y+10, expectSize.width, expectSize.height);
    expectSize=[_distanceLab sizeThatFits:maximumLabelSize];
    _distanceLab.frame=CGRectMake(_timerLab.x-expectSize.width,lineView1.y+10, expectSize.width, expectSize.height);
    
    
    customV.frame=CGRectMake(customV.x, customV.y, customV.width, CGRectGetMaxY(_distanceLab.frame)+10);
    
    _cellHeight=customV.height+10;

}

-(CGSize)sizeThatFits:(CGSize)size{
    CGFloat totalHeight=_cellHeight;
    return CGSizeMake(size.width, totalHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
