//
//  XAction.h
//  Banker
//
//  Created by zhangxiuquan on 15/7/30.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^XActionCallBack)(NSString* act,id date,int code);
typedef void (^XActionDoAct)(id owner,XActionCallBack calback,NSString* act,id data,int code);


@interface XAction : NSObject
//owner 会被弱引用，如果消失则释放
+(void)addAction:(NSString*)act Owner:(id)owner DoAct:(XActionDoAct)bolck;
+(void)callAction:(NSString*)act CalkBack:(XActionCallBack)callBack Data:(id)data Code:(int)code;
+(void)removeAction:(NSString*)act Owner:(id)owner;
@end
