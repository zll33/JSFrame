//
//  Label2.h
//  moi
//
//  Created by zhangxiuquan on 16/7/16.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelH2 : UILabel
@property(nonatomic)UIFont*leftFont;
@property(nonatomic)UIFont*rightFont;
@property(nonatomic)float lineSpace;
+(LabelH2*)newWithLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc;
-(void)setLeftSize:(float)ls Color:(int)lc RightSize:(float)rs Color:(int)rc;
-(void)setLeftText:(NSString*)ltext Right:(NSString*)rtext;
-(void)setLeftFont:(UIFont *)leftFont Right:(UIFont *)rightFont;
-(void)setMoney:(double)money Unit:(NSString*)unit;
@end

//
@interface LabelH3 : UILabel
@property(nonatomic)UIFont*font1;
@property(nonatomic)UIFont*font2;
@property(nonatomic)UIFont*font3;
@property(nonatomic)float lineSpace;
+(LabelH2*)newWithSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3;
-(void)setSize1:(float)ls1 Color1:(int)lc1 Size2:(float)ls2 Color2:(int)lc2 Size3:(float)ls3 Color3:(int)lc3;
-(void)setText1:(NSString*)t1 Text2:(NSString*)t2 Text3:(NSString*)t3;
-(void)setFont1:(UIFont *)f1 Font2:(UIFont *)f2 Font3:(UIFont *)f3;

@end
