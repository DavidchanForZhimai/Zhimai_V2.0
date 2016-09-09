//
//  LayoutMeetingModal.m
//  Lebao
//
//  Created by adnim on 16/9/8.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LayoutMeetingModal.h"
#import "NSString+Extend.h"
@implementation LayoutMeetingModal
- (LayoutMeetingModal *) layoutWithModel:(MeetingData *)model
{
    if (self) {
        
        float height=170;
       _data=model;
        
        if (![_data.service isEqualToString:@""]&&_data.service) {
            CGFloat wid1=0;
            CGFloat height1=0;
            NSArray *productArr=[_data.service componentsSeparatedByString:@"/"];
            
            NSLog(@"productArr=%@",productArr);
            for (int i=0; i<productArr.count; i++) {
                
                if([productArr[i] length]==0){
                    continue;
                }else{
                    NSString *trimedString = [productArr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if([trimedString length]==0){
                        continue;
                    }
                }
                UIImage *img=[UIImage imageNamed:@"biaoqian"];
                NSLog(@"img.size.width=%f",img.size.width);
                CGSize expectSize=[productArr[i] sizeWithFont:Size(24) maxSize:CGSizeMake(1000,900)];
                
                wid1+=(img.size.width+expectSize.width+13);
                CGSize expectSize1=[@"产品服务" sizeWithFont:Size(24) maxSize:CGSizeMake(100, 100)];
                if (wid1>(APPWIDTH-10-64-expectSize1.width)) {
                    wid1=(img.size.width+expectSize.width+13);
                    height1+=(10+expectSize1.height);
                    
                }
                
            }
            
            NSLog(@"wid1=%f",wid1);
            NSLog(@"height1=%f",height1);
            height +=height1;
        }
        if (![_data.resource isEqualToString:@""]&&_data.resource) {
            CGFloat wid1=0;
            CGFloat height1=0;
            NSArray *productArr=[_data.resource componentsSeparatedByString:@"/"];
            for (int i=0; i<productArr.count; i++) {
                
                if([productArr[i] length]==0){
                    continue;
                }else{
                    NSString *trimedString = [productArr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if([trimedString length]==0){
                        continue;
                    }
                }
                UIImage *img=[UIImage imageNamed:@"biaoqian"];
                CGSize expectSize=[productArr[i] sizeWithFont:Size(24) maxSize:CGSizeMake(1000, 100)];
                wid1+=(img.size.width+expectSize.width+13);
                CGSize expectSize1=[@"产品服务" sizeWithFont:Size(24) maxSize:CGSizeMake(100, 100)];
                if (wid1>APPWIDTH-10-64-expectSize1.width) {
                    wid1=(img.size.width+expectSize.width+13);
                    height1+=24;
                    
                }
            }
            height +=height1;
        }
        
        _cellHeight = height;
        
        
    }
    
    return self;
}

@end
