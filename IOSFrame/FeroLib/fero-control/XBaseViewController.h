//
//  XBaseViewController.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/17.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//
@class  XBaseViewController ;
@class  XScrollView ;
@class  LCImage ;
@class  LCLabel ;
#import <UIKit/UIKit.h>

#import "DialogMsg.h"
#import "XTitle.h"
#import "XJson.h"
#import "XViewEx.h"
#import "XTableView.h"


@interface PageLoading : UIView

@property(nonatomic) UIActivityIndicatorView*activityIndicatorView;
@property(nonatomic) UIView*loadingView;
@property(nonatomic) UIView*errView;
@property(nonatomic) LCImage*errIcon;
@property(nonatomic) LCLabel*errMsg;
@property(nonatomic) LCLabel*errButton;

//初始化布局，自定view时，需要重写onCreate。
-(void)onCreate;

//
-(void)showLoading;
-(void)showErr;
@end

@protocol XControllerDataProtocol <NSObject>

-(int)getIntKey:(NSString*)key;
-(long)getLongKey:(NSString*)key;
-(NSString*)getStringKey:(NSString*)key;
-(XJson*)getJsonKey:(NSString*)key;
/**
 *取不到时，返回false
 */
-(Boolean)getBooleanKey:(NSString*)key;
-(id)getObjectKey:(NSString*)key;
-(void)addInt:(int)value Key:(NSString*)key;
-(void)addLong:(long)value Key:(NSString*)key;
-(void)addString:(NSString*)value Key:(NSString*)key;
-(void)addBoolean:(Boolean)value Key:(NSString*)key;
-(void)addObject:(id)value Key:(NSString*)key;
-(void)addJson:(NSDictionary*)value Key:(NSString*)key;

-(void)addMuValue:(NSDictionary*)value;
-(XJson*)getParam;
//弹出消息
-(void)showMsg:(NSString*)msg;

/**
 *
 *弹出等待框
 */
-(void)showWait;
-(void)showWaitMsg:(NSString*)msg;
-(void)showWaitToMsg:(NSString*)msg;
- (void)showWaitToMsg:(NSString *)msg hideWaitAfterDelay:(CGFloat)Delay;
- (void)showWaitToMsg:(NSString *)msg callBackWithAfterDelay:(CGFloat)Delay;
-(void)hideWait;


/*
 *刷新View函数
 *
 */
-(void)resetView;
-(void)onResetView;


/**
 *自动增加titleBar
 *
 */
- (void)hideXTitleBar;
/**
 *隐藏返回
 *
 */
- (void)hideBack;
- (void)showBack;
/**
 *自动设置contentView的约束，适应全屏幕
 *
 */
- (id)setContentViewNibNamed:(NSString*)nibName;
- (id)setContentViewNibNamed:(NSString*)nibName Index:(int)index;
- (void)setContentView:(UIView*)view;

@property (nonatomic)  XScrollView* xscrollView;

- (id)setContentViewInXScrollViewNibNamed:(NSString*)nibName;
- (id)setContentViewInXScrollViewNibNamed:(NSString*)nibName Index:(int)index;
- (void)setContentViewInXScrollView:(UIView*)view;


@property (nonatomic)  XTableView* xtableView;
- (id)setContentViewWithXTableView;
- (NSString*) getLastIdStr;

@end

#define BackCode_Cancel 0
#define BackCode_OK 1
#define BackCode_ToFirst 2

@protocol XControllerProtocol <XControllerDataProtocol>

/*
 *获取所在的UIViewController
 */
-(UIViewController*)getUIViewController;
-(void)setPreviousXControllerProtocol:(id<XControllerProtocol>)previous Requset:(int)rcode;
/*
 *显示一个新页面
 */
-(UIViewController*)showNewControllerIdentifier:(NSString*)newConIdentifier  animated:(BOOL)animated;
-(UIViewController*)showNewController:(UIViewController*)newCon  animated:(BOOL)animated;
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier RequestCode:(int)rCode Param:(NSDictionary*)param animated:(BOOL)animated;


/*
 *显示一个新页面,并且关闭一些页面
 */
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier BackToControllerIdentifier:(NSString*)backToConIdentifier  animated:(BOOL)animated;
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier BackToControllerByCount:(int)acount  animated:(BOOL)animated;

-(UIViewController*)showNewControllerWithBackToTopController:(UIViewController*)newCon :(NSString*)newConIdentifier  animated:(BOOL)animated;
/**
 *退出
 */
-(void)callBack;
-(void)back:(BOOL)animated;
//清空除最后一个的所有回调
-(void)backToController:(UIViewController*)c  animated:(BOOL)animated;
//清空除最后一个的所有回调
-(void)backToControllerByIdentifier:(NSString*)identifier  animated:(BOOL)animated;
//清空除最后一个的所有回调
-(void)backToControllerByBackCount:(int)count  animated:(BOOL)animated;
//清空除最后一个的所有回调
-(void)backToTopControllerAnimated:(BOOL)animated;

//返回时的数据
-(void)setBackCode:(int)bCode Data:(XJson*)data Data2:(id)data2;
-(void)onBackFromOtherController:(UIViewController*)c Identifier:(NSString*)identifier RequestCode:(int)rCode BackCode:(int)bCode Data:(XJson*)data Data2:(id)data2;




@end

//WindowSoftInputMode
enum  WindowSoftInputMode {
    AdjustPan = 0,//当keyboard弹出时，view上移，防止遮挡输入框
    AdjustResize = 1//当keyboard弹出时，view高度减小，防止遮挡输入框
};



@class XBaseViewController;
@protocol XBaseViewControllerListener
-(void)onViewLoad:(XBaseViewController*)controller;
@end


@interface XBaseViewController : UIViewController<XControllerProtocol,UITableViewDataSource>
{
    __weak id thiz;
}
@property (nonatomic) PageLoading*loadingView;
@property(nonatomic)  enum WindowSoftInputMode adjustMode;
@property (nonatomic) BOOL hasAppear;
@property (nonatomic) BOOL canMoveBack;
@property (nonatomic) BOOL canBack;
@property (nonatomic)  XTitleBar* xtitleBar;
@property (nonatomic,readonly) BOOL hasShowInputWindow;
@property (nonatomic)  XScrollView* xscrollView;
@property (nonatomic)  XTableView* xtableView;
@property (weak,nonatomic) UIView * needVisibleViewWhenKeyboardShow;
@property (nonatomic) float needVisibleUpPy;
@property(nonatomic) BOOL allowFixInputView;
@property (nonatomic, assign) BOOL backAnimaction;
+(void)setBaseStyle:(UIStatusBarStyle)style;
-(void)setNeedVisibleViewWhenKeyboardShow:(UIView*)view UpPy:(float)upPy;
//完成切换动画后，第一次load入口。 用于请求网络数据，或其他逻辑。IOS7中，如果切换动画未完成时，启动新页面，会挂掉。
-(void)onFisterLoad;

-(void)addView:(UIView*)view Eq:(UIView*)eview;
-(void)addView:(UIView*)view;
-(void)callBack;
+(void)setOnInit:(id<XBaseViewControllerListener>)onInit;
-(void)addOnBackCall:(void(^)(XBaseViewController* c ,int backCode,XJson*data, id data2)) call;
-(void)clearAllBackCall;
-(void)removeBackCall:(int)count;
-(void)showMaskView:(UIView*)maskview   FixedView:(UIView*)fixview ToCenterView:(UIView*)toCenterView DX:(float)dx DY:(float)dy;

//静态的关闭所有页面
-(void)clearToTopController;
//
-(void)hideInput;


//
-(void)showLoading;
-(void)showLoadingErr;
-(void)hideLoading;
-(void)onClickLoading;

@end
