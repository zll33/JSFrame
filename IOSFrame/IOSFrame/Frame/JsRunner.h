//
//  JsRunner.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSRunnerExport<JSExport>
-(JSValue*)getCurrFunction;
-(NSArray*)getCurrArgs;
-(id)testfun:(JSValue*)value;
@end
@interface JsRunner : NSObject<JSRunnerExport>
-(void)addObject:(NSObject*) object Name:(NSString*) name ;
-(JSValue*)callFunction:(JSValue*) funtion :(NSArray*) args;
-(JSValue*)loadJs:(NSString*)js :(NSString*) sourceName;
-(void)close;
@end
