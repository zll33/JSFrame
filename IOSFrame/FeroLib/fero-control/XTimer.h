//
//  XTimer.h
//  p2p
//
//  Created by zhangxiuquan on 15/2/13.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTimer : NSObject

@property (readonly, getter=getLeftTime) double leftTime;

+(XTimer*)startCountdownTime:(double)time
                        Tick:(double)tickTime
                    TickCall:(void(^)(XTimer*xtimer,double leftTime))tickCall
                   FinshCall:(void(^)(XTimer*xtimer))finishCall
                  CancelCall:(void(^)(XTimer*xtimer))cancelCall;
-(void)cancle;

//隐藏，防止NSTimer不释放
-(void)hide;
//显示，防止NSTimer不释放
-(void)show;
@end
