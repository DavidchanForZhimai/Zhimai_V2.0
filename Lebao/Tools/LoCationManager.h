//
//  LoCationManager.h
//  Lebao
//
//  Created by adnim on 16/7/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LoCationManager : NSObject<CLLocationManagerDelegate>


@property (nonatomic,strong)CLLocationManager *locationMNG;
+(LoCationManager *)shareInstance;


-(void)getLatitudeAndLongitude;//返回经纬度



@end
