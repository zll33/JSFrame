//
//  Rijndael_Algorithm.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/29.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XData.h"
int mul(int a, int b);
int mul4(int a, Byte b[]);
NSObject* makeKey(XByteArray* k, int blockSize);
int getRounds(int keySize, int blockSize);

@interface XRijndael_Algorithm : NSObject
+(NSObject*)makeKey:(XByteArray*)kb :(int)blockSize ;
+(XByteArray*)blockEncrypt:(XByteArray*)pt   :(int)i  :( NSObject* )key    :(int)intblockSize;
+(XByteArray*) blockDecrypt:(XByteArray*) inBytes : (int) inOffset :(NSObject*) sessionKey : (int )blockSize;
@end
