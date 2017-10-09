//
//  XTitle.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/11.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ViewFactory.h"
@class LinearLayout;
@class LFLabel;
@class LFImage;

@interface XTitleBar : UIView
@property ( nonatomic)  LinearLayout *titleLayout;
@property ( nonatomic)  LFLabel *middelTitle;
@property ( nonatomic)  LFLabel *leftTitle;
@property ( nonatomic)  LFLabel *rightTitle;
@property ( nonatomic)  LFImage *leftImage;
@property ( nonatomic)  LFImage *rightImage;
@property(nonatomic)BOOL leftTitleForBack;

@property ( nonatomic)  UILabel *midTitle;

-(void)setOnRightClick:(void (^)(void))onclick;
-(void)setLeftForBack:(Boolean) back;
-(Boolean)isLeftForBack;
-(void)setTitle:(NSString*)title;
-(void)setLeftTitleTitle:(NSString*)title;
-(void)setSysBackColor:(int)c;
-(void)setTitleBackColor:(int)c;
-(void)setBackColor:(int)c;
-(void)setTitleHeight:(float)h;
-(void)hideSysBarAndTitle;
-(void)hideTitle;
-(void)showSysBarAndTitle;
-(void)showTitle;
-(void)setLeftImageHide:(Boolean) can;
@end
