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
@property(nonatomic,assign)float cellHeight;

- (LayoutMeetingModal *)layoutWithModel:(MeetingData*)model;

@end
