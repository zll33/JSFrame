//
//  Frame.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//
#import "XHeader.h"
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JsLoader.h"
#import "JsRunner.h"

@protocol JSFrameExport<JSExport>
-(int)getFrameVersio;
-(NSString*)getFramePlatform;
-(id)createView:(int) type;
//设置主界面
-(void)setMainBaseView:(JSValue*) baseView
                      :(JSValue*)onMainSizeChangeFunction
                      :(JSValue*)onNeedLayoutIfFunction;
//调用刷新
-(void)setBaseViewNeedLayout;
-(float)getDensity;
-(long long)currentTimeMillis;
-(void)postDelayed:(JSValue*)fun
                  :(int)delayed;
-(id) measureTextSize:(NSString*) str
                     :(float) maxWidth
                     :(float) fontSize
                     :(float)lineSpace
                     :(float)charSpace;
-(void)loadJS:(JSValue*)path;
-(void)setLoadJSFinish:(JSValue*)fun;
@end

@interface Frame : NSObject<JSFrameExport>
@property(nonatomic) NSTimer*timer;
@property(nonatomic) JsRunner* jsRunner;
@property(nonatomic) UIView*mainLay;
@property(nonatomic) JsLoader*jsLoader;

@property(nonatomic) JSValue*onMainSizeChangeFunction;
@property(nonatomic) JSValue*onNeedLayoutIfFunction;
-(void)callChange;
//
-(int)getFrameVersio;
-(NSString*)getFramePlatform;
-(id)createView:(int) type;
//设置主界面
-(void)setMainBaseView:(JSValue*) baseView
                      :(JSValue*)onMainSizeChangeFunction
                      :(JSValue*)onNeedLayoutIfFunction;
//调用刷新
-(void)setBaseViewNeedLayou;
-(float)getDensity;
-(long long)currentTimeMillis;
-(void)postDelayed:(JSValue*)fun
                  :(int)delayed;
-(id) measureTextSize:(NSString*) str
                     :(float) maxWidth
                     :(float) fontSize
                     :(float)lineSpace
                     :(float)charSpace;
-(void)loadJS:(JSValue*)path;
-(void)setLoadJSFinish:(JSValue*)fun;
@end
