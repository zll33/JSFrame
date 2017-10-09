//
//  HelpApi.m
//  kzd123
//
//  Created by kzd on 14-3-19.
//  Copyright (c) 2014年 kzd. All rights reserved.
//



#import "HelpApi.h"
#import <CommonCrypto/CommonDigest.h>
#import "BaiduMobStat.h"

void startBaiduTongji(NSString*appId,NSString*channelId){
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    
    if([appId length]>0){
        [statTracker startWithAppId:appId];
    }else{
        [statTracker startWithAppId:@"72f5d64bf9"];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    //NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    if([channelId length]>0){
        statTracker.channelId =channelId;
    }else{
#ifdef DEBUG
        statTracker.channelId =[NSString stringWithFormat:@"%@-Debug",app_Name];//设置您的app的发布渠道
#else
        statTracker.channelId =[NSString stringWithFormat:@"%@-Release",app_Name];//设置您的app的发布渠道
#endif
    }
    

    
    
    //statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
    //statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    //statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    //statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    //statTracker.shortAppVersion  = ; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
    /*如果有需要，可自行传入adid
     NSString *adId = @"";
     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
     adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     }
     statTracker.adid = adId;
     */
    
    
}


NSNumberFormatterRoundingMode  __MoneyRoundingMode = NSRoundDown;

UIColor* ARGB(CGFloat A,CGFloat R,CGFloat G,CGFloat B){
    CGFloat r= R;
    CGFloat g= G;
    CGFloat b= B;
    CGFloat a= A;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}
UIColor *COLOR(int c){
    CGFloat r= c>>16&0x000000ff;
    CGFloat g= c>>8&0x000000ff;
    CGFloat b= c>>0&0x000000ff;
    CGFloat a= c>>24&0x000000ff;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}
XBaseViewController * findXBaseViewController(UIView*view)
{
    return (XBaseViewController*)findViewController(view);
}
UIViewController * findViewController(UIView*view)
{
    UIViewController * controller =nil;
    id target=view;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            controller = target;
            break;
        }
    }
    return controller;
}

//CGFloat scal = 0.75;

CGFloat scal = 1;

//CGFloat scal = 0.5;

CGFloat PD2PX(CGFloat netNum)
{
    return netNum*scal;
}
CGFloat PX2PD(CGFloat netNum)
{
    return netNum/scal;
}

NSString *MD5(NSString *str)
{
        const char *cStr = [str UTF8String];
        unsigned char result[16];
        CC_MD5( cStr, strlen(cStr), result );
    
    
        NSString * MD5sTR =[NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",

                result[0],result[1],result[2],result[3],
    
                result[4],result[5],result[6],result[7],
    
                result[8],result[9],result[10],result[11],
    
                result[12],result[13],result[14],result[15]];
    
    //NSLog(@"%@",str);
    //NSLog(@"%@",MD5sTR);
    //return     @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x";
    return MD5sTR;
    
}
NSString *timeFormat(NSString* fo,long t)
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fo];
    NSDate* date  = [[NSDate alloc]initWithTimeIntervalSince1970:t/1000];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
//全舍
NSString* numberFormat(NSString* format,double num)
{
    NSString* str =nil;
    NSNumberFormatter*formatter =[NSNumberFormatter new];
    formatter.numberStyle=NSNumberFormatterDecimalStyle;
    formatter.positiveFormat=format;
    formatter.roundingMode=__MoneyRoundingMode;

    str= [formatter stringFromNumber:[NSNumber numberWithDouble:num]];
    
    return str;
}
void setNumberFormatRoundingMode(NSNumberFormatterRoundingMode mode){
    __MoneyRoundingMode = mode;
}
//int HashCode(NSString* s) {
//    int hash = 0;
//    NSData *testData = [s dataUsingEncoding: NSUTF8StringEncoding];
//    Byte *testByte = (Byte *)[testData bytes];
//    int len = [testData length];
//
//    for (int i = 0; i < len; i++) {
//        hash <<= 1;
//        if (hash < 0) {
//            hash |= 1;
//        }
//        hash ^= testByte[i];
//    }
//    if ([s isEqualToString:@" "]) {
//
//    }
//    NSLog(@"%@",s);
//    NSLog(@"%d",hash);
//    return hash;
//}
NSString* getCacheFilePath(){
    
    NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    //    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *cacheFullPath   = [documentsFolder stringByAppendingPathComponent:@"CacheStrFile"];
    return [pathes objectAtIndex:0];
}
bool saveCacheStrFile(NSString* pageUrl,NSString* str)
{
    bool ret= false;
    NSString* name = MD5(pageUrl);//[NSString stringWithFormat:@"%d",HashCode(pageUrl)];
    NSString *cacheFullPath   = getCacheFilePath();
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheFullPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheFullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([name length]>0) {
        cacheFullPath = [cacheFullPath stringByAppendingPathComponent:name];
        ret = [str writeToFile:cacheFullPath
                    atomically:NO
                      encoding:NSUTF8StringEncoding
                         error:nil];
        
    }
    return ret;
}
NSString*  readCacheStrFile(NSString* pageUrl)
{
    NSString* name =MD5(pageUrl);// [NSString stringWithFormat:@"%d",HashCode(pageUrl)];
    NSString * str = nil;
    NSString *cacheFullPath   = getCacheFilePath();
    cacheFullPath = [cacheFullPath stringByAppendingPathComponent:name];
    
    str = [NSString stringWithContentsOfFile:cacheFullPath
                                    encoding:NSUTF8StringEncoding
                                       error:nil];
    
    return str;
}
bool  deleteCacheStrFile(NSString* pageUrl)
{
    bool ret= false;
    NSString* name = MD5(pageUrl);//[NSString stringWithFormat:@"%d",HashCode(pageUrl)];
    NSString *cacheFullPath   = getCacheFilePath();
    cacheFullPath = [cacheFullPath stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ret = [fileManager removeItemAtPath:cacheFullPath error:nil];
    
    return ret;
}
bool saveXViewToCacheStrFileIF(NSString* pageUrl,NSString*xviewJStr,XJson *json,long localT)
{
    bool ret= false;
    /*
    id value =[json objectForKey:(XViewTable_infoTime)];
    if (value)
    {
        long t =[value longValue];
        if(t!=0 && localT!=t) {
            ret = saveCacheStrFile(pageUrl,xviewJStr);
        }
    }
    */
    return ret;
}





void runOnUiTread(id object,SEL runFun,id data)
{
    if ([NSThread isMainThread]) {
        [object performSelector:runFun withObject:data];
    }else{
        [object performSelectorOnMainThread:runFun withObject:data waitUntilDone:false];
    }
}

@interface XTheadHandel : NSObject
{
    void (^runFun)(void);
    void (^runFun3)(id);
}

+(void) runFunOnUiThread:(void (^)(void))run;
-(void) callBack:(id)data;

+(void) runFunOnUiThread3:(void (^)(id))run;
-(void) callBack3:(id)data;

+(void) runOnNewUiTread:(void (^)(void))run;
-(void) callNewBack:(id)data;
@end

@implementation XTheadHandel

+(void) runFunOnUiThread:(void (^)(void))run
{
    XTheadHandel * handel = [[XTheadHandel alloc]init];
    
    
    [handel call:run];
    return;
}
-(void) call:(void (^)(void))run{
    runFun = run;
    [self performSelectorOnMainThread:@selector(callBack:) withObject:nil waitUntilDone:false];
    
}
-(void) callBack:(id)data
{
    runFun();
    runFun = nil;
}

+(void) runFunOnUiThread3:(void (^)(id))run :(id)data
{
    XTheadHandel * handel = [[XTheadHandel alloc]init];
    
    
    [handel call3:run :data];
    return;
}

+(void) runOnNewUiTread:(void (^)(void))run
{
    XTheadHandel * handel = [[XTheadHandel alloc]init];
    [handel performSelectorOnMainThread:@selector(callNewBack:) withObject:run waitUntilDone:true];
}
+(void) runOnTread:(void (^)(void))run
{
    XTheadHandel * handel = [[XTheadHandel alloc]init];
    [handel performSelectorInBackground:@selector(callNewBack:) withObject:run ];
    
}

-(void) callNewBack:(id)data{
    void (^runFun)(void) = data;
    runFun();
}


-(void) call3:(void (^)(id))run:(id)data
{
    runFun3 = run;
    [self performSelectorOnMainThread:@selector(callBack3:) withObject:data waitUntilDone:false];
    
}
-(void) callBack3:(id)data
{
    runFun3(data);
    runFun3 = nil;
}
@end


void runOnUiTread2(void (^runFun)(void))
{
    if ([NSThread isMainThread]) {
        runFun();
    }else{
        [XTheadHandel runFunOnUiThread:runFun];
    }
    
}

void runOnUiTread3(void (^runFun)(id),id data)
{
    if ([NSThread isMainThread]) {
        runFun(data);
    }else{
        [XTheadHandel runFunOnUiThread3:runFun:data];
    }
    
}


void runOnNewUiTread(void (^runFun)(void))
{
    runOnTread(^{
        [XTheadHandel runOnNewUiTread:runFun];
    });
    
}
void runOnTread(void (^runFun)(void))
{
    [XTheadHandel runOnTread:runFun];
}

void runOnTreadDelay(void (^runFun)(void),NSTimeInterval delay)
{
    [[NSObject new] run:runFun delay:delay];
}

NSString*getMoney(double money)
{
    return numberFormat(@"###,###,###,##0.00",money);
}
NSString*getAstrC(NSString* str,int counta,int countc)
{
    
    if ([str length]>(counta+countc)) {
        
        NSString*temp = [str substringToIndex:counta];
        
        for (int i=counta; i<[str length]-countc; i++) {
            temp = [NSString stringWithFormat:@"%@%@",temp,@"*"];
        }
        str = [NSString stringWithFormat:@"%@%@",temp,[str substringFromIndex:[str length]-countc]];
    }
    return str;
}
NSString* getEmailStr(NSString* mailAddress){
    if (mailAddress.length > 3) {
        NSRange range = [mailAddress rangeOfString:@"@"];
        NSMutableString *replaceStr = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < range.location-3; i++) {
            [replaceStr appendString:@"*"];
        }
        return [mailAddress stringByReplacingCharactersInRange:NSMakeRange(3, range.location-3) withString:replaceStr];
    }
    return mailAddress;
}
NSString *changeFloatLastzero(NSString *stringFloat)
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}
NSString*getProgress(double p)
{
    //return changeFloatLastzero([NSString stringWithFormat:@"%0.2f",p]);
    return [NSString stringWithFormat:@"%0.2f",p];
}
//@"dd-MMM-yyy,hh:mm:ss"
NSString*getTime(NSString *Format,long long time)
{
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:(time/1000)];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=Format;
    NSString*STR =[dateFormatter stringFromDate:date];
    return STR ;
}
//yyyy-MM-dd hh:mm:ss
NSString*getNowTime(NSString *Format)
{
    NSDate *date =[NSDate new];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=Format;
    NSString*STR =[dateFormatter stringFromDate:date];
    return STR ;
}
NSString*getTimeFormText(NSString*txt, NSString *txtFormat,NSString*returnFormat)
{
    //字符串转换成时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:txtFormat];
    NSDate*date = [formatter dateFromString:txt];
    //时间转换成字符串
    [formatter setDateFormat:returnFormat];
    NSString*STR =[formatter stringFromDate:date];
    return STR ;
}
NSString*getTimeNow(NSString *Format)
{
    return getNowTime(Format);
}
@implementation NSObject(ThreadAfterDelay)
-(void)run:(void(^)(void))bolck delay:(NSTimeInterval)delay
{
    [self performSelector:@selector(_ThreadAfterDelayCallBack:) withObject:bolck afterDelay:delay];
}
-(void)_ThreadAfterDelayCallBack:(void(^)(void))bolck
{
    bolck();
}
@end


@implementation NSString (JS)
- (BOOL)isJsEmpty
{
    return self==nil || ([self isEqualToString:@"null"]);
}
- (NSString*)getJsStr_butEmpty
{
    if ([self isJsEmpty]) {
        return nil;
    }
    return self;
}

+ (NSString *)URLEncodedString:(NSString *)input
{
    NSString *outputStr =(NSString *)
    CFBridgingRelease(
                      CFURLCreateStringByAddingPercentEscapes
                      (kCFAllocatorDefault,
                       (CFStringRef)input ,
                       NULL ,
                      CFSTR("!*'();:@&=+$,/?%#[]"),
                        kCFStringEncodingUTF8));
    
    return outputStr;
}

@end

@implementation NSNull (JS)

- (NSString*)getJsStr_butEmpty
{
    return nil;
}
@end
@interface WeakObject()
@property(nonatomic)XJson*tagJson;

@end
@implementation WeakObject
@synthesize tagJson;
+(WeakObject*)newWeakObject:(NSObject*)object{
    WeakObject*wo = [WeakObject new];
    [wo setObject:object];
    return wo;
}
-(void)setObject:(NSObject*)object{
    _object=object;
}
-(id)getTag:(NSString*)key{
    if(tagJson){
        return tagJson[key];
    }
    return nil;
}
-(void)setTagKey:(NSString*)key Value:(NSObject*)value{
    if(tagJson==nil){
        tagJson = [XJson new];
    }
    [tagJson setObject:value forKey:key];
}
@end
/*
 缩放图片，将图片缩放为指定尺寸大小
 */
UIImage* imageScalWithImage(UIImage*image ,float a)
{
    CGSize newSize = CGSizeMake(image.size.width*a, image.size.height*a);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//UIColor 转UIImage
UIImage* createImageWithColor(int color)
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO ,1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [COLOR(color) CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
 
//    
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    uint32_t* pointColor = &color;
//    int imageWidth = 1;
//    int imageHeight = 1;
//    size_t  bytesPerRow = imageWidth * 4;
//    
////    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
////    Byte a = (color>>24)&0xf;
////    Byte r = (color>>18)&0xf;
////    Byte g = (color>>8)&0xf;
////    Byte b = (color>>0)&0xf;
//    
//    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, pointColor, 1*1*4, NULL);
//    CGImageRef imageRef = CGImageCreate(1, 1, 8, 32, bytesPerRow, colorSpace,
//                                        kCGBitmapByteOrderDefault,
//                                        //kCGImageAlphaFirst | kCGBitmapByteOrder32Big,
//                                        //kCGBitmapByteOrder32Big,
//                                        //kCGBitmapByteOrder32Little,
//                                        //kCGBitmapAlphaInfoMask,
//                                        dataProvider,
//                                        NULL, NO, kCGRenderingIntentDefault);
//    
//    
//    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
//    
//    
//    CGImageRelease(imageRef);
//    CGDataProviderRelease(dataProvider);
//    CGColorSpaceRelease(colorSpace);
//    
//    
//    int w = resultUIImage.size.width;
//    int h = resultUIImage.size.height;
//    
//    
//    return resultUIImage;
    
}

NSString* toString(NSObject* strId)
{
    NSString* ret = nil;
    if ([strId isKindOfClass:[NSString class]]) {
        return strId;
    }else if ([strId isKindOfClass:[ NSNumber class]]) {
        NSNumber* thiz = strId;
        ret = [thiz stringValue];
    }else if([strId isKindOfClass:[ XJson class]]) {
        ret =[(XJson*)strId toString];
    }else if([strId isKindOfClass:[XJsonArray class]]) {
        ret =[(XJsonArray*)strId toJString];
    }
    return ret;
}

NSString* getFirstPinYin(NSString* str)
{
    NSString*  pinyin=nil;
    if ([str length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:[str substringWithRange:NSMakeRange(0,1)]];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                
                pinyin=[[ms uppercaseString]  substringWithRange:NSMakeRange(0,1)] ;
            }
        }
     
    }
    return pinyin;
}



NSString * getHasLaunchTag(){
    XJson *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString * tag = [NSString  stringWithFormat:@"hasLaunched_%@",app_build,nil];
    return tag;
}

bool isFirstLaunch()
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:getHasLaunchTag()]) {
        return NO;
    }
    return YES;
}
void setNotFirstLaunch()
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:getHasLaunchTag()];
}

CGSize measureView(UIView* view,CGSize size,int hPriority,int vPriority){
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        view.bounds = CGRectMake(0, 0, size.width, size.height);
        return  [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
    }else{
        return [view systemLayoutSizeFittingSize:size
                             withHorizontalFittingPriority: 1000//水平方向约束要求为self.contentSize.width，优先级1000，最高，即必须
                                   verticalFittingPriority: 1//垂直方向约束要求为0，优先级1，最低。即不作约束
                ];
    
    }
}

NSString* cutFloatZero(float valueNum){
    NSString *str =[NSString stringWithFormat:@"%f",valueNum];
    NSString *value =str;
    
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
    return value;
}
NSString*getBaseUrl(NSString*url)
{
    NSURL *nsurl =[NSURL URLWithString:url];
    NSString*se =nsurl.scheme;
    NSString*host =nsurl.host;
    NSNumber *port =nsurl.port;
    
    NSString*path=nsurl.path;
    if ([path length]>0) {
        NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location>=0) {
            path = [path substringToIndex:range.location+1];
        }else{
            path = nil;
        }
    }
    if (![path hasPrefix:@"/"]) {
        path = [NSString stringWithFormat:@"/%@",path];
    }
    if (![path hasSuffix:@"/"]) {
        path = [NSString stringWithFormat:@"%@/",path];
    }
    
    if (port) {
        url = [NSString stringWithFormat:@"%@://%@:%d%@",se,host,[port intValue],path];
    }else{
        url = [NSString stringWithFormat:@"%@://%@%@",se,host,path];
    }
    return url;
}
float getStrWidth(NSString*str,float size)
{
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:size]};
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:opts
                                  attributes:attributes
                                     context:nil];
    
    return rect.size.width;
}
//截取时间"2016-04-09 18:34:56" -> "2016-04-09"
NSString*getDataForm(NSString* time){
    if ([time length]>10) {
        return [time substringToIndex:10];
    }
    return time;
}
//截取时间"2016-04-09 18:34:56" -> "18:34:56"
NSString*getTimeForm(NSString* time){

    if ([time length]>=19) {
        return [time substringWithRange:NSMakeRange(11, 8)];
    }
    return time;
}
//判断手机号码格式是否正确
BOOL isMobile(NSString *mobile)
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length < 11||mobile.length > 13)
    {
   
        return NO;
    }else{
        /** 座机电话格式验证 **/
        NSString * PHONE_CALL_PATTERN = @"^(\\d{3,4}-)\\d{7,8}$";
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONE_CALL_PATTERN];
        BOOL isMatch0 = [pred0 evaluateWithObject:mobile];
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch0 || isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
//身份证号码是否正确
BOOL isCorrect(NSString *identityString)
{
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]&&![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
//    NSMutableArray *IDArray = [NSMutableArray array];
//    // 遍历身份证字符串,存入数组中
//    for (int i = 0; i < 18; i++) {
//        NSRange range = NSMakeRange(i, 1);
//        NSString *subString = [IDNumber substringWithRange:range];
//        [IDArray addObject:subString];
//    }
//    // 系数数组
//    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
//    // 余数数组
//    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
//    // 每一位身份证号码和对应系数相乘之后相加所得的和
//    int sum = 0;
//    for (int i = 0; i < 17; i++) {
//        int coefficient = [coefficientArray[i] intValue];
//        int ID = [IDArray[i] intValue];
//        sum += coefficient * ID;
//    }
//    // 这个和除以11的余数对应的数
//    NSString *str = remainderArray[(sum % 11)];
//    // 身份证号码最后一位
//    NSString *string = [IDNumber substringFromIndex:17];
//    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
//    if ([str isEqualToString:string]) {
//        return YES;
//    } else {
//        return NO;
//    }
}

