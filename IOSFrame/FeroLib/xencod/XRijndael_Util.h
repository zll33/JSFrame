//
//  XRijndael_Util.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/30.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XData.h"
#import "XBase64.h"
#import "XRijndael_Algorithm.h"
#import "XFero1.h"
#import "XFero2.h"
@interface XRijndael_Util : NSObject
/**
 * 获取一个随机密匙的位置
 *
 * @return
 * @throws UnsupportedEncodingException
 */
+(NSString*) getKeySeekRandom;

/**
 * 加密
 *
 * @param keySeek
 *            密匙所在的位置
 * @param strData
 *            明文
 * @return 返回密文
 * @throws InvalidKeyException
 * @throws UnsupportedEncodingException
 */
+(NSString*) encodeKeySeek:( NSString*) keySeek Str:( NSString*) strData;

/**
 * 解密
 *
 * @param keySeek
 *            密匙所在的位置
 * @param strData
 *            密文
 * @return 明文
 * @throws InvalidKeyException
 * @throws UnsupportedEncodingException
 */
+(NSString*)  decodeKeySeek:(NSString* )keySeek Str:(NSString*) strData;

@end
