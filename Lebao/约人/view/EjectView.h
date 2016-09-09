//
//  EjectView.h
//  Lebao
//
//  Created by adnim on 16/9/6.
//  Copyright © 2016年 FNY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EjectView;

@protocol EjectViewDelegate <NSObject>

- (void) customAlertView:(EjectView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface EjectView : UIView

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,copy)NSString *title2Str;
@property (nonatomic, strong) UIView *middleView;
@property(nonatomic, weak) id<EjectViewDelegate> delegate;
/**
 * 弹窗在视图中的中心点
 **/
@property (nonatomic, assign) CGFloat centerY;

- (instancetype) initAlertViewWithFrame:(CGRect)frame andSuperView:(UIView *)superView;

- (void) dissMiss;

@end
