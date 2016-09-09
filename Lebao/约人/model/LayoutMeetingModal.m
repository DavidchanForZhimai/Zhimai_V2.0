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
        
        _customVFrame =CGRectMake(0, 0, APPWIDTH, height-10);
        _headImgVFrame=CGRectMake(10, 13, 44, 44);
        
        CGSize expectSize=[_data.realname sizeWithFont:Size(30) maxSize:CGSizeMake(150, 25)];
        _nameLabFrame=CGRectMake(CGRectGetMaxX(_headImgVFrame)+10,12, expectSize.width, expectSize.height);
        
        _certifyImgFrame=CGRectMake(CGRectGetMaxX(_nameLabFrame)+3, _nameLabFrame.origin.y+( _nameLabFrame.size.height - 14)/2.0+1, 14, 14);
        
        _companyLabFrame=CGRectMake(CGRectGetMinX(_nameLabFrame), CGRectGetMaxY(_nameLabFrame)+5, _customVFrame.size.width - 100 - _nameLabFrame.origin.x , 14);
        
         _meetingBtnFrame =  CGRectMake(_customVFrame.size.width-70, 20, 60, 30);
        
        _lineViewFrame = CGRectMake(0, CGRectGetMaxY(_headImgVFrame)+10, _customVFrame.size.width, 1);
        
          _productLabFrame = CGRectMake(_companyLabFrame.origin.x, CGRectGetMaxY(_lineViewFrame)+10, 50, 14);
        
          _resourceLabFrame=CGRectMake(_productLabFrame.origin.x, CGRectGetMaxY(_productLabFrame)+10, 50, 14);
        
          _imgLabview1Frame = CGRectMake(CGRectGetMaxX(_productLabFrame)+10, _productLabFrame.origin.y, 0, 0);
          _imgLabview2Frame = CGRectMake(CGRectGetMaxX(_resourceLabFrame)+10, _resourceLabFrame.origin.y, 0, 0);
        
         _lineView1Frame=CGRectMake(0, CGRectGetMaxY(_resourceLabFrame)+10, _customVFrame.size.width, 1);
        
        NSMutableArray *productFrameArr = allocAndInit(NSMutableArray);
        if (![_data.service isEqualToString:@""]&&_data.service) {
            CGFloat wid1=0;
            CGFloat height1=0;
            float w = 0;
            NSArray *productArr=[_data.service componentsSeparatedByString:@"/"];
            
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
                CGSize expectSize=[productArr[i] sizeWithFont:Size(24) maxSize:CGSizeMake(1000,900)];
                
                CGSize expectSize1=[@"产品服务" sizeWithFont:Size(24) maxSize:CGSizeMake(100, 100)];
                 w = wid1;
                 wid1+=(img.size.width+expectSize.width+13);
            
                if (wid1>(APPWIDTH-(CGRectGetMaxX(_productLabFrame) ))) {
                    w = 0;
                    wid1 = (img.size.width+expectSize.width+13);
                    height1+=(10+expectSize1.height);
                    
                }
                
                CGRect frame = CGRectMake(w, height1, img.size.width+expectSize.width+3, _productLabFrame.size.height);
                [productFrameArr addObject:NSStringFromCGRect(frame)];
               
                _imgLabview1Frame = CGRectMake(CGRectGetMaxX(_productLabFrame)+10, _productLabFrame.origin.y, _customVFrame.size.width-CGRectGetMaxX(_productLabFrame), CGRectGetMaxY(frame));
                
               
            }
            _resourceLabFrame=CGRectMake(_productLabFrame.origin.x, CGRectGetMaxY(_productLabFrame)+10+height1, _productLabFrame.size.width, _productLabFrame.size.height);
            
             _lineView1Frame=CGRectMake(0, CGRectGetMaxY(_resourceLabFrame)+10,_customVFrame.size.width,1);
            
            height +=height1;
        }
        
        NSMutableArray *resourceFrameArr = allocAndInit(NSMutableArray);
        
        if (![_data.resource isEqualToString:@""]&&_data.resource) {
            CGFloat wid1=0;
            CGFloat height1=0;
            float w = 0;
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
                
                w = wid1;
                wid1+=(img.size.width+expectSize.width+13);
                CGSize expectSize1=[@"产品服务" sizeWithFont:Size(24) maxSize:CGSizeMake(100, 100)];
                if (wid1>(APPWIDTH-(CGRectGetMaxX(_productLabFrame) +10))) {
                    
                    w = 0;
                    wid1=(img.size.width+expectSize.width+13);
                    height1+=(10 + expectSize1.height);
                    
                }
                
                CGRect frame = CGRectMake(w, height1, img.size.width+expectSize.width+3, _productLabFrame.size.height);
                [resourceFrameArr addObject:NSStringFromCGRect(frame)];
                  _imgLabview2Frame = CGRectMake(CGRectGetMaxX(_resourceLabFrame)+10, _resourceLabFrame.origin.y, _customVFrame.size.width-CGRectGetMaxX(_resourceLabFrame), CGRectGetMaxY(frame));
            }
            _lineView1Frame=CGRectMake(0, CGRectGetMaxY(_resourceLabFrame)+10+height1,_customVFrame.size.width,1);
            height +=height1;
        }
        
        _productsFrame = productFrameArr;
        _resourcesFrame =resourceFrameArr;
        
        _distanceLabFrame=CGRectMake(APPWIDTH - 210,  _lineView1Frame.origin.y+10, 200, 14);
        _woshouImgVFrame=CGRectMake(10, _lineView1Frame.origin.y+8, 16, 16);
        
        _woNumLabFrame=CGRectMake(CGRectGetMaxX(_woshouImgVFrame)+8, _lineView1Frame.origin.y+10, 60, 14);

        _customVFrame =CGRectMake(0, 0, APPWIDTH, height-10);
        _cellHeight = height;
        
        
    }
    
    return self;
}

@end
