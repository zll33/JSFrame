//
//  MainViewController.m
//  redStar
//
//  Created by zhangxiuquan on 15/10/19.
//  Copyright © 2015年 zhangxiuquan. All rights reserved.
//

#import "MainView.h"
#import "XHeader.h"
#import "ViewStytle.h"
#import <math.h>
#import "Icon.h"
#import "MyView.h"



@interface MainView ()
{
    LCImage *title;
 
    XJsonArray*picUrls;
    XJsonArray*loanList;
    
    LinearLayoutCell* mainCell;
    LinearLayoutCell* waitCell;
    LinearLayoutCell* errCell;
    UIActivityIndicatorView* activityIndicatorView;
}
@end

@implementation MainView
-(void)onBackFromOtherController:(UIViewController *)c Identifier:(NSString *)identifier RequestCode:(int)rCode BackCode:(int)bCode Data:(XJson *)data Data2:(id)data2
{

}
-(void)onDidLoadView:(XBaseViewController*)c{
    title = [LCImage newWithUrl:@"login_logo" Width:MatchPatrent Height:68];
  
    
    [self addView:title];
    [self addView:[ViewStytle createLineV]];
    
    
    
   // [self addView:[ViewStytle createMoreButton:@"测试" :0xff888888 :0xff666666 :self :@selector(shooo)]];
}


@end
