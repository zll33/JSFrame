//
//  MyView.m
//  redStar
//
//  Created by zhangxiuquan on 15/10/26.
//  Copyright © 2015年 zhangxiuquan. All rights reserved.
//

#import "MyView.h"

@interface InputItem ()

@end
@implementation InputItem
-(void)setIconSize:(float)size Color:(int)color Width:(float)width
{
    [self.icon setFont:[UIFont systemFontOfSize:size ]];
    [self.icon  setTextColor:COLOR(color)];
    [self.iconCell  setHeight:WrapContent];
    if (width>0) {
        [self.iconCell setWidth:width];
    }
}
//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.input resignFirstResponder];
    return YES;
}
-(void)setForDone
{
    self.input.returnKeyType = UIReturnKeyDone;
    self.input.delegate=self;
}
@end

@interface AgreeItem ()


@property XBaseViewController *c;

@end

@implementation AgreeItem
+(AgreeItem*)newWith:(XBaseViewController*)c  Title:(NSString*)title Agree1:(NSString*)agree1 Onclick1:(void(^)(void))c1 Agree2:(NSString*)agree2 Onclick2:(void(^)(void))c2;
{
    AgreeItem*item = [AgreeItem new];
    [[item getLinearLayout] setOrientation:LinearLayoutHorizontal];
    
    [item setContentGtavity:GravityMiddleV];
    [item setHeight:44];
    [item setWidth:MatchPatrent];
    
    
    item.icon = [LFImage  newWithUrl:@"ok" Width:44 Height:44];
    [item.icon  setPading:15];
    [item.icon  setPRight:5];
    item.title=[LFLabel newWithText:title FontSize:12 FontColor:0xffA6A6A7 BackColor:0];
    [item addView:item.icon];
    [item addView:item.title];
    LCLinearLayout*lay =[LCLinearLayout newVertical];
    [lay setUse:true Weight:1];
    [lay setHeight:WrapContent];
    [item addView:lay];
    
    item.isAgree=true;
    [item.icon setUrl:@"duigoukuang2"];
    [item.icon setRadius:0 borderWidth:0 borderColor:0];
    item.c=c;
    
    
    __weak AgreeItem* me = item;
    [item.icon setOnClick:^{
        if (me.isAgree) {
            me.isAgree=false;
            [me.icon setUrl:@"duigoukuang1"];
            //[me.icon setRadius:8 borderWidth:1 borderColor:0xff888888];
        }else{
            me.isAgree=true;
            [me.icon setUrl:@"duigoukuang2"];
            //[me.icon setRadius:0 borderWidth:0 borderColor:0];
        }
    }];
    
   
    if (agree1!=nil) {
        item.agree1 =[LFLabel newWithText:agree1 FontSize:12 FontColor:Color_RedBack BackColor:0];
        [lay addView:item.agree1];
        //打开《居间借款协议》网页
        [item.agree1 setOnClick:c1];
    }

    if (agree2!=nil) {
        item.agree2 =[LFLabel newWithText:agree2 FontSize:12 FontColor:Color_RedBack BackColor:0];
        [item.agree2 setMTop:6];
        [lay addView:item.agree2];
        //打开《居间借款协议》网页
        [item.agree2 setOnClick:c2];
        [item setHeight:44+18];
    }
    
    return item;
}

@end

@interface MyView ()

@end

@implementation MyView


+(InputItem*)createInputItem:(NSString*)icon Msg:(NSString*)msg Hit:(NSString*)hit OnClick:(void(^)(void))click{
    InputItem*item = [InputItem new];
    [item getLinearLayout].orientation = LinearLayoutHorizontal;
    item.icon = [UILabel new];
    item.input  = [UITextField new];
    
    LinearLayoutCell*cell =[LinearLayoutCell newWithView:item.icon
                                               MarginLeft:15
                                                MarginTop:0
                                             MarginBottom:0
                                              MarginRight:15
                                                UseWeight:false
                                                   Weight:1];
    item.iconCell = cell;
    [cell setHeight:26];
    [cell setGravity:GravityLeft_MiddleV];
    [item.icon setFont:[UIFont fontWithName:@"icomoon" size:22]];
    [item.icon setTextColor:COLOR(Color_BlueBack)];
    [item.icon setText:icon];
    [item.icon setClipsToBounds:FALSE];
    [[item getLinearLayout] addView:cell];
    
    cell = [LinearLayoutCell newWithView:item.input
                              MarginLeft:0
                               MarginTop:0
                            MarginBottom:0
                             MarginRight:15
                               UseWeight:true
                                  Weight:1];
    //[cell setHeight:MatchPatrent];
    [item.input setTextColor:COLOR(0xff222222)];
    [item.input setFont:[UIFont systemFontOfSize:14]];
    [item.input setText:msg];
    [item.input setPlaceholder:hit];
    //[item.input setValue:COLOR(0xffe1e1e1) forKeyPath:@"_placeholderLabel.textColor"];
    //[item.input setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    item.input.autocorrectionType = UITextAutocorrectionTypeNo;
    item.input.autocapitalizationType = UITextAutocapitalizationTypeNone;
    item.input.clearButtonMode = UITextFieldViewModeWhileEditing;

    [[item getLinearLayout] addView:cell];
    [[item getLinearLayout]setGravity:GravityMiddleV];
    [item setPBottom:12];
    [item setPTop:12];
    [[item getLinearLayout]setClipsToBounds:FALSE];
   
    //[item setHeight:48];
    
    if (click!=nil) {
       UILabel*toLeft =  [UILabel new];
        cell =[LinearLayoutCell newWithView:toLeft
                                  MarginLeft:0
                                   MarginTop:0
                                MarginBottom:0
                                 MarginRight:15
                                   UseWeight:false
                                      Weight:1];
        [toLeft setFont:[UIFont fontWithName:@"icomoon" size:12]];
        [toLeft setTextColor:COLOR(0XFF888888)];
        //[toLeft setText:ICON_go];
        [cell setHeight:MatchPatrent];
        [cell setGravity:GravityLeft_MiddleV];
        [[item getLinearLayout] addView:cell];
        [item setNormalColor:0 PressColor:0X55000000];
        [item setOnClick:click];
        [item.input setEnabled:false];
    }
    [item setForDone];
    return item;

}
+(LCMoreItem*)createItemIcon:(NSString*)icon Title:(NSString*)title Msg:(NSString*)msg HasRight:(BOOL) hasRight  Target:(id)target Sel:(SEL) sel
{
    LCMoreItem*button = [ViewStytle createMoreItem:title Msg:msg Icon:icon HasRight:hasRight Target:target Sel:sel];
    
    [button LeftIconUseLabel:icon FontSize:30 Color:Color_BlueBack];
    [button.leftIconLabel setWidth:WrapContent];
    [[button.leftIconLabel getLabel]setFont:[UIFont fontWithName:@"icomoon" size:18]];
    [button.leftIconLabel setTextAlignment:NSTextAlignmentCenter];
    [button.leftTitle setTextColor:COLOR(0xff888888)];
    
    return button;
}

+(InputItem*)createInputItem:(NSString*)icon Msg:(NSString*)msg Hit:(NSString*)hit
{
    return [self createInputItem:icon  Msg:msg Hit:hit OnClick:nil];
}
+(AgreeItem*)createAgree:(XBaseViewController*)c  Msg:(NSString*)msg Url:(NSString*)url
{
   
    
    __weak XBaseViewController* con = c;
    return [AgreeItem newWith:c Title:@"我已阅读并同意" Agree1:msg Onclick1:^{
        [con showNewController:[WebController new]
                    Identifier:nil
                   RequestCode:0
                         Param:@{@"url":url}
                      animated:true];
        
    } Agree2:nil Onclick2:nil];
    
}

+(AgreeItem*)createAgree:(XBaseViewController*)c   Msg1:(NSString*)msg1 Onclick1:(void(^)(void))c1 Msg2:(NSString*)msg2 Onclick2:(void(^)(void))c2
{
    return  [AgreeItem newWith:c Title:@"我已阅读并同意" Agree1:msg1 Onclick1:c1 Agree2:msg2 Onclick2:c2];;
}
@end

@implementation ViewStytle(Style)
+(LCMoreItem*)createMoreItem:(NSString*)title Msg:(NSString*)msg Icon:(NSString*) leftImage HasRight:(BOOL) hasRight  Target:(id)target Sel:(SEL)action{
    LCMoreItem * item = [self createMoreItem:title :msg :leftImage :hasRight :target :action];
    [item.leftTitle setTextColor:COLOR(0xff333333)];
    [item.leftTitle setFont:[UIFont systemFontOfSize:14]];
    [item.msgLabel setTextColor:COLOR(0xff666666)];
    [item.msgLabel setFont:[UIFont systemFontOfSize:14]];
    return item;
}
@end
LCLabel* createButton(NSString*title,id target,SEL action){
    LCLabel* button;
    button = [LCLabel newWithText:title FontSize:18 FontColor:Color_Line ];
    [button setMTop:50];
    [button setWidth:218];
    [button setHeight:40];
    [button setGravity:GravityMiddleH];
    [button setTextAlignment:NSTextAlignmentCenter];
    [button setRadius:20 borderWidth:1 borderColor:Color_Line];
    if(target&&action){
        [button setOnClickTarget:target action:action];
    }
    [button setNormalColor:Color_ButtonNormal PressColor:Color_ButtonPress DisabledColor:Color_ButtonUnabel];
    
    return button;
}

NSString*getBankIcon(int bankid)
{
    
    NSString* idicon = @"zaixianzhifu";
    switch (bankid) {
            
        case 100: /* 邮政银行 */
            idicon = @"youzheng"; break;
        case 102:   /* 工商银行 */
            idicon = @"gongshang"; break;
        case 103:     /* 中国农业 */
            idicon = @"nongye"; break;
        case 104:     /* 中国银行 */
            idicon = @"zhongguo"; break;
        case 105:     /* 中国建设 */
            idicon = @"jianshe"; break;
        case 301:   /* 交通银行 */
            idicon = @"jiaotong"; break;
        case 302:  /* 中信银行 */
            idicon = @"zhongxin"; break;
        case 303:  /* 光大银行 */
            idicon = @"guangda"; break;
        case 304:   /* 华夏银行 */
            idicon = @"huaxia"; break;
        case 305:   /* 民生银行 */
            idicon = @"minsheng"; break;
        case 306:   /* 广发银行 */
            idicon = @"guangfa"; break;
        case 307:   /* 平安银行 */
            idicon = @"pingan"; break;
        case 308:  /* 招商银行 */
            idicon = @"zhaoshang"; break;
        case 309:   /* 兴业银行 */
            idicon = @"xingye"; break;
        case 310: /* 浦发银行 */
            idicon = @"pufa"; break;
        case 401:   /* 上海银行 */
            idicon = @"shanghai"; break;
        case 403:   /* 北京银行 */
            idicon = @"beijing"; break;
        case 408:   /* 宁波银行 */
            idicon = @"ningbo"; break;
        case 422:   /* 河北银行 */
            idicon = @"hebei"; break;
        case 434:   /* 天津银行 */
            idicon = @"tianjin"; break;
        case 440:  /* 微商银行 */
            idicon = @"huishang"; break;
        case 442:   /* 哈尔滨银行 */
            idicon = @"haerbing"; break;
        case 447:   /* 兰州银行 */
            idicon = @"lanzhou"; break;
        case 450:   /* 青岛银行 */
            idicon = @"qingdao"; break;
        case 781:   /* 厦门银行 */
            idicon = @"xiamen"; break;
        case 3054:   /* 厦门国际银行 */
            idicon = @"xiamenguoji"; break;
        case 1401:   /* 上海农村商业银行 */
            idicon = @"shanghainongshang"; break;
        case 3002:   /* 南洋商行 */
            idicon = @"nayangshangye"; break;
        case 3010:  /* 花旗银行 */
            idicon = @"citi"; break;
        case 3001:  /* 东亚银行 */
            idicon = @"dongya"; break;
        case 12345:   /* 在线支付 */
            idicon = @"zaixianzhifu"; break;
        case 1405:   /* 广州农商银行*/
            idicon = @"guangzhounongshang";
            break;
    }
    return idicon;
    
}

@implementation   DownTask(BankInfo)

-(NSString*)getBankInfoOrErr
{
    XJson*ret =[self getResultJson];
    if (ret && [ret objectForKey:@"info"]) {
        return [ret getString:@"info"];
    }
    return [self getErrStr];
}

@end

UIImageView* createToRight()
{
    UIImageView *icon = [UIImageView new];
    [icon setImage:[UIImage imageNamed:@"jiantou"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setWH:icon MultW:0 MultH:0 DW:20 DH:20];
    return icon;
    
}
LinearLayoutCell* createToRightCell(){
    
    UIImageView *icon = [UIImageView new];
    LinearLayoutCell*cell = [LinearLayoutCell newWithView:icon];
    [icon setImage:[UIImage imageNamed:@"jiantou"]];
    [cell setMLeft:15];
    [cell setMRight:15];
    [cell setWidth:20];
    [cell setHeight:20];
    return cell;
}
BOOL isAllNumber(NSString* number){
    
    NSString * regex   = @"^[0-9]{0,}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch       = [pred evaluateWithObject:number];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}
BOOL isMobileNumber(NSString *mobileNum) {
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum]
         || [regextestcm evaluateWithObject:mobileNum]
         || [regextestct evaluateWithObject:mobileNum]
         || [regextestcu evaluateWithObject:mobileNum])) {
        return YES;
    }
    
    return NO;
}

BOOL isPassword2(NSString* password){
    //NSString*TESU=@"!@#$%^&*()_+|{}";  ：\  .  *  ^  &  [  ]  {  }  ?  需要转义
    //不能只含一种
    NSString *notOnlyOne  = @"(?!^\\d+$)(?!^[a-zA-Z]+$)(?!^[\\!@#$%\\^\\&\\*\\(\\)_+|\\{\\}]+$).{6,18}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", notOnlyOne];
    if(![pred evaluateWithObject:password]){
        return false;
    }
    //必须是数字字母字符
    NSString*onlyWord = @"^[a-zA-Z0-9\\!@#$%\\^\\&\\*\\(\\)_+|\\{\\}]{6,18}";
    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", onlyWord];
    
    if([pred evaluateWithObject:password]){
        return true;
    }
    return false;
}
BOOL isIdCardNumber(NSString *value) {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    
    if (!value) {
        return NO;
    }else {
        length = value.length;
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]){
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag){
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year = 0;
    
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value  substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value  substringWithRange:NSMakeRange(3,1)].intValue + [value  substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value  substringWithRange:NSMakeRange(4,1)].intValue + [value  substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value  substringWithRange:NSMakeRange(5,1)].intValue + [value  substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value  substringWithRange:NSMakeRange(6,1)].intValue + [value  substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value  substringWithRange:NSMakeRange(7,1)].intValue *1 + [value  substringWithRange:NSMakeRange(8,1)].intValue *6 + [value  substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
            
        default:
            return NO;
            
    }
}

