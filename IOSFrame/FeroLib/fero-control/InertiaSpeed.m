//
//  InertiaSpeed.m
//  ipad-statistics
//
//  Created by zhangxiuquan on 16/8/30.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import "InertiaSpeed.h"

@interface InertiaSpeed()
{
    NSMutableArray*list;// 记录点
    double a;//加速度acceleration
    double it;//间隔时间interval
    double velocityX;//速度
    double velocityY;//速度
    double maxVelocity;//最大速度
    void(^onRunCall)(float currx,float curry,float dx,float dy,BOOL isEnd);
    double et;//有效时间Effective time
    double startTime;//开始时间
    CADisplayLink*timer;//定时器
    CGRect lastVr;//
}
@end
@implementation InertiaSpeed
-(instancetype)init{

    self =[super init];
    list = [NSMutableArray new];
    maxVelocity=1500;
    a = 1300;//600;
    it=0.05;
    velocityX=0;
    velocityY=0;
    et=0.1;
    return self;
}
//添加移动距离 单位秒
-(void)addX:(float)x Y:(float)y Time:(double)time{
    CGRect r = CGRectMake(x,y,(float)time,0);
    NSValue *value = [NSValue valueWithCGRect:r ];
    [list addObject:value];
    //清除过期的数据
    for (int i=0;i<[list count];i++) {
        NSValue *v =  [list objectAtIndex:i];
        CGRect vr =[v CGRectValue];
        if (time - vr.size.width > et) {
            [list removeObject:v];
            i--;
        }
    }
}
//开始滑动
-(void)startRun{
    //
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    //
    if ([list count]<3) {
        [self ontime];
    }else{
        //结构体是复制的，不是引用
        CGRect r0 = [[list firstObject]CGRectValue];
        CGRect rl= [[list lastObject] CGRectValue];
        double dt=rl.size.width -r0.size.width;
        if (dt<0.01) {
            velocityX=0;
            velocityY=0;
            [self ontime];
        }else{
            velocityX =(rl.origin.x-r0.origin.x)/dt;
            velocityY =(rl.origin.y-r0.origin.y)/dt;
            startTime = [[NSDate date]timeIntervalSince1970];
            lastVr = rl;
            lastVr.size.width = startTime;
            if (velocityX>maxVelocity) {
                velocityX=maxVelocity;
            }
            if (velocityY>maxVelocity) {
                velocityY=maxVelocity;
            }
            if (velocityX<-maxVelocity) {
                velocityX=-maxVelocity;
            }
            if (velocityY<-maxVelocity) {
                velocityY=-maxVelocity;
            }
            
            //NSTimer 在主线程回调
            //timer =[NSTimer scheduledTimerWithTimeInterval:it target:self selector:@selector(ontime) userInfo:nil repeats:true];
            timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(ontime)];
            [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        }
    }
}
-(void)ontime{
    float currx=0;
    float curry=0;
    float dx=0;
    float dy=0;
    BOOL isEnd =false;
    
    //
    if ([list count]<3||(velocityY==0&&velocityX==0)) {
        if ([list count]>0) {
            NSValue *v = [list lastObject];
            CGRect vr =[v CGRectValue];
            currx =vr.origin.x;
            curry =vr.origin.y;
            dx=0;
            dy=0;
            isEnd=true;
        }else{
            currx=0;
            curry=0;
            dx=0;
            dy=0;
            isEnd =true;
        }
    }else{
        double now = [[NSDate date]timeIntervalSince1970];
        double dt = now - startTime;
        
        CGRect rl= [[list lastObject] CGRectValue];
        
        currx = lastVr.origin.x;
        curry = lastVr.origin.y;
        
        //X方向速度位移计算
        if (velocityX!=0) {
            float t = dt;
            float aTemp=(float)(velocityX>0?a:-a);//减数运动
            // 大于停止时间时，按停止计算。
            if (t>velocityX/aTemp){
                t = velocityX/aTemp;
                currx = rl.origin.x+0.5*aTemp*t*t;
                velocityX = 0;
            }else{
                float v2 =velocityX-aTemp*t;
                currx = rl.origin.x+ (velocityX*t + v2*t)/2;
            }
        }
        //Y方向的速度位移计算
        if (velocityY!=0) {
            float t = dt;
            float aTemp=(float)(velocityY>0?a:-a);//减数运动
            
            // 大于停止时间时，按停止计算。
            if (t>velocityY/aTemp){
                t = velocityY/aTemp;
                curry = rl.origin.y+0.5*aTemp*t*t;
                velocityY = 0;
            }else{
                float v2 =velocityX-aTemp*t;
                curry = rl.origin.y+ (velocityY*t + v2*t)/2;
            }
        }
        
        dx = currx - lastVr.origin.x;
        lastVr.origin.x = currx;
        dy = curry - lastVr.origin.y;
        lastVr.origin.y = curry;
        lastVr.size.width = now;
    }
    //判断是否停止
    if (velocityX==0&&velocityY==0) {
        isEnd = true;
    }
    //
    if (isEnd&&timer) {
        [timer invalidate];
        timer = nil;
    }
    if (onRunCall) {
        //NSLog(@"currx=%f dx=%f velocityX=%f ",currx,dx,velocityX);
        onRunCall(currx,curry,dx,dy,isEnd);
    }
}
//停止滑动，并清除信息. 主动停止，不会调用isEnd==true
-(void)clearStop{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    velocityX=0;
    velocityY=0;
    startTime=0;
    [list removeAllObjects];
}
//设置监听函数
-(void)setOnRun:(void(^)(float currx,float curry,float dx,float dy,BOOL isEnd))onRun{
    onRunCall = onRun;
    
    
}

@end
