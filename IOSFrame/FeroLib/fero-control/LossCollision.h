//
//  LossCollision.h
//  p2p
//
//  Created by zhangxiuquan on 15/5/14.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LossCollision : NSObject
-(double)getCurHeight;
-(void)stop;
/**
 * 同 start(double height, double velocity, double a, double depleteEnergy)
 * @param height
 *            起始高度
 * @param velocity
 *            起始速度,默认0
 * @param a
 *            加速度,默认400f
 * @param depleteEnergy
 *            每次碰撞损失能量百分比,默认0.7
 */
-(void)start:(double) height;
/**
 *
 * @param height
 *            起始高度
 * @param v
 *            起始速度,默认0
 * @param a
 *            加速度,默认100
 * @param de
 *            每次碰撞损失能量百分比,默认100
 */
-(void)start:(double) height
    velocity:(double)velocity
acceleration: (double) a
depleteEnergy:(double) depleteEnergy;
/**
 * 检查碰撞，返回false表示完成。
 *
 * @return
 */
-(BOOL)doCollision;
/**
 * 检查碰撞，返回false表示完成。使用累计时间
 *
 * @return
 */
-(BOOL)doCollisionDtime:(long)dt;
@end
