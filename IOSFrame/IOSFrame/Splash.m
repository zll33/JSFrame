//
//  Splash.m
//  p2p
//
//  Created by zhangxiuquan on 15/5/20.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "Splash.h"
#import "XHeader.h"
#import "AppDelegate.h"
#import "XNAViewController.h"
#import "MainPage.h"
#import "UIImage+GIF.h"
#import "JsLoader.h"
#import "JsRunner.h"
#import "Frame.h"

@interface Splash ()
{
    UIView*lay;
    UIImageView *backword;
    UIImageView *backcircle;
    UIImageView *flower;
    NSInteger *flag;
    
    
    Frame*fame;
    JsLoader*jsLoader;
    
    //
    UIView*mainView;
    //
    BOOL hasActNetwork;
}
@property(nonatomic)JsRunner* jsRunner;
@property(nonatomic)NSString* mainJs;
@end

@implementation Splash
@synthesize jsRunner;
@synthesize mainJs;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated{
 
    flag=0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR(0XFF333333)];
    
    //[self hideXTitleBar];
    [self.xtitleBar hideTitle];
  
    
    [self createMainView];
    
    
   
   // [self performSelector:@selector(finishAnimation) withObject:nil afterDelay:3];
    
}

-(void)finishAnimation{
    
  [self showNewControllerWithBackToTopController:[MainPage new]  :nil animated:NO ];
  
}
-(void)createMainView
{
    //
    mainView = [UIView new];
    [mainView setFrame:CGRectMake(0, 40, SCRW, SCRH-100)];
    //[self.view addSubview:mainView];
    [self setContentView:mainView];
 
   
    
    //self setContentView:
    //self.view.translatesAutoresizingMaskIntoConstraints=YES;
    
    //创建js接口对象
    jsRunner = [JsRunner new];
    fame = [Frame new];
    jsLoader = [JsLoader new];
    [jsLoader setBaseUrl:@"http://www.zhangxiuquan.com/html_xview/"];
    [fame setMainLay:mainView];
    [fame setJsLoader:jsLoader];
    [fame setJsRunner:jsRunner];
    
    [jsRunner addObject:fame Name:@"Frame"];

    //
    __weak Frame * tmp = fame;
    [mainView setOnFrameChange:^(UIView *view, CGRect oldRect, CGRect newRect) {
        [tmp callChange];
    }];
    //等待有网络
    hasActNetwork = false;
    [self loadMainJs];
    
    
    [self.view setOnClickTarget:self action:@selector(tete)];
}
-(void)tete{
    
}
-(void)waitWifi{
    if(hasActNetwork){
        hasActNetwork = true;
        [XAction addAction:@"hascontect" Owner:self DoAct:^(id owner, XActionCallBack calback, NSString *act, id data, int code) {
            [self loadMainJs];
        }];
    }
 
}
-(void)loadMainJs{
    WS(weakSelf);
    if(weakSelf.mainJs){
        return;
    }
    [jsLoader addPath:@"my_app.js"];
    [jsLoader startLoading:^(NSString *path, NSString *js, BOOL isEnd) {
        if(js!=nil){
            weakSelf.mainJs = js;
        }
        if(isEnd){
            runOnUiTread2(^{
                if(weakSelf.mainJs){
                    [weakSelf.jsRunner loadJs:weakSelf.mainJs :@"my_app.js"];
                }else{
                    [weakSelf waitWifi];
                }
            });
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
