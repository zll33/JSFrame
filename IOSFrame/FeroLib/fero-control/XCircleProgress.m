//
//  XCircleProgress.m
//  p2p
//
//  Created by zhangxiuquan on 15/4/21.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XCircleProgress.h"
#import "XHeader.h"
#import <math.h>



@interface XCircleProgress()
{
    LossCollision*lc;
    NSMutableArray* colors;
    NSMutableArray* progresss;
}
@end


@implementation XCircleProgress
@synthesize lineWide;
-(id)init{
    self = [super init];
    [self setBackgroundColor:COLOR(0)];
    //[self setBackColor:COLOR(0)];
    self.progress = 0;
    self.useAnimation =TRUE;
    lc=nil;
    self.dr = 20;
    lineWide=2;
    [self setLineColor:COLOR(0xff97bacd) :COLOR(0xfff0f0f0)];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.progress = 0;
    self.useAnimation =TRUE;
    lc=nil;
    self.dr = 20;
    [self setLineColor:COLOR(0xff97bacd) :COLOR(0xfff0f0f0)];
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.progress = 0;
    self.useAnimation =TRUE;
    lc=nil;
    self.dr = 20;
    [self setLineColor:COLOR(0xff97bacd) :COLOR(0xfff0f0f0)];
    return self;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backColor=backgroundColor;
    super.backgroundColor= COLOR(0);
    [self setNeedsDisplay];
}

/**
 * 设置进度
 *
 * @param p
 */
-(void) setProgress:(float) p {
    super.progress = p >= 0 ? (p <= 1 ? p : 1) : 0;
    [self setProgresss:nil Colors:nil];
}
-(void)setLineColor:(UIColor *)lineColor
{
    [self setLineColor:lineColor :super.lineBackColor ];
}
-(void)setLineBackColor:(UIColor *)lineBackColor
{
    [self  setLineColor:super.lineColor :lineBackColor ];
}
-(void)setLineColor:(UIColor *)color :(UIColor *)lbColor
{
    super.lineColor=[color copy];
    super.lineBackColor= lbColor;
    [self setProgresss:nil Colors:nil];
    
}
-(void)setProgresss:(NSMutableArray *)p Colors:(NSMutableArray *)c
{
    if (p==nil) {
        p =[NSMutableArray new];
        [p addObject: [NSNumber numberWithFloat:self.progress]];
        [p addObject: [NSNumber numberWithFloat:1-self.progress]];
        
      
    }
    if (c==nil) {
        if (super.lineBackColor==nil) {
            super.lineBackColor=COLOR(0);
        }
        if (super.lineColor==nil) {
            super.lineColor=COLOR(0);
        }
        c =[NSMutableArray new];
        [c addObject: super.lineColor];
        [c addObject: super.lineBackColor];
        
    }
    colors = c;
    progresss=p;
    
    if (self.useAnimation) {
        if (lc == nil ) {
            lc = [LossCollision new];
        }
        
        [lc start:360
         velocity:200
     acceleration:1700
    depleteEnergy:1/*0.8*/];
    }else{
        lc = nil;
    }

    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    
    float p =1;
    if (lc) {
        if ([lc doCollisionDtime:10]) {
            //postInvalidateDelayed(50);
            __weak UIView *me = self;
            [self performBlock:^{
                
                [me setNeedsDisplay];
                
            } afterDelay:0.01];
        }
        p = 1-[lc getCurHeight]/360;
    }
    if (self.backColor) {
        [self drawCircle:0 sweep:2*M_PI color:self.backColor];
    }
    if ([colors count]==[progresss count]) {
        float PI = M_PI;
        float start= -0.25*2*PI;
        for (int i=0; i<[colors count]; i++) {
            float progress =[(NSNumber*)[progresss objectAtIndex:i] floatValue];
            progress =progress * p;
            progress = progress * 2*PI;
            if(progress>0){
                [self drawCircle:start sweep:progress color:(UIColor*)[colors objectAtIndex:i]];
                start+=progress;
            }
            
        }
    }
}
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}


- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}


-(void)drawCircle:(float) seek  sweep:(float) sweep color:(UIColor*) color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
    int r = (w>h ?h/2:w/2)-1;
    int x = w/2;
    int y = h/2;
    
    int dr = self.dr;
    
    
    //已完成的背景
    CGContextSetStrokeColorWithColor(context, UIColor.whiteColor.CGColor);//改变画笔颜色
    CGContextSetLineWidth(context, lineWide);//线的宽度
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddArc(context, x, y, r,  seek ,seek+sweep, 0); //添加一个圆
    CGContextAddArc(context, x, y, r-dr, seek+sweep, seek,1); //添加一个圆
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
}

@end
