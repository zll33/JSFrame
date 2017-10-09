//
//  Label2.m
//  moi
//
//  Created by zhangxiuquan on 16/7/16.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import "Label2.h"
#import "HelpApi.h"
@interface LabelH2()
{
    float lsize;
    int lcolor;
    float rsize;
    int rcolor;
    NSString* ltext;
    NSString* rtext;
}
@end

@implementation LabelH2
@synthesize leftFont;
@synthesize rightFont;
+(LabelH2*)newWithLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc
{
    LabelH2 *l2 = [LabelH2 new];
    [l2 setLeftSize:ls Color:lc RightSize:rs Color:rc];
    return l2;
}
-(void)setLeftFont:(UIFont *)lFont Right:(UIFont *)rFont{
    leftFont = lFont;
    rightFont = rFont;
    [self build];
}
-(void)setLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc{
    lsize = ls;
    lcolor =lc;
    rsize =rs;
    rcolor =rc;
    leftFont = nil;
    rightFont = nil;
    [self build];
    
}
-(void)setLeftText:(NSString*)lt Right:(NSString*)rt{
    ltext = lt?lt:@"";
    rtext = rt?rt:@"";
    [self build];
}
-(void)setMoney:(double)money  Unit:(NSString*)unit{
    NSString*str = getMoney(money);
    [self setLeftText:[str substringToIndex:str.length-3]
                Right:[NSString stringWithFormat:@".%@%@",[str substringFromIndex:str.length-2],unit?unit:@""]];
}

-(void)setLineSpace:(float)lineSpace{
    _lineSpace=lineSpace;
    [self build];
}

-(void)build
{
    ltext = ltext?ltext:@"";
    rtext = rtext?rtext:@"";
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",ltext,rtext]];
    
    NSRange leftRange = {0,[ltext length]};
    NSRange rightRange = {[ltext length],[rtext length]};
    [content addAttribute:NSFontAttributeName
                    value:leftFont?leftFont:[self.font fontWithSize:lsize]
                    range:leftRange];
    [content addAttribute:NSFontAttributeName
                    value:rightFont?rightFont:[self.font fontWithSize:rsize]
                    range:rightRange];
    
    [content addAttribute:NSForegroundColorAttributeName
                    value:COLOR(lcolor)
                    range:leftRange];
    [content addAttribute:NSForegroundColorAttributeName
                    value:COLOR(rcolor)
                    range:rightRange];
    
    if(self.lineSpace>0){
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:_lineSpace];//调整行间距
   
    if(self.textAlignment != NSTextAlignmentLeft){
        [paragraphStyle setAlignment:self.textAlignment];
    }
    
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    
 

    }

    
    
    self.attributedText = content;
}
@end


@interface LabelH3()
{
    float s1;
    float s2;
    float s3;
    
    int c1;
    int c2;
    int c3;
    
    NSString* t1;
    NSString* t2;
    NSString* t3;
}
@end

@implementation LabelH3
@synthesize font1;
@synthesize font2;
@synthesize font3;
@synthesize lineSpace;

+(LabelH3*)newWithSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3{
    LabelH3 *l3 = [LabelH3 new];
    [l3 setSize1:ls1 Color1:lc1 Size2:ls2 Color2:lc2 Size3:ls3 Color3:lc3];
    return l3;
}
-(void)setSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3{
    s1 = ls1;
    c1 = lc1;
    s2 = ls2;
    c2 = lc2;
    s3 = ls3;
    c3 = lc3;
    [self build];
}
-(void)setText1:(NSString*)t1_ Text2:(NSString*)t2_ Text3:(NSString*)t3_
{
    t1=t1_;
    t2=t2_;
    t3=t3_;
    [self build];
}
-(void)setFont1:(UIFont *)f1 Font2:(UIFont *)f2 Font3:(UIFont *)f3
{
    font1=f1;
    font2=f2;
    font3=f3;
    
    [self build];
}
-(void)build
{
    t1 = t1?t1:@"";
    t2 = t2?t2:@"";
    t3 = t3?t3:@"";
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",t1,t2,t3]];
    
    NSRange range1 = {0,[t1 length]};
    NSRange range2 = {[t1 length],[t2 length]};
    NSRange range3 = {[t1 length]+[t2 length],[t3 length]};
    
    [content addAttribute:NSFontAttributeName
                    value:font1?font1:[self.font fontWithSize:s1]
                    range:range1];
    [content addAttribute:NSFontAttributeName
                    value:font2?font2:[self.font fontWithSize:s2]
                    range:range2];
    [content addAttribute:NSFontAttributeName
                    value:font3?font3:[self.font fontWithSize:s3]
                    range:range3];
    
    
    [content addAttribute:NSForegroundColorAttributeName
                    value:COLOR(c1)
                    range:range1];
    [content addAttribute:NSForegroundColorAttributeName
                    value:COLOR(c2)
                    range:range2];
    [content addAttribute:NSForegroundColorAttributeName
                    value:COLOR(c3)
                    range:range3];
    
    if(lineSpace>0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];//调整行间距
        
        if(self.textAlignment != NSTextAlignmentLeft){
            [paragraphStyle setAlignment:self.textAlignment];
        }
        
        [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    }
    
    
    self.attributedText = content;
}
@end
