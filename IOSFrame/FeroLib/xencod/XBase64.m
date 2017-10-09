//
//  XBase.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/26.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XBase64.h"


// Byte byte[] = {0,1,2,3,4};

@implementation XBase64
+(NSString*)  encode:(XByteArray*) raw
{
   
    XByteArray *encoded =  [XByteArray new ];
    int count =[raw count];
    for (int i = 0; i < count; i += 3) {
        //encoded.append(encodeBlock(raw, i));
        [encoded addObjectsFromArray:[self encodeBlock:raw :i ]];
    }
    return  [encoded toString];
}
/**
 *
 *return byte 数组
 */
+(XByteArray* )encodeBlock:(XByteArray*) raw :(int)offset
{
    
    int block = 0;
    int slack = [raw count] - offset - 1;
    int end = (slack >= 2) ? 2 : slack;
    for (int i = 0; i <= end; i++) {
        Byte b = [raw[offset + i] getByte];
        int neuter = (b < 0) ? b + 256 : b;
        block += neuter << (8 * (2 - i));
    }
//    char[] base64 = new char[4];
    XByteArray * base64 = [XByteArray newWithLength:4];
  
    for (int i = 0; i < 4; i++) {
        int sixbit = (block >> (6 * (3 - i))) & 0x3f;
//        base64[i] = getChar(sixbit);
            [base64 setByte:[self getChar:sixbit] At:i];
     
        
    }
    
    if (slack < 1)
        base64[2] = @'=';
    
    if (slack < 2)
        base64[3] = @'=';
    
    return base64;
    
//    return nil;
}
+(Byte ) getChar:(int) sixBit
{
    if (sixBit >= 0 && sixBit <= 25)
        return (Byte) ('A' + sixBit);
    if (sixBit >= 26 && sixBit <= 51)
        return (Byte) ('a' + (sixBit - 26));
    if (sixBit >= 52 && sixBit <= 61)
        return (Byte) ('0' + (sixBit - 52));
    if (sixBit == 62)
        return '+';
    if (sixBit == 63)
        return '/';
    return '?';
}

+(XByteArray* )decode:(NSString*) base64
{
    
    int pad = 0;
    XByteArray * base64StrArr = [NSMutableArray newWithString:base64];
    
    for (int i = [base64StrArr count] - 1; [base64StrArr[i] getByte] == '='; i--)
        pad++;
    int length = [base64StrArr count] * 6 / 8 - pad;
    XByteArray * raw = [XByteArray newWithLength: length];
    int rawIndex = 0;
    for (int i = 0; i < [base64StrArr count]; i += 4) {
        int block = ([self getValue:[base64StrArr[i] getByte]]<< 18)
        + ([self getValue:[base64StrArr[i+1] getByte]] << 12)
        + ([self getValue:[base64StrArr[i+2] getByte]]<< 6)
        + ([self getValue:[base64StrArr[i+3] getByte]]);
        
        for (int j = 0; j < 3 && rawIndex + j < [raw count]; j++)
            raw[rawIndex + j] = [XByte newWithByte:(Byte) ((block >> (8 * (2 - j))) & 0xff)];
        rawIndex += 3;
    }
    return raw;

}

+(int)getValue:(Byte)  c
{
    if (c >= 'A' && c <= 'Z')
        return c - 'A';
    if (c >= 'a' && c <= 'z')
        return c - 'a' + 26;
    if (c >= '0' && c <= '9')
        return c - '0' + 52;
    if (c == '+')
        return 62;
    if (c == '/')
        return 63;
    if (c == '=')
        return 0;
    return -1;
}
    
@end
