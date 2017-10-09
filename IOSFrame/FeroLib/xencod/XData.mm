//
//  XByteArray.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/29.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XData.h"



@implementation NSNumber(XXByte)
+(id)newWithByte:(Byte)byte
{
    return [[XByte alloc]initWithUnsignedChar:byte];
}


-(char)getChar
{
 return  [self charValue] ;

}
-(Byte)getByte
{
    return  [self unsignedCharValue] ;
}

@end


@implementation NSMutableArray(XXByteArray)

+(NSMutableArray*)newWithString:(NSString*)str
{
    XByteArray *arr= [XByteArray new];
    NSData* bytes = [str dataUsingEncoding:NSUTF8StringEncoding];
    Byte * myByte = (Byte *)[bytes bytes];
    int lenght = [bytes length];
    for (int i=0; i<lenght; i++) {
        [arr addByte:*(myByte+i)];
    }
    return arr;
}

-(NSString*)toString
{
    NSMutableData* data = [NSMutableData data];
    for (int i=0; i<[self count]; i++) {
        XByte*xb = self[i];
        Byte byte =[xb getByte];
        [data appendBytes:&byte length:1];
    }
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return str;
}

+(id)newWithLength:(int)length
{
    XByteArray *arr= [XByteArray new];
    if(length>0){
        for (int i=0; i<length; i++) {
            [arr addByte:0];
        }
    }
    return arr;
}

-(Byte)getByteAt:(int)index
{
    return  [[self getXByteAt:index ] getByte];
}

-(XByte*)getXByteAt:(int)index
{
    XByte* xb = [self objectAtIndex:index];
    return xb;
}

-(void)setByte:(Byte)b At:(int)index
{
    [self setXByte:[XByte newWithByte:b ] At:index];
}

-(void)setXByte:(XByte*)b At:(int)index
{
    [self replaceObjectAtIndex:index withObject:b];
}

-(void)addByte:(Byte)b
{
    [self addXByte:[XByte newWithByte:b]];
}

-(void)addXByte:(XByte*)b
{
    [self addObject:b];
}

-(void)repalceAt:(int)index WithByte:(Byte)b
{
    [self   setByte:b At:index];
}

-(void)repalceAt:(int)index WithXByte:(XByte*)b
{
    [self setXByte:b At:index];
}

@end

void arraycopy(XByteArray* src, int srcPos, XByteArray* dest, int destPos, int length)
{
    for (int i=0; i<length; i++) {
        dest[destPos+i]= [XByte newWithByte:[src[srcPos+i] getByte]];
        //dest[destPos+i]= src[srcPos+i];
    }
}
