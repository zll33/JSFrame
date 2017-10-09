//
//  XTitle.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/11.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XTitle.h"
#import "HelpApi.h"
#import "XBaseViewController.h"
#import "XObjectEx.h"
#import "ViewFactory.h"
@interface XTitleBar()
{
    Boolean forBack;
    UITapGestureRecognizer *backClick;
    UITapGestureRecognizer *backClick2;
}

@end
@implementation XTitleBar
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self XTitleBar_onCreate];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self XTitleBar_onCreate];
    }
    return self;
    
}
- (id)init
{
    self = [super init];
    if (self) {
        [self XTitleBar_onCreate];
    }
    return self;
}

-(void)XTitleBar_onCreate
{
    if (self.titleLayout==nil) {
        
        
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLayout = [LinearLayout newHorizontal];
        self.middelTitle =  [LFLabel newWithText:@"" FontSize:16 FontColor:0xffffffff BackColor:0];
        self.leftImage = [LFImage newWithUrl:@"left_back2" Width:40 Height:40];
        self.leftTitle = [LFLabel newWithText:@"" FontSize:16 FontColor:0xffffffff BackColor:0];
        self.rightImage = [LFImage newWithUrl:nil Width:40 Height:40];
        self.rightTitle =  [LFLabel newWithText:@"" FontSize:16 FontColor:0xffffffff BackColor:0];
        
        [self addSubview:self.titleLayout];
        [self addConstraintBig:[NSLayoutConstraint
                                constraintWithItem: self.titleLayout
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:self
                                attribute:NSLayoutAttributeTop
                                multiplier:1
                                constant:0]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem: self.titleLayout
                             attribute:NSLayoutAttributeLeft
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeLeft
                             multiplier:1
                             constant:0]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem: self.titleLayout
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeRight
                             multiplier:1
                             constant:0]];
        [self addConstraintBigBig:[NSLayoutConstraint
                             constraintWithItem: self
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.titleLayout
                             attribute:NSLayoutAttributeBottom
                             multiplier:1
                             constant:0]];
        
        [self setTitleHeight:48];
        [self.titleLayout addView:self.leftImage];
        [self.titleLayout addView:self.leftTitle];
        [self.titleLayout addView:self.middelTitle];
        [self.titleLayout addView:self.rightImage];
        [self.titleLayout addView:self.rightTitle];
       
        [self.middelTitle setUse:TRUE Weight:1];
        [self.middelTitle setLineNum:2];
        [self.middelTitle setTextAlignment:NSTextAlignmentCenter];
        [self.leftImage setLayoutGtavity:GravityMiddleV];
        [self.leftTitle setLayoutGtavity:GravityMiddleV];
        [self.leftTitle setHeight:MatchPatrent];
        [self.middelTitle setLayoutGtavity:GravityMiddleV];
        [self.rightTitle setHeight:MatchPatrent];
        [self.rightTitle setLayoutGtavity:GravityMiddleV];
        [self.rightImage setLayoutGtavity:GravityMiddleV];
        
        backClick= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        backClick2= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [self setLeftForBack:TRUE];
        
        //添加一个中间title
        self.midTitle = [UILabel new];
        [self.midTitle setTextAlignment:NSTextAlignmentCenter];
        [self.midTitle setNumberOfLines:2];
        [self.midTitle setFont:[self.midTitle.font fontWithSize:16]];
        [self.midTitle setTextColor:COLOR(0XFFFFFFFF)];
        [self.titleLayout addViewEqSelf:self.midTitle];
        [self.titleLayout addOnCenter:self.midTitle W:0 H:0 DX:0 DY:0];
        [self.titleLayout setWH:self.midTitle MultW:1 MultH:1 DW:-80 DH:0];
        
        //LFLabel 约束逻辑错误
        [self.leftTitle.getContentCell setHeight:WrapContent];
        [self.leftTitle.getContentCell setWidth:WrapContent];
        [self.leftTitle setWidth:WrapContent];
        //IOS11.1 无故出现leftTitle挤压middelTitle的比重，设一个约束即可不挤压
        if(([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)){
           [[self.leftTitle getContentCell] setMinWidth:0];
        }
        //
        [self.middelTitle setUse:TRUE Weight:1];
        [[self.middelTitle getContentCell] setWidth:WrapContent];
        [self.middelTitle setHeight:MatchPatrent];
        //
        [self.rightTitle.getContentCell setHeight:WrapContent];
        [self.rightTitle.getContentCell setWidth:WrapContent];
        [self.rightTitle setWidth:WrapContent];
        
    }
}
-(void)setOnRightClick:(void (^)(void))onclick{
    [self.rightTitle setOnClick:onclick];
    [self.rightImage setOnClick:onclick];
}

-(Boolean)isLeftForBack{
    return forBack;
}
-(void)setLeftTitleTitle:(NSString*)title
{
    [self.leftTitle setText:title];
}
-(void)setTitle:(NSString*)title{
    [self.midTitle setText:title];
}
-(void)setSysBackColor:(int)c{
    [self setBackgroundColor:COLOR(c)];
}
-(void)setTitleBackColor:(int)c{
    [self.titleLayout setBackgroundColor:COLOR(c)];
}
-(void)setBackColor:(int)c
{
    [self setSysBackColor:c];
}
-(void)hideSysBarAndTitle{
    [self hideTitle];
    [self setVisible:AutoLayoutVisibleHideHeight];
}
-(void)hideTitle{
    [self setTitleHeight:0];
    [self.titleLayout setHidden:true];
}
-(void)showSysBarAndTitle{
    [self showTitle];
    [self setVisible:AutoLayoutVisibleShow];
}
-(void)showTitle{
    [self setTitleHeight:48];
    [self.titleLayout setHidden:false];
}

-(void)setTitleHeight:(float)height{
    
    NSArray *arr = [self.titleLayout constraints];
    for (int i=0; i<arr.count; i++) {
        NSLayoutConstraint * c =[arr objectAtIndex:i];
        if (c.firstItem == self.titleLayout &&
            c.firstAttribute==NSLayoutAttributeHeight &&
            c.secondAttribute==NSLayoutAttributeNotAnAttribute &&
            c.priority==1000&&
            c.secondItem==nil) {
            [self.titleLayout removeConstraint:c];
        }
    }
    [self.titleLayout addConstraint:[NSLayoutConstraint
                                     constraintWithItem: self.titleLayout
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:height]];
}
-(void)setLeftForBack:(Boolean) back
{
    forBack = back;
    if (forBack) {
        [self.leftImage getView].userInteractionEnabled = YES;
        [[self.leftImage getView] addGestureRecognizer:backClick];
        [[self.leftImage getImageView]setImage:[UIImage imageNamed:@"left_back2"]];
        //
//        [self.leftTitle getBackView].userInteractionEnabled = YES;
//        [[self.leftTitle getBackView] addGestureRecognizer:backClick2];
//        [[self.leftTitle getBackView] setHidden:false];
    }else{
        [[self.leftImage getView] removeGestureRecognizer:backClick];
        [self.leftImage getView].userInteractionEnabled = NO;
        //[self.leftImage getImageView] setImage:[UIImage imageNamed:@"backicon"]];
        [[self.leftImage getImageView]setImage:nil];
        //
//        [self.leftTitle getBackView].userInteractionEnabled = NO;
//        [[self.leftTitle getBackView] removeGestureRecognizer:backClick];
//        [[self.leftTitle getBackView] setHidden:true];
    }
    [self checkLeftTitleBack];
}
-(void)setLeftTitleForBack:(BOOL)leftTitleForBack{
    _leftTitleForBack = leftTitleForBack;
    [self checkLeftTitleBack];
}
-(void)checkLeftTitleBack{
    if (forBack&&_leftTitleForBack) {
        [self.leftTitle getBackView].userInteractionEnabled = YES;
        [[self.leftTitle getBackView] addGestureRecognizer:backClick2];
        [[self.leftTitle getBackView] setHidden:false];
    }else{
        [self.leftTitle getBackView].userInteractionEnabled = NO;
        [[self.leftTitle getBackView] removeGestureRecognizer:backClick];
        [[self.leftTitle getBackView] setHidden:true];
    }
}
-(void)setLeftImageHide:(Boolean) can{
    [[self.leftImage getView] setHidden:can];
    [[self.leftTitle getView] setHidden:can];
}

-(void)actionTap:(UITapGestureRecognizer *)recognizer {
    if (forBack) {
        UIViewController * controller = findViewController(self);
        //[controller dismissModalViewControllerAnimated:YES];
        //
        if ([controller conformsToProtocol:@protocol(XControllerProtocol)]) {
            @try {
                [(id<XControllerProtocol>)controller callBack];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            @finally {
                
            }
            
        }
    }
}
@end


