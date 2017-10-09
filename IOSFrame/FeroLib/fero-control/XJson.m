//
//  XJson.m
//  p2p
//
//  Created by zhangxiuquan on 15/2/3.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XJson.h"

@implementation NSMutableArray(XJsonArray)
-(NSString*)toJString
{
    NSData *jsonData  =  [self toJData];
    NSString* jstr= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jstr;
}
-(NSData*)toJData
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return jsonData;
}
+(XJsonArray*) newJArrWithString:(NSString*)str
{
    //保护一下
    if(str.length==0){
        return [XJsonArray new];
    }
    //
    NSData*data = [str dataUsingEncoding: NSUTF8StringEncoding];
    
    XJsonArray* jarr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([jarr isKindOfClass:[XJsonArray class]]) {
        
        jarr = jarr;
    }
    return jarr;
}
@end


@implementation NSMutableDictionary(XJson)


-(void) addjson:(NSDictionary*)nsdictionary
{
    [self addEntriesFromDictionary:nsdictionary];
}
+(XJson*) newWithNSDictionary:(NSDictionary*)nsdictionary
{
    if (nsdictionary) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:nsdictionary options:NSJSONWritingPrettyPrinted error:nil];
        XJson* json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        return json;
    }else{
        return [XJson new];
    }
}
+(XJson*) newWithString:(NSString*)str
{
    if(str.length==0){
        return [XJson new];
    }
    NSData*data = [str dataUsingEncoding: NSUTF8StringEncoding];
    XJson *json = [NSMutableDictionary newWithData:data];
    return json;
}
+(XJson*) newWithData:(NSDate*)data
{
    if(data!=nil){
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }else{
        return [XJson new];
    }
    
}
+(BOOL)isXJson:(id)ojson
{
    return [ojson isKindOfClass:[XJson class]] && [ojson respondsToSelector:@selector(putJSON)];
}
//对比json内容
-(BOOL) isIncludChild:(XJson*)child
{
    NSArray*kesy = [child allKeys];
    for (NSString*key in kesy) {
        NSString*value = [child getString:key FailBack:@""];
        if (![value isEqualToString:[self getString:key FailBack:@""]]) {
            return false;
        }
    }
    return true;
}
-(void) putFloat:(NSString*)key Value:(float)value
{
    NSNumber * num = [[NSNumber alloc]initWithFloat:value];
    [self setValue:num forKey:key];
}
-(void) putDouble:(NSString*)key Value:(double)value
{
    NSNumber * num = [[NSNumber alloc]initWithDouble:value];
    [self setValue:num forKey:key];
}

-(void) putBoolean:(NSString*)key Value:(BOOL)value
{
    NSNumber * num = [[NSNumber alloc]initWithBool:value];
    [self setValue:num forKey:key];
}
-(void) putLong:(NSString*)key Value:(long)value
{
    NSNumber * num = [[NSNumber alloc]initWithLong:value];
    [self setValue:num forKey:key];
}

-(void) putInt:(NSString*)key Value:(int)value
{
    NSNumber * num = [[NSNumber alloc]initWithInt:value];
    [self setValue:num forKey:key];
}

-(void) putString:(NSString*)key Value:(NSString*)value
{
    [self setValue:value forKey:key];
}

-(void) putJSON:(NSString*)key Value:(XJson*)value
{
    [self setValue:value forKey:key];
}
-(void) putJSONArray:(NSString*)key Value:(XJsonArray*)value
{
    [self setValue:value forKey:key];
}


-(float) getFloat:(NSString*)key
{
    return [self getFloat:key FailBack:0];
}
-(double) getDouble:(NSString*)key
{
     return [self getDouble:key FailBack:0];
}
-(BOOL) getBoolean:(NSString*)key
{
     return [self getBoolean:key FailBack:FALSE];
}
-(long long) getLong:(NSString*)key
{
     return [self getLong:key FailBack:0];
}
-(int) getInt:(NSString*)key
{
     return [self getInt:key FailBack:0];
}

-(float) getFloat:(NSString*)key FailBack:(float)failBack
{
    float value = failBack;
    id _value = [self objectForKey:key];
    if ([_value respondsToSelector:@selector(floatValue)] )
    {
        value = [_value floatValue];
    }
    return value;
}
-(double) getDouble:(NSString*)key FailBack:(double)failBack
{
    double value = failBack;
    id _value = [self objectForKey:key];
    if ([_value respondsToSelector:@selector(doubleValue)] )
    {
        value = [_value doubleValue];
    }
    return value;
}

-(BOOL) getBoolean:(NSString*)key FailBack:(BOOL)failBack
{
    BOOL value = failBack;
    id _value = [self objectForKey:key];
    if ([_value respondsToSelector:@selector(boolValue)] )
    {
        value = [_value boolValue];
    }
    return value;
}
-(long long) getLong:(NSString*)key FailBack:(long long)failBack
{
    long long value = failBack;
    id _value = [self objectForKey:key];
    if ([_value respondsToSelector:@selector(longLongValue)] )
    {
        value = [_value longLongValue];
    }
    return value;
}
-(int) getInt:(NSString*)key FailBack:(int)failBack
{
    int value = failBack;
    id _value = [self objectForKey:key];
    if ([_value respondsToSelector:@selector(intValue)] )
    {
        value = [_value intValue];
    }
    return value;
}
-(NSString*) getString:(NSString*)key
{
    return [self getString:key FailBack:nil];
}
-(NSString*) getString:(NSString*)key FailBack:(NSString*)failBack
{
    
    id value = [self objectForKey:key];
    if (value==nil) {
        if (![[self allKeys] containsObject:key]) {
            value  = failBack;
        }
    }
 

    if ([value isKindOfClass:[NSNumber class]] && (strcmp([value objCType], @encode(double)) == 0||strcmp([value objCType], @encode(float)) == 0)) {
        
        NSString * str = [value stringValue];
        if (strcmp([value objCType], @encode(double)) == 0) {
            str =  [[NSString alloc]initWithFormat:@"%f",[value doubleValue] ];
        }else if(strcmp([value objCType], @encode(float)) == 0){
            str =  [[NSString alloc]initWithFormat:@"%f",[value floatValue] ];
        }
        
        value =str;
        
        //去掉末尾的0
        for (int i= str.length -1 ; i>=0; i--) {
            if ([str hasSuffix:@"0"]) {
                str = [str substringToIndex:str.length -1];
            }else{
                break;
            }
        }
        //查询是否是含有小数点
        if ([str rangeOfString:@"."].length>0) {
            if ([str hasSuffix:@"."]) {
                str = [str substringToIndex:str.length -1];
            }
            value =str;
        }
        
        
    }else
        if ([value respondsToSelector:@selector(stringValue)] )
        {
            value = [value stringValue];
        }else if([value respondsToSelector:@selector(toJString)]){
            value = [value toJString];
        }else if([value respondsToSelector:@selector(toString)]){
            value = [value toString];
        }else if(![value isKindOfClass:[NSString class]]){
            value = failBack;
        }
    return value;
}
-(XJson*) getJSON:(NSString*)key
{
    id dic = [self objectForKey:key];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        if([dic isKindOfClass:[NSString class]]){
            dic = [XJson newWithString:dic];
        }else{
            dic = nil;
        }
    }else {
        dic = [XJson newWithNSDictionary:dic];
    }
    
    return dic;
}
-(XJsonArray*) getJSONArray:(NSString*)key
{
    id arr = [self objectForKey:key];
    
    if (![arr isKindOfClass:[NSArray class]]) {
        arr = nil;
    }else{
        XJsonArray * list = [XJsonArray new];
        for (int i=0; i<[arr count]; i++) {
            id oc =[arr objectAtIndex:i];
            if ([oc isKindOfClass:[NSDictionary class]]) {
                [list addObject:[XJson newWithNSDictionary:oc]];
            }
            else{
                [list addObject:oc];
            }
        }
        arr =list;
    }
    return arr;
}
-(NSString*)toString
{
    NSData *jsonData  =  [self toData];
    NSString* jstr= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jstr;
}
-(NSData*)toData
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return jsonData;
}
@end



