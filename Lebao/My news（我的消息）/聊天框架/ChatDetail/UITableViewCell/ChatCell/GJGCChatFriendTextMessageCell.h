//
//  GJGCChatFriendTextMessageCell.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"
#import "GJGCChatFriendContentModel.h"

@interface GJGCChatFriendTextMessageCell : GJGCChatFriendBaseCell

@property (nonatomic,strong)GJCFCoreTextContentView *contentLabel;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@end
