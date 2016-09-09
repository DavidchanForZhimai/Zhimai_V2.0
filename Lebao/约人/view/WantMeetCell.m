//
//  WantMeetCell.m
//  Lebao
//
//  Created by adnim on 16/9/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WantMeetCell.h"

@implementation WantMeetCell

{
    UIView *customV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView:frame];
    }
    return self;
}

-(void)customView:(CGRect)frame
{
    customV=[[UIView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-10)];
    customV.backgroundColor=[UIColor whiteColor];
    customV.layer.cornerRadius=10;
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
    _certifyImg.frame=CGRectMake(CGRectGetMaxX(_nameLab.frame), 18, 14, 14);
    _certifyImg.image=[UIImage imageNamed:@"renzheng"];
    [customV addSubview:_certifyImg];
    
    _companyLab=[[UILabel alloc]init];
    _companyLab.frame=CGRectMake(CGRectGetMinX(_nameLab.frame), CGRectGetMaxY(_nameLab.frame)+5, 22, 14);
    _companyLab.font=[UIFont systemFontOfSize:12];
    _companyLab.textColor=[UIColor lightGrayColor];
    _companyLab.textAlignment=NSTextAlignmentLeft;
    _companyLab.text=@"知脉";
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [_companyLab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    _companyLab.frame = CGRectMake(CGRectGetMinX(_nameLab.frame), CGRectGetMaxY(_nameLab.frame)+5, expectSize.width, expectSize.height);
    [customV addSubview:_companyLab];
    
    _jobLab=[[UILabel alloc]init];
    _jobLab.frame=CGRectMake(CGRectGetMaxX(_companyLab.frame)+5, _companyLab.y, 55, 14);
    _jobLab.font=[UIFont systemFontOfSize:12];
    _jobLab.textColor=[UIColor lightGrayColor];
    _jobLab.textAlignment=NSTextAlignmentLeft;
    _jobLab.text=@"知脉科技";
    //关键语句
    expectSize = [_jobLab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    _jobLab.frame = CGRectMake(CGRectGetMaxX(_companyLab.frame)+5, _companyLab.y, expectSize.width, expectSize.height);
    [customV addSubview:_jobLab];
    
    _yearLab=[[UILabel alloc]init];
    _yearLab.frame=CGRectMake(CGRectGetMaxX(_jobLab.frame)+5, _companyLab.y, 55, 14);
    _yearLab.font=[UIFont systemFontOfSize:12];
    _yearLab.textColor=[UIColor lightGrayColor];
    _yearLab.textAlignment=NSTextAlignmentLeft;
    _yearLab.text=@"从业1000年";
    expectSize=[_yearLab sizeThatFits:maximumLabelSize];
    _yearLab.frame=CGRectMake(CGRectGetMaxX(_jobLab.frame)+5, _companyLab.y, expectSize.width, expectSize.height);
    [customV addSubview:_yearLab];
    
    _meetingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _meetingBtn.frame=CGRectMake(customV.width-70, 20, 60, 30);
    _meetingBtn.backgroundColor=AppMainColor;
    [_meetingBtn setTitle:@"约见" forState:UIControlStateNormal];
    [_meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _meetingBtn.layer.cornerRadius=12;
    [_meetingBtn addTarget:self action:@selector(meetAction:) forControlEvents:UIControlEventTouchUpInside];
    [customV addSubview:_meetingBtn];
    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, CGRectGetMaxY(_yearLab.frame)+10, customV.width, 1);
    lineView.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [customV addSubview:lineView];
    
    UILabel *productLab=[[UILabel alloc]init];
    productLab.frame=CGRectMake(_companyLab.x, CGRectGetMaxY(lineView.frame)+10, 50, 14);
    productLab.font=[UIFont systemFontOfSize:12];
    productLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    productLab.textAlignment=NSTextAlignmentLeft;
    productLab.text=@"产品服务";
    [customV addSubview:productLab];
    
    UILabel *resourceLab=[[UILabel alloc]init];
    resourceLab.frame=CGRectMake(productLab.x, CGRectGetMaxY(productLab.frame)+10, 50, 14);
    resourceLab.font=[UIFont systemFontOfSize:12];
    resourceLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    resourceLab.textAlignment=NSTextAlignmentLeft;
    resourceLab.text=@"资源特点";
    [customV addSubview:resourceLab];
    
    
    UILabel *reasonLab=[[UILabel alloc]init];
    reasonLab.frame=CGRectMake(productLab.x, CGRectGetMaxY(resourceLab.frame)+10, 50, 14);
    reasonLab.font=[UIFont systemFontOfSize:12];
    reasonLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    reasonLab.textAlignment=NSTextAlignmentLeft;
    reasonLab.text=@"约见理由";
    [customV addSubview:reasonLab];

    UILabel *reasontextLab=[[UILabel alloc]init];
    reasontextLab.frame=CGRectMake(CGRectGetMaxX(reasonLab.frame)+10, reasonLab.y, customV.width-CGRectGetMaxX(reasonLab.frame)-20, 14);
    reasontextLab.font=[UIFont systemFontOfSize:14];
    reasontextLab.textColor=[UIColor colorWithWhite:0.298 alpha:1.000];
    reasontextLab.textAlignment=NSTextAlignmentLeft;
    reasontextLab.text=@"来来来,谈谈理想,聊聊人生,啊哈哈哈哈哈啊哈哈哈啊哈哈哈哈啊哈哈哈啊哈啊啊哈哈哈啊哈哈哈啊哈哈哈啊啊哈啊啊阿啊哈哈哈来来来,谈谈理想,聊聊人生,啊哈哈哈哈哈啊哈哈哈啊哈哈哈哈啊哈哈哈啊哈啊啊哈哈哈啊哈哈哈啊哈哈哈啊啊哈啊啊阿啊哈哈哈来来来,谈谈理想,聊聊人生,啊哈哈哈哈哈啊哈哈哈啊哈哈哈哈啊哈哈哈啊哈啊啊哈哈哈啊哈哈哈啊哈哈哈啊啊哈啊啊阿啊哈哈哈";
    reasontextLab.lineBreakMode=NSLineBreakByWordWrapping;
    reasontextLab.numberOfLines=0;
    CGSize size = [reasontextLab sizeThatFits:CGSizeMake(reasontextLab.frame.size.width, MAXFLOAT)];
    
    reasontextLab.frame =CGRectMake(reasontextLab.x, reasontextLab.y, reasontextLab.width, size.height);
    if (reasontextLab.height>70) {
        reasontextLab.height=70;
    }
    
    [customV addSubview:reasontextLab];

    UILabel *rewardLab=[[UILabel alloc]init];
    rewardLab.frame=CGRectMake(productLab.x, CGRectGetMaxY(reasontextLab.frame)+10, 50, 14);
    rewardLab.font=[UIFont systemFontOfSize:12];
    rewardLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    rewardLab.textAlignment=NSTextAlignmentLeft;
    rewardLab.text=@"约见打赏";
    [customV addSubview:rewardLab];

    
    
    UIView *lineView1=[[UIView alloc]init];
    lineView1.frame=CGRectMake(0, CGRectGetMaxY(rewardLab.frame)+10, customV.width, 1);
    lineView1.backgroundColor=[UIColor colorWithRed:0.925 green:0.925 blue:0.929 alpha:1.000];
    [customV addSubview:lineView1];
    
    _timerLab=[[UILabel alloc]init];
    _timerLab.frame=CGRectMake(customV.width-65, lineView1.y+10, 60, 14);
    _timerLab.font=[UIFont systemFontOfSize:12];
    _timerLab.textColor=[UIColor lightGrayColor];
    _timerLab.textAlignment=NSTextAlignmentRight;
    _timerLab.text=@"在1000年以后";
    expectSize=[_timerLab sizeThatFits:maximumLabelSize];
    _timerLab.frame=CGRectMake(customV.width-expectSize.width-10, lineView1.y+10, expectSize.width, expectSize.height);
    [customV addSubview:_timerLab];
    
    _distanceLab=[[UILabel alloc]init];
    _distanceLab.frame=CGRectMake(0, lineView1.y+10, 50, 14);
    _distanceLab.textColor=[UIColor lightGrayColor];
    _distanceLab.textAlignment=NSTextAlignmentRight;
    _distanceLab.font=[UIFont systemFontOfSize:12];
    _distanceLab.text=@"0.0000km·";
    expectSize=[_distanceLab sizeThatFits:maximumLabelSize];
    _distanceLab.frame=CGRectMake(_timerLab.x-expectSize.width, lineView1.y+10, expectSize.width, expectSize.height);
    [customV addSubview:_distanceLab];
    
    UIImageView *woshouImgV=[[UIImageView alloc]init];
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
    
    customV.frame=CGRectMake(10, 0, customV.width, CGRectGetMaxY(_woNumLab.frame)+10);
}

-(void)configCellWithObjiect:(MeetingModel *)model withRow:(NSInteger)row
{
    
}

-(void)meetAction:(UIButton *)sender
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"同意约见后,您将获得99999元的约见打赏" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
