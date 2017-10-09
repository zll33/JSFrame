//
//  XViewEx.m
//  p2p
//
//  Created by zhangxiuquan on 15/1/28.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XViewEx.h"
#import "HelpApi.h"
#import "XJson.h"
#import "XObjectEx.h"
#import "LinearLayout.h"
#import <objc/runtime.h> 

@implementation XViewEx

@end

@implementation UIView (HideForAutoLayout)

-(void)setNormalColor:(int)color PressColor:(int)sColor
{
    [self setNormalColor:color PressColor:sColor DisabledColor:color ];
}

-(void)setNormalColor:(int)color PressColor:(int)sColor DisabledColor:(int)dColor
{
    [ self putXBingDataInt:@"_clickNormalColor":color ];
    [ self putXBingDataInt:@"_clickSelectedColor":sColor];
    [ self putXBingDataInt:@"_clickDisabledColor":dColor];
    self.backgroundColor = COLOR(color);
}

-(void)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge
{
    [self setNormalImage:iamge PressImage:sIamge DisabledImage:iamge ];
}

-(void)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge DisabledImage:(UIImage*)dIamge
{
    [ self putXBingDataObject:@"_clickNormalImage" :iamge];
    [ self putXBingDataObject:@"_clickPressImage":sIamge];
    [ self putXBingDataObject:@"_clickDisabledImage":dIamge];
    self.layer.contents = (id) iamge.CGImage;
}
-(void)setClickAble:(BOOL)canClick{
    [self setUserInteractionEnabled:canClick];
    if(canClick){
        [self _onBackViewClickEnd];
    }else{
        [self _onBackViewDisabledClick];
    }
}
//按下后多次触发事件 间隔事件 interval
-(void)setOnTouchMultTriggerInterval:(double)interval  Target:(__weak id)target Begin:(SEL)begin Touch:(SEL)touch End:(SEL)end{
    
    if(target){
        id onbegin=nil;
        id ontouch=nil;
        id onend=nil;
        if(begin){
            onbegin= ^(){
                [target performSelector:begin withObject:nil];
            };
        }
        if(touch){
            ontouch= ^(){
                [target performSelector:touch withObject:nil];
            };
        }
        if(end){
            onend= ^(){
                [target performSelector:end withObject:nil];
            };
        }
        
        if(interval<=0){
            interval = 0.1;
        }
        
        [self putXBingDataObject:@"OnTouchMultTriggerBegin" :onbegin];
        [self putXBingDataObject:@"OnTouchMultTriggerTouch" :ontouch];
        [self putXBingDataObject:@"OnTouchMultTriggerEnd" :onend];
        //[self putXBingDataObject:@"OnTouchMultTriggerInterval" :[NSNumber numberWithDouble:interval]];
        [self putXBingDataDouble:@"OnTouchMultTriggerInterval" :interval];
        
         self.userInteractionEnabled = YES;
        //判断是否已经添加手势,如果没有添加则新加
        if([self getXBingDataBOOL:@"OnTouchMultTrigger_Gesture" Fail:FALSE]==FALSE){
            UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_OnTouchMultTrigger_Gesture:)];
            
            longPressGr.minimumPressDuration = 0.01;
            [self addGestureRecognizer:longPressGr];
            [self putXBingDataBOOL:@"OnTouchMultTrigger_Gesture" :YES];
        }
        
    }

}
-(void)_onPopTouchMultTrigger{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(_onPopTouchMultTrigger)
                                               object:nil];
    void(^ontouch)(void) = [self getXBingDataObject:@"OnTouchMultTriggerTouch"];
    double interval = [self getXBingDataDouble:@"OnTouchMultTriggerInterval" Fail:0.1];
    if(ontouch){
        ontouch();
        [self performSelector:@selector(_onPopTouchMultTrigger)
                   withObject:nil
                   afterDelay:interval];
        
    }
    
}
-(void)_OnTouchMultTrigger_Gesture:(UILongPressGestureRecognizer*)g{
    
    NSLog(@"longlongClick");
    if(g.state == UIGestureRecognizerStateBegan){
        [self putXBingDataBOOL:@"OnTouchMultTriggerBegin_has" :true];
        double interval = [self getXBingDataDouble:@"OnTouchMultTriggerInterval" Fail:0.1];
        [self performSelector:@selector(_onPopTouchMultTrigger)
                   withObject:nil
                   afterDelay:interval];
        
        void(^onbegin)(void) = [self getXBingDataObject:@"OnTouchMultTriggerBegin"];
        if(onbegin){
            onbegin();
        }
    }else{
        if([self getXBingDataBOOL:@"OnTouchMultTriggerBegin_has" Fail:false]){
            [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:@selector(_onPopTouchMultTrigger)
                                                       object:nil];
            void(^onEND)(void) = [self getXBingDataObject:@"OnTouchMultTriggerEnd"];
            if(onEND){
                onEND();
            }
        }
    }
    
}


-(void)setOnClick:(void(^)(void))block;
{
    [self  setUserInteractionEnabled:YES];
    UITapGestureRecognizer* click = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_onSetOnClick:)];
    
    [self putXBingDataObject:@"setOnClick" :block];
    [self addGestureRecognizer:click];
}
-(void)_onSetOnClick:(id)click{
    //NSLog(@"_onSetOnClick");
 
    //判断是否需要背景变动动画
    [self _onBackViewClickStart];
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self _onBackViewClickEnd];
                     }
                     completion:^(BOOL finished) {
                         //NSLog(@"doClick");
                         //防止动画延时
                         if(self.userInteractionEnabled){
                             void (^block)(void)  = [self getXBingDataObject:@"setOnClick"];
                             if (block) {
                                 block();
                             }
                             
                             void (^block2)(id)  = [self getXBingDataObject:@"setOnClick2"];
                             if (block2) {
                                 block2(click);
                             }
                         }
                         
                     }];
    
    //规避其它动画的影响
    //NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(doClick:) userInfo:click repeats:NO];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)doClick:(id)click{
    NSLog(@"doClick");
    //防止动画延时
    if(self.userInteractionEnabled){
        void (^block)(void)  = [self getXBingDataObject:@"setOnClick"];
        if (block) {
            block();
        }
        
        void (^block2)(id)  = [self getXBingDataObject:@"setOnClick2"];
        if (block2) {
            block2(click);
        }
    }
}
-(void)setOnClickTarget:(id)target action:(SEL)action;
{
    //判断是否已经添加手势,如果没有添加则新加
    if([self getXBingDataObject:@"setOnClick2"]==nil){
        UITapGestureRecognizer* click = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_onSetOnClick:)];
        [self addGestureRecognizer:click];
    }

    
    //添加或则更新点击事件
    __weak id tagetTemp = target;
    
    void(^block2)(id) = ^(id tag){
        //使用afterDelay:0，滚动会导致延时执行
        //[tagetTemp performSelector:action withObject:tag afterDelay:0];
        [tagetTemp performSelector:action withObject:tag];
    };
    [self  setUserInteractionEnabled:YES];
    [self putXBingDataObject:@"setOnClick2" :block2];
    

    
    
//    UITapGestureRecognizer* click = [[UITapGestureRecognizer alloc] initWithTarget:target  action:action];
//    
//    [self addGestureRecognizer:click];
    
}
-(BOOL)_hasClickEvent{
    
//    for(UIGestureRecognizer *ges in [self gestureRecognizers]){
//        if ([ges isKindOfClass:[UITapGestureRecognizer class] ])
//        {
            return self.userInteractionEnabled;
//        }
//    }
//    return false;
}
- (void)_onBackViewClick
{
    
}

- (void)_onBackViewClickStart
{
    if ([self isHasXBingDataKey:@"_clickSelectedColor"]) {
        int color = [self getXBingDataInt:@"_clickSelectedColor" Fail:0];
        self.backgroundColor = COLOR(color);
    }
    if ([self isHasXBingDataKey:@"_clickPressImage"]) {
        UIImage* iamge  = [self getXBingDataObject:@"_clickPressImage"];
        self.layer.contents = (id) iamge.CGImage;
    }
    
}
- (void)_onBackViewClickEnd
{
    if ([self isHasXBingDataKey:@"_clickNormalColor"]) {
        int color = [self getXBingDataInt:@"_clickNormalColor" Fail:0];
        self.backgroundColor = COLOR(color);
    }
    if ([self isHasXBingDataKey:@"_clickNormalImage"]) {
        UIImage* iamge  = [self getXBingDataObject:@"_clickNormalImage"];
        self.layer.contents = (id) iamge.CGImage;
    }
    
}
-(void)_onBackViewDisabledClick{
    if ([self isHasXBingDataKey:@"_clickDisabledColor"]) {
        int color = [self getXBingDataInt:@"_clickDisabledColor" Fail:0];
        self.backgroundColor = COLOR(color);
    }
    if ([self isHasXBingDataKey:@"_clickDisabledImage"]) {
        UIImage* iamge  = [self getXBingDataObject:@"_clickDisabledImage"];
        self.layer.contents = (id) iamge.CGImage;
    }
}
-(BOOL)_isFirstFinger:(NSSet *) touches withEvent:(UIEvent *) event
{
    NSSet *allTouches = [event allTouches];
    if ([allTouches allObjects] .count>0) {
        UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
        UITouch *touchCur = [touches anyObject];
        if (touchCur==touch1) {
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
    
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    [super touchesBegan:touches withEvent:event];
    
//    UITouch *touch = [touches anyObject];
//    CGPoint tapPoint = [touch locationInView:self];
//    UIView* v = [self hitTest:tapPoint withEvent:event];
//    if (v==self) {
        if ([self _hasClickEvent] && [self _isFirstFinger:touches withEvent:event]) {
            [self _onBackViewClickStart];
        }
//    }
    
}

- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    [super touchesMoved:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([self _hasClickEvent] && [self _isFirstFinger:touches withEvent:event]) {
        [self _onBackViewClick];
        [self _onBackViewClickEnd];
    }
}

- (void)touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event
{
    [super touchesCancelled:touches withEvent:event];
    if ([self _hasClickEvent] && [self _isFirstFinger:touches withEvent:event]) {
        [self _onBackViewClickEnd];
    }
}

-(void)setVisible:(AutoLayoutVisible)visible
{
    if ([self getVisible]==visible) {
        return;
    }
    
    switch (visible) {
        case AutoLayoutVisibleShow:
        {
            NSLayoutConstraint*lcWidth = [self getHideLayoutWidthConstraint];
            NSLayoutConstraint*lcHeight = [self getHideLayoutHeightConstraint];
            self.hidden = FALSE;
            if (lcWidth!=nil) {
                [self removeConstraint:lcWidth];
            }
            if (lcHeight!=nil) {
                [self removeConstraint:lcHeight];
            }
        }
            break;
            
        case AutoLayoutVisibleHide:
        {
            self.hidden = TRUE;
            NSLayoutConstraint*lcHeight = [self getHideLayoutHeightConstraint];
            if (lcHeight==nil) {
                lcHeight = [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:AutoLayoutVisibleAttribute
                                                       multiplier:1
                                                         constant:0];
                [self addConstraint:lcHeight];
            }
            NSLayoutConstraint*lcWidth = [self getHideLayoutWidthConstraint];
            if (lcWidth==nil) {
                lcWidth = [NSLayoutConstraint constraintWithItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:AutoLayoutVisibleAttribute
                                                      multiplier:1
                                                        constant:0];
                [self addConstraint:lcWidth];
            }
        }
            break;
            
            
        case AutoLayoutVisibleHideWidth:
        {
            self.hidden = TRUE;
            NSLayoutConstraint*lcWidth = [self getHideLayoutWidthConstraint];
            if (lcWidth==nil) {
                lcWidth = [NSLayoutConstraint constraintWithItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:AutoLayoutVisibleAttribute
                                                      multiplier:1
                                                        constant:0];
                [self addConstraint:lcWidth];
            }
            
            break;
        }
        case AutoLayoutVisibleHideHeight:
        {
            self.hidden = TRUE;
            NSLayoutConstraint*lcHeight = [self getHideLayoutHeightConstraint];
            if (lcHeight==nil) {
                lcHeight = [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:AutoLayoutVisibleAttribute
                                                       multiplier:1
                                                         constant:0];
                [self addConstraint:lcHeight];
            }
            break;
        }
        case AutoLayoutVisibleHideAndUsed:
        {
            self.hidden = TRUE;
            
        }
            break;
        default:
            break;
    }
    
}
-(AutoLayoutVisible)getVisible
{
    AutoLayoutVisible visible = AutoLayoutVisibleShow;
    NSLayoutConstraint*lcHeight = [self getHideLayoutHeightConstraint];
    NSLayoutConstraint*lcWidth = [self getHideLayoutWidthConstraint];
    if (self.hidden) {
        if (lcHeight==nil || lcWidth==nil) {
            visible = AutoLayoutVisibleHideAndUsed;
        }else if(lcWidth==nil){
            visible = AutoLayoutVisibleHideWidth;
        }else if(lcHeight==nil){
            visible = AutoLayoutVisibleHideHeight;
        }else{
            visible = AutoLayoutVisibleHide;
        }
        
    }else{
        visible = AutoLayoutVisibleShow;
    }
    
    return visible;
}
-(NSLayoutConstraint*)getHideLayoutHeightConstraint
{
    
    for (NSLayoutConstraint * lc in [self constraints]) {
        if (lc.firstItem== self &&
            lc.firstAttribute==NSLayoutAttributeHeight &&
            lc.secondAttribute == AutoLayoutVisibleAttribute &&
            lc.secondItem == nil &&
            lc.constant ==0 &&
            lc.priority==1000) {
            return lc;
        }
    }
    return nil;
    
}
-(NSLayoutConstraint*)getHideLayoutWidthConstraint
{
    
    for (NSLayoutConstraint * lc in [self constraints]) {
        if (lc.firstItem== self &&
            lc.firstAttribute==NSLayoutAttributeWidth &&
            lc.secondAttribute == AutoLayoutVisibleAttribute &&
            lc.secondItem == nil &&
            lc.constant ==0  &&
            lc.priority==1000) {
            return lc;
        }
    }
    return nil;
    
}
@end

@implementation UIView (LayoutConstraint)
-(void)addConstraint:(NSLayoutConstraint*)c P:(float)priority{
    c.priority=priority;
    [self addConstraint:c];
}

-(void)addConstraintBigBig:(NSLayoutConstraint*)c{
    c.priority=999;
    [self addConstraint:c];
}

-(void)addConstraintBig:(NSLayoutConstraint*)c{
    c.priority=750;
    [self addConstraint:c];
}
-(void)addConstraintLit:(NSLayoutConstraint*)c{
    c.priority=250;
    [self addConstraint:c];
}
-(void)addConstraintLitLit:(NSLayoutConstraint*)c{
    c.priority=1;
    [self addConstraint:c];
}

-(void)clearConstraintsFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute )firstAttribute
{
    NSArray *cList = [self constraints];
    NSMutableArray *reList=  [NSMutableArray new];
    for (NSLayoutConstraint * c in cList) {
        
        if (firstItem == c.firstItem && c.firstAttribute == firstAttribute ) {
            [reList addObject:c];
        }
        
    }
    if ([reList count]>0) {
        [self removeConstraints:reList];
    }
}
-(void)removeConstraintsFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute )firstAttribute
{
    [self clearConstraintsFirstItem:firstItem firstAttribute:firstAttribute];
}
-(NSLayoutConstraint*)getConstraintsFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute )firstAttribute
{
    NSArray *cList = [self constraints];
    for (NSLayoutConstraint * c in cList) {
        
        if (firstItem == c.firstItem && c.firstAttribute == firstAttribute ) {
            return c;
        }
        
    }
    return nil;
}
-(void)addViewEqSelf:(UIView*)view
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    if ([view superview]!=self) {
        [view removeFromSuperview];
        [self addSubview : view] ;
    }
    
    [self addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self
                              attribute:NSLayoutAttributeHeight
                              multiplier:1
                              constant:0]];
    [self addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0]];
    [self addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    [self addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
}
-(void)setWH:(UIView *)view MultW:(float)w MultH:(float)h DW:(float)dw DH:(float)dh
{
    if ([view superview]||self==view) {
        if (w>0 || dw!=0) {
            [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
            [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:w
                                                               constant:dw]];
        }
        
        if (h>0 || dh!=0) {
            [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
            [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:h
                                                               constant:dh]];
        }
    }

}
-(void)addOnCenter:(UIView *)view W:(float)w H:(float)h DX:(float)dx DY:(float)dy;
{
    [self addOnCenter:view W:w  H:h MultCX:1 MultCY:1 DX:dx DY:dy];
}
-(void)addOnCenter:(UIView *)view W:(float)w H:(float)h MultCX:(float)cx MultCY:(float)cy DX:(float)dx DY:(float)dy
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:cy
                                                       constant:dy]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:cx
                                                       constant:dx]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
}
-(void)addOnCenterRight:(UIView *)view W:(float)w H:(float)h DR:(float)dr MultCY:(float)cy DY:(float)dy;
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:cy
                                                       constant:dy]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:dr]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
}
-(void)addOnCenterLeft:(UIView *)view W:(float)w H:(float)h DL:(float)dl  MultCY:(float)cy  DY:(float)dy
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:cy
                                                       constant:dy]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:dl]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
}
-(void)addOnCenterTop:(UIView *)view W:(float)w H:(float)h DT:(float)dt  MultCX:(float)cx  DX:(float)dx
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:cx
                                                       constant:dx]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:dt]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }

}
//添加到自己的子View，上下中心对齐，局右，偏差dr、dy，如果w!=0或h!=0,设置宽和高度,并且可设置为MatchParent,负数代表倍数
-(void)addOnCenterBottom:(UIView *)view W:(float)w H:(float)h DB:(float)db  MultCX:(float)cx  DX:(float)dx
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:cx
                                                       constant:dx]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:db]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }

}
-(void)addOnLeftTop:(UIView *)view W:(float)w H:(float)h DLeft:(float)dleft  DTop:(float)dtop
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:dleft]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:dtop]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
    
}

-(void)addOnLeftBottom:(UIView *)view W:(float)w H:(float)h DLeft:(float)dleft  DBottom:(float)dbottom
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:dleft]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:dbottom]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
    
}

-(void)addOnRightBottom:(UIView *)view W:(float)w H:(float)h DRight:(float)dright  DBottom:(float)dbottom
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:dright]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:dbottom]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
}


-(void)addOnRightTop:(UIView *)view W:(float)w H:(float)h DRight:(float)dright  DTop:(float)dtop

{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:dright]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:dtop]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
    
}
-(void)addView:(UIView *)view toViewTopRight:(UIView*)leftView W:(float)w H:(float)h DMargin:(float)dmargin  DTop:(float)dtop

{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:leftView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:dmargin]];
    [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:leftView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:dtop]];
    
    if (w>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeWidth];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:w]];
    }else if(w<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:-w
                                                           constant:0]];
    }
    
    if (h>0) {
        [self removeConstraintsFirstItem:view firstAttribute:NSLayoutAttributeHeight];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:h]];
    }else if(h<0){
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:-h
                                                           constant:0]];
    }
    
}


@end

@implementation UIView (view)

-(void)setOnFrameChange:(void(^)(UIView*view,CGRect oldRect,CGRect newRect))block{
    objc_setAssociatedObject(self, &"fb", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)layoutSubviews{
    void(^(block))(UIView*view,CGRect oldRect,CGRect newRect) = objc_getAssociatedObject(self,&"fb");
    if(block){
        //NSRange
        NSValue*oldRectValue = objc_getAssociatedObject(self,&"fr");
        CGRect oldRect = [oldRectValue CGRectValue];
        CGRect newRect = self.frame;
        block(self,oldRect,newRect);
        
        oldRectValue =[NSValue valueWithCGRect:newRect];
        objc_setAssociatedObject(self, &"fr",oldRectValue , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(void)removeAllChild
{
    NSArray* arr = self.subviews;
    for (int i=0; i< arr.count; i++) {
        UIView*v = [arr objectAtIndex:i];
        [v removeFromSuperview];
    }

}
-(void)setRadius:(float)r borderWidth:(int)bw borderColor:(int)c
{
    
    //设置圆角边框
    self.layer.cornerRadius = r;
    self.layer.masksToBounds = YES;
    //设置边框及边框颜色
    self.layer.borderWidth = bw;
    self.layer.borderColor = COLOR(c).CGColor;
    
    return;
}
-(void)showViewController:(XBaseViewController*)vc{
    [findXBaseViewController(self) showNewController:vc animated:true];
}
@end
@implementation UILabel (Text)
-(void) setText:(NSString *)text Color:(int)color Size:(float)size{
    [self setText:text];
    [self setTextColor:COLOR(color)];
    [self setFont:[[self font] fontWithSize:size]];
}
@end
@implementation UIButton (OnClickBack)



-(void)setNormalColor:(int)color PressColor:(int)sColor DisabledColor:(int)dColor
{
    [self setNormalImage:createImageWithColor(color) PressImage:createImageWithColor(sColor) DisabledImage:createImageWithColor(dColor)];
}

-(void)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge DisabledImage:(UIImage*)dIamge
{
    self.backgroundColor = COLOR(0);
    [self setBackgroundImage:iamge forState:UIControlStateNormal];
    [self setBackgroundImage:sIamge forState:UIControlStateSelected];
    [self setBackgroundImage:sIamge forState:UIControlStateHighlighted];
    [self setBackgroundImage:dIamge forState:UIControlStateDisabled];
    
}


@end

@implementation UITextField(MaxLength)
-(void)setMaxLength:(int)length{
    [self putXBingDataInt:@"__MaxLength" :length];
    [self addTarget:self
             action:@selector(textFiledEditChangedMaxLength)
   forControlEvents:UIControlEventEditingChanged];
    
}
-(void)textFiledEditChangedMaxLength{
    int max = [self getXBingDataInt:@"__MaxLength" Fail:0X0FFFFFFF];
    if ([self.text length]>max) {
        self.text = [self.text substringToIndex:max];
    }
}
@end
@implementation UIView (OnDraw)
-(void)onCallInvalidateDelay{
    //[self putXBingDataBOOL:@"hasCallInvalidateDelay" :false];
    [self setNeedsDisplay];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
//延时刷新
-(void) postInvalidateDelay:(double) delay{
    if(delay==0){
        [self postInvalidate];
    }else/* if ([self getXBingDataBOOL:@"hasCallInvalidateDelay" Fail:false]==false) */{
        [self performSelector:@selector(onCallInvalidateDelay)
                   withObject:nil
                   afterDelay:delay];
    }
}
-(void)onCallInvalidate{
    [self putXBingDataBOOL:@"hasCallInvalidate" :false];
    [self setNeedsDisplay];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
-(void) postInvalidate{
    if ([self getXBingDataBOOL:@"hasCallInvalidate" Fail:false]==false) {
        [self performSelector:@selector(onCallInvalidate)
                   withObject:nil
                   afterDelay:0.001];
    }
}

//查找子view根据tag
-(UIView*)findViewByTag:(long)tag
{
    
    
    for (UIView*cv in self.subviews) {
        if (cv.tag==tag) {
            return cv;
        }
    }
    
    for (UIView*cv in self.subviews) {
        UIView *tagView = [cv findViewByTag:tag];
        if (tagView) {
            return tagView;
        }
    }
    return nil;
}
@end

@implementation TouchHideKeyborad
-(id)init{
    self = [super init];
    //不用释放，若引用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wilShowInputWindow) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wilHideInputWindow) name: UIKeyboardWillHideNotification object:nil];
    [self setClickAble:false];
    return self;
}

-(void)dealloc{
    //ios8.3  8.4 没有自动释放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)wilShowInputWindow{
    [self setClickAble:true];
    if(findXBaseViewController(self).hasAppear && self.showTag){
        [self.showTag performSelector:self.showSel withObject:nil];
    }
}
-(void)wilHideInputWindow{
    [self setClickAble:false];
    if(findXBaseViewController(self).hasAppear && self.hideTag){
        [self.hideTag performSelector:self.hideSel withObject:nil];
    }
}
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    [super touchesBegan:touches withEvent:event];
    
    [findXBaseViewController(self) hideInput];
}

-(void)setOnShowTag:(NSObject*)tag selector:(SEL)sel{
    self.showSel = sel;
    self.showTag=tag;
}
-(void)setOnHideTag:(NSObject*)tag selector:(SEL)sel{
    self.hideSel = sel;
    self.hideTag=tag;
}
@end
