//
//  MeetingTVCell.h
//  Lebao
//
//  Created by adnim on 16/8/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutMeetingModal.h"
#import "BaseButton.h"
@interface MeetingTVCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImgV;// 头像
@property (nonatomic,strong)UILabel *nameLab;//用户名
@property (nonatomic,strong)UIImageView *certifyImg;//认证
@property (nonatomic,strong)UILabel *companyLab;//公司
@property (nonatomic,strong)UILabel *distanceAndtimerLab;//距离//时间
@property (nonatomic,strong)UILabel *woNumLab;//匹配度
@property (nonatomic,strong)UIButton *meetingBtn;//约见


-(void )configCellWithObjiect:(LayoutMeetingModal *)layout;//传入布局
-(void)customView;
@end
