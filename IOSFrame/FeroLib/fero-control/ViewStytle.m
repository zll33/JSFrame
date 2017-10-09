//
//  ViewStytle.m
//  p2p
//
//  Created by zhangxiuquan on 15/4/23.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "ViewStytle.h"
#import "XHeader.h"
#define lineHeight 1
#define lineColor 0xffE1E1E1

#define margin2P 10
#define _marginLeft 15
#define _marginRight 15
#define _marginTop 15
#define _marginBottom 15

#define pading2P 10
#define padingLeft 15
#define padingRight 15
#define padingTop 15
#define padingBottom 15


//小标签类标题
#define labelTextFontSize  14
#define labelTextFontColor 0xff606060
#define labelTextBackColor 0xffE1E1E1
#define labelMl _marginLeft
#define labelMr _marginRight
#define labelMt _marginTop
#define labelMb _marginBottom

#define labelPl padingLeft
#define labelPr padingRight
#define labelPt padingTop*3/2
#define labelPb padingBottom

@implementation LCMoreItem
+(LCMoreItem*)newWithView:(UIView*)v
{
    LCMoreItem* item = [LCMoreItem new];
    [item setView:v];
    return item ;
}
-(LFLabel*)LeftIconUseLabel:(NSString*)title FontSize:(int)size Color:(int)color{
   
    if (self.leftIconLabel==nil) {
        LFLabel* label = [LFLabel newWithText:title FontSize:size FontColor:color BackColor:0];
        self.leftIconLabel = label;
        LinearLayout* lay = [self getView];
        
        [label setWidth:[self.leftImage getWidth]];
        [label setHeight:[self.leftImage getHeight]];
        [label setMarginBottom:self.leftImage.marginBottom];
        [label setMarginTop:self.leftImage.marginTop];
        [label setMarginRight:self.leftImage.marginRight];
        [label setMarginLeft:self.leftImage.marginLeft];
        
        [lay addView:label Index:0];
        [lay removeViewCell:self.leftImage];
        
    }
    [self.leftIconLabel setText:title];
    [[self.leftIconLabel getLabel] setFont:[UIFont systemFontOfSize:size]];
    [[self.leftIconLabel getLabel] setTextColor:COLOR(color)];
    
    
    
    return self.leftIconLabel;
}
@end

@implementation ViewStytle
+(LinearLayoutCell *)createSpaceVHeight:(int)height BackColor:(int)backcolor
{
    UIView*v=[UIView new];
    v.backgroundColor=COLOR(backcolor);
    
   return  [[LinearLayoutCell newWithView:v] setHeight:height];
}
+(LinearLayoutCell *)createLineV
{   //[XLine newWithHeight:lineHeight :COLOR(lineColor)]
    return [LinearLayoutCell newWithView:[XLine newHeight1Color:lineColor] MarginLeft:0 MarginTop:0 MarginBottom:0 MarginRight:0 UseWeight:FALSE  Weight:0];
}

+(LinearLayoutCell *)createLineH
{
    return [[LinearLayoutCell newWithView:[XLine newWidth1Color:lineColor] MarginLeft:0 MarginTop:0 MarginBottom:0 MarginRight:0 UseWeight:FALSE  Weight:0] setHeight:MatchPatrent];
}

+(LinearLayoutCell *)createLineVMLeft
{
    return  [self createLineVMLeftAndLeftColor:0];
}
+(LinearLayoutCell *)createLineVMLeftMoreItem
{
    return  [self createLineVMLeftMoreItemAndLeftColor:0];
}
+(LinearLayoutCell *)createLineVMLeftAndLeftColor:(int)c
{
    if (c==0) {
            return [LinearLayoutCell newWithView:[XLine newHeight1Color:lineColor] MarginLeft:_marginLeft MarginTop:0 MarginBottom:0 MarginRight:0 UseWeight:FALSE  Weight:0];
    }else{
        LCFrame * lineFram = [LCFrame newWithView:[XLine newHeight1Color:lineColor]];
        return  [[lineFram setPLeft:_marginLeft]setBackColor:c];
    }
}
+(LinearLayoutCell *)createLineVLeftPadding:(float)left LeftColor:(int)c
{
    if (c==0) {
        return [LinearLayoutCell newWithView:[XLine newHeight1Color:lineColor] MarginLeft:left MarginTop:0 MarginBottom:0 MarginRight:0 UseWeight:FALSE  Weight:0];
    }else{
        LCFrame * lineFram = [LCFrame newWithView:[XLine newHeight1Color:lineColor]];
        return  [[lineFram setPLeft:left]setBackColor:c];
    }
}

+(LinearLayoutCell *)createLineVMLeftMoreItemAndLeftColor:(int)c
{
    if (c==0) {
            return [LinearLayoutCell newWithView:[XLine newHeight1Color:lineColor] MarginLeft:60 MarginTop:0 MarginBottom:0 MarginRight:0 UseWeight:FALSE  Weight:0];
    }else{
        LCFrame * lineFram = [LCFrame newWithView:[XLine newHeight1Color:lineColor]];
        
        
        return  [[lineFram setPLeft:60]setBackColor:c];
    }

}
+(LFLabel *)createLabelV:(NSString*)title
{
    LFLabel * l = [LFLabel newWithText:title
                              FontSize:labelTextFontSize
                             FontColor:labelTextFontColor
                             BackColor:labelTextBackColor];
    [l setPRight:labelPr];
    [l setPLeft:labelPl];
    [l setPTop:labelPt];
    [l setPBottom:labelPb];
    //[l setMTop:labelMt];
    return l;
    
}
+(LFLabel *)createLabelV2:(NSString*)title
{
    LFLabel * l = [LFLabel newWithText:title
                              FontSize:labelTextFontSize
                             FontColor:labelTextFontColor
                             BackColor:labelTextBackColor];
    [l setMRight:labelMr];
    [l setMLeft:labelMl];
    [l setMTop:labelMt];
    [l setMBottom:labelMb];
    [l setPTop:labelPt];
    return l;
    
}

+(LFLabel *)createLabelV:(NSString*)title BackColor:(int)backcolor
{
    LFLabel * l = [LFLabel newWithText:title
                              FontSize:labelTextFontSize
                             FontColor:labelTextFontColor
                             BackColor:backcolor];
    [l setMRight:labelMr];
    [l setMLeft:labelMl];
    [l setMTop:labelMt];
    [l setMBottom:labelMb];
    [l setPTop:labelPt];
    return l;
}

+(LCMoreItem*)createItem:(NSString*)imagePath Title:(NSString*)title Onclick:(void(^)(void))onclick{
  
    LCMoreItem*item = [self createMoreItem:title :nil :imagePath :onclick!=nil :nil :nil];
    
    if (onclick!=nil) {
        [[item getView] setNormalColor:0xffffffff PressColor:0xfff0f0f0];
        [[item getView]setOnClick:onclick];
    }
    
    return item;
}
+(LCMoreItem*)createMoreItem:(NSString*)title Msg:(NSString*)msg Hit:(NSString*) hit
{
    LinearLayout * item = [LinearLayout newHorizontal];
    LCMoreItem *lcItem =   [LCMoreItem newWithView:item];
    
    //添加title
    UILabel* titleLabel = [UILabel new];
    [titleLabel setText:title];
    [titleLabel setTextColor:COLOR(0xff888888)];
    [titleLabel setFont: [UIFont systemFontOfSize:14]];
    [titleLabel setContentMode:UIViewContentModeLeft];
    [item addView:lcItem.leftTitleCell=[LinearLayoutCell newWithView:titleLabel MarginLeft:15 MarginTop:13 MarginBottom:13 MarginRight:15 UseWeight:false  Weight:0]];
    [lcItem setLeftTitle:titleLabel];
    
    //添加编辑框
    
    LFTextField* editText = [LFTextField newWithHit:hit FontSize:14 FontColor:0xff222222 BackColor:0];
    [editText setText:msg];
    [editText setUse:true Weight:1];
    [editText setTextAlignment:NSTextAlignmentRight];
    [editText setMRight:15];
    [editText setGravity:GravityMiddleV];
    [item addView:editText];
    [lcItem setEditText:editText];
    
    return lcItem;
}
 
+(LCMoreItem*)createMoreItem:(NSString*)title Msg:(NSString*)msg Icon:(NSString*) leftImage HasRight:(BOOL) hasRight  Target:(id)target Sel:(SEL)action{
    LCMoreItem * item = [self createMoreItem:title :msg :leftImage :hasRight :target :action];
    [item.leftTitle setTextColor:COLOR(0xff333333)];
    [item.leftTitle setFont:[UIFont systemFontOfSize:14]];
    [item.msgLabel setTextColor:COLOR(0xff222222)];
    [item.msgLabel setFont:[UIFont systemFontOfSize:14]];
    return item;
}
+(LCMoreItem*)createMoreItem:(NSString*)title :(NSString*)msg :(NSString*) leftImage :(BOOL) hasRight :(id)target :(SEL)action
{
    LinearLayout * item = [LinearLayout newHorizontal];
    LCMoreItem *lcItem =   [LCMoreItem newWithView:item];
    
    //添加leftImage
    if (leftImage) {
//        UIImageView* image = [UIImageView new];
//        [image setImage:[UIImage imageNamed:leftImage]];
//        [image setContentMode:UIViewContentModeScaleAspectFit];
//        LinearLayoutCell*cell;
//        [item addView:[[[[cell=[LinearLayoutCell newWithView:image] setWidth:30]setHeight:30] setMRight:0] setMLeft:15]];
//        
        LFImage*image = [LFImage newWithUrl:leftImage
                                      Width:30
                                     Height:30
                                       Mode:UIViewContentModeScaleAspectFit
                                 MarginLeft:15
                                  MarginTop:0
                                MarginRight:0
                               MarginBottom:0
                                 PadingLeft:0
                                  PadingTop:0
                                PadingRight:0
                               PadingBottom:0
                                  UseWeight:NO
                                     Weight:0];
        lcItem.leftImage = image;
        [item addView:image];
        //[cell setGravity:GravityLeft_MiddleV];
    }
    
    //添加title
    UILabel* titleLabel = [UILabel new];
    [titleLabel setText:title];
    [titleLabel setTextColor:COLOR(0xff000000)];
    [titleLabel setFont: [UIFont systemFontOfSize:16]];
    [titleLabel setContentMode:UIViewContentModeLeft];
    [item addView:lcItem.leftTitleCell=[LinearLayoutCell newWithView:titleLabel MarginLeft:15 MarginTop:13 MarginBottom:13 MarginRight:15 UseWeight:NO Weight:0]];// setWidth:80] ];
    
    
    //添加msg
//    UILabel* msgLabel = [UILabel new];
//    [msgLabel setText:msg];
//    [msgLabel setTextColor:COLOR(0xff8a898e)];
//    [msgLabel setFont: [UIFont systemFontOfSize:16]];
//    [msgLabel setContentMode:UIViewContentModeRight];
//    [msgLabel  setTextAlignment:NSTextAlignmentCenter];
//    [item addView:[[[LinearLayoutCell newWithView:msgLabel MarginLeft:15 MarginTop:13 MarginBottom:13 MarginRight:15 UseWeight:false  Weight:0] setHeight:18]setMinWidth:18]];
    
    LFLabel* msgLFLabel = [LFLabel newWithText:msg
                                      FontSize:16
                                     FontColor:0xff8a898e
                                     BackColor:0
                                    MarginLeft:15
                                     MarginTop:12
                                   MarginRight:15
                                  MarginBottom:12
                                    PadingLeft:2
                                     PadingTop:2
                                   PadingRight:2
                                  PadingBottom:2
                                     UseWeight:YES
                                        Weight:1];
    [msgLFLabel setTextAlignment:NSTextAlignmentRight];
    [msgLFLabel setLineNum:1];
    [[msgLFLabel setHeight:20]setMinWidth:20];
    UILabel* msgLabel = [msgLFLabel getLabel];
    [item addView:msgLFLabel];
    
    //添加右箭头
    if(hasRight){
        UIImageView* rightImage = [UIImageView new];
        [rightImage setImage:[UIImage imageNamed:@"goto_right_gray"]];
        [rightImage setContentMode:UIViewContentModeScaleAspectFit];
         LinearLayoutCell*cell;
        [item addView:[[[cell=[LinearLayoutCell newWithView:rightImage] setWidth:10] setHeight:30]setMRight:15]];
        [lcItem setRightImage:rightImage];
        [lcItem setRightImageCell:cell];
    }
    
    //点击事件
    if(action){
        [item setOnClickTarget:target action:action];
        [item setNormalColor:0xffffffff PressColor:0xfff0f0f0];
    }else{
        [item setBackgroundColor:COLOR(0xffffffff)];
    }
    
    item.gravity = GravityLeft_MiddleV;
    
   
    [lcItem setLeftTitle:titleLabel];
    [lcItem setMsgLabel: msgLabel];
    [lcItem setMsgLFLabel:msgLFLabel];
    [lcItem setWidth:MatchPatrent];
    return lcItem;
    
}
+(LCMoreItem*)createMoreButton:(NSString*)title :(int) color :(int) pressColor  :(id)target :(SEL)action
{
    LFLabel * lfTable = [LFLabel newWithText:title
                              FontSize:16
                             FontColor:0xffffffff
                             BackColor:0xff669878
                            MarginLeft:10
                             MarginTop:10
                           MarginRight:10
                          MarginBottom:10
                            PadingLeft:0
                             PadingTop:10
                           PadingRight:0
                          PadingBottom:10
                             UseWeight:false
                                Weight:0
                   ];
    
    UILabel* titleLabel = [lfTable getContentView];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    UIView  * back = [lfTable getBackView];
    
    back.layer.cornerRadius = 4;
    back.layer.masksToBounds = YES;
    [back setNormalColor:color PressColor:pressColor];
    [back setOnClickTarget:target action:action];
    
    LinearLayout * layout = [LinearLayout newVertical];
    [layout addView:lfTable ];
    
    LCMoreItem *lcItem =   [LCMoreItem newWithView:layout];
    [lcItem setMsgLabel: titleLabel];
    
    return lcItem;
}
+(void) addJARRToLinearLayout:(LinearLayout*)l XJsonArray:(XJsonArray*)jarr
{
    int count = [jarr count];
    for (int i=0; i<count; i++) {
        
        if (i==0) {
             [l addView: [ViewStytle createLineV]];
        }else{
            [l addView: [ViewStytle createLineVMLeft]];
        }
        XJson*json =[jarr objectAtIndex:i];
        [l addView:[LFLabel newWithText:[json getString:@"title"] FontSize:14 FontColor:0xff444444 BackColor:0
                             MarginLeft:0 MarginTop:0 MarginRight:0 MarginBottom:0
                             PadingLeft:15 PadingTop:15 PadingRight:15 PadingBottom:15 UseWeight:false Weight:0]
         ];
        
        [l addView: [LFLabel newWithText:[json getString:@"value"] FontSize:14 FontColor:0xff444444 BackColor:0xffffffff
                              MarginLeft:0 MarginTop:0 MarginRight:0 MarginBottom:0
                              PadingLeft:15 PadingTop:15 PadingRight:15 PadingBottom:15 UseWeight:false Weight:0]
         ];
        if (i==count-1) {
            [l addView: [ViewStytle createLineV]];
        }
    }
}
+(void) addJARR2ToLinearLayout:(LinearLayout*)l XJsonArray:(XJsonArray*)jarr
{
    int count = [jarr count];
    for (int i=0; i<count; i++) {
        
        if (i==0) {
            [l addView: [ViewStytle createLineV]];
        }else{
            [l addView: [ViewStytle createLineVMLeft]];
        }
        XJson*json =[jarr objectAtIndex:i];
        LinearLayout *lchild = [LinearLayout newHorizontal];
        
        [lchild addView:[LFLabel newWithText:[json getString:@"title"]
                                    FontSize:14
                                   FontColor:0xff444444
                                   BackColor:0
                                  MarginLeft:0
                                   MarginTop:0
                                 MarginRight:0
                                MarginBottom:0
                                  PadingLeft:15
                                   PadingTop:15
                                 PadingRight:15
                                PadingBottom:15
                                   UseWeight:true
                                      Weight:1]
         ];
        
        [lchild addView:[[LFLabel newWithText:[json getString:@"value"]
                                     FontSize:14
                                    FontColor:0xff444444
                                    BackColor:0xffffffff
                                   MarginLeft:0
                                    MarginTop:0
                                  MarginRight:0
                                 MarginBottom:0
                                   PadingLeft:15
                                    PadingTop:15
                                  PadingRight:15
                                 PadingBottom:15
                                    UseWeight:false
                                       Weight:0]setTextAlignment:NSTextAlignmentRight ]
         ];
        
        [l  addView:[LinearLayoutCell newWithView:lchild]];
        
        if (i==count-1) {
            [l addView: [ViewStytle createLineV]];
        }
    }
}

@end
