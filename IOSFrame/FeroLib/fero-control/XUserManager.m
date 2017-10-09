//
//  XUserManager.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/12.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XUserManager.h"
#import "SQLiteKeyValue.h"
#import "HelpApi.h"
#import "XAction.h"
NSObject*XUserManager_Lock;
XJson* XUserManager_user;
@interface XUserManager()

@end

@implementation XUserManager
+(NSObject*)getLock{
    if (XUserManager_Lock==nil) {
        XUserManager_Lock = [NSObject new];
    }
    return XUserManager_Lock;
}
+(void)saveDefaultUser:(XJson*)userJson
{
    @synchronized([self getLock]){
        XUserManager_user = userJson;
        [SQLiteKeyValue saveJsonKey:@"XDefaultUser" Value:userJson];
    }
}
+(XJson*)getDefaultUser
{
     @synchronized([self getLock]){
         if (XUserManager_user==nil) {
            XUserManager_user=[SQLiteKeyValue getJsonWithKey:@"XDefaultUser"];
        }
         return [XUserManager_user mutableCopy];
     }
}

+(Boolean)isDefaultUserLogin
{
     @synchronized([self getLock]){
         return [self getDefaultUserIdAuth]!=nil;
     }
}
+(NSString*)getDefaultName
{
    @synchronized([self getLock]){
        return [[self  getDefaultUser] objectForKey:@"loginAccount"];
    }
}
+(NSString*)getDefaultUserIdAuth
{
    @synchronized([self getLock]){
        return [[self  getDefaultUser] objectForKey:@"identity"];
    }
}

+(NSString*)getDefaultUserUUID
{
    @synchronized([self getLock]){
        return [[self  getDefaultUser] objectForKey:@"uuid"];
    }
}
+(void)cleanDefaultUserLogin{
    @synchronized([self getLock]){
        NSString* userName =[self getDefaultName];
        if (userName) {
            XJson* user = [[XJson alloc]initWithObjectsAndKeys:userName,    @"loginAccount",nil];
            [self saveDefaultUser:user];
        }
    }
    
}

+(void)cleanDefaultUserLoginToLoginPage
{
    [self cleanDefaultUserLoginToLoginPageWithMsg:nil];
}
+(void)cleanDefaultUserLoginToLoginPageWithMsg:(NSString*)msg
{
    runOnUiTread2(^{
        [self cleanDefaultUserLogin];
        
    });
    
}
@end
