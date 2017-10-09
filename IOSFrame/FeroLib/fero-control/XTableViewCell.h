//
//  XTableViewCell.h
//  p2p
//
//  Created by zhangxiuquan on 15/1/22.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJson.h"
//用于绑定计算宽度的，以便tabelview快速预算。  垃圾的IOS布局机制
#define ContentHeightBingJsonKey @"ContentHeightBingJsonKey"
@class XTableView;
#define ItemNormalColor 0x00000000
#define ItemPressColor 0x00000000
@interface XTableViewCell : UITableViewCell
@property(nonatomic) XJson* contentHeightBingJson;

@property(nonatomic,readonly)UIView*mainContent;
@property(nonatomic,weak)XTableView*list;
-(void)setBingJsonHeight:(float)height;
-(void)setSelectNormalColor:(int)color PressColor:(int)sColor;

-(void)setSelect:(UIView*)view NormalColor:(int)color PressColor:(int)sColor;
-(void)setSelectBlock:(void(^)(BOOL isSelect,NSObject*forSelectObject))onselect Object:(NSObject*)forSelectObject;
-(BOOL)isFree;
-(void)addToContent:(UIView*)v;
-(void)addToContent:(UIView*)v MLeft:(float)ml MRight:(float)mr MTop:(float)mt MBottom:(float)mb;
-(float)getContentHeight:(float)width;
//清除绑定json中的高度。（比如当json变动时，或宽度变动）
+(void)clearContentHeightBingJson:(XJson*)json;
@end
