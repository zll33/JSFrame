//
//  XNAViewController.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/18.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBaseViewController.h"
@interface XNAViewController : UINavigationController
+(UIViewController*)showNewControllerWithBackToTopController:(UIViewController*)newCon :(NSString*)newConIdentifier  animated:(BOOL)animated;
+(XBaseViewController*)getTopController;
@end
