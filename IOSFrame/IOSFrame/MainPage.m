//
//  MainPage.m
//  Banker
//
//  Created by zhangxiuquan on 15/7/24.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "MainPage.h"
#import "XScrollPageView.h"
#import "ViewFactory.h"
#import "ViewStytle.h"
#import "MainView.h"
#import "MyView.h"
#import "Icon.h"
#import "XNAViewController.h"
@interface MainPage ()
{
    XScrollPageView* sPageView;
    UIView*page[4];
    LCImage*itemImage[4];
    LCLabel*itemTitle[4];
 
    NSTimer *timer;

    BOOL canRefreshPerInfo;
    NSTimeInterval lastDate;
    //    NewPageView*    newPageView ;
    
    //
    BOOL hasCheckWeiXin;
    BOOL hasCheckVersion;
    
}
@end


NSString *itemImagePathNomor[]={@"tab_1",@"tab_2",@"tab_3"};
NSString *itemImagePathSelect[]={@"tab_1y",@"tab_2y",@"tab_3y",};
NSString *itemTitleStr[]={@"工作台",@"进件",@"我的"};
NSString *itemIconStr[]={ICON_shouye2,ICON_shouyelicai,ICON_qianbao,ICON_wode};
NSString *itemIconStrSelect[]={ICON_shouye2,ICON_shouyelicai,ICON_qianbao,ICON_wode};
@implementation MainPage
- (UIStatusBarStyle) preferredStatusBarStyle {
  
 
    return UIStatusBarStyleLightContent;
 
}
-(void)onBackFromOtherController:(UIViewController *)c Identifier:(NSString *)identifier RequestCode:(int)rCode BackCode:(int)bCode Data:(XJson *)data Data2:(id)data2
{
    [(id)[sPageView getPageView:[sPageView getPageIndex]] onBackFromOtherController:c
                                                                         Identifier:identifier
                                                                        RequestCode:rCode
                                                                           BackCode:bCode
                                                                               Data:data
                                                                              Data2:data2];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    canRefreshPerInfo=YES;
    [self.xtitleBar hideTitle];
    [self.view setWH:self.xtitleBar MultW:0 MultH:0 DW:0 DH:0.01];
    [self.view setBackgroundColor:COLOR(Color_PageBack)];
    [self.view setBackgroundColor:COLOR(0xffffffff)];
    LinearLayout * mainLayout =[LinearLayout newVertical];
    sPageView =[XScrollPageView new];
    [sPageView setCanScroll:NO];
    LFLinearLayout * manuBar =[LFLinearLayout newHorizontal];
 
    [mainLayout addView:[LinearLayoutCell newWithView:sPageView
                                           MarginLeft:0
                                            MarginTop:0
                                         MarginBottom:0
                                          MarginRight:0
                                            UseWeight:TRUE
                                               Weight:1]];
    [manuBar setHeight:48];
    [[manuBar getLinearLayout] setGravity:GravityMiddleV];
   
    LFLinearLayout * menuLay =[LFLinearLayout newVertical];
    [menuLay setHeight:WrapContent];
    [menuLay setBackColor:0XFFffffff];
    [mainLayout addView:menuLay];
    [menuLay addView:[ViewStytle createLineV]];
    [menuLay addView:manuBar];
    
    
    [self setContentView:mainLayout];
    
    //0
    MainView*main = [MainView new];
    [sPageView addPageView:main];
    [main onDidLoadView:self];
    [manuBar addView: [self getMenuItem:0]];
    
    
    //1
 
     MainView*jinjian = [MainView new];
    [sPageView addPageView:jinjian];
     [jinjian onDidLoadView:self];
    [manuBar addView: [self getMenuItem:1]];
    
    //2
    MainView*person= [MainView new];
    [sPageView addPageView:person];
    [person onDidLoadView:self];

    [manuBar addView: [self getMenuItem:2]];
    

    
    [sPageView hidePageIndexView];

    __weak MainPage* me = self;
    [sPageView setOnPageChange:^(int index) {
        [me onPageChange:index];
    }];
    
    
     [self onClickMenuItem:0];
    
 
}
-(void)showLockIfNeed
{
 
}

-(void)onPageChange:(int)index{
 
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)onClickMenuItem:(int)index{
    
    for (int i=0; i<4; i++) {
        if (index==i) {
            
            [itemImage[i] setUrl: itemImagePathSelect[i]];
            [itemTitle[i] setFontColor:0xffd43d3d];
            
        }else{
            [itemImage[i] setUrl:itemImagePathNomor[i]];
            [itemTitle[i] setFontColor:0xFF79818C];
        }
    }
    
    [sPageView changeToPage:index];
 
}
-(LinearLayoutCell*)getMenuItem:(int)index{
    LFLinearLayout * menutem =[LFLinearLayout newVertical];
    LCImage *image = [LCImage newWithUrl:itemImagePathNomor[index] Width:30 Height:30];
    //[image setBackColor:0xff123131];
    LCLabel*title=[LCLabel newWithText:itemTitleStr[index] FontSize:10 FontColor:0xff333333];
    [title setWidth:WrapContent];
    //[image setHeight:30];
    [image setPBottom:2];
    [image setWidth:WrapContent];
    //[[image getLabel]setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [menutem addView:image];
    [menutem addView:title];
    [menutem setHeight:WrapContent];
    [menutem setUse:TRUE Weight:1];
    [[menutem getLinearLayout] setGravity:GravityMiddleH_MiddleV];
    itemImage[index]=image;
    itemTitle[index]=title;
     __weak MainPage* me = self;
    [[menutem getBackView] setOnClick:^{
        [me onClickMenuItem:index];
    }];
    
    
    return menutem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
