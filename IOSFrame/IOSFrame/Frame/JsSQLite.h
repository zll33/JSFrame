//
//  JsSQLite.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsSQLite : NSObject
+(BOOL)saveKey:(NSString*)key Value:(NSString*)value AppKey:(NSString*)appkey;
+(NSString*)getValueKey:(NSString*)key AppKey:(NSString*)appkey;
+(BOOL)removeKey:(NSString*)key AppKey:(NSString*)appkey;
@end
