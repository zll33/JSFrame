//
//  AppDelegate.m
//  p2p
//
//  Created by kzd on 14-11-17.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "XUserManager.h"
#import "HelpApi.h"
#import "XHeader.h"
#import "Reachability.h"
#import "XUserManager.h"
#import "SQLiteKeyValue.h"
#import "Splash.h"

#import <objc/objc.h>



#define  win self.window
//[[UIApplication sharedApplication].keyWindow

@interface AppDelegate ()
{
 
    long backTime;
    BOOL mayLock;
    //
 
}
@property (strong, nonatomic) Reachability *internetReachability;
@property (strong, nonatomic) UILabel *msgLable;
@property (strong, nonatomic) UIView *msgLableBack;
@end

@implementation AppDelegate
@synthesize  internetReachability;
@synthesize  msgLable;
@synthesize  msgLableBack;


- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:
                // 没有网络连接
                [self showMsg:@"网络连接已断开"];
                break;
            case ReachableViaWWAN:
                // 使用3G网络
                [self showMsg:@"当前正在使用移动网络"];
                [XAction callAction:@"hascontect" CalkBack:nil Data:nil Code:0];
                 
                break;
            case ReachableViaWiFi:
                // 使用WiFi网络
                [self showMsg:@"当前正在使用WiFi网络"];
                [XAction callAction:@"hascontect" CalkBack:nil Data:nil Code:1];
                
                break;
                
        }
        
    }
    
}


-(void)addNetChangNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:internetReachability];
}
-(void)removeNetChangNotify
{
    [self.internetReachability stopNotifier];
    self.internetReachability = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

-(void)showMsg:(NSString*)msg
{
    if (msg==nil || msg.length==0) {
        return;
    }
    
    runOnUiTread2(^(){
        if (msgLable==nil || msgLableBack==nil) {
            
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
            [win addSubview: msgLableBack];
            
            
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
            
            [win  addConstraint:[NSLayoutConstraint
                                 constraintWithItem:msgLableBack
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:win
                                 attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                 constant:0]];
            [win  addConstraint:[NSLayoutConstraint
                                 constraintWithItem:msgLableBack
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:win
                                 attribute:NSLayoutAttributeCenterY
                                 multiplier:0.6
                                 constant:0]];
            [win  addConstraint:[NSLayoutConstraint
                                 constraintWithItem:msgLableBack
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                 toItem:win
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:0.8
                                 constant:0]];
            
        }
        [msgLable setText:msg];
        
        [win   bringSubviewToFront:msgLableBack];
        msgLableBack.alpha = 0.0;
        UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^
         {
             msgLableBack.alpha = 1.0;
         } completion:^(BOOL finish){
             msgLableBack.alpha = 1.0;
             [UIView animateWithDuration:0.2 delay:1.5 options:options animations:^{
                 msgLableBack.alpha = 0.0;
             }completion:nil];
         }];
        
    });
    
}


-(void)initQQ{
    
}

//向微信注册
-(void)initWeiXin{
    
}
/*
 -(void)initWeiBo{
 [WeiboSDK enableDebugMode:NO];
 [WeiboSDK registerApp:@"1973838487"];
 }
 */
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

-(void)initBaiduLocation{
    
 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self addNetChangNotify];
    
    startBaiduTongji(nil,nil);
    
    //webview的缓存
    //[NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    //[XProtocol readData];
    
    [self initQQ];
    [self initWeiXin];
    // [self initWeiBo];
    [self initBaiduLocation];
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
  
    return YES;
}


//暂停、来电 锁屏
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    mayLock = true;
    
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
-(UIViewController *)appTopViewController
{
    UIViewController* top =  self.window.rootViewController ;
    UIViewController* temp=top;
    while (temp) {
        temp = [[temp childViewControllers] lastObject];
        if (temp) {
            top = temp;
        }
    }
    return top;
}
-(void)showLock{
    
    
  
    
}
//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    backTime = [NSProcessInfo processInfo].systemUptime;
}
//进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //
    [XAction callAction:@"applicationWillEnterForeground" CalkBack:nil Data:nil Code:0];
    
    //如果是锁屏立即弹出
    if (mayLock) {
        mayLock=false;
        [self showLock];
        return;
    }
    
    //后台进入大于5分钟
    long now = [NSProcessInfo processInfo].systemUptime;
    if (now - backTime>300) {
        [self showLock];
        return;
    }
    
}

//
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self removeNetChangNotify];
}


@end

