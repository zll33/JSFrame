//
//  XViewEx.h
//  p2p
//
//  Created by zhangxiuquan on 15/1/28.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBaseViewController.h"


@interface XViewEx : NSObject

@end

#define  AutoLayoutVisibleAttribute  NSLayoutAttributeNotAnAttribute
typedef NS_ENUM(NSInteger, AutoLayoutVisible) {
    AutoLayoutVisibleShow = 1,
    AutoLayoutVisibleHide = 2,
    AutoLayoutVisibleHideWidth = 3,
    AutoLayoutVisibleHideHeight = 4,
    AutoLayoutVisibleHideAndUsed = 5,
    
};

@interface UIView (AutoLayoutVisible)
/*
 *AutoLayoutVisibleShow：将本窗体显示，并且去掉高度和宽度置为0的约束[约束级别最高1000]，
 *AutoLayoutVisibleHide：将本窗体隐藏，并且加上高度和宽度置为0的约束[约束级别最高1000]，所以本view的高度和宽度的约束不能固定。（或者最好将愿约束的级别设为750，即低于1000）
 *AutoLayoutVisibleHideAndUsed：将本窗体隐藏，但约束仍然有效（去掉高度和宽度置为0的约束）。所以原图不能含有0大小约束
 */
-(void)setVisible:(AutoLayoutVisible)visible;
-(AutoLayoutVisible)getVisible;

/**
*   注意Block里赢防止会循环引用，使用__weak或 __unsafe_unretained 可防止循环引用。
*   UIView*myButton =  [UIView new];
*   __weak UIView * weakView = myButton;
*   [myButton setOnClick:^{
*
*        //[myButton doSomething];//错误的
*
*       [weakView doSomething];//正确的
*
*   }];
*/
-(void)setOnClick:(void(^)(void))block;
-(void)setOnClickTarget:(id)target action:(SEL)action;
-(void)setNormalColor:(int)color PressColor:(int)sColor;
-(void)setNormalColor:(int)color PressColor:(int)sColor DisabledColor:(int)dColor;

-(void)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge;
-(void)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge DisabledImage:(UIImage*)dIamge;
//设置是否可点击
-(void)setClickAble:(BOOL)canClick;

//按下后多次触发事件 间隔事件 interval
-(void)setOnTouchMultTriggerInterval:(double)interval  Target:(id)target Begin:(SEL)begin Touch:(SEL)touch End:(SEL)end;
@end

@interface UIView (LayoutConstraint)
-(void)addConstraint:(NSLayoutConstraint*)c P:(float)priority;
-(void)addConstraintLitLit:(NSLayoutConstraint*)c;
-(void)addConstraintLit:(NSLayoutConstraint*)c;
-(void)addConstraintBig:(NSLayoutConstraint*)c;
-(void)addConstraintBigBig:(NSLayoutConstraint*)c;
-(void)clearConstraintsFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute )firstAttribute;
//删除指定约束。同clearConstraintsFirstItem
-(void)removeConstraintsFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute )firstAttribute;
//获取添加的约束，以便修改，动画
-(NSLayoutConstraint*)getConstraintsFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute )firstAttribute;
//添加为自己的子VIEW，完全相等
-(void)addViewEqSelf:(UIView*)view;
//添加到自己的子View，中心对齐，偏差dx、dy，如果w!=0或h!=0,设置宽和高度,并且可设置为MatchParent,负数代表倍数
-(void)addOnCenter:(UIView *)view W:(float)w H:(float)h DX:(float)dx DY:(float)dy;

//添加到自己的子View，中心对齐，偏差dx、dy,倍数cx、cy，如果w!=0或h!=0,设置宽和高度,并且可设置为MatchParent,负数代表倍数
-(void)addOnCenter:(UIView *)view W:(float)w H:(float)h MultCX:(float)cx MultCY:(float)cy DX:(float)dx DY:(float)dy;

-(void)setWH:(UIView *)view MultW:(float)w MultH:(float)h DW:(float)dw DH:(float)dh;


//添加到自己的子View，上下中心对齐，局右，偏差dr、dy，如果w!=0或h!=0,设置宽和高度,并且可设置为MatchParent,负数代表倍数
-(void)addOnCenterRight:(UIView *)view W:(float)w H:(float)h DR:(float)dr  MultCY:(float)cy  DY:(float)dy;

//添加到自己的子View，上下中心对齐，局右，偏差dr、dy，如果w!=0或h!=0,设置宽和高度,并且可设置为MatchParent,负数代表倍数
-(void)addOnCenterLeft:(UIView *)view W:(float)w H:(float)h DL:(float)dl  MultCY:(float)cy  DY:(float)dy;
-(void)addOnCenterTop:(UIView *)view W:(float)w H:(float)h DT:(float)dt  MultCX:(float)cx  DX:(float)dx;
//添加到自己的子View，上下中心对齐，局右，偏差dr、dy，如果w!=0或h!=0,设置宽和高度,并且可设置为MatchParent,负数代表倍数
-(void)addOnCenterBottom:(UIView *)view W:(float)w H:(float)h DB:(float)db  MultCX:(float)cx  DX:(float)dx;
-(void)addOnLeftTop:(UIView *)view W:(float)w H:(float)h DLeft:(float)dleft  DTop:(float)dtop;
-(void)addOnRightTop:(UIView *)view W:(float)w H:(float)h DRight:(float)dright  DTop:(float)dtop;

-(void)addOnLeftBottom:(UIView *)view W:(float)w H:(float)h DLeft:(float)dleft  DBottom:(float)dbottom;
-(void)addOnRightBottom:(UIView *)view W:(float)w H:(float)h DRight:(float)dright  DBottom:(float)dbottom;

-(void)addView:(UIView *)view toViewTopRight:(UIView*)leftView W:(float)w H:(float)h DMargin:(float)dmargin  DTop:(float)dtop;



@end


@interface UIView (view)
-(void)setOnFrameChange:(void(^)(UIView*view,CGRect oldRect,CGRect newRect))block;
-(void)removeAllChild;
-(void)setRadius:(float)r borderWidth:(int)bw borderColor:(int)c;
-(void)showViewController:(XBaseViewController*)vc;
@end

@interface UILabel (Text)
-(void) setText:(NSString *)text Color:(int)color Size:(float)size;
@end
@interface UIButton (OnClickBack)
//-(void)setNormalColor:(int)color SelectedColor:(int)sColor;
//-(void)setNormalColor:(int)color SelectedColor:(int)sColor DisabledColor:(int)dColor;

@end


@interface UITextField(MaxLength)
-(void)setMaxLength:(int)length;
@end
@interface UIView (OnDraw)
//延时刷新
-(void) postInvalidate;
//延时刷新,如果已存在，无论delay是多少，都不会继续调用。
-(void) postInvalidateDelay:(double) delay;
//查找子view根据tag
-(UIView*)findViewByTag:(long)tag;
@end

//点击隐藏软键盘
@interface TouchHideKeyborad : UIView
@property(nonatomic,weak)NSObject*showTag;
@property(nonatomic)SEL showSel;
@property(nonatomic,weak)NSObject*hideTag;
@property(nonatomic)SEL hideSel;
-(void)setOnShowTag:(id)tag selector:(SEL)sel;
-(void)setOnHideTag:(NSObject*)tag selector:(SEL)sel;
@end
