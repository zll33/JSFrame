//
//  BaseView.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JsRunner.h"
#import "JsLoader.h"
#import "XHeader.h"
#define Density  [UIScreen mainScreen].scale

#define  TView 0        // 四个基础控件
#define  TTextView 1    // 四个基础控件
#define  TEditView 2    // 四个基础控件
#define  TScrollView 3  // 四个基础控件

#define  GravityNO   0X00000000
#define  GravityLeft   (0X00000001<<0)
#define  GravityRight   (0X00000001<<1)
#define  GravityCenterH   (0X00000001<<2)

#define  GravityTop   (0X00000001<<4)
#define  GravityBottom  (0X00000001<<5)
#define  GravityCenterV   (0X00000001<<6)

#define  ScaleMax   0   //默认：图片填满View的宽或高，View可能不留空。图片可能按比例缩放，图片显示完整。
#define  ScaleCrop   1  //图片填满View，View完全不留空。图片可能按比例缩放，多余的图片会剪切掉。
#define  ScaleFill   2  //图片填满View，View完全不留空。图片可能变形，图片显示完整。

@class BaseView;
@protocol JSBaseViewExport<JSExport>
-(void) setClip:(BOOL) clip;
-(void) setRect:(float) x :(float) y :(float) w :(float) h;
-(void) setWidth:(float) w;
-(void) setHeight:(float) h;
-(void) setX:(float) x;
-(void) setY:(float) y;
-(void) setText:(NSString*) str;
-(NSString*) getText;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//文本编辑框
-(void) setOnTextChange:(JSValue*) onchange;
//IOS\DIV没有内边距概念，强制支持TextPadding，正常的pading在XYWH上已经计算完成。 但是内边距不支持clip
-(void) setTextPadding:(float) left :(float) top :(float) right :(float) bottom;

-(void) setLineSpace:(float)value;
-(void)setCharSpace:(float)value;
-(void)setFontSize:(float)value;
-(void)setFontColor:(int)color;
-(void) setTextGravity:(int)gravity;

-(void) setBackColor:(int) color;
-(void) setBackImage:(NSString*)  url;

-(void) setScaleType:(int) type;
-(void) addView:(JSValue*)view :(int)index;
-(void) removeView:(JSValue*) view;
-(void) setOnClick:(JSValue*) fun;
//

-(void) setContentView:(JSValue*) view;
//垂直滚动条overflow-y:visible或overflow-y:hidden
-(void) setShowVertical:(BOOL)show;

//水平滚动条
-(void) setShowHorizontal:(BOOL)show;
//设置滚动监听。 向上滚动，滚动的位置为负数，向下滚动滚动的位置为正数
-(void) setOnScroll:(JSValue*) onScroll;
//完全隐藏
-(void) setGone;
//完全可见
-(void) setVisibel;
-(void) setRotate:(float) rotate :(float) cx :(float)cy;
-(void) setAlpha:(float) alpha;
-(void) setScale:(float) sx :(float) sy :(float) cx :(float) cy;
//动画类
-(void) startAnimation;
-(void) stopAnimation;
-(void) clearAnimation;
//动画循环次数
-(void) setAnimationCount;
//动画结束，保持结束状态
-(void) setAnimationKeep;
/*
 animation: name duration timing-function delay iteration-count direction;
 name:keyframe的名称，也就是定义了关键帧的动画的名称,这个名称用来区别不同的动画。
 duration:完成动画所需要的时间（2s 或者 2000ms）
 timing-function:完成动画的速度曲线
 delay：动画开始之前的延迟
 iteration-count：动画播放次数
 direction：是否轮流反向播放动画（normal:正常顺序播放，alternate下一次反向播放）如果把动画设置为只播放一次，则该属性没有效果。
 */
-(void) addTranslate:(long long) delayTime :(long long) continueTime :(int) changeType :(float) fromx :(float) tox :(float) fromy :(float) toy;
-(void) addAlpha:(long long) delayTime :(long long) continueTime :(int) changeType :(float) fromAlpha :(float) toAlpha;
-(void) addScale:(long long) delayTime :(long long) continueTime :(int) changeType :(float) fromX :(float) toX :(float) fromY :(float) toY :(float) pX :(float) pY;
-(void) addRotate:(long long) delayTime :(long long) continueTime :(int) changeType  :(float) fromRotate :(float) toRotate :(float) cenerX :(float) cenery;
 
@end

@interface BaseView : NSObject<JSBaseViewExport>
@property(nonatomic)UIView*tv;
@property(nonatomic)UIView*mainView;
@property(nonatomic)JsRunner*jsRunner;
@property(nonatomic)JsLoader*jsLoader;

@property(nonatomic) void(^onSetWH)(float w,float h);
//设置文字比重
-(void)resetTextGravity;
@end
