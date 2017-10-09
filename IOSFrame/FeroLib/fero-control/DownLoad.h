//
//  DownLoad.h
//  kzd123
//
//  Created by kzd on 14-3-15.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJson.h"
@interface DownTaskKVNode:  NSObject
@property(nonatomic) NSString*key;
@property(nonatomic) NSObject*value;
+(DownTaskKVNode*)newWithKey:(NSString*)k Value:(NSString*)v;
@end
typedef enum  {
    
    DownTastType_picture = 0,// 图片
    DownTastType_jsonStr = 1,// json

}DownTastType;
@interface DownTask : NSObject

@property(nonatomic)BOOL forbiddenMsg;
@end
////定义一个接口类，用于下载json完成时的回调
@protocol DownTastCallBack
    //接口函数
-(void) onDownTastFinsh:(DownTask*) data;

@end
#define DownMethod_POST 0
#define DownMethod_GET 1
#define DownMethod_PUT 2
#define DownMethod_DELETE 3
#define DownMethod_POSTFILE 4

//一个任务节点,加对（），可已继续定义DownTast
@interface DownTask()
@property(nonatomic)  NSMutableArray*paramList;
@property(strong) void (^callBackFun)(DownTask*);
@property(readwrite) id<DownTastCallBack> back;
@property(readwrite) id  owner;
@property(readwrite) NSString* url; //请求但目标地址
@property(readwrite) DownTastType type;//请求的类型

@property(readwrite)  NSString* jstr;//请求的参数
@property(readwrite)  long time;//请求的参数
@property(readwrite)  NSString*  name;//请求的参数
@property(readwrite)  NSString* datastr;//返回的json

@property(readwrite)  UIImage *pic;//返回的json

@property(readwrite)  XJson *json;//返回的json

@property(readwrite)  int method;//请求方法
@property(readwrite)  long ResponseStatue;//返回状态

+(instancetype)newWithURL:(NSString*)url Method:(int)method CallBack:(void (^)(DownTask* task))callback;

-(id)initWithJsonTypeOwner:(id)owner CallBack:(id<DownTastCallBack>)callback OURL:(NSString*)url  JSTR:(NSString*)jstr TIME:(int)time FILENAME:(NSString*)name;
-(id)initWithPictureTypeOwner:(id)owner CallBack:(id<DownTastCallBack>)callback OURL:(NSString*)url FILENAME:(NSString*)name;


-(id)initWithJsonTypeOURL:(NSString*)url CallBack:(void (^)(DownTask*))callback ;
-(void)addParam:(NSString*)key Value:(NSString*)value ;
-(NSString*)getParam:(NSString*)key;
-(XJson*)getParam;
-(void)addParam:(XJson*)param;
-(void)addParam:(NSString*)key FileImage:(UIImage*)param;
-(void)addParam:(NSString*)key Object:(NSObject*)value;
-(int) getStatue;
-(Boolean)isSucc;
-(NSString*)getErrStr;
-(NSString*)getMsgStr;
-(id)getResult;
-(NSString*)getResultStr;
-(XJson*)getResultJson;
-(XJson*)getResultJsonFailBack:(XJson*)json;
-(XJsonArray*)getResultJsonArr;

-(void) start;
-(void) addToDownLoad;


@end

//声明一个下载类
@interface DownLoad : NSObject
@property(readwrite) NSMutableArray* tastList;
@property(weak) NSThread* runThread;
+(NSString*)getServerUrl;
+(NSString*)getServerHost;

//同步下载，阻塞. + 类似静态函数
+(NSString*)getJstr:(DownTask*)task;
+(NSString*)getJstrFormURL:(NSString*)url param:(NSString*)jstr;
+(UIImage*)getImageFromFile:(NSString*)url;
+(void) addDownTast:(DownTask*)t;
+(void)removeDownTast:(id)owner;
+(NSData*)getImageNSDataWithUrl:(NSString*)url :(float) maxPx;
+(void) startDownTast:(DownTask*)t;
+(void) setLogoutErr:(int)e1 Err:(int)e2 Act:(NSString*)actLogout;
+(void) setRequestSucc:(int)s1 Succ2:(int)s2;
+(void) setResponseBlockOnFinish:(void (^)(DownTask*))onFinish
                        GetStatue:(int (^)(DownTask*))getStatue
                        IsSuccess:(BOOL (^)(DownTask*))isSuccess
                        IsNeedLogin:(BOOL (^)(DownTask*))isNeedLogin
                        GetResult:(id (^)(DownTask*))getResult
                        GetMsg:(NSString* (^)(DownTask*))getMsg;


@end


