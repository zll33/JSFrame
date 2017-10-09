//
//  DownLoad.m
//  kzd123
//
//  Created by kzd on 14-3-15.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import "DownLoad.h"
#import "HelpApi.h"
#import "XEncod.h"
#import "XRijndael_Util.h"
#import "XUserManager.h"
#import "XAction.h"

//#define DownLoad_Debug
int DownLoadFileNameTag = 0;
static DownLoad *DOWNLOAD=nil;
int _DownLoad_LogoutErr1=900;
int _DownLoad_LogoutErr2=1000;
NSString*_DownLoad_LogoutAct=@"logout";

int _DownLoad_Succ1=0;
int _DownLoad_Succ2=99;

NSData * createParamJSTR(NSString *jstr,long time){
    
    //XJson *dictionary = [[XJson alloc] init];
    CGFloat scrw =[[UIScreen mainScreen] applicationFrame].size.width;
    
    NSNumber *number = [NSNumber numberWithDouble:[[[UIDevice currentDevice] systemVersion] doubleValue]];
    NSString*sys_sysversions = [NSString stringWithFormat:@"IOS%@)",[number stringValue]];
    
    XJson *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    
    XJson *dictionary = [XJson dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithLong:time],   @"infot",
                                       [NSNumber numberWithLong:PX2PD(scrw)], @"sys_scrw",
                                       sys_sysversions, @"sys_sysversions",
                                       [NSString stringWithFormat:@"IOS_FC_%@",app_build], @"sys_appversions",
                                       sys_sysversions, @"sys_phonemodels",nil];

    if (jstr!=nil) {
        
        XJson *jsonparam =  [XJson newWithString:jstr];
        if (jsonparam!=nil) {
            [dictionary setValue:jsonparam forKey:@"paramjstr"];
        }
    }
    
    //XJson -> NSData:
    NSData *jsonData = [dictionary toData];
    
    if (jsonData!=nil) {
            //NSData -> NSString:
            //NSString* jstr2= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }


    
    return jsonData;
}

//解密
XJson * decode(XJson *jsonparam ){
    
    NSString* seek = [jsonparam objectForKey:@"seek"];
    NSString* data = [jsonparam objectForKey:@"data"];
    NSString * str = [XRijndael_Util decodeKeySeek:seek Str:data];
   
    return [XJson newWithString:str];
    
}

//加密
NSString* encode(XJson* param,NSString* seek){
    
    NSString* str =[param toString];
    
    NSString* str2= [XRijndael_Util encodeKeySeek:seek Str:str];
    
    return str;
}

XJson * createParamJson(XJson* param){
    
    //XJson *dictionary = [[XJson alloc] init];
    CGFloat scrw =[[UIScreen mainScreen] applicationFrame].size.width;
    
    NSNumber *number = [NSNumber numberWithDouble:[[[UIDevice currentDevice] systemVersion] doubleValue]];
    NSString*sys_sysversions = [NSString stringWithFormat:@"IOS%@)",[number stringValue]];
    
    XJson *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
  
    XJson *dictionary = [XJson dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithLong:time],   @"infot",
                                       [NSNumber numberWithLong:PX2PD(scrw)], @"sys_scrw",
                                       sys_sysversions, @"sys_sysversions",
                                       [NSString stringWithFormat:@"IOS_FC_%@",app_build], @"sys_appversions",
                                       sys_sysversions, @"sys_phonemodels",nil];
    
    [dictionary addEntriesFromDictionary:param];
 
    
    
//    NSString* seekK = [XRijndael_Util getKeySeekRandom];
//    XJson *dictionary2 = [XJson dictionaryWithObjectsAndKeys:
//                                       seekK, @"seek",
//                                       encode(dictionary,seekK), @"data",
//                                       nil];
    
    
 
    
    
    return dictionary;
}
NSData * createParamJSTR2(XJson* param){
    
    NSData *jsonData = [createParamJson(param) toData];
    
    if (jsonData!=nil) {
        //NSData -> NSString:
        //NSString* jstr2= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    
    return jsonData;
}
NSString*getNowText(){
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYYMMdd-HHmmss"];
    NSString *dateTime = [formatter stringFromDate:date];
    //8.3 返回的小时是 “12:00:00”
    dateTime = [dateTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    return dateTime;
}
#define UTF8(str) [str dataUsingEncoding:NSUTF8StringEncoding]


void addToHttpBody(NSMutableData *data,NSString*key,NSObject*value,NSString*boundary){
    if ([value isKindOfClass:[UIImage class]]) {
        
        //优先使用jpg
        NSData *jpgData =UIImageJPEGRepresentation((UIImage*)value,0.8);
        NSLog(@"w=%f,h=%f  jpgData=%f",((UIImage*)value).size.width,((UIImage*)value).size.height,(double)jpgData.length);
        
        //jpg不纯在使用
        NSData *pngData =jpgData?nil:UIImagePNGRepresentation((UIImage*)value);
        
        NSString*filename = [NSString stringWithFormat:@"%@-%d.%@",getNowText(),++DownLoadFileNameTag,jpgData?@"jpg":@"png"];
        
        //参数起始
        [data appendData:UTF8(@"--")];[data appendData:UTF8(boundary)];
        [data appendData:UTF8(@"\r\n")];
        //描述
        NSString*contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"",key,filename];
        [data appendData:UTF8(contentDisposition)];
        [data appendData:UTF8(@"\r\n")];
        //文件类型
        if(jpgData){
            [data appendData:UTF8(@"Content-Type: image/jpeg")];
        }else{
            [data appendData:UTF8(@"Content-Type: image/png")];
        }
        [data appendData:UTF8(@"\r\n")];
        //开始数据
        [data appendData:UTF8(@"\r\n")];
        //数据
        if(jpgData){
            [data appendData:jpgData];
        }else{
            [data appendData:pngData];
        }
        [data appendData:UTF8(@"\r\n")];
        
    }else if([value isKindOfClass:[NSString class]]){
        //参数起始
        [data appendData:UTF8(@"--")];[data appendData:UTF8(boundary)];
        [data appendData:UTF8(@"\r\n")];
        //描述
        [data appendData:UTF8(@"Content-Disposition: form-data; name=\"")];[data appendData:UTF8(key)];[data appendData:UTF8(@"\"")];
        [data appendData:UTF8(@"\r\n")];
        //开始数据
        [data appendData:UTF8(@"\r\n")];
        //数据
        [data appendData:UTF8((NSString*)value)];
        [data appendData:UTF8(@"\r\n")];
        
    }else if([value isKindOfClass:[XJson class]]){
    
        addToHttpBody(data, key, [(XJson*)value toString], boundary);
    
    }else if([value isKindOfClass:[XJsonArray class]]){
        
        addToHttpBody(data, key, [(XJsonArray*)value toJString], boundary);
        
    }

}

NSData * createParamFile(NSMutableArray* paramlist,NSString*boundary){
    
    XJson*json= createParamJson([XJson new]);
    NSMutableData *data = [NSMutableData data];
    NSArray*keys  =  [json allKeys];
    
    for (NSString*key in keys) {
        NSObject*value = [json valueForKey:key];
        addToHttpBody(data,key,value,boundary);
    }
    for (DownTaskKVNode*node in paramlist) {
        addToHttpBody(data,node.key,node.value,boundary);
    }
    //数据结束
    [data appendData:UTF8(@"--")];
    [data appendData:UTF8(boundary)];
    [data appendData:UTF8(@"--")];
    //[data appendData:UTF8(@"\r\n")];
    
    //
    return data;
}


NSString * getDayT(){
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue] / (10*24*60*60);
    NSString *dt = [NSString stringWithFormat:@"%llu",dTime];
    
    
    return [@"temppicture" stringByAppendingPathComponent:dt];
}

void saveBitmapFile(UIImage* pic,NSString* url)
{
//    int hash = HashCode(url);
    NSString *documentsFolder = getCacheFilePath();
    NSString *imageFullPath   = [documentsFolder stringByAppendingPathComponent:getDayT()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageFullPath]) {
        bool RET = [[NSFileManager defaultManager] removeItemAtPath:[documentsFolder stringByAppendingPathComponent:@"temppicture"] error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:imageFullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    imageFullPath = [imageFullPath stringByAppendingPathComponent:MD5(url)];
    BOOL ret = [UIImagePNGRepresentation(pic) writeToFile:imageFullPath atomically:YES];
    
}
UIImage* getSaveBitmapFile(NSString* url) {
    UIImage* image = nil;
//    int hash = HashCode(url);

    NSString *documentsFolder = getCacheFilePath();
    NSString *imageFullPath  = [documentsFolder stringByAppendingPathComponent:getDayT()];
    imageFullPath = [imageFullPath stringByAppendingPathComponent:MD5(url)];
    
    image = [[UIImage alloc]initWithContentsOfFile:imageFullPath];
    
    return image;
}
@interface DownLoad()
@property(strong) void (^Down_onFinish)(DownTask*task);
@property(strong) BOOL (^Down_isSuccess)(DownTask*task);
@property(strong) BOOL (^Down_isNeedLogin)(DownTask*task);
@property(strong) int (^Down_getStatue)(DownTask*task);
@property(strong) id (^Down_getResult)(DownTask*task);
@property(strong)  NSString* (^Down_getMsg)(DownTask*task);
@end



@implementation DownLoad

@synthesize runThread;
@synthesize tastList;

//同步下载，阻塞. + 类似静态函数
+(NSString*)getJstr:(DownTask*)task
{
    NSString *jsonString = nil;
    //加载一个NSURL对象
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSMutableURLRequest *request2 =  nil;
    
  
    
    // 设置执行方式
    if (task.method==DownMethod_GET) {
        
        //
        NSString* urlTemp = nil;
        
        if([task.url containsString:@"?"]){
            urlTemp =  [NSString stringWithFormat:@"%@&",task.url];
        }else{
            urlTemp =  [NSString stringWithFormat:@"%@?",task.url];
        }
        
        //urlTemp += "?";
        
        BOOL isFirst = YES;
        XJson* jsonObj = createParamJson([task getParam]);
        //Iterator<String> li =  jsonObj.keys();
        
        NSArray *DicArr = jsonObj.allKeys;
        
        NSString* valueTemp=nil;
        
        for (NSString *key in DicArr) {
            id obj = [jsonObj objectForKey:key];
            if ([obj isKindOfClass:[NSString class]]) {
                valueTemp = [NSString URLEncodedString:obj];
            }else{
                valueTemp =[jsonObj getString:key];
            }
            if(isFirst){
                isFirst = false;
                urlTemp = [NSString stringWithFormat:@"%@%@=%@",urlTemp,(NSString*)key,valueTemp];
            }else{
                urlTemp = [NSString stringWithFormat:@"%@&%@=%@",urlTemp,key,valueTemp];
            }
        }
        
          request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlTemp]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:30.0f];
        
        //缓存策略以及最长加载时间x
        [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request2.HTTPMethod = @"GET";
        
        
    }else  {
        request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:task.url]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:30.0f];
         [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //缓存策略以及最长加载时间x
        
        if (task.method==DownMethod_PUT) {
            request2.HTTPMethod = @"PUT";
            request2.HTTPBody = createParamJSTR2([task getParam]);
        }else  if (task.method==DownMethod_DELETE) {
            request2.HTTPMethod = @"DELETE";
            request2.HTTPBody = createParamJSTR2([task getParam]);
        }
        //上传文件
        else  if (task.method==DownMethod_POSTFILE) {
            request2.HTTPMethod = @"POST";
            NSString*boundary= [@"----boundary" stringByAppendingString:getNowText()];
            [request2 setValue:[@"multipart/form-data; boundary=" stringByAppendingString:boundary] forHTTPHeaderField:@"Content-Type"];
            request2.HTTPBody = createParamFile(task.paramList ,boundary);
            
        }
        else{
            request2.HTTPMethod = @"POST";
            request2.HTTPBody = createParamJSTR2([task getParam]);
        }
    }
    

    /*
    NSHTTPURLResponse* response=nil;
    
    NSError*err=nil;
    NSData *response2=[NSURLConnection sendSynchronousRequest:request2 returningResponse:&response error:&err];
  
    task.datastr = [[NSString alloc] initWithData:response2 encoding:NSUTF8StringEncoding];

    task.ResponseStatue =[response statusCode];
    */
    
    /**/
    //新的请求函数。NSURLConnection方法无法获取401状态
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask*sessionTask = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
   
        task.datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        task.ResponseStatue =[(NSHTTPURLResponse*)response statusCode];
        if (task.ResponseStatue==0) {
            task.ResponseStatue=-1;
        }
        dispatch_semaphore_signal(semaphore);
       
    }];

    [sessionTask resume];
    if (task.ResponseStatue==0) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    /**/
    XJson *jsonparam =  [XJson newWithString:task.datastr];
    //解密
    if (jsonparam!=nil) {
      
        task.json = jsonparam;//decode(jsonparam);
    }
    //sleep(3);
    return jsonString;
}
+(NSString*)getJstrDebugTest:(DownTask*)task
{
    sleep(1);
    task.ResponseStatue = 200;
    task.json=[XJson new];
    [task.json putString:@"message" Value:@"测试"];
    [task.json putBoolean:@"success" Value:true];
    XJson*data =  [XJson new];
    [data putString:@"loginName" Value:@"zzzzz"];
    [data putString:@"token" Value:@"token"];
    [task.json putJSON:@"data" Value:data];
    task.datastr= [task.json toString];
    
    return task.datastr;
}
//同步下载，阻塞. + 类似静态函数
+(NSString*)getJstrFormURL:(NSString*)url param:(NSString*)jstr
{
    NSString *jsonString = nil;
    //加载一个NSURL对象
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0f];   //缓存策略以及最长加载时间
    // 设置执行方式
    request2.HTTPMethod = @"post";
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    request2.HTTPBody = createParamJSTR(jstr,0);
    //request2.HTTPBody = createParamJSTR(@"{\"url\":\"http://text\"}",0);
    NSData *response2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:nil error:nil];
    
    jsonString = [[NSString alloc] initWithData:response2 encoding:NSUTF8StringEncoding];
    
    ////
    //jsonString = @"{\"type\":1,\"viewList\":[         \
    {\"type\":3,\"w\":-2,\"h\":50,\"g\":16,\"ts\":20,\"tstr\":\"标题3\",\"tc\":4294967295,\"tcp\":4294967295,\"bc\":4293684345,\"ml\":15},      \
    {\"type\":3,\"w\":-2,\"h\":0,\"weight\":1,\"g\":16,\"bc\":0,\"mr\":15},           \
    {\"type\":2,\"w\":-2,\"h\":-1,\"g\":64,\"bc\":2282159200,\"pl\":15,\"pt\":15,\"pr\":15,\"viewList\":[{\"type\":2,\"w\":45,\"h\":50,\"bc\":4282269246},{\"type\":2,\"w\":80,\"h\":50,\"bc\":4293684345}]},  \
    {\"type\":3,\"w\":-2,\"h\":0,\"weight\":2,\"g\":16,\"bc\":4293684345,\"ml\":15},  \
    {\"type\":16,\"w\":-2,\"h\":60,\"bc\":4282269246,\"pl\":15,\"pt\":5,\"pr\":15,\"pb\":5,\"viewList\":[{\"type\":3,\"w\":-1,\"h\":-1,\"ts\":16,\"bc\":4293684345,\"tstr\":\"ssss\",\"tc\":4294967295,\"tcp\":4294967295,\"id\":\"netform_menu.text\",\"lg\":65},{\"type\":3,\"w\":100,\"h\":36,\"g\":16,\"ts\":16,\"bc\":4293684345,\"tstr\":\"提交订单\",\"tc\":4294967295,\"tcp\":4294967295,\"lg\":68,\"bp\":\"local:universal/menuButton.png\",\"bpp\":\"local:universal/menuButtonPress.png\",\"clickable\":true,\"jsfun\":\"javascript:submit();\"}]}],\"javaScript\":\"{}\",\"infot\":3}";

    ////
    //jsonString = @"{\"type\":2,\"w\":-2,\"h\":40,\"g\":64,\"bc\":2282159200,\"pl\":15,\"pt\":10,\"pb\":0,\"pr\":15,\"viewList\":[{\"type\":2,\"w\":45,\"h\":50,\"bc\":4282269246},{\"type\":2,\"w\":80,\"h\":50,\"bc\":4293684345}]}";
    
    ////滚动行
    //jsonString = @"{\"type\":13,\"w\":-2,\"h\":140,\"g\":0,\"bc\":2282159200,\"pl\":0,\"pt\":0,\"pb\":0,\"pr\":0,\"viewList\":[{\"type\":2,\"w\":45,\"h\":50,\"bc\":4282269246},{\"type\":2,\"w\":80,\"h\":50,\"mt\":1050,\"bc\":4293684345}]}";
    
    ////
    //jsonString = @"{\"type\":1,\"viewList\":[{\"type\":16,\"w\":-2,\"h\":60,\"bc\":4282269246,\"pl\":15,\"pt\":5,\"pr\":15,\"pb\":5,\"viewList\":[{\"type\":3,\"w\":-1,\"h\":-1,\"ts\":16,\"bc\":4293684345,\"tstr\":\"ssss\",\"tc\":4294967295,\"tcp\":4294967295,\"id\":\"netform_menu.text\",\"lg\":65},{\"type\":3,\"w\":100,\"h\":36,\"g\":16,\"ts\":16,\"bc\":4293684345,\"tstr\":\"提交订单\",\"tc\":4294967295,\"tcp\":4294967295,\"lg\":68,\"bp\":\"local:universal/menuButton.png\",\"bpp\":\"local:universal/menuButtonPress.png\",\"clickable\":true,\"jsfun\":\"javascript:submit();\"}]}]}";
        
    return jsonString;
}
+(UIImage*)getImageFromFile:(NSString*)url
{
    UIImage* pic =  nil;
    if ([url  hasPrefix:@"local:"]) {
        NSString*name =  [url substringFromIndex:[@"local:" length]];
        pic =  [UIImage imageNamed:name];
    }else{
        pic =  getSaveBitmapFile(url);
    }
    return pic ;
}
+(NSData*)getImageNSDataWithUrl:(NSString*)url :(float) maxPx
{
    NSData *dataObj = nil;
    if(url){
        UIImage* pic =  [DownLoad getImageFromFile:url];
        if (maxPx>=1) {
            
            if (pic==nil) {
                NSURL *url2=[NSURL URLWithString:url];
                pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
                if (pic) {
                    saveBitmapFile(pic, url);
                }
            }
            
            if (pic) {
                float aaa= 1.0;
                float w = [pic size].width;
                float h = [pic size].height;
                if(w> maxPx || h > maxPx){
                    if(h>0 && h<w){
                        aaa =maxPx/w;
                    }else if(w>0 && w<h){
                         aaa =maxPx/h;
                    }
                    pic = imageScalWithImage(pic,aaa);
                }
                
                dataObj= UIImageJPEGRepresentation(pic, 1.0);
                
            }

        }else{
            if (pic==nil) {
                NSURL *url2=[NSURL URLWithString:url];
                pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
                if (pic) {
                    saveBitmapFile(pic, url);
                }
            }
            dataObj= UIImageJPEGRepresentation(pic, 1.0);
        }
    }
    
    return dataObj;
    
}
+(void)removeDownTast:(id)owner
{
    @synchronized(DOWNLOAD.tastList)
    {
       for (DownTask *tast in DOWNLOAD.tastList) {
           if (tast.owner==owner) {
               [DOWNLOAD.tastList removeObject:tast];
           }
       }
    }
}
+(void)addDownTast:(DownTask*)t
{
    if (DOWNLOAD==nil) {
        DOWNLOAD = [[DownLoad alloc] init];
    }
    
    [DOWNLOAD add:t];
    
}
-(void) add:(DownTask*)t
{
    @synchronized(DOWNLOAD.tastList)
    {
        bool include = false;
        for (DownTask *tast in tastList) {
            if (tast!=nil) {
                if (tast.back == t.back &&
                    tast.type == t.type &&
                    [tast.url isEqualToString:t.url]
                    ) {
                    include = true;
                    break;
                }
            }
        }
        if (include==false) {
             [tastList addObject:t];
        }
       
    }
    
    if (runThread==nil) {
        NSThread* thread;
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(callBackFun:) object:DOWNLOAD];
        [thread start];
        runThread = thread;
        
    }
    
}
+(void) setLogoutErr:(int)e1 Err:(int)e2 Act:(NSString*)actLogout
{
    _DownLoad_LogoutErr1=e1;
    _DownLoad_LogoutErr2=e2;
    _DownLoad_LogoutAct=actLogout;
}
+(void) setRequestSucc:(int)s1 Succ2:(int)s2
{
    _DownLoad_Succ1=s1;
    _DownLoad_Succ2=s2;
}
+(void) setResponseBlockOnFinish:(void (^)(DownTask*))onFinish
    GetStatue:(int (^)(DownTask*))getStatue
    IsSuccess:(BOOL (^)(DownTask*))isSuccess
    IsNeedLogin:(BOOL (^)(DownTask*))isNeedLogin
    GetResult:(id (^)(DownTask*))getResult
    GetMsg:(NSString* (^)(DownTask*))getMsg
{
    if (DOWNLOAD==nil) {
        DOWNLOAD = [[DownLoad alloc] init];
    }
    DOWNLOAD.Down_onFinish = onFinish;
    DOWNLOAD.Down_isSuccess = isSuccess;
    DOWNLOAD.Down_isNeedLogin = isNeedLogin;
    DOWNLOAD.Down_getStatue = getStatue;
    DOWNLOAD.Down_getResult = getResult;
    DOWNLOAD.Down_getMsg = getMsg;
}
+(void) startDownTast:(DownTask*)t
{
    if (DOWNLOAD==nil) {
        DOWNLOAD = [[DownLoad alloc] init];
    }
    
    [DOWNLOAD _startDownTast:t];
    
    
}
-(void) _startDownTast:(DownTask*)t
{
    [self performSelectorInBackground:@selector(doTask:) withObject:t];
}

-(void) callBackFun:(NSObject*)data
{
    while (true) {
        DownTask* tast = nil;
        @synchronized(tastList)
        {
            tast =[tastList objectAtIndex:0];
        }
        
        [self doTask:tast];
        
        @synchronized(tastList)
        {
            [tastList removeObject:tast];
            if ([tastList count]==0) {
                break;
            }
        }
    }
    
    DOWNLOAD.runThread = nil;
}
-(void)clearBlock:(DownTask*) tast
{
    tast.callBackFun= nil;
}
-(void) doTask:(DownTask*) tast
{
    [self down:tast];
    runOnUiTread2(^{
        if(DOWNLOAD.Down_onFinish){
            DOWNLOAD.Down_onFinish(tast);
        }
        // 状态码 0-99成功；900-999身份失效，需要重新登陆；1000-1099登录失败
        int err = [tast getStatue];
        if (tast.json!= nil && (err >= _DownLoad_LogoutErr1 && err <= _DownLoad_LogoutErr2)) {
            [XUserManager cleanDefaultUserLogin];
            [XAction callAction:_DownLoad_LogoutAct CalkBack:nil Data:nil Code:0];
        }
        //回调
        if (tast.back!=nil) {
            [tast.back onDownTastFinsh:tast];
        }else if(tast.callBackFun!=nil){
            tast.callBackFun(tast);
        }
        //清除引用
        [self clearBlock:tast];
    });
}
-(void) down:(DownTask*) tast
{
    if (tast.type==DownTastType_picture) {
        if ([tast.url  hasPrefix:@"local:"]) {
            NSString*name =  [tast.url substringFromIndex:[@"local:" length]];
            tast.pic =  [UIImage imageNamed:name];
        }
        else{
            
           tast.pic =  getSaveBitmapFile(tast.url);
           if (tast.pic == nil) {
               
               NSURL *url=[NSURL URLWithString:tast.url];
               tast.pic =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
               if (tast.pic!=nil) {
                   saveBitmapFile(tast.pic,tast.url);
               }
           }
        }
        
    }else if (tast.type==DownTastType_jsonStr){
        //tast.datastr = [DownLoad getJstrFormURL:tast.url param:tast.jstr];
#ifdef DownLoad_Debug
        tast.datastr = [DownLoad getJstrDebugTest:tast];
#else
        tast.datastr = [DownLoad getJstr:tast];
#endif
        
        //
    }
}

-(id) init
{
    self = [super init];
    if (self) {
        tastList =  [[NSMutableArray alloc]init];
        runThread = nil;
    }
    return self;
}
+(NSString*)getServerUrl
{
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Host"];
}
+(NSString*)getServerHost
{
    NSURL* uri  = [NSURL URLWithString:[self getServerUrl]];

    if(uri.port!=nil && uri.port>0){
        return [NSString stringWithFormat:@"%@://%@:%d/",uri.scheme,uri.host,uri.port.intValue];
    }else{
        return [NSString stringWithFormat:@"%@://%@/",uri.scheme,uri.host];
    }
    
}
@end




@implementation DownTaskKVNode
+(DownTaskKVNode*)newWithKey:(NSString*)k Value:(NSString*)v
{
    DownTaskKVNode*kv = [DownTaskKVNode new];
    kv.key=k;
    kv.value=v;
    return kv;
}
@end

//实现类
@implementation DownTask
//将变量按@property的要求初始化

@synthesize back;
@synthesize owner;
@synthesize url; //请求但目标地址
@synthesize type;//请求的类型


@synthesize jstr;//请求的参数
@synthesize time;//请求的参数
@synthesize name;//请求的参数
@synthesize datastr;//返回的json@end


@synthesize  pic;//返回的图片
@synthesize  forbiddenMsg;
@synthesize  paramList;//
+(instancetype)newWithURL:(NSString*)url Method:(int)method CallBack:(void (^)(DownTask* task))callback
{
    DownTask*task = [DownTask new];
    task.type = DownTastType_jsonStr;
    task.url = url;
    task.method=method;
    task.callBackFun = callback;
    return task;
}
-(id)init{
    self = [super init];
    [self onInit];
    return self;
}
        
-(id)initWithJsonTypeOwner:(id)owner CallBack:(id<DownTastCallBack>)callback OURL:(NSString*)url  JSTR:(NSString*)jstr TIME:(int)time FILENAME:(NSString*)name
{
    self = [super init];
    [self onInit];
    self.back = callback;
    self.callBackFun = nil;
    self.owner = owner;
    self.url = url;
    self.type = DownTastType_jsonStr;
    self.jstr = jstr;
    self.time = time;
    self.name = name;
    self.datastr = nil;
    forbiddenMsg = false;
    
    return self;
}
-(id)initWithPictureTypeOwner:(id)owner CallBack:(id<DownTastCallBack>)callback OURL:(NSString*)url FILENAME:(NSString*)name
{
    self = [super init];
    [self onInit];
    self.back = callback;
    self.callBackFun = nil;
    self.owner = owner;
    self.url = url;
    self.type = DownTastType_picture;
    self.jstr = nil;
    self.time = 0;
    self.name = name;
    self.datastr = nil;
    return self;
}
-(id)initWithJsonTypeOURL:(NSString*)url CallBack:(void (^)(DownTask*))callback
{
    self = [super init];
    [self onInit];
    self.back = nil;
 
    self.callBackFun = callback;
    self.owner = owner;
    if (url==nil) {
        self.url = [DownLoad getServerUrl];
    }else{
        self.url = url;
    }
    
    self.type = DownTastType_jsonStr;
    self.jstr = nil;
    self.time = 0;
    self.name = name;
    self.datastr = nil;
    return self;

}
-(void) onInit{
    self.back = nil;
    self.callBackFun = nil;
    self.owner = nil;
    self.url = nil;
    self.type = DownTastType_jsonStr;
    self.jstr = nil;
    self.time = 0;
    self.name = nil;
    self.datastr = nil;
    self.method=DownMethod_POST;
    paramList = [NSMutableArray new];
}
-(void)addParam:(NSString*)key Object:(NSObject*)value
{
    if([value isKindOfClass:[NSNumber class]]){
        value = [(NSNumber*)value stringValue];//   [NSString stringWithFormat:@"%@",value];
    }
    if (key!=nil) {
        if (value!=nil) {
            [paramList addObject:[DownTaskKVNode newWithKey:key Value:value]];
        }else{
            NSMutableArray*del=[NSMutableArray new];
            for (DownTaskKVNode*node in paramList) {
                if([node.key isEqualToString:key]){
                    [del addObject:node];
                }
            }
            [paramList removeObjectsInArray:del];
        }
    }
}
-(NSObject*)getObjectKey:(NSString*)key{
    for (DownTaskKVNode*node in paramList) {
        if([node.key isEqualToString:key]){
            return node.value;
        }
    }
    return nil;
}
-(void)addParam:(NSString*)key Value:(NSString*)value
{
    [self addParam:key Object:value];
}
-(NSString*)getParam:(NSString*)key
{
    return  (NSString*)[self getObjectKey:key];
}
-(XJson*)getParam
{
    XJson*json = [XJson new];
    for (DownTaskKVNode*node in paramList) {
        [json setValue:node.value  forKey:node.key];
    }
    return json;
}
   
-(void)addParam:(XJson*)param
{
    NSArray*KEYS =  [param allKeys];
    for (NSString *key in KEYS) {
        [self addParam:key Value:param[key]];
    }
}
-(void)addParam:(NSString*)key FileImage:(UIImage*)param
{
    [self addParam:key Object:param];
}
-(int) getStatue
{
    if (DOWNLOAD.Down_getStatue){
        return DOWNLOAD.Down_getStatue(self);
    }
    int statue = -10000;
    if (self.json) {
        statue = [self.json getInt:@"state" FailBack:statue];
    }
    return statue;
}
-(Boolean)isSucc
{
    if (DOWNLOAD.Down_isSuccess){
        return DOWNLOAD.Down_isSuccess(self);
    }
    Boolean succ = false;
    //状态码 0-99成功；900-999身份失效，需要重新登陆；1000-1099登录失败
    int succCode = [self getStatue];
    if (succCode>=_DownLoad_Succ1&&succCode<=_DownLoad_Succ2) {
        succ = true;
    }
    
    return succ;
    
}
-(NSString*)getErrStr
{
     NSString* err = @"网络错误";
    
    if (DOWNLOAD.Down_getMsg){
        NSString* err2 =DOWNLOAD.Down_getMsg(self);
        if(err2==nil){
            return err;
        }else{
            return err2;
        }
    }
    if (self.json) {
        err =[self.json  getString:@"msg" FailBack:err];
    }
    
    return err;
}
-(NSString*)getMsgStr
{
    if (DOWNLOAD.Down_getMsg){
        return DOWNLOAD.Down_getMsg(self);
    }
    
    NSString* msg = nil;
    if (self.json) {
        msg =[self.json  objectForKey:@"msg"];
    }
    return msg;
}
-(id)getResult
{
    if (DOWNLOAD.Down_getResult){
        return DOWNLOAD.Down_getResult(self);
    }
    return [self.json  objectForKey:@"data"];
}
-(NSString*)getResultStr
{
    return toString([self getResult]);
}
-(XJson*)getResultJson
{
    id ret =[self getResult];
    if ([XJson isXJson:ret]) {
        return ret;
    }else if([ret isKindOfClass:[NSDictionary class]]){
        return [XJson newWithNSDictionary:ret];
    }
    return nil;
}
-(XJson*)getResultJsonFailBack:(XJson*)json
{
    id ret =[self getResultJson];
    if (ret !=nil) {
        return ret;
    }
    return json;
}
-(XJsonArray*)getResultJsonArr
{
    id ret = [self getResult];
    if ([ret isKindOfClass:[NSArray class]]) {
        XJsonArray*arr = [XJsonArray new];
        for (int i=0; i<[ret count]; i++) {
            id oc =[ret objectAtIndex:i];
            if ([oc isKindOfClass:[NSDictionary class]]) {
                [arr addObject:[XJson newWithNSDictionary:oc]];
            }
            else{
                [arr addObject:oc];
            }
        }
        return arr;
    }
    return nil;
 
    
}


-(void) start
{
    [DownLoad startDownTast:self];
}

-(void) addToDownLoad
{
    [DownLoad addDownTast:self];
}

//-(void) run;
//{
//    NSString *str=[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:str];
//    
//    NSURLRequest *requrst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    //step 3：创建链接
//    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:requrst delegate:self];
//    if (connect) {
//        NSLog(@"链接成功");
//    }else {
//        NSLog(@"链接失败");
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    //接受一个服务端回话，再次一般初始化接受数据的对象
//    NSLog(@"返回数据类型：%@",[response textEncodingName]);
//    NSMutableData *d = [[NSMutableData alloc] init];
//    self.data = d;
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    //接受返回数据，这个方法可能会被调用多次，因此将多次返回数据加起来
//    [self.data appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    //连接结束
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//    NSString *mystr = [[NSString alloc] initWithData:data encoding:enc];
//    [callback onGetFinshData:mystr  URL:url param:jstr];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    //链接错误
//    NSLog(@"最后的结果：%@",@"链接错误");
//    [callback onGetFinshData:nil  URL:url param:jstr];
//}
@end



