//
//  ViewFactory.h
//  p2p
//
//  Created by zhangxiuquan on 15/4/22.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHeader.h"


/**
 *单个View的LinearLayoutCell
 */
@interface LCFrame : LinearLayoutCell

+(LCFrame*)newWithView:(UIView*)v;
-(LCFrame*)setContentView:(UIView*)v;
-(UIView*)getContentView;
-(UIView*)getBackView;
-(LinearLayoutCell*)getContentCell;

-(LCFrame*)setPLeft:(float)l;
-(LCFrame*)setPTop:(float)t;
-(LCFrame*)setPBottom:(float)b;
-(LCFrame*)setPRight:(float)r;
-(LCFrame*)setPading:(float)p;

-(LCFrame*)setContentGtavity:(int)g;
-(LCFrame*)setLayoutGtavity:(int)g;
-(LinearLayout*)getLinearLayout;
@end

@interface LCLinearLayout : LinearLayoutCell

+(LCLinearLayout*)newHorizontal;
+(LCLinearLayout*)newVertical;
-(LCLinearLayout*)addView:(LinearLayoutCell*)v;
-(LCLinearLayout*)setContentGtavity:(int)g;
-(LCLinearLayout*)setLayoutGtavity:(int)g;
-(LinearLayout*)getLinearLayout;
@end

@interface LFLinearLayout : LCFrame
+(LFLinearLayout*)newHorizontal;
+(LFLinearLayout*)newVertical;
-(LinearLayout*)getLinearLayout;
-(LinearLayout*)addView:(LinearLayoutCell*)v;

@end
//带外边距，用于标签
@interface LCLabel : LinearLayoutCell{
    //iOS 直接赋值 nil 有小动作 会卡。
    BOOL useAttributedText;

}
@property(nonatomic)float lineSpacing;

+(LCLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c;
+(LCLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc
                 Width:(int)w
                Height:(int)h
            MarginLeft:(float) ml
             MarginTop:(float) mt
           MarginRight:(float) mr
          MarginBottom:(float) mb;

-(LCLabel*)setText:(NSString*)text;
-(LCLabel*)setFontSize:(float)size;
-(LCLabel*)setFontColor:(int)color;
-(LCLabel*)setLineNum:(int)n;
-(LCLabel*)setTextAlignment:(NSTextAlignment)ali;
-(UILabel*)getLabel;
-(LCLabel*)setCanClickWithNormalColor:(int)color PressColor:(int)sColor TextColor:(int)tc;
-(LCLabel*)setCanNotClick:(int)uc TextColor:(int)tc;
-(LCLabel*)setWeightPriority1;
-(LCLabel*)setHorizontalWeightPriority1;
@end


//带外边距的双文本，用于金钱等标签
@interface LCLabelH2:LinearLayoutCell
@property (nonatomic)float lineSpace;
+(LCLabelH2*)newWithLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc;
-(LCLabelH2*)setLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc;
-(LCLabelH2*)setLeftText:(NSString*)ltext Right:(NSString*)rtext;
-(LCLabelH2*)setLeftFont:(UIFont *)leftFont Right:(UIFont *)rightFont;
-(LCLabelH2*)setMoney:(double)money Unit:(NSString*)unit;
-(UILabel*)getLabel;
@end

//
@interface LCLabelH3 : LinearLayoutCell

+(LCLabelH3*)newWithSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3;
-(void)setSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3;
-(void)setText1:(NSString*)t1 Text2:(NSString*)t2 Text3:(NSString*)t3;
-(void)setFont1:(UIFont *)f1 Font2:(UIFont *)f2 Font3:(UIFont *)f3;

@end




//带内外边距，内边距用于圆角，按钮
@interface LFLabel : LCFrame
+(LFLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc; 
+(LFLabel*)newWithText:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc
            MarginLeft:(float) ml
             MarginTop:(float) mt
           MarginRight:(float) mr
          MarginBottom:(float) mb
            PadingLeft:(float) pl
             PadingTop:(float) pt
           PadingRight:(float) pr
          PadingBottom:(float) pb
             UseWeight:(BOOL) use
                Weight:(float) w;

-(LFLabel*)setText:(NSString*)text;
-(LFLabel*)setFontSize:(float)size;
-(LFLabel*)setFontColor:(UIColor*)color;
-(LFLabel*)setLineNum:(int)n;
-(LFLabel*)setTextAlignment:(NSTextAlignment)ali;
-(UILabel*)getLabel;


@end
@interface LCImage : LCFrame
@property(nonatomic) NSString* holderPath;
+(LCImage*)newWithUrl:(NSString*)path
                Width:(float)w
               Height:(float)h;
+(LCImage*)newWithHolder:(NSString*)path
                   Width:(float)w
                  Height:(float)h;
+(LCImage*)newWithUrl:(NSString*)path
                Width:(float)w
               Height:(float)h
                 Mode:(UIViewContentMode)bc
           MarginLeft:(float) ml
            MarginTop:(float) mt
          MarginRight:(float) mr
         MarginBottom:(float) mb
           PadingLeft:(float) pl
            PadingTop:(float) pt
          PadingRight:(float) pr
         PadingBottom:(float) pb
            UseWeight:(BOOL) use
               Weight:(float) weight;
-(LCImage*)setUrl:(NSString*)path Holder:(NSString*)holder;
-(LCImage*)setUrl:(NSString*)path;
-(LCImage*)setMode:(UIViewContentMode)mod;
-(UIImageView*)getImageView;
@end

@interface LFTextField : LCFrame
+(LFTextField*)newWithHit:(NSString*)text
                FontSize:(float)size
               FontColor:(int)c
               BackColor:(int)bc;

-(LFTextField*)setText:(NSString*)text;
-(LFTextField*)setFontSize:(float)size;
-(LFTextField*)setFontColor:(UIColor*)color;
-(LFTextField*)setHitText:(NSString*)text;
-(LFTextField*)setHitFontSize:(float)size;
-(LFTextField*)setHitFontColor:(UIColor*)color;
-(LFTextField*)setTextAlignment:(NSTextAlignment)ali;
-(LFTextField*)setMaxLenght:(int)lenght;
-(int)getMaxLenght;
-(NSString*)getText;
-(UITextField*)getTextView;
-(NSInteger)getRealLength;
-(LFTextField*)setForPassword;
-(LFTextField*)showPasswordButtonOpen:(NSString*)path1 Colos:(NSString*)path2;
-(LFTextField*)setReturnForNext:(UITextField *)nextField;
-(LFTextField*)setForNumberInt:(int)lenght Float:(int)fLenght;
//设置金钱输入
-(LFTextField*)setForInputMoneyIntLenght:(int)lenght;
-(LCImage*)getPasswordButton;
-(LFTextField*)setPasswordButtonOpen:(BOOL)isopen;

-(LFTextField*)setOnReturnType:(UIReturnKeyType)type Tag:(id)tag Act:(SEL)sel;

//
-(LFTextField*)setOnChangeTarget:(nullable id)target action:(SEL)action;
//设置允许输入的文本
-(LFTextField*)setAllowText:(NSString*)text;
//设置允许输入的正则匹配
-(LFTextField*)setAllowMatches:(NSString*)matches;
@end

@interface LFEditText : LCFrame
+(LFEditText*)newWithHit:(NSString*)text
              FontSize:(float)size
             FontColor:(int)c
             BackColor:(int)bc;

-(LFEditText*)setText:(NSString*)text;
-(LFEditText*)setFontSize:(float)size;
-(LFEditText*)setFontColor:(UIColor*)color;
-(LFEditText*)setHitText:(NSString*)text;
-(LFEditText*)setHitFontSize:(float)size;
-(LFEditText*)setHitFontColor:(UIColor*)color;
-(LFEditText*)setLineNum:(int)n;
-(LFEditText*)setMaxLenght:(int)lenght;
-(LFEditText*)setTextAlignment:(NSTextAlignment)ali;
-(NSString*)getText;
-(UITextView*)getTextView;
-(void)setOnChangeTarget:(nullable id)target action:(SEL)action;
@end



@interface LFImage : LCFrame
+(LFImage*)newWithUrl:(NSString*)path
              Width:(float)w
               Height:(float)h;
+(LFImage*)newWithUrl:(NSString*)path
              Width:(float)w
             Height:(float)h
             Mode:(UIViewContentMode)bc
            MarginLeft:(float) ml
             MarginTop:(float) mt
           MarginRight:(float) mr
          MarginBottom:(float) mb
            PadingLeft:(float) pl
             PadingTop:(float) pt
           PadingRight:(float) pr
          PadingBottom:(float) pb
             UseWeight:(BOOL) use
                Weight:(float) weight;

-(LFImage*)setUrl:(NSString*)path;
-(LFImage*)setMode:(UIViewContentMode)mod;
-(UIImageView*)getImageView;
@end


@interface LCLine: LinearLayoutCell
//竖直方向的line
+(LCLine*)newVWith:(int)lineColor;
//水平方向的line
+(LCLine*)newHWith:(int)lineColor;

//竖直方向的line
+(LCLine*)newWidth1Color:(int)lineColor;
//水平方向的line
+(LCLine*)newHeight1Color:(int)lineColor;

-(XLine*)getLine;
@end

@interface ViewFactory : NSObject
 
@end
