//
//  MeetingModel.h
//  Lebao
//
//  Created by adnim on 16/8/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@interface MeetingModel : BaseModal

@end

@interface MeetingData : NSObject
@property(nonatomic,strong)NSString *authen;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *industry;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *synopsis;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *workyears;
@property(nonatomic,strong)NSString *service;
@property(nonatomic,strong)NSString *match;
@property(nonatomic,strong)NSString *resource;

@end
