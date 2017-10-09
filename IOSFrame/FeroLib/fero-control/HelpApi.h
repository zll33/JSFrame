//
//  HelpApi.h
//  kzd123
//
//  Created by kzd on 14-3-19.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBaseViewController.h"
#import "XJson.h"

#define SCRW [[UIScreen mainScreen] applicationFrame].size.width
#define SCRH [[UIScreen mainScreen] applicationFrame].size.height

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//启动初始化百度统计，
void startBaiduTongji( NSString* appId,NSString* channelId);

UIColor* ARGB(CGFloat A,CGFloat R,CGFloat G,CGFloat B);
UIColor *COLOR(int c);
CGFloat PD2PX(CGFloat netNum);
CGFloat PX2PD(CGFloat netNum);
NSString* getCacheFilePath();
NSString*MD5(NSString* s);
NSString* timeFormat(NSString* format,long time);
NSString* numberFormat(NSString* format,double num);
//NSRoundDown 全舍弃小数，NSNumberFormatterRoundHalfEven 四设误入
void setNumberFormatRoundingMode(NSNumberFormatterRoundingMode mode);
//int HashCode(NSString* s);

bool saveCacheStrFile(NSString* pageUrl,NSString* str);
bool saveXViewToCacheStrFileIF(NSString* pageUrl,NSString*xviewJStr,XJson *json,long localT);
NSString*  readCacheStrFile(NSString* pageUrl);
bool  deleteCacheStrFile(NSString* pageUrl);
void runOnUiTread(id object,SEL aSelector,id data);
void runOnUiTread2(void (^runFun)(void));
void runOnUiTread3(void (^runFun)(id),id data);
void runOnNewUiTread(void (^runFun)(void));
void runOnTread(void (^runFun)(void));

//获取金钱格式1,000.00
NSString*getMoney(double money);
//自动加*  起始个数counta，结束个数countc
NSString*getAstrC(NSString* str,int counta,int countc);
//邮箱地址自动加*
NSString* getEmailStr(NSString* email);

NSString*getProgress(double p);
NSString*changeFloatLastzero(NSString *stringFloat);
//@"dd-MMM-yyy,hh:mm:ss"
NSString*getTime(NSString *Format,long long time);
//yyyy-MM-dd hh:mm:ss
NSString*getNowTime(NSString *Format);
NSString*getTimeNow(NSString *Format);
//时间字符串转换
NSString*getTimeFormText(NSString*txt, NSString *txtFormat,NSString*returnFormat);

void runOnTreadDelay(void (^runFun)(void),NSTimeInterval delay);
@interface NSObject(ThreadAfterDelay)
-(void)run:(void(^)(void))bolck delay:(NSTimeInterval)delay;
@end

@interface NSString (JS)
- (BOOL)isJsEmpty;
- (NSString*)getJsStr_butEmpty;
+ (NSString *)URLEncodedString:(NSString *)input;
@end

@interface NSNull (JS)
- (NSString*)getJsStr_butEmpty;
@end

@interface WeakObject:NSObject
@property(nonatomic)id tag;
@property(nonatomic,weak)NSObject *object;
+(WeakObject*)newWeakObject:(NSObject*)object;
-(id)getTag:(NSString*)key;
-(void)setTagKey:(NSString*)key Value:(NSObject*)value;
-(id)getTag;
-(void)setTag:(id)value;
@end

UIImage* imageScalWithImage(UIImage*image ,float a);
UIImage* createImageWithColor(int color);
UIViewController * findViewController(UIView*view);
XBaseViewController* findXBaseViewController(UIView*view);

NSString* toString(NSObject* strId);
NSString* getFirstPinYin(NSString* str);
bool isFirstLaunch();
void setNotFirstLaunch();
CGSize measureView(UIView* view,CGSize size,int hPriority,int vPriority);
NSString* cutFloatZero(float valueNum);
NSString*getBaseUrl(NSString*url);

float getStrWidth(NSString*str,float size);
//截取时间"2016-04-09 18:34:56" -> "2016-04-09"
NSString*getDataForm(NSString* time);
//截取时间"2016-04-09 18:34:56" -> "18:34:56"
NSString*getTimeForm(NSString* time);
//身份证号码是否正确
BOOL isCorrect(NSString*number);
//判断手机号码格式是否正确
BOOL isMobile(NSString *mobile);
