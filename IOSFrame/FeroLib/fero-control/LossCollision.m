//
//  LossCollision.m
//  p2p
//
//  Created by zhangxiuquan on 15/5/14.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "LossCollision.h"
#import "Math.h"
@interface vNote : NSObject 
@property (nonatomic, assign)  long startHeight;
@property (nonatomic, assign)  long startT;
@property (nonatomic, assign)  long endT;
@property (nonatomic, assign)  double startV;
@property (nonatomic, assign)  double endV;
@end
@implementation vNote
@end


@interface LossCollision ()
{
    // 起始高度
    double startHeight;
    // 起始速度
    double startVelocity;
    // 加速度
    double acceleration;
    // 碰撞损耗能量，百分比
    double depleteEnergy;
    
    long startTime;
    long endTime;
    
    long lastTime;
    
    double curHeight;
    
    NSMutableArray *vList;
}
@end
@implementation LossCollision
-(id)init{
    self = [super init];
    [self initValue];
    return self;
}
-(void)initValue{
    startHeight=0;
    startVelocity=0;
    acceleration=0;
    depleteEnergy=0;
    startTime=0;
    endTime=0;
    curHeight=0;
    vList=[NSMutableArray new];

}
-(double) getCurHeight {
    
    return curHeight / 1000;
}

- (void) stop {
    
}
-(void) start:(double) height{
    
    [self start:height
       velocity:0
   acceleration:400
  depleteEnergy:0.7];
    
}
-(void)start:(double) height
    velocity:(double)velocity
acceleration: (double) a
depleteEnergy:(double) _depleteEnergy
{
    startHeight = curHeight = height * 1000;
    startVelocity = velocity;
    acceleration = a / 1000;
  
    depleteEnergy = (double)  sqrt(1 - (_depleteEnergy > 1 ? 1 : _depleteEnergy));
    startTime = [[NSProcessInfo processInfo] systemUptime]*1000;
    endTime = LONG_MAX;
    lastTime = startTime;
    
    [vList removeAllObjects];
    
}
-(BOOL)doCollisionDtime:(long)dt {
    lastTime+=dt;
    return [self doCollisionCurr:lastTime];
}
-(BOOL)doCollision{
    lastTime=[[NSProcessInfo processInfo] systemUptime]*1000;
    return [self doCollisionCurr:lastTime];
}
-(BOOL)doCollisionCurr:(long)curTime {
    BOOL find = false;
     for (vNote* note in vList) {
        // 是否在当前过程
        if (curTime >= note.startT && curTime <= note.endT) {
            long t = curTime - note.startT;
            curHeight = note.startV * t + 0.5f * acceleration * t * t;
            curHeight = note.startHeight - curHeight;
            find = true;
            break;
        }
    }
    
    // 找不到添加新的
    if (find == false && curTime > startTime) {
        vNote *note = nil;
        do {
            note = [vNote new];
            if ([vList count] > 0) {
                vNote* lastNote = [vList lastObject];
                note.startHeight = 0;
                note.startT = lastNote.endT;
                note.startV = -lastNote.endV * depleteEnergy;
                note.endV = -note.startV;
                note.endT = (long) ((note.endV - note.startV) / acceleration)
                + note.startT;
                
            } else {
                note.startHeight = (long) startHeight;
                note.startT = startTime;
                note.startV = startVelocity;
                note.endV = (double) sqrt(2 * acceleration * startHeight + note.startV * note.startV);
                note.endT = (long) ((note.endV - note.startV) / acceleration) + note.startT;
                
            }
            
            // 速度太小，停止弹起
            if (note.endT - note.startT < 50) {
                endTime = note.endT;
            }
            
            [vList addObject:note];
            
        } while (curTime > note.endT && curTime < endTime);
        
        if (curTime > endTime) {
            curHeight = 0;
        } else {
            long dt = curTime - note.startT;
            curHeight = note.startV * dt + 0.5f * acceleration * dt * dt;
            curHeight = note.startHeight - curHeight;
        }
        
    }
    
    if (curTime < endTime) {
        return true;
    } else {
        return false;
    }
    
}
@end
