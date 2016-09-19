//
//  GJGCChatFriendAudioMessageCell.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendAudioMessageCell : GJGCChatFriendBaseCell

@property (nonatomic,strong)UIImageView *audioPlayIndicatorView;

@property (nonatomic,strong)GJCFCoreTextContentView *audioTimeLabel;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@property (nonatomic,strong)UIActivityIndicatorView *downloadIndicator;

@property (nonatomic,strong)UIImageView *isAudioPlayTagView;

- (void)finishPlayAudioAction;

- (void)playAudioAction;

- (void)startDownloadAction;

- (void)faildDownloadAction;


@end
