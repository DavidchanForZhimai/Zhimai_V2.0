//
//  MeetHeadV.m
//  Lebao
//
//  Created by adnim on 16/8/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetHeadV.h"
#import "CanmeetTabVC.h"
@implementation MeetHeadV

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        
        
    }
    return self;
}

-(void)creatUI
{
    self.backgroundColor=[UIColor clearColor];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, 200)];
    
    [self addSubview:bgView];
    
    UIImageView *bgImgV=[[UIImageView alloc]initWithFrame:bgView.bounds];
    bgImgV.image=[UIImage imageNamed:@"wodeBG"];
    [bgView addSubview:bgImgV];
    
    UIView *underView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), APPWIDTH, 44)];
    underView.backgroundColor=[UIColor whiteColor];
    [self addSubview:underView];
    _nearManLab=[[UILabel alloc]init];
    _nearManLab.frame=CGRectMake(15, 10, 160, 20);
    _nearManLab.textColor=[UIColor colorWithRed:0.424 green:0.427 blue:0.431 alpha:1.000];
    _nearManLab.textAlignment=NSTextAlignmentLeft;
    _nearManLab.font=[UIFont systemFontOfSize:15];
    _nearManLab.text=@"最近有空 99999999人";
    [underView addSubview:_nearManLab];
    
    
    UIButton *genduoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    genduoBtn.frame=CGRectMake(APPWIDTH-44, 0, 44, 44);
    [genduoBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [underView addSubview:genduoBtn];
    
    
    _wantMeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _wantMeBtn.frame=CGRectMake(20, bgImgV.height-80, 60, 60);
    _wantMeBtn.layer.cornerRadius=30;
    _wantMeBtn.layer.borderWidth=2;
    _wantMeBtn.layer.borderColor=[UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    
    _wantMeBtn.titleLabel.font = Size(20);
    _wantMeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_wantMeBtn setTitle:@"16\n想约见我" forState:UIControlStateNormal];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_wantMeBtn.titleLabel.text];
    [text addAttribute:NSFontAttributeName value:Size(40) range:[_wantMeBtn.titleLabel.text rangeOfString:@"16"]];
    [_wantMeBtn setAttributedTitle:text forState:UIControlStateNormal];
    _wantMeBtn.titleLabel.numberOfLines = 0;
    [bgView addSubview:_wantMeBtn];
    
    _meWantBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _meWantBtn.frame=CGRectMake(APPWIDTH-80, bgImgV.height-80, 60, 60);
    _meWantBtn.layer.cornerRadius=30;
    _meWantBtn.layer.borderWidth=2;
    _meWantBtn.layer.borderColor=[UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    
    _meWantBtn.titleLabel.font = Size(20);
    _meWantBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_meWantBtn setTitle:@"16\n我想约见" forState:UIControlStateNormal];
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:_meWantBtn.titleLabel.text];
    [text1 addAttribute:NSFontAttributeName value:Size(40) range:[_meWantBtn.titleLabel.text rangeOfString:@"16"]];
    [_meWantBtn setAttributedTitle:text forState:UIControlStateNormal];
    _meWantBtn.titleLabel.numberOfLines = 0;
    [bgView addSubview:_meWantBtn];
    
    
    CAShapeLayer*layer1=[[CAShapeLayer alloc]init];
    layer1.frame=_meWantBtn.frame;
    layer1.strokeStart=0;
    layer1.position=_wantMeBtn.center;
    layer1.fillColor=[UIColor clearColor].CGColor;
    layer1.strokeColor=[UIColor whiteColor].CGColor;
    layer1.strokeEnd=0.5;
    layer1.lineWidth=2;
    UIBezierPath *bezier1=[UIBezierPath bezierPathWithOvalInRect:layer1.bounds];
    layer1.path=bezier1.CGPath;
    [bgView.layer addSublayer:layer1];
    
    CAShapeLayer*layer2=[[CAShapeLayer alloc]init];
    layer2.frame=_meWantBtn.frame;
    layer2.strokeStart=0;
    layer2.position=_meWantBtn.center;
    layer2.fillColor=[UIColor clearColor].CGColor;
    layer2.strokeColor=[UIColor whiteColor].CGColor;
    layer2.strokeEnd=0.5;
    layer2.lineWidth=2;
    UIBezierPath *bezier2=[UIBezierPath bezierPathWithOvalInRect:layer2.bounds];
    layer2.path=bezier2.CGPath;
    
    [bgView.layer addSublayer:layer2];
    
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake((bgView.width-110)/2.0, (bgView.height-110)/2.0, 110, 110)];
    [bgView addSubview:view1];
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake((bgView.width-95)/2.0, (bgView.height-95)/2.0, 95, 95)];
    [bgView addSubview:view2];
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake((bgView.width-80)/2.0, (bgView.height-80)/2.0, 80, 80)];
    [bgView addSubview:view3];
    view1.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.18];
    view2.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.18];
    view3.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.18];
    view1.layer.cornerRadius=view1.width/2.0;
    view2.layer.cornerRadius=view2.width/2.0;
    view3.layer.cornerRadius=view3.width/2.0;
    
    _timer1 =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shake:) userInfo:view1 repeats:YES];
    [_timer1 fire];
    _timer2 =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shake:) userInfo:view2 repeats:YES];
    [_timer2 fire];
    _timer3 =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shake:) userInfo:view3 repeats:YES];
    [_timer3 fire];
    if (_startAndStopTimerBlock) {
        _startAndStopTimerBlock(_timer1,_timer2,_timer3);
    }
    
    _midBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _midBtn.frame=CGRectMake((bgView.width-105)/2.0, (bgView.height-105)/2.0, 105, 105);
    _midBtn.backgroundColor=[UIColor colorWithRed:0.835 green:0.937 blue:0.988 alpha:1.000];
    _midBtn.layer.cornerRadius=_midBtn.width/2.0;
    _midBtn.layer.borderWidth=10;
    _midBtn.layer.borderColor=[UIColor colorWithRed:0.314 green:0.686 blue:0.988 alpha:0.72].CGColor;
    
    _midBtn.titleLabel.font=Size(22);
    _midBtn.titleLabel.textColor=AppMainColor;
    _midBtn.titleLabel.text=@"可约\n205\n位经纪人";
    _midBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:_midBtn.titleLabel.text];
    [str addAttribute:NSFontAttributeName value:Size(60) range:[_midBtn.titleLabel.text rangeOfString:@"205"]];
    [_midBtn setAttributedTitle:str forState:UIControlStateNormal];
    _midBtn.titleLabel.numberOfLines=0;
    [_midBtn addTarget:self action:@selector(midBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addEightImgView];
    [self addSubview:_midBtn];
}

-(void)addEightImgView
{
    
    
    
    NSArray *frameArr=@[NSStringFromCGRect(CGRectMake(_midBtn.x-10, _midBtn.y, 20,20)),
                        NSStringFromCGRect(CGRectMake(_midBtn.x+30, 10, 23, 23)),
                        NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)-15, 30, 30, 30)),NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)+30, _midBtn.y+30, 18, 18)),
                        NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)+10, CGRectGetMaxY(_midBtn.frame)-40, 22, 22)),
                        NSStringFromCGRect(CGRectMake(CGRectGetMaxX(_midBtn.frame)-40,CGRectGetMaxY(_midBtn.frame), 20, 20)),
                        NSStringFromCGRect(CGRectMake(_midBtn.x-10, CGRectGetMaxY(_midBtn.frame)-8, 25, 25)),
                        NSStringFromCGRect(CGRectMake(_midBtn.x-40, _midBtn.y+50, 17, 17))];
    
    
    UIBezierPath *apath=[UIBezierPath bezierPath];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    //设置边框颜色
    shapelayer.strokeColor = [[UIColor colorWithWhite:1.000 alpha:0.15]CGColor];
    //设置填充颜色 如果只要边 可以把里面设置成[UIColor ClearColor]
    shapelayer.fillColor = [[UIColor clearColor]CGColor];
    //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
    
    for (int i=0; i<frameArr.count; i++) {
    CGRect rect = CGRectFromString(frameArr[i]);
        
        [apath moveToPoint:CGPointMake(rect.origin.x+rect.size.width/2.0, rect.origin.y+rect.size.height/2.0)];

        for (int j=1;j<frameArr.count; j++) {
            if (j-i==4||j-i==1||j-i==7||j-i==5) {
                CGRect rect1 = CGRectFromString(frameArr[j]);
                
                [apath addLineToPoint:CGPointMake(rect1.origin.x+rect1.size.width/2.0, rect1.origin.y+rect1.size.height/2.0)];
                [apath closePath];
                shapelayer.path = apath.CGPath;
                
                [self.layer addSublayer:shapelayer];

            }
            

        }
    
    }
     for (int i=0; i<frameArr.count; i++) {
        CGRect rect = CGRectFromString(frameArr[i]);
        UIImageView *imgV=[[UIImageView alloc]init];
        [[ToolManager shareInstance] imageView:imgV setImageWithURL:@"" placeholderType:PlaceholderTypeUserHead];
        imgV.frame=rect;
        imgV.layer.cornerRadius=imgV.width/2.0;
        imgV.clipsToBounds=YES;
        imgV.layer.borderWidth=2;
        imgV.layer.borderColor=[UIColor colorWithWhite:1.000 alpha:0.2].CGColor;
    
        
        
            [self addSubview:imgV];
    }
   
  
    
    
    
}

-(void)midBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(pushView:userInfo:)]&&[self.delegate conformsToProtocol:@protocol(MeetHeadVDelegate)]) {
        [_delegate pushView:allocAndInit(CanmeetTabVC) userInfo:nil];
    }
    
}





- (void) shakeToShow:(UIView*)aView//放大缩小动画
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


- (void) shake:(NSTimer*)timer
{
   
    UIView *aView = (UIView *)timer.userInfo;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 3.0;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.fromValue = [NSNumber numberWithFloat:1.1];
    animation.toValue = [NSNumber numberWithFloat:1.9];
    [aView.layer addAnimation:animation forKey:@"scale-layer"];
    
    CABasicAnimation
    *_anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    _anim1.duration
    = 3.0;
    _anim1.fromValue
    = [NSNumber numberWithFloat:1.0];
    _anim1.toValue
    = [NSNumber numberWithFloat:0.4];
    
    _anim1.timingFunction
    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _anim1.repeatCount
    = CGFLOAT_MAX;
    _anim1.autoreverses
    = YES;
    
    [aView.layer
     addAnimation:_anim1 forKey:nil];
     _anim1 = nil;
}


@end
