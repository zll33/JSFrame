//
//  AppDelegate.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHeader.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(XJson*)getLocation;
-(void)showLock;
-(void)showMsg:(NSString*)msg;
-(UIViewController *)appRootViewController;
-(UIViewController *)appTopViewController;
@end

