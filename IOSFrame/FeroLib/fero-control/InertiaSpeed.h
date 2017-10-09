//
//  InertiaSpeed.h
//  ipad-statistics
//
//  Created by zhangxiuquan on 16/8/30.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InertiaSpeed : NSObject
//添加移动距离 单位秒
-(void)addX:(float)x Y:(float)y Time:(double)time;
//开始滑动
-(void)startRun;
//停止滑动，并清除信息. 主动停止，不会调用isEnd==true
-(void)clearStop;
//设置监听函数
-(void)setOnRun:(void(^)(float currx,float curry,float dx,float dy,BOOL isEnd))onRun;

@end
