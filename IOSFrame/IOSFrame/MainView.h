//
//  MainViewController.h
//  redStar
//
//  Created by zhangxiuquan on 15/10/19.
//  Copyright © 2015年 zhangxiuquan. All rights reserved.
//

#import "XHeader.h"
@interface MainView: LinearLayout
-(void)onDidLoadView:(XBaseViewController*)c;
-(void)onBackFromOtherController:(UIViewController *)c Identifier:(NSString *)identifier RequestCode:(int)rCode BackCode:(int)bCode Data:(XJson *)data Data2:(id)data2;
@end
