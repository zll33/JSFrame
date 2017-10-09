//
//  XObjectEx.h
//  p2p
//
//  Created by zhangxiuquan on 15/2/6.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XObjectEx : NSObject

@end

@interface NSObject(XBingData)
-(int)getXBingDataInt:(NSString*)key Fail:(int) back;
-(BOOL)getXBingDataBOOL:(NSString*)key Fail:(BOOL) back;
-(long)getXBingDataLong:(NSString*)key Fail:(long) back;
-(double)getXBingDataDouble:(NSString*)key Fail:(double) back;
-(NSString*)getXBingDataString:(NSString*)key;
-(id)getXBingDataObject:(NSString*)key;
-(void)putXBingDataInt:(NSString*)key :(int)value;
-(void)putXBingDataBOOL:(NSString*)key :(BOOL)value;
-(void)putXBingDataLong:(NSString*)key :(long)value;
-(void)putXBingDataDouble:(NSString*)key :(double)value;
-(void)putXBingDataString:(NSString*)key :(NSString*)value;
-(void)putXBingDataObject:(NSString*)key :(id)value;

-(BOOL)isHasXBingDataKey:(NSString*)key;
//清楚失效的数据
+(void)checkXBingData;
//当UIContronller被卸载后，清楚UIContronller内部所有view的绑定数据。
+(void)clearXBingDataForUIContronller:(UIViewController*)con;

@end
