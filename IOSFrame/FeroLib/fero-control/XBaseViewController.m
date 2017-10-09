//
//  XBaseViewController.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/17.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XBaseViewController.h"
#import "XScrollView.h"
#import "BaiduMobStat.h"
#import "XObjectEx.h"
#import "HelpApi.h"
#import "ViewFactory.h"

UIStatusBarStyle  __basestyel =UIStatusBarStyleLightContent;
@interface OnBackCall : NSObject
@property(strong) void(^call)(XBaseViewController* c ,int backCode,XJson*data, id data2);
@end


@implementation OnBackCall


@end

@implementation PageLoading
@synthesize activityIndicatorView;
@synthesize loadingView;
@synthesize errView;
@synthesize errIcon;
@synthesize errMsg;
@synthesize errButton;

-(id)init{
    self = [super init];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self onCreate];
    return self;
}
-(void)onCreate{
    
    //
    loadingView = [UIView new];
    activityIndicatorView = [UIActivityIndicatorView new];
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [loadingView addOnCenter:activityIndicatorView W:32 H:32 DX:0 DY:0];
    
   
    //
    LinearLayout*errLay = [LinearLayout newVertical];
    [errLay setGravity:GravityMiddleH];
    errView = errLay;
    
    //
    LCLabel*sp1 = [LCLabel newWithText:nil FontSize:0 FontColor:0];
    [sp1 setUse:true Weight:145];
    [errLay addView:sp1];
    
    //
    errIcon = [LCImage newWithUrl:nil Width:210 Height:160];
    [errLay addView:errIcon];
    
    //
    errMsg = [LCLabel newWithText:@"网络异常，请刷新重试" FontSize:16 FontColor:0xff666666];
    [errMsg setTextAlignment:NSTextAlignmentCenter];
    [errMsg setLineSpacing:3];
    [errMsg setMRight:25];
    [errMsg setMLeft:25];
    [errMsg setWidth:MatchPatrent];
    [errMsg setHeight:WrapContent];
    [errMsg setMTop:20];
    [errLay addView:errMsg];
    
    //
    errButton = [LCLabel newWithText:@"刷新" FontSize:16 FontColor:0xffffffff];
    [errButton setHeight:44];
    [errButton setWidth:120];
    [errButton setTextAlignment:NSTextAlignmentCenter];
    [errButton setMTop:36];
    [errButton setRadius:2 borderWidth:0 borderColor:0];
    [errButton setBackColor:0xffaaaaaa];
    [errLay addView:errButton];
 
    //
    LCLabel*sp2 = [LCLabel newWithText:nil FontSize:0 FontColor:0];
    [sp2 setUse:true Weight:805];
    [errLay addView:sp2];
}
//
-(void)showLoading{
    if(loadingView.superview==nil){
        [self addViewEqSelf:loadingView];
        [activityIndicatorView startAnimating];
        [errView removeFromSuperview];
    }
}
-(void)showErr{
    if(errView.superview==nil){
        [self addViewEqSelf:errView];
        [activityIndicatorView stopAnimating];
        [loadingView removeFromSuperview];
    }
}
@end


@interface XBaseViewController ()
{
    NSMutableArray*callList;
    UIView*msgLableBack;
    UILabel*msgLable;
    XJson* paramList;
    
    UIView* waitBack;
    UIView* waitBackBlack;
    UIActivityIndicatorView* waitActivity;
    UILabel* waitActMsg;
    UILabel* waitToMsg;
    
    id<XControllerProtocol> previousXControllerProtocol;
    int requsetCode;
    int backCode;
    XJson* data;
    id data2;
    UIView*contentViewConstraintsView;
    BOOL doFisterLoad;
    
    
    //垃圾IOS，同时重写set和get，属性无法直接使用了。
    PageLoading*  tmpLoadingView;
   
}
@property (nonatomic) BOOL hasCallBack;
@end

id<XBaseViewControllerListener> xbaseOnInit=nil;

@implementation XBaseViewController
@synthesize hasShowInputWindow;;
@synthesize needVisibleViewWhenKeyboardShow;
@synthesize adjustMode;

+(void)setOnInit:(id<XBaseViewControllerListener>)onInit
{
    xbaseOnInit = onInit;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self XBaseViewController_onCreate];
    
    return self;
}

-(id)init
{
    self =[super init];
   
    [self XBaseViewController_onCreate];
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self XBaseViewController_onCreate];
    return self ;
}

-(void)loadView{ 
    [super loadView];
}

-(void)XBaseViewController_onCreate{
    if (paramList==nil) {
        adjustMode = AdjustPan;
        thiz = self;
        self.allowFixInputView = TRUE;
        paramList = [[XJson alloc]init];
        self.xtitleBar=  [XTitleBar new];
        [self.xtitleBar setBackColor:(0XFF3978bd)];
        hasShowInputWindow =  false;
        doFisterLoad =  false;
        self.backAnimaction = TRUE;
        callList = [NSMutableArray new];
        [self setCanBack:TRUE];
        self.hasCallBack = false;
        self.hasAppear=false;
    }
}

-(void) setCanBack:(Boolean)can{
    _canBack=can;
    [self.xtitleBar setLeftImageHide:!can];
}
-(void) addWaitMsgView
{
    waitBack = [[[NSBundle mainBundle] loadNibNamed:@"XBaseViewWaitView" owner:nil options:nil] firstObject];
    waitBackBlack = [waitBack viewWithTag:4];
    waitActivity = [waitBack viewWithTag:1];
    waitActMsg = [waitBack viewWithTag:2];
    waitToMsg = [waitBack viewWithTag:3];
    
    //设置圆角边框
    waitBackBlack.layer.cornerRadius = 4;
    waitBackBlack.layer.masksToBounds = YES;
    
    [waitBack setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:waitBack];
    XJson *views = XJsonOfVariableBindings(waitBack);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[waitBack]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[waitBack]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [waitBack addConstraint:[NSLayoutConstraint
                             constraintWithItem:waitBackBlack
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationLessThanOrEqual
                             toItem:waitBack
                             attribute:NSLayoutAttributeWidth
                             multiplier:0.8
                             constant:0]];
    
    waitBack.userInteractionEnabled = YES;
    [waitBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
    
    waitBack.hidden=true;
}
-(void)actionTap:(UITapGestureRecognizer *)recognizer {
    if (!waitToMsg.hidden||waitBack.alpha == 0.0) {
        [self hideWait];
    }
}
+(void)setBaseStyle:(UIStatusBarStyle)style{
    __basestyel=style;

}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return __basestyel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR(0xffffffff);
    self.canMoveBack=true;
    [self setNeedsStatusBarAppearanceUpdate];
    [self addXTitleBar];
    //[self hideXTitleBar];
	
    //UILabel* lable = [UILabel new];
    // lable.backgroundColor = COLOR(0XFF887700);
    // [self setContentView:lable];
    // [self setContentViewNibNamed:@"LaunchScreen"];
    
    //[self _backClickCloseInput];
    
    if (xbaseOnInit) {
        [xbaseOnInit onViewLoad:self];
    }
}

//支持滑动返回

- (BOOL)hasNotNeedDo:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL isRoot =  (self == self.navigationController.viewControllers.firstObject);
    BOOL hasBack =[self.xtitleBar isLeftForBack] && ![self.xtitleBar isHidden];

    return isRoot || !hasBack || !self.canBack;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.canMoveBack || [self hasNotNeedDo:gestureRecognizer]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL g = [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];

    return g;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self onResetView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1) 
    	[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionOld context:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hasAppear=true;
    
    if (self.allowFixInputView) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_wilShowInputWindow:) name: UIKeyboardWillShowNotification object:nil];
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didShowInputWindow:) name: UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_wilHideInputWindow:) name: UIKeyboardWillHideNotification object:nil];
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_wilHideInputWindow:) name: UIKeyboardDidHideNotification object:nil];
    }

    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (!doFisterLoad) {
        [self onFisterLoad];
        doFisterLoad = true;
    }
    
    //百度统计，开启一个页面
    NSString* cName =  NSStringFromClass([self class]);
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}
-(void)onFisterLoad{

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1) 
    	[self.view removeObserver:self forKeyPath:@"frame" context:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.hasAppear=false;
    
    if (self.allowFixInputView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillShowNotification object:nil];
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    //百度统计，关闭一个页面
    NSString* cName =  NSStringFromClass([self class]);
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    
    
    
    //
    // 释放所有关于自己的绑定数据。
    UIViewController  *  pp1  =  self.parentViewController;
    UIViewController  *  pp2  =  self.modalViewController;
    UIViewController  *  pp3  =  self.presentedViewController;
    UIViewController  *  pp4  =  self.presentingViewController;
    
    if (pp1==nil &&
        pp2==nil &&
        pp3==nil &&
        pp4==nil
        )
    {
        [NSObject clearXBingDataForUIContronller:self];
    }
}
-(void)dealloc
{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [NSObject clearXBingDataForUIContronller:self];
}
-(void)setNeedVisibleViewWhenKeyboardShow:(UIView*)view
{
    [self setNeedVisibleViewWhenKeyboardShow: view UpPy:0];
}
-(void)setNeedVisibleViewWhenKeyboardShow:(UIView*)view UpPy:(float)upPy
{
    needVisibleViewWhenKeyboardShow = view ;
    self.needVisibleUpPy =upPy;
}
// Search recursively for first responder
- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}
- (UIScrollView*)findFirstResponderUIScrollView:(UIView*)view
{
    while (view.superview) {
        if([view.superview isKindOfClass:[UIScrollView class]]){
            return view.superview;
        }else{
            view = view.superview;
        }
    }
    return nil;
}
-(float)getVisebleNeedUpPy:(NSNotification *)notification{
    //获取高度，重新布局view，设置view可以上下滑动，并滑出编辑框的焦点，或则滑出设置可见的view。
    float needUpDy = 0;
    if (needVisibleViewWhenKeyboardShow!=nil) {
        needUpDy = [self getVisebleNeedUppY:needVisibleViewWhenKeyboardShow AndHeightADD:(float)self.needVisibleUpPy hasUpPy:needUpDy :notification];
    }
    UIView * firstResponder = [self findFirstResponderBeneathView:self.view];
    
    float dh = 0;//44;
    //为键盘添加一个隐藏按钮
    if ([firstResponder isKindOfClass:[UITextField class]] ) {
        
        __weak UITextField*tv = (UITextField*)firstResponder;
        if (tv.inputAccessoryView==nil) {
            UIView *keyBoardTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,300, 44)];
            
            keyBoardTopView.backgroundColor = [UIColor lightGrayColor];
            
            [keyBoardTopView setOnClick:^{
                
                [tv resignFirstResponder];
                
            }];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(keyBoardTopView.bounds.size.width - 60 - 12, 4, 60, 36)];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            
            
            
            // [keyBoardTopView addSubview:btn];
            // tv.inputAccessoryView = keyBoardTopView;
        }
        //firstResponder.inputAccessoryView==nil;
        
        CGRect keyboardRect1 = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (keyboardRect1.size.height<=tv.inputAccessoryView.frame.size.height) {
            tv.inputAccessoryView.hidden=YES;
        }else{
            tv.inputAccessoryView.hidden=NO;
        }
        
        
        
    }
    
    
    if ([firstResponder isKindOfClass:[UITextView class]] ) {
        UITextView*tv = (UITextView*)firstResponder;
        CGRect keyboardRect1 = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (keyboardRect1.size.height<=tv.inputAccessoryView.frame.size.height) {
            tv.inputAccessoryView.hidden=YES;
        }else{
            tv.inputAccessoryView.hidden=NO;
            
        }
        
    }
    
    
    
    
    needUpDy =  [self getVisebleNeedUppY:firstResponder AndHeightADD:0 hasUpPy:needUpDy + dh :notification];
    
    return needUpDy;
}
-(float)getVisebleNeedUppY:(UIView*)view  AndHeightADD:(float)heightEx  hasUpPy:(float)hasUpPy :(NSNotification *)notification
{
    float needUpDy = hasUpPy;
    if (view) {
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect viewRect=[view convertRect:view.bounds toView:window];
        CGRect keyWindowRect=[[[UIApplication sharedApplication] keyWindow] convertRect:[[UIApplication sharedApplication] keyWindow].bounds toView:window];
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        
        CGRect scrRect = [[UIScreen mainScreen] bounds];
        float viewTopY = viewRect.origin.y;
        float viewBottomY = viewTopY +viewRect.size.height + heightEx;
        float keyWindowTopY = keyWindowRect.origin.y + keyboardRect.origin.y;
        
        //8。0前的版本长宽的位置有问题
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            CGRect beginKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect endKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            if (beginKeyboardRect.origin.y!=endKeyboardRect.origin.y) {
                //viewBottomY = viewRect.origin.y+viewRect.size.height + heightEx;
                //keyWindowTopY = keyWindowRect.origin.y + keyboardRect.origin.y;z
            }else if (beginKeyboardRect.origin.x!=endKeyboardRect.origin.x) {
                CGRect winRect = [window bounds];
                viewTopY = winRect.size.width - viewRect.origin.x - viewRect.size.width;
                viewBottomY =  viewTopY   +   viewRect.size.width  + heightEx;
                keyWindowTopY =(keyWindowRect.origin.x + keyWindowRect.size.width) - endKeyboardRect.size.width - endKeyboardRect.origin.x ;
                
            }
            
        }
        //需要提升
        needUpDy = viewBottomY - keyWindowTopY;
        
        //提升不足时，使用新的
        if (hasUpPy<needUpDy) {
            needUpDy = needUpDy;
        }
        //提升足够，是否过多
        else if(viewTopY - hasUpPy <0){
            needUpDy = viewTopY;
        }
        //足够，且无影响
        else{
            needUpDy = hasUpPy;
        }
       
    }
    return needUpDy;
}
-(void)setToViseble:(float)needUpDy :(NSNotification *)notification animated:(BOOL)animated
{
    //如果没有使用自动布局
    if ([self.view translatesAutoresizingMaskIntoConstraints]) {
        
        if (animated) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                                  delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y-needUpDy)];
                 [self.view layoutIfNeeded];
             } completion:nil];
        }else{
            [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y-needUpDy)];
            [self.view layoutIfNeeded];
        }
    };
}
-(void)_checkShowInputWindow:(NSNotification *)notification animated:(BOOL)animated
{
    float needUpDy = [self getVisebleNeedUpPy:notification];
    

    if (needUpDy!=0) {
        [self setToViseble:needUpDy :notification animated:animated];
    }
    
}
-(void)_resizeView:(NSNotification *)notification Animated:(BOOL)animated{

    //
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect keyWindowRect=[[[UIApplication sharedApplication] keyWindow] convertRect:[[UIApplication sharedApplication] keyWindow].bounds toView:window];
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    CGRect scrRect = [[UIScreen mainScreen] bounds];
    float keyWindowTopY = keyWindowRect.origin.y + keyboardRect.origin.y;
    
    //8。0前的版本长宽的位置有问题
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        CGRect beginKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (beginKeyboardRect.origin.x!=endKeyboardRect.origin.x) {
            CGRect winRect = [window bounds];
            keyWindowTopY =(keyWindowRect.origin.x + keyWindowRect.size.width) - endKeyboardRect.size.width - endKeyboardRect.origin.x ;
        }
    }
    float needUpDy = [self getVisebleNeedUpPy:notification];
    __weak UIScrollView*scrollView=nil;
    if(needUpDy>0){
        scrollView = [self findFirstResponderUIScrollView:needVisibleViewWhenKeyboardShow];
        if(scrollView==nil){
            scrollView = [self findFirstResponderUIScrollView:[self findFirstResponderBeneathView:self.view]];
        }
    }
    
    //获取高度，重新布局view，设置view不可以上下滑动。并将位置滑到最顶部。
    if ( self.view.frame.size.height!=keyWindowTopY) {
        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^
         {
             if(needUpDy>0 && scrollView){
                 [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+needUpDy) animated:false];
             }
             self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, keyWindowTopY);
         } completion:nil];
    }
}
-(void)_wilShowInputWindow:(NSNotification *)notification
{
    hasShowInputWindow = true;
    if(adjustMode == AdjustResize){
         [self _resizeView:notification Animated:TRUE];
    }else{
        [self _checkShowInputWindow:notification animated:TRUE];
    }
    
}
-(void)_didShowInputWindow:(NSNotification *)notification
{
    hasShowInputWindow = true;
    if(adjustMode == AdjustResize){
        [self _resizeView:notification Animated:false];
    }else{
        [self _checkShowInputWindow:notification animated:false];
    }
}

-(void)_wilHideInputWindow:(NSNotification *)notification
{
    hasShowInputWindow =  false;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    //获取高度，重新布局view，设置view不可以上下滑动。并将位置滑到最顶部。
    if ( self.view.frame.origin.y!=0||self.view.frame.size.height!=window.bounds.size.height) {
        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^
         {
             self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, window.bounds.size.height);
         } completion:nil];
    }
    
}
//使用手势会将tableview的点击事件拦截掉。
-(void)_backClickCloseInput
{
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(_backClickCloseInputAction:)]];
}
-(void)_backClickCloseInputAction:(UITapGestureRecognizer *)recognizer {
    //UIView* pView = [[[UIApplication sharedApplication] keyWindow] superview];
    [self hideInput];
}
-(void)hideInput{
    BOOL isVisible =[[UIApplication sharedApplication] keyWindow].hidden==false;
    if (self.hasShowInputWindow || isVisible) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
}
- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
}
- (void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
     BOOL isVisible =[[UIApplication sharedApplication] keyWindow].hidden==false;
    if (self.hasShowInputWindow || isVisible) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}


-(void)showWait
{
	if (waitBack==nil) {
		[self addWaitMsgView];
	}
    [self showWaitMsg:@"加载中..."];
}
-(void)showWaitMsg:(NSString*)msg
{
	if (waitBack==nil) {
		[self addWaitMsgView];
	}
	
    waitActMsg.text=msg;
    waitToMsg.text=nil;
    
    [self showWaitBack];
    [thiz hideInput];
    if (waitActivity.hidden) {
        waitActivity.hidden = NO;
    }
    if (waitActMsg.hidden) {
        waitActMsg.hidden = NO;
    }
    if (!waitToMsg.hidden) {
        waitToMsg.hidden = YES;
    }
    if (![waitActivity isAnimating]) {
        [waitActivity startAnimating];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
}
-(void)showWaitToMsg:(NSString*)msg
{
	if (waitBack==nil) {
		[self addWaitMsgView];
	}
    
    if(msg==nil||msg.length ==0){
        [self hideWait];
        return;
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    
    waitActMsg.text=nil;
    waitToMsg.text=msg;
    
    [self showWaitBack];
    [thiz hideInput];
    if (!waitActivity.hidden) {
        waitActivity.hidden = YES;
    }
    if (!waitActMsg.hidden) {
        waitActMsg.hidden = YES;
    }
    if (waitToMsg.hidden) {
        waitToMsg.hidden = NO;
    }
    
    if ([waitActivity isAnimating]) {
        [waitActivity stopAnimating];
    }
    
}

- (void)showWaitToMsg:(NSString *)msg hideWaitAfterDelay:(CGFloat)Delay
{
    [self showWaitToMsg:msg];
    [self performSelector:@selector(hideWait) withObject:nil afterDelay:Delay];
}

- (void)showWaitToMsg:(NSString *)msg callBackWithAfterDelay:(CGFloat)Delay
{
    [self showWaitToMsg:msg];
    [self performSelector:@selector(callBack) withObject:nil afterDelay:Delay];
}
-(void)showWaitBack{
	if (waitBack==nil) {
		[self addWaitMsgView];
	}
	
    if (waitBack.hidden||waitBack.alpha == 0.0) {
        waitBack.hidden = NO;
        [self.view  bringSubviewToFront:waitBack];
        waitBack.alpha = 0.0;
        UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
            waitBack.alpha = 1.0;
            
        }completion:^(BOOL finish){
            waitBack.alpha = 1.0;
            
        }];
    }
}
-(void)hideWait{
	if (waitBack==nil) {
		[self addWaitMsgView];
	}
	
    if (!waitBack.hidden) {
        self.navigationController.interactivePopGestureRecognizer.enabled=YES;
        waitBack.alpha = 1.0;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            waitBack.alpha = 0.0;
            
        }completion:^(BOOL finish){
            //万一进不来，隐藏不掉就悲剧了吧吧
            waitBack.alpha = 0.0;
            waitBack.hidden = YES;
        }];
        
    }
    
}

-(void)showMsg:(NSString*)msg
{
    if (msg==nil || msg.length==0) {
        return;
    }
    
    runOnUiTread2(^(){
        if (msgLable==nil || msgLableBack==nil) {
            [thiz hideInput];
            msgLableBack = [[UIView alloc]init];
            msgLableBack.backgroundColor = COLOR(0xaa000000);
            msgLableBack.clipsToBounds = true;
            
            //设置圆角边框
            msgLableBack.layer.cornerRadius = 4;
            msgLableBack.layer.masksToBounds = YES;
            
            msgLable = [[UILabel alloc]init];
            msgLable.clipsToBounds = true;
            msgLable.textAlignment = UITextAlignmentCenter;
            msgLable.numberOfLines = 0;
            [msgLable setTextColor:COLOR(0xffffffff)];
            [msgLable setFont:[UIFont systemFontOfSize:PD2PX(16)]];
            msgLable.backgroundColor = COLOR(0x00000000);
            
            [msgLableBack addSubview: msgLable];
            [self.view addSubview: msgLableBack];
            
            
            [msgLable setTranslatesAutoresizingMaskIntoConstraints:NO];
            [msgLableBack setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            
            XJson *views = XJsonOfVariableBindings(msgLableBack,msgLable);
            [msgLableBack addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[msgLable]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
            [msgLableBack addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[msgLable]-(15)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
            
            [self.view addConstraint:[NSLayoutConstraint
                                      constraintWithItem:msgLableBack
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1
                                      constant:0]];
            [self.view addConstraint:[NSLayoutConstraint
                                      constraintWithItem:msgLableBack
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:0.6
                                      constant:0]];
            [self.view addConstraint:[NSLayoutConstraint
                                      constraintWithItem:msgLableBack
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:0.8
                                      constant:0]];
            
        }
        [msgLable setText:msg];
        
        [self.view  bringSubviewToFront:msgLableBack];
        msgLableBack.alpha = 0.0;
        UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^
         {
             msgLableBack.alpha = 1.0;
         } completion:^(BOOL finish){
             msgLableBack.alpha = 1.0;
             [UIView animateWithDuration:0.2 delay:1.2 options:options animations:^{
                 msgLableBack.alpha = 0.0;
             }completion:nil];
         }];
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //[NSObject checkXBingData];
    
}
-(int)getIntKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [[paramList objectForKey:key] intValue];
    }
    return 0;
}
-(long)getLongKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [[paramList objectForKey:key] longValue];
    }
    return 0;
}
-(NSString*)getStringKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return toString([paramList objectForKey:key]);
    }
    return nil;
}
-(XJson*)getJsonKey:(NSString*)key
{
    return (XJson*)[self  getObjectKey:key];
}

/**
 *取不到时，返回false
 */
-(Boolean)getBooleanKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [[paramList objectForKey:key] boolValue];
    }
    return false;
}
-(id)getObjectKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [paramList objectForKey:key];
    }
    return nil;
}
-(void)addInt:(int)value Key:(NSString*)key
{
    if (key) {
        [paramList setObject:[[NSNumber alloc]initWithInt:value] forKey:key];
    }
    
}
-(void)addLong:(long)value Key:(NSString*)key
{
    if (key) {
        [paramList setObject:[[NSNumber alloc]initWithLong:value] forKey:key];
    }
}
-(void)addString:(NSString*)value Key:(NSString*)key
{
    if (value && key) {
        [paramList setObject:value forKey:key];
    }
}
-(void)addBoolean:(Boolean)value Key:(NSString*)key
{
    if (key) {
        [paramList setObject:[[NSNumber alloc]initWithBool:value] forKey:key];
    }
}
-(void)addObject:(id)value Key:(NSString*)key
{
    if (value && key) {
        [paramList setObject:value forKey:key];
    }
}

-(void)addJson:(NSDictionary*)value Key:(NSString*)key
{
    [self addObject: [XJson dictionaryWithDictionary:value] Key:key];
}

-(void)addMuValue:(NSDictionary*)value
{
    [paramList addEntriesFromDictionary:value];
}

-(XJson*)getParam
{
    return paramList;
}
/**
 *
 */

/*
 *获取所在的UIViewController
 */


-(UIViewController*)getUIViewController
{
    return self;
}
-(id<XControllerProtocol>)getPreviousXControllerProtocol
{
    return previousXControllerProtocol;
}
-(void)setPreviousXControllerProtocol:(id<XControllerProtocol>)previous Requset:(int)rcode
{
    previousXControllerProtocol = previous;
    requsetCode = rcode;
}
/*
 *显示一个新页面
 */
-(UIViewController*)showNewControllerIdentifier:(NSString*)newConIdentifier  animated:(BOOL)animated
{
    return [self showNewController:nil Identifier:newConIdentifier RequestCode:0 Param:nil animated:animated];
}
-(UIViewController*)showNewController:(UIViewController*)newCon  animated:(BOOL)animated
{
    return [self showNewController:newCon Identifier:nil RequestCode:0 Param:nil animated:animated];
}
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier RequestCode:(int)rCode Param:(NSDictionary*)param animated:(BOOL)animated
{
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if ([newCon conformsToProtocol:@protocol(XControllerProtocol)]) {
        [(id<XControllerProtocol>)newCon setPreviousXControllerProtocol: self Requset:rCode];
        [(id<XControllerProtocol>)newCon addMuValue:param];
    }
    if (self.navigationController) {
        [self.navigationController pushViewController:newCon animated:animated];
    }
    
    if ([newCon isKindOfClass:[XBaseViewController class]]) {
        ((XBaseViewController*)newCon).hasCallBack = false;
    }
    return newCon;
}


/*
 *显示一个新页面,并且关闭一些页面
 */
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier BackToControllerIdentifier:(NSString*)backToConIdentifier  animated:(BOOL)animated
{
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if (self.navigationController) {
        NSMutableArray * list = [NSMutableArray new];
        
        int count = [[self.navigationController childViewControllers] count];
        for (int i= count-1; i>=0; i--) {
            UIViewController *vc = [[self.navigationController childViewControllers] objectAtIndex:i];
            [list addObject:vc];
            if ([vc.restorationIdentifier isEqualToString:backToConIdentifier]) {
                [self showNewController:newCon  animated:animated];
                for (UIViewController *vc  in list) {
                    [vc removeFromParentViewController];
                }
                break;
            }
        }
        
        
    }
    
    return newCon;
    
}
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier BackToControllerByCount:(int)backCount  animated:(BOOL)animated
{

    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if (self.navigationController) {
        NSMutableArray * list = [NSMutableArray new];
        
        int count = [[self.navigationController childViewControllers] count];
        for (int i= count-1; i>=0 && count - i <= backCount; i--) {
            UIViewController *vc = [[self.navigationController childViewControllers] objectAtIndex:i];
            [list addObject:vc];
        }
        
        
        [self showNewController:newCon  animated:animated];
        
        for (UIViewController *vc  in list) {
            [vc removeFromParentViewController];
        }
        
    }
    
    return newCon;

}
-(UIViewController*)showNewControllerWithBackToTopController:(UIViewController*)newCon :(NSString*)newConIdentifier  animated:(BOOL)animated
{
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if (self.navigationController) {
        NSArray * list = [NSArray arrayWithArray: [ self.navigationController childViewControllers]];
        [self showNewController:newCon  animated:animated];
        //在定部时清空所有数据
        if ([newCon conformsToProtocol:@protocol(XControllerProtocol)]) {
            [(id<XControllerProtocol>)newCon setPreviousXControllerProtocol: nil Requset:0];
        }
        for (UIViewController *vc  in list) {
            [vc removeFromParentViewController];
        }
    }else if([self.presentingViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController*na =(UINavigationController*)self.presentingViewController;
        [na dismissViewControllerAnimated:animated completion:nil];
        [((XBaseViewController*)na.topViewController) showNewControllerWithBackToTopController:newCon :nil animated:NO];
    }else if([self.presentingViewController isKindOfClass:[XBaseViewController class]]){
        XBaseViewController*ba = (XBaseViewController*)self.presentingViewController;
        [ba showNewControllerWithBackToTopController:newCon :nil animated:animated];
    }
    
    return newCon;
}

-(NSString  *) getMeIdentifier
{
    NSString *restorationId = self.restorationIdentifier;
    return restorationId;
}

-(void)doBackData
{
    
    @synchronized(callList) {
        NSMutableArray*callListTemp=[callList mutableCopy];
        [callList removeAllObjects];
        for (OnBackCall* node  in callListTemp) {
            node.call(self,backCode,data,data2);
        }
        
    }
    
    
    if (previousXControllerProtocol && requsetCode>0) {
        [previousXControllerProtocol onBackFromOtherController:self Identifier:[self getMeIdentifier] RequestCode:requsetCode BackCode:backCode Data:data Data2:data2];
    }
    requsetCode = 0;
    backCode = 0;
    data = nil;
    data2 = nil;
    previousXControllerProtocol = nil;
}
-(void)removeFromParentViewController
{
    [super removeFromParentViewController];
}
-(void)willMoveToParentViewController:(UIViewController *)parent
{

    [super willMoveToParentViewController:parent];
}
-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (parent==nil) {
        [self doBackData];
    }
}

/**
 *退出
 */
-(void)back:(BOOL)animated
{
    if (!self.canBack) {
        return;
    }
    //防止循环调用
    if (self.hasCallBack) {
        return;
    }else{
        self.hasCallBack = true;
    }
    
    [self doBackData];
    if (self.navigationController) {
        //[self doBackData];
        if (self.navigationController.topViewController!=self) {
            [self removeFromParentViewController];
        }else{
            [self.navigationController popViewControllerAnimated:animated];
        }
    }else{
        //[self doBackData];
        [self dismissViewControllerAnimated:animated completion:nil];
        
    }
    //[self doBackData];
}
-(void)backToController:(UIViewController*)toc  animated:(BOOL)animated
{
    [self backToController:toc FromC:nil animated:animated];
}
-(void)backToController:(UIViewController*)toc  FromC:(UIViewController*)form animated:(BOOL)animated
{
    if (!self.canBack) {
        return;
    }
    if (self.navigationController && toc) {
        NSArray* arr =[self.navigationController childViewControllers];
        int count = [arr count];
        NSMutableArray*willBackArr = [NSMutableArray new];
        BOOL begin = (form == nil)?YES:NO;
        for (int i= count-1; i>=0; i--) {
            XBaseViewController *vc = [arr objectAtIndex:i];
            
            if (begin&&vc!=toc) {
               [willBackArr addObject:vc];
            }else if(!begin)
            {
                if(form==vc){
                    begin = YES;
                }
            }
            else{
                break;
            }
        }
        count = [willBackArr count];
        for (int i= count-1; i>=0; i--) {
            XBaseViewController *vc = [willBackArr objectAtIndex:i];
            if (i!=count-1) {
                [vc clearAllBackCall];
            }
            if (i==0) {
                [vc back:animated];
            }else{
                [vc back:false];
            }
        }
    }
    
}

//-(void)backToController:(UIViewController*)toc  FromC:(UIViewController*)form animated:(BOOL)animated
//{
//    if (!self.canBack) {
//        return;
//    }
//    if (self.navigationController && toc) {
//        //错误代码，怎么来的？？！！！
//        //[self doBackData];
//        //[self.navigationController popToViewController:c animated:animated];
//        
//        NSArray* arr =[self.navigationController childViewControllers];
//        
//        
//        int count = [arr count];
//        
//        //规避返回多个时，能看到上一个页面的问题。
//        XBaseViewController*first =nil;
//        for (int i= count-1; i>=0; i--) {
//            XBaseViewController *vc = [arr objectAtIndex:i];
//            
//            if (form==nil&&vc!=toc) {
//                if (i== count-1) {
//                    //[vc back:animated];
//                    first= vc;
//                    [first doBackData];
//                }else{
//                    [vc back:false];
//                }
//            }else if(form!=nil)
//            {
//                if(form==vc){
//                    form = nil;
//                }
//            }
//            else{
//                break;
//            }
//        }
//        //
//        if (first) {
//            [first back:animated];
//        }
//        
//    }
//    
//}
-(void)backToControllerByIdentifier:(NSString*)identifier  animated:(BOOL)animated
{
    UIViewController * toCon = nil;
    int count = [[self.navigationController childViewControllers] count];
    for (int i= count-1; i>=0; i--) {
        UIViewController *vc = [[self.navigationController childViewControllers] objectAtIndex:i];
        if ([vc.restorationIdentifier isEqualToString:identifier]) {
            toCon = vc;
            [self backToController:toCon animated:animated];
            break;
        }
    }
}

-(void)backToControllerByBackCount:(int)count  animated:(BOOL)animated
{
    if (self.navigationController && count>0) {
        NSArray* arr =[self.navigationController childViewControllers];
        XBaseViewController *lastC = nil;
        int all = (int)[arr count];
        for (int i= all-1; i>=0; i--) {
            XBaseViewController *vc = [arr objectAtIndex:i];
            if (vc==self) {
                int index =i-count;
                if(index>=0&&index<all){
                    [self backToController:[arr objectAtIndex:index]  FromC:lastC animated:animated];
                }
            }else
            {
                lastC = vc;
            }
        }
    }
}
-(void)backToTopControllerAnimated:(BOOL)animated
{
  [self backToController:[[self.navigationController childViewControllers]objectAtIndex:0]  animated:animated];
}
-(void)clearToTopController{
  [self backToController:[[self.navigationController childViewControllers]objectAtIndex:0]  FromC:self animated:NO];
  [self back:false];
}
//返回时的数据
-(void)setBackCode:(int)bCode Data:(XJson*)d Data2:(id)d2
{
    backCode = bCode;
    data=d;
    data2=d2;
}
-(void)onBackFromOtherController:(UIViewController*)c Identifier:(NSString*)identifier RequestCode:(int)rCode BackCode:(int)bCode Data:(XJson*)data Data2:(id)data2
{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)resetView
{
    runOnUiTread2(^{
        [self onResetView];
    });
}
-(void)onResetView
{
}

/**
 *自动增加titleBar
 *
 */
- (void)hideXTitleBar
{
    [self.xtitleBar hideSysBarAndTitle];
    return;
}
- (void)hideBack
{
    [self.xtitleBar setLeftForBack: FALSE];
}
- (void)showBack
{
    [self.xtitleBar setLeftForBack: TRUE];
}
- (void)addXTitleBar
{
    XTitleBar* titleView =  self.xtitleBar;
    [self.view addSubview:titleView];
    
    //self.view作为第一个view，不能设置MaskIntoConstraints，垃圾的ios。
    //self.view.TranslatesAutoresizingMaskIntoConstraints = NO;
    
    [self.xtitleBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
 //   id<UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
 //   UIView *  titleContentView =titleView.titleLayout;
 //   XJson *views = XJsonOfVariableBindings(titleView,topLayoutGuide,titleContentView);
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleView]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[topLayoutGuide]-0-[titleContentView]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[titleView]-(0@750)-|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
	
	
	
    //    //高度
    //    NSLayoutConstraint* layout =   [NSLayoutConstraint
    //                                    constraintWithItem:titleView
    //                                    attribute:NSLayoutAttributeHeight
    //                                    relatedBy:NSLayoutRelationEqual
    //                                    toItem:nil
    //                                    attribute:NSLayoutAttributeNotAnAttribute
    //                                    multiplier:0
    //                                    constant:50];
    //    [layout setPriority:UILayoutPriorityDefaultHigh];
    //    [self.view addConstraint:layout];
    //
    //    //y位置
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[topLayoutGuide]-0-[titleView]"
    //                                                                      options:[self.topLayoutGuide length]
    //                                                                      metrics:nil
    //                                                                        views:views]];
        //宽度
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:titleView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                  constant:0]];
    //
        //X位置
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:titleView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                  constant:0]];
	
	//Y位置
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:titleView
							  attribute:NSLayoutAttributeTop
							  relatedBy:NSLayoutRelationEqual
							  toItem:self.view
							  attribute:NSLayoutAttributeTop
							  multiplier:1
							  constant:0]];
	//Y2位置
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:titleView.titleLayout
							  attribute:NSLayoutAttributeTop
							  relatedBy:NSLayoutRelationEqual
							  toItem:self.topLayoutGuide
							  attribute:NSLayoutAttributeBottom
							  multiplier:1
							  constant:0]];
    return;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1) {
       contentViewConstraintsView.frame =self.view.frame;
   }
}
-(void)addView:(UIView*)view Eq:(UIView*)eview
{
	[view setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview : view] ;
	
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeHeight
							  relatedBy:NSLayoutRelationEqual
							  toItem:eview
							  attribute:NSLayoutAttributeHeight
							  multiplier:1
							  constant:0]];
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeWidth
							  relatedBy:NSLayoutRelationEqual
							  toItem:eview
							  attribute:NSLayoutAttributeWidth
							  multiplier:1
							  constant:0]];
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeCenterX
							  relatedBy:NSLayoutRelationEqual
							  toItem:eview
							  attribute:NSLayoutAttributeCenterX
							  multiplier:1
							  constant:0]];
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeCenterY
							  relatedBy:NSLayoutRelationEqual
							  toItem:eview
							  attribute:NSLayoutAttributeCenterY
							  multiplier:1
							  constant:0]];
}
-(void)callBack
{
    [self back:_backAnimaction];
}
-(void)addOnBackCall:(void(^)(XBaseViewController* c ,int backCode,XJson*data, id data2)) call
{
    @synchronized(callList) {
        OnBackCall* node = [OnBackCall new];
        node.call=call;
        [callList addObject:node];
    }
}
-(void)clearAllBackCall{
    @synchronized(callList) {
        [callList removeAllObjects];
    }
    requsetCode = 0;
    backCode = 0;
    data = nil;
    data2 = nil;
    previousXControllerProtocol = nil;
    [self setCanBack:YES];
}
//清空返回回调接口数据
-(void)removeBackCall:(int)count{
    
    if (self.navigationController && count>0) {
        NSArray* arr =[self.navigationController childViewControllers];
        
        int all = (int)[arr count];
        BOOL needClear=false;
        for (int i= all-1; i>=0&&count>0; i--) {
            XBaseViewController *vc = [arr objectAtIndex:i];
            if (vc==self) {
                needClear = true;
            }
            if (needClear) {
                [vc clearAllBackCall];
                count--;
            }
        }
    }
}

-(void)HideMaskView:(UITapGestureRecognizer*)tg
{
    [tg.view removeFromSuperview];
}
-(void)showMaskView:(UIView*)maskview   FixedView:(UIView*)fixview ToCenterView:(UIView*)toCenterView DX:(float)dx DY:(float)dy
{
    [maskview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addView:maskview];
    if (fixview && toCenterView) {
        [fixview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [toCenterView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view removeConstraintsFirstItem:fixview firstAttribute:NSLayoutAttributeCenterX];
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:fixview
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:toCenterView
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1
                                  constant:dx]];
        
        [self.view removeConstraintsFirstItem:fixview firstAttribute:NSLayoutAttributeCenterY];
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:fixview
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:toCenterView
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1
                                  constant:dy]];
    }
    [maskview setOnClickTarget:self action:@selector(HideMaskView:)];
}
-(void)addView:(UIView*)view
{
	[view setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview : view] ;
	
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeBottom
							  relatedBy:NSLayoutRelationEqual
							  toItem:self.view
							  attribute:NSLayoutAttributeBottom
							  multiplier:1
							  constant:0]];
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeWidth
							  relatedBy:NSLayoutRelationEqual
							  toItem:self.view
							  attribute:NSLayoutAttributeWidth
							  multiplier:1
							  constant:0]];
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeCenterX
							  relatedBy:NSLayoutRelationEqual
							  toItem:self.view
							  attribute:NSLayoutAttributeCenterX
							  multiplier:1
							  constant:0]];
	[self.view addConstraint:[NSLayoutConstraint
							  constraintWithItem:view
							  attribute:NSLayoutAttributeTop
							  relatedBy:NSLayoutRelationEqual
							  toItem:self.topLayoutGuide
							  attribute:NSLayoutAttributeBottom
							  multiplier:1
							  constant:0]];
}
/**
 *自动设置contentView的约束，适应全屏幕
 *
 */
- (void)setContentView:(UIView*)view
{
    [self addContentView:view];
}

-(void)addContentView:(UIView*)view{
    //IOS8.0以前，如果将内容的宽度使用约束适应self.view的宽度，返回本controller布局时，将会使self.view的宽度变动，是个BUG。
    //解决方案规避使用self.view的宽度。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1) {
        contentViewConstraintsView = [UIView new];
        contentViewConstraintsView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 10);
        [self.view addSubview:contentViewConstraintsView];
        contentViewConstraintsView.hidden=YES;
    }else{
        contentViewConstraintsView = self.view;
    }
    
    
    
    [self.view addSubview:view];
    
    
    
    if (view!=nil) {
        
        //float bHeight =self.bottomLayoutGuide.length;
        
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        XJson *views =  @{@"contentView":view,
                          @"super":contentViewConstraintsView,
                          @"bottomLayoutGuide":self.bottomLayoutGuide,
                          @"xtitleBar":self.xtitleBar};
        //        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[contentView]-(0)-|"
        //                                                                          options:0
        //                                                                          metrics:nil
        //                                                                            views:views]];
        
        //宽度
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:view
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:contentViewConstraintsView
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                  constant:0]];
        
        //X位置
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:contentViewConstraintsView
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1
                                  constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                   @"V:[xtitleBar]-0-[contentView]-0-[bottomLayoutGuide]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        
    }
}
- (id)setContentViewNibNamed:(NSString*)nibName Index:(int)index
{
    UIView* view =[[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:index];
    [self setContentView:view];
    return view;
}

- (id)setContentViewNibNamed:(NSString*)nibName
{
    return [self setContentViewNibNamed:nibName Index:0];
}


- (id)setContentViewInXScrollViewNibNamed:(NSString*)nibName
{
    return [self setContentViewInXScrollViewNibNamed:nibName Index:0 ];
}
- (id)setContentViewInXScrollViewNibNamed:(NSString*)nibName Index:(int)index
{
    UIView* view =[[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:index];
    [self setContentViewInXScrollView:view];
    return view;
}
- (void)setContentViewInXScrollView:(UIView*)view
{
    
    self.xscrollView =[XScrollView new];
    [self setContentView:self.xscrollView];
    [self.xscrollView setContentView:view];
    
    self.xscrollView.backgroundColor = view.backgroundColor;
    [self.xscrollView setOnClickTarget:self action:@selector(_backClickCloseInputAction:)];

}

- (id)setContentViewWithXTableView
{
    self.xtableView = [XTableView new];
    //self.xtableView.dataSource = self;
    [self setContentView:self.xtableView];
    return self.xtableView;
}

- (NSString*) getLastIdStr{
    return nil;
}
//每组的个数[必须]
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
//每个item的view[必须]
- (UITableViewCell *)tableView:(XTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XTableViewCell new];
}



-(PageLoading*)loadingView{
    if(tmpLoadingView==nil){
        [self setLoadingView:[PageLoading new]];
    }
    return tmpLoadingView;
}

-(void)setLoadingView:(PageLoading *)lView
{
    tmpLoadingView = lView;
    [tmpLoadingView.errButton setOnClickTarget:self action:@selector(onClickLoading)];
}

-(void)__addPageLoading{
    if(self.loadingView.superview==nil){
        [self addContentView:self.loadingView];
    }
}
//
-(void)showLoading{
    [self __addPageLoading];
    [self.loadingView showLoading];
}
-(void)showLoadingErr{
    //如果没有显示过就不用添加显示
    //[self __addPageLoading];
    
    [self.loadingView showErr];
}
-(void)hideLoading{
    [self.loadingView removeFromSuperview];
}
-(void)onClickLoading{
    
}
@end
