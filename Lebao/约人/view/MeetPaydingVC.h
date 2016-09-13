//
//  MeetPaydingVC.h
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetPaydingVC : UIViewController
typedef enum {
    FaBuZhiFu=0,//发布支付
    LingQuZhiFu,//领取支付
    WeiKuanZhiFu,//支付尾款
} ZFYMTYPE;
@property (weak, nonatomic) IBOutlet UILabel *dingjinLab;
@property (weak, nonatomic) IBOutlet UIImageView *zhimaiImg;
@property (weak, nonatomic) IBOutlet UILabel *yueLab;
@property (weak, nonatomic) IBOutlet UIImageView *wxImg;
@property (strong,nonatomic) NSString * jineStr;
@property (weak, nonatomic) IBOutlet UIButton *zhifuBtn;
- (IBAction)zhifuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *zhimaiV;
@property (weak, nonatomic) IBOutlet UIView *weixinV;
@property (assign,nonatomic)int zfymType;
@property (strong,nonatomic)NSString * titStr;
@property (strong,nonatomic)NSString * content;
@property (strong,nonatomic)NSString * industry;
@property (strong,nonatomic)NSString * bfb;
@property (strong,nonatomic)NSString * xsID;
@property (strong,nonatomic)NSString * qwjeStr;
@property (nonatomic,assign)BOOL isAudio;
@end
