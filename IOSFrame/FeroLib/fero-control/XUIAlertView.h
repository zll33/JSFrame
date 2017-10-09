//
//  XUIAlertView.h
//  moi
//
//  Created by zhangxiuquan on 16/7/7.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUIAlertView : UIAlertView


+(XUIAlertView*)newWithTitle:(NSString*)title Msg:(NSString*)msg Cancel:(NSString*)cancel Yes:(NSString*)yes Target:(id)target action:(SEL)action;
+(XUIAlertView*)newWithTitle:(NSString*)title Msg:(NSString*)msg Cancel:(NSString*)cancel Yes:(NSString*)yes Action:(void(^)(void))onyes;
@end
