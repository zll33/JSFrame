//
//  XEncod.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/10.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEncod.h"
//获取一个随机密匙
NSString* getKeySeekRandom()
{
    return @"MTYwODk=";
}


/**
 * 加密
 *
 * @param keySeek
 *            密匙所在的位置
 * @param strData
 *            明文
 * @return 返回密文
 */
NSString* encodeEx(NSString* keySeek, NSString* strData)
{
    return strData;
}

/**
 * 解密
 *
 * @param keySeek
 *            密匙所在的位置
 * @param strData
 *            密文
 * @return 明文
 */
NSString* decodeEx(NSString* keySeek, NSString* strData)
{
    return strData;
}
