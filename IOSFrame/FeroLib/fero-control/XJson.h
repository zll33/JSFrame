//
//  XJson.h
//  p2p
//
//  Created by zhangxiuquan on 15/2/3.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSMutableArray XJsonArray;
typedef NSMutableDictionary XJson;
@interface NSMutableArray(XJsonArray)
-(NSString*)toJString;
-(NSData*)toJData;
+(XJsonArray*) newJArrWithString:(NSString*)str;
@end
@interface NSMutableDictionary(XJson)

+(XJson*) newWithNSDictionary:(NSDictionary*)nsdictionary;
+(XJson*) newWithString:(NSString*)str;
+(XJson*) newWithData:(NSDate*)data;
+(BOOL)  isXJson:(id)ojson;

//对比json内容
-(BOOL) isIncludChild:(XJson*)child;
-(void) putFloat:(NSString*)key Value:(float)value;
-(void) putDouble:(NSString*)key Value:(double)value;
-(void) putBoolean:(NSString*)key Value:(BOOL)value;
-(void) putLong:(NSString*)key Value:(long)value;
-(void) putInt:(NSString*)key Value:(int)value;
-(void) putString:(NSString*)key Value:(NSString*)value;;
-(void) putJSON:(NSString*)key Value:(XJson*)value;;
-(void) putJSONArray:(NSString*)key Value:(NSArray*)value;;


-(float) getFloat:(NSString*)key;
-(double) getDouble:(NSString*)key;
-(BOOL) getBoolean:(NSString*)key;
-(long long) getLong:(NSString*)key;
-(int) getInt:(NSString*)key;


-(float) getFloat:(NSString*)key FailBack:(float)failBack;
-(double) getDouble:(NSString*)key FailBack:(double)failBack;
-(BOOL) getBoolean:(NSString*)key FailBack:(BOOL)failBack;
-(long long) getLong:(NSString*)key FailBack:(long long)failBack;
-(int) getInt:(NSString*)key FailBack:(int)failBack;
-(NSString*) getString:(NSString*)key;
-(NSString*) getString:(NSString*)key FailBack:(NSString*)failBack;
-(XJson*) getJSON:(NSString*)key;
-(XJsonArray*) getJSONArray:(NSString*)key;

-(NSString*)toString;
-(NSData*)toData;

@end

//#define XJsonOfVariableBindings(...) [XJson newWithNSDictionary:NSDictionaryOfVariableBindings(__VA_ARGS__)]
#define XJsonOfVariableBindings NSDictionaryOfVariableBindings
