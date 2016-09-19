//
//  GJGCSnowFallLayer.h
//  ZYChat
//
//  Created by ZYVincent on 15/4/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GJGCParticleEffectLayer : CAEmitterLayer

@property(nonatomic,assign)CGFloat delayHideTime;

- (id)initWithImageName:(NSString *)imageName;
- (id)initWithImageNameArray:(NSArray *)imageNameArray;

-(void)initializeValue;

-(CAEmitterCell*)createSubLayerContainer;
-(CAEmitterCell *)createSubLayer:(UIImage *)image;

@end
