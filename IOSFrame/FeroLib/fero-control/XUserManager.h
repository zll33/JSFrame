//
//  XUserManager.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/12.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJson.h"

@interface XUserManager : NSObject
+(NSObject*)getLock;
+(Boolean)isDefaultUserLogin;
+(NSString*)getDefaultName;
+(NSString*)getDefaultUserIdAuth;
+(void)saveDefaultUser:(XJson*)userJson;
+(XJson*)getDefaultUser;
+(NSString*)getDefaultUserUUID;
+(void)cleanDefaultUserLogin;
+(void)cleanDefaultUserLoginToLoginPage;
+(void)cleanDefaultUserLoginToLoginPageWithMsg:(NSString*)msg;
@end
