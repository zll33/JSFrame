//
//  JsRunner.m
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "JsRunner.h"
#import "XHeader.h"
#import "Frame.h"

@interface JsRunner()
{
    JSContext*jsContext;
    
    JSValue*currFunction;
    NSArray*currArgs;
}

@end
@implementation JsRunner
-(id)init{
    self = [super init];
    __weak JsRunner*thiz = self;
    //
    jsContext = [JSContext new];
    [jsContext setExceptionHandler:^(JSContext *c, JSValue *v) {
        NSString*errMsg;
        //XJson*err = [XJson newWithNSDictionary:[v toDictionary]];
        //[err putString:@"errMsg" Value:[v toString]];
        //errMsg =[err toString];
        
        NSDictionary*dic= [v toDictionary];
        errMsg = [NSString stringWithFormat:
                  @"\n%@ \n文件名：%@ ，行数 %@，字处 %@",
                  [v toString],
                  dic[@"sourceURL"],
                  dic[@"line"],
                  dic[@"column"]];
        
        [thiz doException:errMsg];
        
    }];
    
    
    jsContext[@"IOSFunction"]=self;
    //[self addObject:self Name:@"IOSFunction"];
    
    /*
    //
    [jsContext evaluateScript:
     @"function mytest(str,num){ \
     return 'num='+str+num;\
     }"
     ];
    JSValue*value1 = [jsContext evaluateScript:@"IOSFunction.testfun(mytest);"];
    JSValue*value2 = [jsContext evaluateScript:@"mytest"];
    JSValue*value3 = [self callFunction:value2 :@[@"1",@23]];
    //
    [self loadJs:@"function errfun(){return erer.ee;}" :@"test"];
    JSValue*value4 = [jsContext evaluateScript:@"errfun();"];
    */
    return self;
    
}
-(void)addObject:(NSObject*)object Name:(NSString*)name {
    jsContext[name] = object;
}
-(id)testfun:(JSValue*)value
{
    NSLog(@"%@",value);
    
    return @"123";
}

-(JSValue*)getCurrFunction
{
    return currFunction;
}
-(NSArray*)getCurrArgs{
    return currArgs;
}
//只有一个线程调用函数
-(JSValue*)callFunction:(JSValue*) funtion :(NSArray*) args{
    currFunction = funtion;
    currArgs = args;
    JSValue*value =  [jsContext evaluateScript:@"IOSFunction.getCurrFunction().apply(IOSFunction,IOSFunction.getCurrArgs(0));"];
    
    return value;
}
-(JSValue*)loadJs:(NSString*)js :(NSString*)sourceName{
    //sourceName = [NSString stringWithFormat:@"http://file.name/%@",sourceName]
    JSValue*value =  [jsContext evaluateScript:js
                                 withSourceURL:[NSURL URLWithString:sourceName]];
    return value;
}
-(void)doException:(NSString*)errMsg{
    
    NSLog(@"JsRunner Err: %@",errMsg);
}
-(void)close
{

}
@end
