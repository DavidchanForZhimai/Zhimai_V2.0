//
//  GJGCChatFriendGifCell.h
//  ZYChat
//
//  Created by ZYVincent on 15/6/3.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendGifCell : GJGCChatFriendBaseCell

@property (nonatomic,assign)CGFloat downloadProgress;

- (void)successDownloadGifFile:(NSData *)fileData;

- (void)faildDownloadGifFile;

@end
