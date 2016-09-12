//
//  MeetingCellLayout.m
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MeetingCellLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "Parameter.h"
#import "NSString+Extend.h"
@implementation MeetingCellLayout

- (MeetingCellLayout *)initCellLayoutWithModel:(MeetingData *)model
{
    self = [super init];
    if (self) {
        //用户头像
        LWImageStorage *_avatarStorage = [[LWImageStorage alloc]initWithIdentifier:@"avatar"];
        _avatarStorage.frame = CGRectMake(10, 13, 44, 44);
        model.imgurl = [[ToolManager shareInstance] urlAppend:model.imgurl];
//        NSLog(@"model.imgurl  =%@",model.imgurl );
        _avatarStorage.contents = model.imgurl;
        _avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
        if ([model.imgurl isEqualToString:ImageURLS]) {
        
            _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
           
        }
      _avatarStorage.cornerRadius = _avatarStorage.width/2.0;
        //用户名
        NSString *renzen;
        if ([model.authen intValue]==3) {
            renzen = @"[renzhen]";
        }
        else
        {
            renzen=@"[weirenzhen]";
        }
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = [NSString stringWithFormat:@"%@ %@",model.realname,renzen];
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(_avatarStorage.right + 10, 12.0, SCREEN_WIDTH - (_avatarStorage.right), CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",model.userid]
                                      range:NSMakeRange(0,model.realname.length)
                                  linkColor:BlackTitleColor
                             highLightColor:RGB(0, 0, 0, 0.15)];
        
        [LWTextParser parseEmojiWithTextStorage:nameTextStorage];
        
        
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (model.industry&&model.industry.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@  ",[Parameter industryForChinese:model.industry]];
        }
        if (model.workyears&&model.workyears.length>0) {
            industryTextStorage.text=[NSString stringWithFormat:@"%@从业%@年",industryTextStorage.text,model.workyears];
        }

        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
        //约见按钮
        _meetBtnRect = CGRectMake(APPWIDTH-70, 20, 60, 30);
        _line1Rect  = CGRectMake(0, _avatarStorage.bottom + 10, APPWIDTH, 0.5);
        
        
        LWTextStorage *productTextStorage=[[LWTextStorage alloc]init];
        productTextStorage.text=@"产品服务";
        productTextStorage.font=Size(26.0);
        productTextStorage.frame=CGRectMake(_avatarStorage.left, _line1Rect.origin.y+10, 52, CGFLOAT_MAX);
        productTextStorage.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.529 alpha:1.000];
        
        float productLbStorageheight = productTextStorage.bottom;
        if (![model.service isEqualToString:@""]&&model.service) {
            NSArray *productArr=[model.service componentsSeparatedByString:@"/"];
            NSMutableString *productStr = allocAndInit(NSMutableString);
          
            CGFloat wid1=0;
            for (int i=0; i<productArr.count; i++) {
                UIImage *img=[UIImage imageNamed:@"[biaoqian]"];
                NSString *text = [NSString stringWithFormat:@" %@   ",productArr[i]];
                CGSize expectSize=[text sizeWithFont:Size(26) maxSize:CGSizeMake(1000,900)];
                wid1 += (img.size.width + expectSize.width);
                if (wid1>(SCREEN_WIDTH - (productTextStorage.right) - 20)) {
                    [productStr appendString:@"\n"];
                     wid1 =img.size.width + expectSize.width;

                }

                  [productStr appendFormat:@"[biaoqian] %@   ",productArr[i]];
                
               
            }
            LWTextStorage* productLbStorage = [[LWTextStorage alloc] init];
            productLbStorage.font = Size(26.0);
            productLbStorage.textColor = [UIColor colorWithRed:0.482 green:0.486 blue:0.494 alpha:1.000];
            productLbStorage.text = productStr;
            productLbStorage.frame = CGRectMake(productTextStorage.right + 10, productTextStorage.top, SCREEN_WIDTH - (productTextStorage.right) - 20, CGFLOAT_MAX);
            [LWTextParser parseEmojiWithTextStorage:productLbStorage];
            
            [self addStorage:productLbStorage];
            productLbStorageheight = productLbStorage.bottom;
        }
        
        LWTextStorage *resourceTextStorage=[[LWTextStorage alloc]init];
        resourceTextStorage.text=@"资源特点";
        resourceTextStorage.font=Size(26.0);
        resourceTextStorage.frame=CGRectMake(_avatarStorage.left, productLbStorageheight + 10, 52, CGFLOAT_MAX);
        resourceTextStorage.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.529 alpha:1.000];
        float resourceTextStorageheight = resourceTextStorage.bottom;
        if (![model.resource isEqualToString:@""]&&model.resource) {
            NSArray *resourceArr=[model.resource componentsSeparatedByString:@"/"];
            NSMutableString *resourceStr = allocAndInit(NSMutableString);
            CGFloat wid1=0;
            for (int i=0; i<resourceArr.count; i++) {
                UIImage *img=[UIImage imageNamed:@"[biaoqian]"];
                NSString *text = [NSString stringWithFormat:@" %@   ",resourceArr[i]];
                CGSize expectSize=[text sizeWithFont:Size(26) maxSize:CGSizeMake(1000,900)];
                wid1 += (img.size.width + expectSize.width);
                if (wid1>(SCREEN_WIDTH - (productTextStorage.right) - 20)) {
                    [resourceStr appendString:@"\n"];
                    wid1 =img.size.width + expectSize.width;
                    
                }
                
                [resourceStr appendFormat:@"[biaoqian] %@   ",resourceArr[i]];
                
                
            }
            LWTextStorage* resourceLbStorage = [[LWTextStorage alloc] init];
            resourceLbStorage.text = resourceStr;
            resourceLbStorage.font = Size(26.0);
            resourceLbStorage.textColor = [UIColor colorWithRed:0.482 green:0.486 blue:0.494 alpha:1.000];
            resourceLbStorage.frame = CGRectMake(resourceTextStorage.right + 10, resourceTextStorage.top, SCREEN_WIDTH - (resourceTextStorage.right) - 20, CGFLOAT_MAX);
            [LWTextParser parseEmojiWithTextStorage:resourceLbStorage];
            resourceTextStorageheight = resourceLbStorage.bottom;
            [self addStorage:resourceLbStorage];
        }
        
        
        _line2Rect  = CGRectMake(0, resourceTextStorageheight + 10, APPWIDTH, 0.5);
        
        LWTextStorage* woshouImg=[[LWTextStorage alloc]initWithFrame:CGRectMake(_avatarStorage.left,_line2Rect.origin.y+8, nameTextStorage.width, nameTextStorage.height)];
        woshouImg.text=[NSString stringWithFormat:@"[pipeidu] %@",model.match];
        [LWTextParser parseEmojiWithTextStorage:woshouImg];
        
        LWTextStorage* distanceAndtimerLab=[[LWTextStorage alloc]initWithFrame:CGRectMake(0, woshouImg.top, APPWIDTH-10, woshouImg.height)];
        float distance=[model.distance floatValue]/1000.00;
        
        distanceAndtimerLab.text=[NSString stringWithFormat:@"%.2lfkm·%@",distance,[model.time updateTime]];
        NSLog(@"distanceAndtimerLab.text=%@",distanceAndtimerLab.text);
        distanceAndtimerLab.textAlignment=NSTextAlignmentRight;
        distanceAndtimerLab.textColor=[UIColor colorWithRed:0.482 green:0.486 blue:0.494 alpha:1.000];
        distanceAndtimerLab.font=Size(26.0);
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        [self addStorage:productTextStorage];
        [self addStorage:resourceTextStorage];
        [self addStorage:woshouImg];
        [self addStorage:distanceAndtimerLab];
        self.cellHeight = [self suggestHeightWithBottomMargin:20];
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
        
        
        
    }
    
    return self;
    
}
@end
