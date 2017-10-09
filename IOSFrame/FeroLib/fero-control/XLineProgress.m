//
//  XLineProgress.m
//  p2p
//
//  Created by zhangxiuquan on 15/4/20.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XLineProgress.h"
#import "HelpApi.h"
@implementation XLineProgress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize lineColor;
@synthesize lineBackColor;
@synthesize progress;
-(void)setLineColor:(UIColor *)color :(UIColor *)_lineBackColor
{
    lineColor=[color copy];
    lineBackColor= _lineBackColor;
    [self setNeedsDisplay];
}
-(void)setProgress:(float)_progress
{
    progress = _progress;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0.0, 0.0);
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
 
        
    //OC绘制矩形时，会多绘制1
    rect = CGRectMake(0, 0, w, h);
        
    //设置矩形填充颜色：红色
    CGContextSetFillColorWithColor(context, lineBackColor.CGColor);
    //填充矩形
    CGContextFillRect(context, rect);
    
    //设置矩形填充颜色：红色
    CGContextSetFillColorWithColor(context, lineColor.CGColor);
    //填充矩形
    rect = CGRectMake(0, 0, w*self.progress, h);
    CGContextFillRect(context, rect);
    
    
    //执行绘画
    CGContextStrokePath(context);
   
    
}
@end
