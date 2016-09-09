//
//  LayoutMeetingModal.h
//  Lebao
//
//  Created by adnim on 16/9/8.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingModel.h"
@interface LayoutMeetingModal : NSObject
@property(nonatomic,strong)MeetingData *data;
@property(nonatomic,assign)CGRect customVFrame;
@property(nonatomic,assign)CGRect lineViewFrame;
@property(nonatomic,assign)CGRect lineView1Frame;
@property(nonatomic,assign)CGRect imgLabview1Frame;
@property(nonatomic,assign)CGRect imgLabview2Frame;
@property(nonatomic,assign)CGRect headImgVFrame;
@property(nonatomic,assign)CGRect nameLabFrame;
@property(nonatomic,assign)CGRect certifyImgFrame;
@property(nonatomic,assign)CGRect companyLabFrame;

@property(nonatomic,assign)CGRect distanceLabFrame;
@property(nonatomic,assign)CGRect woshouImgVFrame;
@property(nonatomic,assign)CGRect woNumLabFrame;
@property(nonatomic,assign)CGRect meetingBtnFrame;

@property(nonatomic,copy)NSArray *resourcesFrame;
@property(nonatomic,copy)NSArray *productsFrame;

@property(nonatomic,assign)CGRect productLabFrame;
@property(nonatomic,assign)CGRect resourceLabFrame;

@property(nonatomic,assign)float cellHeight;

- (LayoutMeetingModal *)layoutWithModel:(MeetingData*)model;

@end
