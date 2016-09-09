//
//  WantMeetCell.h
//  Lebao
//
//  Created by adnim on 16/9/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
@interface WantMeetCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImgV;// 头像
@property (nonatomic,strong)UILabel *nameLab;//用户名
@property (nonatomic,strong)UIImageView *certifyImg;//认证
@property (nonatomic,strong)UILabel *companyLab;//公司
@property (nonatomic,strong)UILabel *jobLab;//职位
@property (nonatomic,strong)UILabel *yearLab;//年限
@property (nonatomic,strong)UILabel *timerLab;//时间
@property (nonatomic,strong)UILabel *distanceLab;//距离
@property (nonatomic,strong)UILabel *woNumLab;//约见人数
@property (nonatomic,strong)UIButton *meetingBtn;//约见


-(void)configCellWithObjiect:(MeetingModel *)model withRow:(NSInteger)row;//传入model

@end
