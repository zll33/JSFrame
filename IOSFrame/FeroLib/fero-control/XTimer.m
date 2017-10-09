//
//  XTimer.m
//  p2p
//
//  Created by zhangxiuquan on 15/2/13.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XTimer.h"


@interface XTimer()
{
    void(^tickCall)(XTimer*xtimer,double leftTime);
    void(^finishCall)(XTimer*xtimer);
    void(^cancelCall)(XTimer*xtimer);
    //单位毫秒
    double  time;
    double tickTime;
    double startSystemUpTime;
    NSTimer*m_pTimer;
}
@end

@implementation XTimer





+(XTimer*)startCountdownTime:(double)time
                        Tick:(double)tickTime
                    TickCall:(void(^)(XTimer*xtimer,double leftTime))tickCall
                   FinshCall:(void(^)(XTimer*xtimer))finishCall
                   CancelCall:(void(^)(XTimer*xtimer))cancelCall
{
    XTimer*  timer = [XTimer new];
    [timer _countdownTime:time Tick:tickTime TickCall:tickCall FinshCall:finishCall CancelCall:cancelCall];
    return timer;
}

-(void) _countdownTime:(double)Time
                  Tick:(double)ticktime
              TickCall:(void(^)(XTimer*xtimer,double leftTime))tickcall
             FinshCall:(void(^)(XTimer*xtimer))finishcall
            CancelCall:(void(^)(XTimer*xtimer))cancelcall
{
    time = Time;
    tickTime =ticktime;
    
    tickCall=tickcall;
    finishCall=finishcall;
    cancelCall=cancelcall;
   
    startSystemUpTime = [[NSProcessInfo processInfo] systemUptime]*1000;
    
    id userinfo = self;
    
    m_pTimer = [NSTimer scheduledTimerWithTimeInterval:ticktime/1000
                                                target:self
                                              selector:@selector(tickCallBack)
                                              userInfo:userinfo
                                            repeats:YES];
    [self tickCallBack];
    
}

- (void)tickCallBack
{
    double leftTime = self.leftTime;
    
    if (leftTime>tickTime) {
        if (tickCall) {
            tickCall(self,leftTime);
        }
    }
    else if (leftTime>0)
    {
        if (tickCall) {
            tickCall(self,leftTime);
        }
    }else{
        if (finishCall) {
            finishCall(self);
        }
        if (m_pTimer) {
            [m_pTimer invalidate];
            m_pTimer= nil;
            tickCall= nil;
            finishCall=nil;
            cancelCall= nil;
        }
       
    }
}
-(void)cancle
{
    if (cancelCall) {
        cancelCall(self);
    }
    if (m_pTimer) {
        [m_pTimer invalidate];
        m_pTimer= nil;
        tickCall= nil;
        finishCall=nil;
        cancelCall= nil;
    }
   
}
//隐藏，防止NSTimer不释放
-(void)hide{
    if (m_pTimer) {
        [m_pTimer invalidate];
    }

}
//显示，防止NSTimer不释放
-(void)show{
    if (m_pTimer) {
        [m_pTimer invalidate];
    }
    m_pTimer = [NSTimer scheduledTimerWithTimeInterval:tickTime/1000
                                                target:self
                                              selector:@selector(tickCallBack)
                                              userInfo:self
                                               repeats:YES];
}
-(double)getLeftTime
{
    double systemUptime = [[NSProcessInfo processInfo] systemUptime]*1000;
    double leftTime =  time - (systemUptime - startSystemUpTime);
    return leftTime;
}
@end
