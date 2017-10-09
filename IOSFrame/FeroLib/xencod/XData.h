//
//  XByteArray.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/29.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *XByte 是无符号的8位整型，位移时填0
 */
typedef NSNumber XByte;
typedef NSMutableArray XByteArray;

@interface NSNumber(XXByte)
+(id)newWithByte:(Byte)byte;
-(Byte)getByte;
//-(char)getChar;
@end


@interface  NSMutableArray(XXByteArray)

+(id)newWithLength:(int)length;

-(Byte)getByteAt:(int)index;
-(XByte*)getXByteAt:(int)index;

-(void)setByte:(Byte)b At:(int)index;
-(void)setXByte:(XByte*)b At:(int)index;

-(void)addByte:(Byte)b;
-(void)addXByte:(XByte*)b;

-(void)repalceAt:(int)index WithByte:(Byte)b;
-(void)repalceAt:(int)index WithXByte:(XByte*)b;


+(NSMutableArray*)newWithString:(NSString*)str;
-(NSString*) toString;
@end


void arraycopy(XByteArray* src, int srcPos, XByteArray* dest, int destPos, int length);
