//
//  XLine.m
//  p2p
//
//  Created by zhangxiuquan on 15/1/29.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XLine.h"
#import "HelpApi.h"

@implementation XLine

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@synthesize lineWidth;
@synthesize lineColor;
@synthesize linePiontVisibel;
@synthesize linePiontGone;
@synthesize paddingStart;
@synthesize paddingEnd;
-(instancetype)init{
    float onePx = 1.0/[UIScreen mainScreen].scale+0.00000001;
    self =[super init];
    self.useLines=false;
    self.onBottom=false;
    self.onCenter=false;
    linePiontVisibel = 1;
    linePiontGone = 2;
    lineWidth =onePx;
    paddingStart=0;
    paddingEnd=0;
    [self setBackgroundColor:[UIColor whiteColor]];
    return self;
}
-(void)setPaddingStart:(float)pStart{
    paddingStart = pStart;
    [self setNeedsDisplay];
}
+(XLine*)newWithWidth:(float)w :(UIColor*)lineColor
{
    XLine * line = [XLine new];
    [line setLineColor:lineColor];
    [line addConstraint:[NSLayoutConstraint
                         constraintWithItem:line
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:0
                         constant:w]];
    NSLayoutConstraint *H = [NSLayoutConstraint
                             constraintWithItem:line
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                             multiplier:0
                             constant:0];
    H.priority=11;
    [line addConstraint:H];
    line.lineWidth=w;
    return line;
}
+(XLine*)newWithHeight:(float)h :(UIColor*)lineColor
{
    XLine * line = [XLine new];
    [line setLineColor:lineColor];
    [line addConstraint:[NSLayoutConstraint
                         constraintWithItem:line
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:0
                         constant:h]];
    
    NSLayoutConstraint *W = [NSLayoutConstraint
                             constraintWithItem:line
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                             multiplier:0
                             constant:0];
    W.priority=11;
    [line addConstraint:W];
    line.lineWidth=h;
    return line;
}
//竖直方向的line
+(XLine*)newWidth1Color:(int)lineColor{
    float onePx = 1.0/[UIScreen mainScreen].scale+0.00000001;
    return [XLine newWithWidth:onePx :COLOR(lineColor)];
}
//水平方向的line
+(XLine*)newHeight1Color:(int)lineColor{
    float onePx = 1.0/[UIScreen mainScreen].scale+0.00000001;
    return [XLine newWithHeight:onePx :COLOR(lineColor)];
}
//设置虚线
-(void)setLinePiontVisibel:(float)visibel LinePiontGone:(float)gone
{
    self.linePiontGone =gone;
    self.linePiontVisibel =visibel;
    self.useLines = true;
    [self setNeedsDisplay];
}
//-(void)setLineColor:(UIColor *)color
//{
//    //[self setBackgroundColor:color];
//    lineColor = color;
//}
//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    super.backgroundColor = COLOR(0);
//    lineColor=backgroundColor;
//}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0.0, 0.0);
    double w = self.bounds.size.width;
    double h = self.bounds.size.height;
    float onePx = 1.0/[UIScreen mainScreen].scale+0.00000001;
    if (w<=onePx) {
        //绘线
        // 核心代码 关闭抗锯齿即可
        CGContextSetAllowsAntialiasing(context,NO);
      
       

        CGContextSetLineWidth(context, onePx);
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
//
//        if(self.onCenter){
//            //修正位置
//            CGContextMoveToPoint(context,h/2, paddingStart);
//            CGContextAddLineToPoint(context, h/2, h-paddingEnd);
//        }else{
            CGContextMoveToPoint(context, w/2, paddingStart);
            CGContextAddLineToPoint(context, w/2, h-paddingEnd);
//        }
        if (self.useLines) {
            CGFloat lengths[] = {linePiontVisibel,linePiontGone};
            CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        }
        CGContextStrokePath(context);
    }else if(h<=onePx){
        
        // 核心代码 关闭抗锯齿即可
        CGContextSetAllowsAntialiasing(context,NO);
     
        //float onePx =  0.5;
        //绘线
        CGContextSetLineWidth(context, onePx);
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
//        if(self.onCenter){
//            //修正位置
            CGContextMoveToPoint(context, paddingStart, h/2);
            CGContextAddLineToPoint(context, w-paddingEnd, h/2);
//        }else if(self.onBottom){
//            //修正位置
//            CGContextMoveToPoint(context, paddingStart, h-onePx);
//            CGContextAddLineToPoint(context, w-paddingEnd, h-onePx);
//        }else{
//            CGContextMoveToPoint(context, paddingStart, onePx);
//            CGContextAddLineToPoint(context, w-paddingEnd, onePx);
//        }
        if (self.useLines) {
            CGFloat lengths[] = {linePiontVisibel,linePiontGone};
            CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        }
        CGContextStrokePath(context);
    }else if(w>onePx&&h>onePx){
        
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        
        if(w>h){
            CGContextMoveToPoint(context,paddingStart, h/2);
            CGContextAddLineToPoint(context, w-paddingEnd, h/2);
        }else{
            CGContextMoveToPoint(context,w/2, paddingStart);
            CGContextAddLineToPoint(context, w/2, h-paddingEnd);
        }
        
        //
        if (self.useLines) {
            if (w<h) {
                CGFloat lengths[] = {linePiontVisibel,linePiontGone};
                CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
            }else{
                CGFloat lengths[] = {linePiontVisibel,linePiontGone};
                CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
            }
        }
        
        //执行绘画
        CGContextStrokePath(context);

        
    }
    
}
@end
