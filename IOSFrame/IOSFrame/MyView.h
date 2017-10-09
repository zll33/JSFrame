//
//  MyView.h
//  redStar
//
//  Created by zhangxiuquan on 15/10/26.
//  Copyright © 2015年 zhangxiuquan. All rights reserved.
//

#import "XBaseViewController.h"
#import "XHeader.h"
#import "Icon.h"
#import "AppDelegate.h"
#define STATUSBARH [[UIApplication sharedApplication] statusBarFrame].size.height//状态栏高度

#define Color_BlueBack 0xff0889C4
#define Color_BlueBack_Press 0xff0a8fda
#define Color_BlueBack_2 0xff5dc8f9
#define Color_RedBack 0xffcc0927
#define Color_Title_Back 0xffd4584c
#define Color_Line  0XFFE1E1E1
#define Color_PageBack  0xFFF6F6F6  /*0XFFF4F3F1*/
#define Color_MoneyYellow  0xffFB8727

#define Color_Yellow  0xffFB8727
#define Color_Green  0xff46C346
#define Color_Red 0xffC80004
#define Color_Blue 0xff178CE3
#define Color_White 0xffffffff


#define Color_ButtonNormal 0xFF1e76dd
#define Color_ButtonPress 0xFF1e76dd
#define Color_ButtonUnabel 0xffC6CACF

#define NavgationBarStyel UIStatusBarStyleLightContent

#define Value_Title_FontSize 18
#define showMsg(msg)      [((AppDelegate*)[UIApplication sharedApplication].delegate) showMsg:(msg)]
//#define Environment  @"https://test.maobank.com/api"
//#define Environment  @"http://test.maobank.com/api"
//#define Environment  @"http://uat.maobank.com/api"

#define PagePaddingLR 15
#define DengluPadding 20
//nslog输出行数
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d  \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )


@interface InputItem : LFLinearLayout
@property  (nonatomic) LinearLayoutCell*iconCell;
@property  (nonatomic) UILabel*icon;
@property  (nonatomic) UITextField*input;
-(void)setIconSize:(float)size Color:(int)color Width:(float)width;
-(void)setForDone;
@end

@interface AgreeItem : LCLinearLayout
@property LFImage *icon;
@property LFLabel *title;
@property LFLabel *agree1;
@property LFLabel *agree2;

@property(nonatomic)BOOL isAgree;
+(AgreeItem*)newWith:(XBaseViewController*)c Title:(NSString*)title Agree1:(NSString*)agree1 Onclick1:(void(^)(void))c1 Agree2:(NSString*)agree2 Onclick2:(void(^)(void))c2;
@end

@interface MyView : NSObject
+(InputItem*)createInputItem:(NSString*)icon Msg:(NSString*)msg Hit:(NSString*)hit;
+(InputItem*)createInputItem:(NSString*)icon Msg:(NSString*)msg Hit:(NSString*)hit OnClick:(void(^)(void))click;
+(LCMoreItem*)createItemIcon:(NSString*)icon Title:(NSString*)title Msg:(NSString*)msg HasRight:(BOOL) hasRight  Target:(id)target Sel:(SEL) sel;
+(AgreeItem*)createAgree:(XBaseViewController*)c Msg:(NSString*)msg Url:(NSString*)url;
+(AgreeItem*)createAgree:(XBaseViewController*)c Msg1:(NSString*)msg1 Onclick1:(void(^)(void))c1 Msg2:(NSString*)msg2 Onclick2:(void(^)(void))c2;
@end

@interface ViewStytle(Style)
+(LCMoreItem*)createMoreItem:(NSString*)title Msg:(NSString*)msg Icon:(NSString*) leftImage HasRight:(BOOL) hasRight  Target:(id)target Sel:(SEL)action;
@end

//创建通用的按钮
LCLabel* createButton(NSString*title,id target,SEL action);
/*
 *根据银行id获取银行图标path
 */
NSString*getBankIcon(int bankid);

@interface DownTask(BankInfo)

-(NSString*)getBankInfoOrErr;
@end

//
UIImageView*createToRight();
LinearLayoutCell*createToRightCell();


BOOL isAllNumber(NSString* number);
BOOL isPassword2(NSString* password);
BOOL isIdCardNumber(NSString *value);
BOOL isMobileNumber(NSString *mobileNum);

@interface  XTableView(Style)

@end
