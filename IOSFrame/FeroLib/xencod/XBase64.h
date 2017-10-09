//
//  XBase.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/26.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XData.h"

@interface XBase64 : NSObject
/**
 *  NSMutableArray Byte
 */

//+(XByteArray* )encodeBlock:(XByteArray*) raw :(int)offset;
//+(Byte ) getChar:(int) sixBit;
//
//+(int)getValue:(Byte) c;

//将二进制加密成base64字符串
+(NSString*)  encode:(XByteArray*) raw;

//将base64字符串解密成二进制
+(XByteArray* )decode:(NSString*) base64;

@end
