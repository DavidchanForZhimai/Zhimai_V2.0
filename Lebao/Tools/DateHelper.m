//
//  DateHelper.m
//  YaJu
//
//  Created by qianfeng on 16/3/23.
//  Copyright © 2016年 fny. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper
+ (BOOL )calculatorExpireDatetimeWithData:(NSDate *)expireDatetime
{
    //日历
    NSCalendar *cal = [NSCalendar currentCalendar];
    //时间差格式
    NSCalendarUnit unitFlags =NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour;
    
    //现在的时间
    NSDate *date1 = [NSDate date];
    //设置转换后的时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
     NSDate *date2=expireDatetime;
    
    //时间差 从给定时间到现在
    NSDateComponents *d = [cal components:unitFlags fromDate:date2 toDate:date1 options:0];
    
//    NSLog(@"d=================%@",d);
//    NSLog(@"date1=================%@",date1);
    if ([d year]>1) {
        return YES;
    }
    if ([d month] >1){
       return YES;}
    if ([d day] >1){
        return YES;}
    else return NO;
    
}

@end
