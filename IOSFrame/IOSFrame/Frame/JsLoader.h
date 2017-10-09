//
//  JsLoader.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsLoader : NSObject
@property(nonatomic)NSMutableArray*paths;
@property(nonatomic)NSString*baseUrl;
-(void)addPath:(NSString*)path;
-(void)startLoading:(void(^)(NSString*path,NSString*js,BOOL isEnd))onfinish;
@end
