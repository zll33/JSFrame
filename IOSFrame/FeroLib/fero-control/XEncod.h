//
//  XEncod.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/10.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#ifndef p2p_XEncod_h
#define p2p_XEncod_h
#import <UIKit/UIKit.h>

//获取一个随机密匙
NSString* getKeySeekRandom();


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
NSString* encodeEx(NSString* keySeek, NSString* strData);

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
NSString* decodeEx(NSString* keySeek, NSString* strData);


#endif
