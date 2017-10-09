//
//  XKeyBoardTopView.m
//  moi
//
//  Created by zhangxiuquan on 16/1/25.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import "XKeyBoardTopView.h"
#import "XViewEx.h"
#import "HelpApi.h"
#import "ViewFactory.h"
BOOL __UseXKeyBoardTopView = TRUE;
void setUseXKeyBoardTopView(BOOL use){
    __UseXKeyBoardTopView = use;
}
@interface XKeyBoardTopView ()
{
    __weak UIView *textView;
}

@end
@implementation XKeyBoardTopView

-(instancetype)addToKeyBoardView:(UIView*)view{
    textView = view;
    self.frame=CGRectMake(0, 0,0, 40);
    [self setBackgroundColor:COLOR(0XFFFFFFFF)];
    UIButton *btn = [UIButton new];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont  systemFontOfSize:14]];
    
    [btn setTitleColor:COLOR(0XFF0076FF) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callHideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self addOnCenterRight:btn W:60 H:36 DR:-4 MultCY:1 DY:0];
    
    
    if ([view isKindOfClass:[UITextField class]]) {
        ((UITextField*)textView).inputAccessoryView = self;
    }else    if ([view isKindOfClass:[UITextView class]]) {
        ((UITextView*)textView).inputAccessoryView = self;
    }else    if ([view isKindOfClass:[UISearchBar class]]) {
        ((UISearchBar*)textView).inputAccessoryView = self;
    }
    
    //
    [self addOnCenterTop:[XLine newHeight1Color:0XFFC5C5C5] W:MatchPatrent H:0 DT:0 MultCX:1 DX:0];
    [self addOnCenterBottom:[XLine newHeight1Color:0XFFC5C5C5] W:MatchPatrent H:0 DB:0 MultCX:1 DX:0];
    
     
    return self;
}
-(void)callHideKeyBoard
{
    [textView resignFirstResponder];
}

@end
@implementation UITextField(XKeyBoardTopView)
-(void)hideTopView{
    self.inputAccessoryView=nil;
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (self.inputAccessoryView==nil&&__UseXKeyBoardTopView) {
        [[XKeyBoardTopView new] addToKeyBoardView:self];
    }
    
}
@end
@implementation UITextView(XKeyBoardTopView)
-(void)hideTopView{
    self.inputAccessoryView=nil;
}
- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (self.inputAccessoryView==nil&&__UseXKeyBoardTopView) {
        [[XKeyBoardTopView new] addToKeyBoardView:self];
    }
}
@end
@implementation UISearchBar(XKeyBoardTopView)
-(void)hideTopView{
    self.inputAccessoryView=nil;
}
- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (self.inputAccessoryView==nil&&__UseXKeyBoardTopView) {
        [[XKeyBoardTopView new] addToKeyBoardView:self];
    }
    
}
@end

