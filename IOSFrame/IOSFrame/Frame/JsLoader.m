//
//  JsLoader.m
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "JsLoader.h"
#import "XHeader.h"
#import "JsSQLite.h"

@implementation JsLoader
@synthesize baseUrl;
@synthesize paths;

-(void)addPath:(NSString*)path
{
    if (paths==nil) {
        paths = [NSMutableArray new];
    }
    if(![[path lowercaseString] hasPrefix:@"http"]){
         path = [NSString stringWithFormat:@"%@%@",baseUrl,path];
    }
    [paths addObject:path];
}
-(void)startLoading:(void(^)(NSString*path,NSString*js,BOOL isEnd))onfinish
{
    //
    NSArray*files = paths.copy;
    paths = [NSMutableArray new];
    runOnTread(^{
        for (NSString*url in files) {
            NSString*js = [self doDownJs:url];
            onfinish([url lastPathComponent],js,false);
        }
        onfinish(nil,nil,true);
    });
}
-(NSString*)doDownJs:(NSString*)url{
    //获取本地保存的数据
    NSString* md5 = MD5(url);
    NSString*str = [JsSQLite getValueKey:md5 AppKey:@""];
    NSString* modified=nil;
    NSString* match=nil;
    XJson* oldInfo=nil;
    if(str.length>0){
        oldInfo = [XJson newWithString:str];
        modified = [oldInfo getString:@"modified"];
        match = [oldInfo getString:@"match"];
    }else{
        oldInfo = [XJson new];
    }
    //文件名不能有中文
    NSMutableURLRequest *request2 =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                         timeoutInterval:10.0f];;
    //判断是否需要更新,//更新文件，并保存文件信息
    if(modified.length>0){
        [request2 setValue:modified forHTTPHeaderField:@"If-Modified-Since"];
    }
    if(match.length>0){
        [request2 setValue:match forHTTPHeaderField:@"If-None-Match"];
    }
    request2.HTTPMethod = @"GET";
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask*sessionTask = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        int code = [(NSHTTPURLResponse*)response statusCode];
        if (code==304) {
            //无变动
        }else if(code==200){
            NSString*js = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [oldInfo putString:@"js" Value:js];
            [oldInfo putString:@"modified"
                         Value:[(NSHTTPURLResponse*)response allHeaderFields][@"Last-Modified"]];
            [oldInfo putString:@"match"
                         Value:[(NSHTTPURLResponse*)response allHeaderFields][@"Etag"]];//ETag
            [JsSQLite saveKey:md5 Value:[oldInfo toString] AppKey:@""];
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    [sessionTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return [oldInfo getString:@"js"];
}
@end
