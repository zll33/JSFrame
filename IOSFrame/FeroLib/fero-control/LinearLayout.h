//
//  LinearLayout.h
//  p2p
//
//  Created by zhangxiuquan on 15/2/10.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJson.h"


enum LinearLayoutOrientation{
    LinearLayoutVertical = 0,
    LinearLayoutHorizontal = 1
    
};

#define GravityNo 0
#define GravityLeft 1
#define GravityTop  2
#define GravityRight  4
#define GravityBottom  8
#define GravityMiddleH  16
#define GravityMiddleV 32

#define GravityNo_NO 0

#define GravityLeft_Top (GravityLeft|GravityTop)
#define GravityLeft_MiddleV (GravityLeft|GravityMiddleV)
#define GravityLeft_Bottom (GravityLeft|GravityBottom)

#define GravityMiddleH_Top (GravityMiddleH|GravityTop)
#define GravityMiddleH_MiddleV (GravityMiddleH|GravityMiddleV)
#define GravityMiddleH_Bottom (GravityMiddleH|GravityBottom)

#define GravityRight_Top (GravityRight|GravityTop)
#define GravityRight_MiddleV (GravityRight|GravityMiddleV)
#define GravityRight_Bottom (GravityRight|GravityBottom)


#define MatchPatrent -1
#define WrapContent -2
#define WithWeight -3

//@protocol  LinearLayoutCell <NSObject>
////@property (nonatomic)  UIView* lv;
////@property (nonatomic)  UIView* tv;
////@property (nonatomic)  UIView* rv;
////@property (nonatomic)  UIView* bv;
//
//@property (nonatomic)  XJson* json;
//@property (nonatomic)  id data;
//@property (nonatomic)  int type;
//@property (nonatomic)  BOOL useWeight;
//@property (nonatomic)  float weight;
//@property (nonatomic)  float marginLeft;
//@property (nonatomic)  float marginTop;
//@property (nonatomic)  float marginBottom;
//@property (nonatomic)  float marginRight;
//
//@property (nonatomic)  int gravity;
//
//
////@property (nonatomic)  BOOL isMatchParent;
//-(UIView*)getView;
//
//
//@end
@class LinearLayout;
@interface  LinearLayoutCell:NSObject
@property (nonatomic)  NSString* cellName;
@property (nonatomic)  XJson* json;
@property (nonatomic)  id data;
@property (nonatomic)  int type;
@property (nonatomic)  BOOL useWeight;
@property (nonatomic)  float weight;
@property (nonatomic)  float marginLeft;
@property (nonatomic)  float marginTop;
@property (nonatomic)  float marginBottom;
@property (nonatomic)  float marginRight;
@property (weak,nonatomic)  LinearLayout*parent;
@property (nonatomic ,setter=setGravity2:)  int gravity;
//@property (nonatomic)  BOOL isMatchParent;

-(UIView*)getView;
+(LinearLayoutCell*)newWithView:(UIView*)v
                     MarginLeft:(float) ml
                      MarginTop:(float) mt
                   MarginBottom:(float) mb
                    MarginRight:(float) mr
                      UseWeight:(BOOL)use
                         Weight:(float) w;
+(LinearLayoutCell*)newWithView:(UIView*)v;
-(LinearLayoutCell*)setView:(UIView*)v;
-(LinearLayoutCell*)setMinWidth:(float)w;
-(LinearLayoutCell*)setWidth:(float)w;
-(LinearLayoutCell*)setMaxWidth:(float)w;
-(LinearLayoutCell*)setMaxHeight:(float)h;
-(LinearLayoutCell*)setMinHeight:(float)h;
-(LinearLayoutCell*)setHeight:(float)h;
-(LinearLayoutCell*)setRadius:(float)r borderWidth:(int)bw borderColor:(int)c;
-(LinearLayoutCell*)setBackColor:(int)c;
-(LinearLayoutCell*)setMLeft:(float)l;
-(LinearLayoutCell*)setMTop:(float)t;
-(LinearLayoutCell*)setMBottom:(float)b;
-(LinearLayoutCell*)setMRight:(float)r;
-(LinearLayoutCell*)setMargin:(float)m;
-(LinearLayoutCell*)setUse:(BOOL)use Weight:(float)w;
//-(LinearLayoutCell*)setMatchParent:(BOOL)matchParent;
-(LinearLayoutCell*)setGravity:(int)gravity;
-(void)setGravity2:(int)gravity;
-(float)getWidth;
-(float)getHeight;

/**
 *
 * u
 */
-(LinearLayoutCell*)setOnClick:(void(^)())onClick;
-(LinearLayoutCell*)setOnClickTarget:(id)target action:(SEL)action;
-(LinearLayoutCell*)setOnClickWeak:(id)weakid Click:(void(^)(id weakid,LinearLayoutCell*view))onClick;
-(LinearLayoutCell*)setOnClick:(id)weakid ViewAction:(SEL)action;
-(LinearLayoutCell*)setNormalColor:(int)color PressColor:(int)sColor;
-(LinearLayoutCell*)setNormalColor:(int)color PressColor:(int)sColor DisabledColor:(int)dColor;
-(LinearLayoutCell*)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge;
-(LinearLayoutCell*)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge DisabledImage:(UIImage*)dIamge;

-(LinearLayoutCell*)setClickAble:(BOOL)canClick;

//按下后多次触发事件 间隔事件 interval
-(LinearLayoutCell*)setOnTouchMultTriggerInterval:(double)interval  Target:(id)target Begin:(SEL)begin Touch:(SEL)touch End:(SEL)end;


/**
 * 设置隐藏
 */
//可见
-(LinearLayoutCell*)setVisibleVisibel;
//不可见
-(LinearLayoutCell*)setVisibleGone;
//不可见，但是占位子
-(LinearLayoutCell*)setVisibleInVisibel;

-(BOOL)isVisibleVisibel;
//不可见
-(BOOL)isVisibleGone;
//不可见，但是占位子
-(BOOL)isVisibleInVisibel;

@end


@interface LinearLayout : UIView
@property (nonatomic,weak)  LinearLayoutCell* thisCell;

@property (nonatomic) enum LinearLayoutOrientation orientation;


@property (nonatomic)  int gravity;

@property (nonatomic)  BOOL isCenterChild;
@property (nonatomic)  NSString* name;
@property (nonatomic)  XJson* json;
@property (nonatomic)  id data;
@property (nonatomic)  int type;
-(void)callAllViewDispaly;
+(LinearLayout*) newVertical;
+(LinearLayout*) newHorizontal;
-(void)setOnRefresh2:(void (^)(LinearLayoutCell *cell))onRefresh;
-(void)setOnRefresh:(void (^)(LinearLayoutCell *cell))onRefresh;
-(void)addView:(LinearLayoutCell*)v;
-(void)addView:(LinearLayoutCell*)v Index:(int)index;
-(LinearLayoutCell*)getView:(int)index;
-(int)getCount;
-(void)removeView:(UIView*)v;
-(void)removeViewCell:(LinearLayoutCell*)cell;
-(void)removeView:(UIView*)v OrXJson:(XJson* )json OrData:(id)data OrType:(int)type;
-(void)removeViewIndex:(int)index;
-(void)callRefresh;
-(void)removeAllView;
//更新布局
-(void)callUpdata;
//检查UILabel的压缩权重
-(void)checkUILabel;
//
-(LinearLayoutCell*)findViewByCellName:(NSString*)name;
@end
