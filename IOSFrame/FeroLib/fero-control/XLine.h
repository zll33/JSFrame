//
//  XLine.h
//  p2p
//
//  Created by zhangxiuquan on 15/1/29.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLine : UIView
@property(nonatomic) float lineWidth;
@property(nonatomic,copy) UIColor *lineColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) BOOL useLines;
@property(nonatomic) float linePiontVisibel;
@property(nonatomic) float linePiontGone;
@property(nonatomic) BOOL onBottom;//废弃
@property(nonatomic) BOOL onCenter;//废弃
@property(nonatomic) float paddingStart;//Left Top
@property(nonatomic) float paddingEnd;//Right Bottom
+(XLine*)newWithWidth:(float)w :(UIColor*)lineColor;
+(XLine*)newWithHeight:(float)h :(UIColor*)lineColor;
//竖直方向的line
+(XLine*)newWidth1Color:(int)lineColor;
//水平方向的line
+(XLine*)newHeight1Color:(int)lineColor;
//设置虚线
-(void)setLinePiontVisibel:(float)visibel LinePiontGone:(float)gone;
@end
