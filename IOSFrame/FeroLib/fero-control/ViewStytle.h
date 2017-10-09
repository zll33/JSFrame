//
//  ViewStytle.h
//  p2p
//
//  Created by zhangxiuquan on 15/4/23.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewFactory.h"
@class LFTextField;
@interface LCMoreItem: LinearLayoutCell
@property (weak)  UILabel *msgLabel;
@property (weak)  LFLabel* msgLFLabel;
@property (weak)  UILabel* leftTitle;
@property (nonatomic)  LinearLayoutCell*leftTitleCell;


@property (weak)  LFImage* leftImage;
@property (weak)  LFLabel* leftIconLabel;
@property (weak)  LinearLayoutCell* rightImageCell;
@property (weak)  UIImageView* rightImage;
@property (weak)  LFTextField* editText;


+(LCMoreItem*)newWithView:(UIView*)v;
-(LFLabel*)LeftIconUseLabel:(NSString*)title FontSize:(int)size Color:(int)color;
@end


@interface ViewStytle : NSObject

+(LinearLayoutCell *)createSpaceVHeight:(int)height BackColor:(int)backcolor;
+(LinearLayoutCell *)createLineV;
+(LinearLayoutCell *)createLineH;
+(LinearLayoutCell *)createLineVMLeft;
+(LinearLayoutCell *)createLineVMLeftMoreItem;
+(LinearLayoutCell *)createLineVMLeftAndLeftColor:(int)c;
+(LinearLayoutCell *)createLineVMLeftMoreItemAndLeftColor:(int)c;
+(LinearLayoutCell *)createLineVLeftPadding:(float)left LeftColor:(int)c;

+(LFLabel *)createLabelV:(NSString*)title;
+(LFLabel *)createLabelV2:(NSString*)title;

+(LFLabel *)createLabelV:(NSString*)title BackColor:(int)backcolor;

+(LCMoreItem*)createItem:(NSString*)imagePath Title:(NSString*)title Onclick:(void(^)(void))onclick;
+(LCMoreItem*)createMoreItem:(NSString*)title :(NSString*)msg :(NSString*) leftImage :(BOOL) hasRight  :(id)target :(SEL)action;
+(LCMoreItem*)createMoreItem:(NSString*)title Msg:(NSString*)msg Icon:(NSString*) leftImage HasRight:(BOOL) hasRight  Target:(id)target Sel:(SEL)action;
//多行
+(LCMoreItem*)createMoreItem:(NSString*)title Msg:(NSString*)msg Hit:(NSString*) hit;
//单行
//+(LCMoreItem*)createInputItem:(NSString*)title Msg:(NSString*)msg Hit:(NSString*) hit;

+(LCMoreItem*)createMoreButton:(NSString*)title :(int) color :(int) pressColor  :(id)target :(SEL)action;

+(void) addJARRToLinearLayout:(LinearLayout*)l XJsonArray:(XJsonArray*)jarr;
+(void) addJARR2ToLinearLayout:(LinearLayout*)l XJsonArray:(XJsonArray*)jarr;


@end
