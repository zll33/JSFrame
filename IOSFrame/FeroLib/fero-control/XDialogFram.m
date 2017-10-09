//
//  XDialogFram.m
//  moi
//
//  Created by zhangxiuquan on 16/9/6.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import "XDialogFram.h"
#import "XHeader.h"
#import "XViewEx.h"
#import "HelpApi.h"
@interface XDialogFram()
{
    void(^onClose)(XDialogFram*dialog);
    
}

@property (nonatomic, weak) UIView *contentView;
//
@property (nonatomic, weak) id<NSObject> observer;
@end
@implementation XDialogFram
-(instancetype)init{
    self = [super init];
    [self XDialogFram_oncreate];
    return self;
}
-(void)XDialogFram_oncreate{
    [self setOnClickTarget:self action:@selector(hide)];
    self.backgroundColor=COLOR(0X4C000000);
    //键盘弹出动画时，移动居中
    [self addFixInput];
    
}
-(void)setFobiddenFixKeyBoard:(BOOL)fobiddenFixKeyBoard{
    _fobiddenFixKeyBoard=fobiddenFixKeyBoard;
    if(_fobiddenFixKeyBoard){
        if(self.observer!=nil){
            [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
            self.observer = nil;
        }
    }else{
        [self addFixInput];
    }

}
-(void)addFixInput{
    if(self.observer==nil){
        WS(weakSelf)
        self.observer = [[NSNotificationCenter defaultCenter]
                         addObserverForName:UIKeyboardWillChangeFrameNotification
                         object:nil
                         queue:[NSOperationQueue mainQueue]
                         usingBlock:^(NSNotification * _Nonnull noti) {
                             CGFloat keyY = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
                             CGFloat kScreenH = [[UIScreen mainScreen] bounds].size.height;
                             //                         // 使动画与键盘保持一致,两种动画
                             if ([weakSelf.frontView isKindOfClass:[UIWindow class]]) {
                                 [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                                     //                             weakSelf.transform = CGAffineTransformMakeTranslation(0, (keyY - kScreenH) * 0.35);
                                     weakSelf.transform = CGAffineTransformMakeTranslation(0, (keyY - kScreenH)*0.5);
                                 }];
                                 
                             }else{
                                 //第一次弹出式，动画错误问题。 规避第一次弹出使用动画
                                 if(weakSelf.frame.size.height==0){
                                     [weakSelf.frontView setWH:weakSelf MultW:1 MultH:1 DW:0 DH:keyY-kScreenH];
                                 }else{
                                     
                                     [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                                         
                                         [weakSelf.frontView setWH:weakSelf MultW:1 MultH:1 DW:0 DH:keyY-kScreenH];
                                         [weakSelf.frontView setNeedsDisplay];
                                         [weakSelf.frontView setNeedsUpdateConstraints];
                                         [weakSelf.frontView setNeedsLayout];
                                         [weakSelf.frontView updateConstraintsIfNeeded];
                                         [weakSelf.frontView layoutIfNeeded];
                                     }];
                                 }
                             }
                         }];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    self.observer = nil;
}

- (UIWindow *)frontView
{
    if (_frontView == nil) {
        self.frontView = [UIApplication sharedApplication].keyWindow;
    }
    return _frontView;
}
-(void)show{
    if ([self superview]==nil) {
        //[self.frontView addViewEqSelf:self];
        [self.frontView addOnCenterTop:self W:-1 H:-1 DT:0 MultCX:1 DX:0];
    }
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    if (onClose) {
        onClose(self);
    }
}
-(void)hide{
    [self removeFromSuperview];
}
-(void)setContentViewOnCenter:(UIView*)view{
    [_contentView removeFromSuperview];
    _contentView = view;
    [self addOnCenter:_contentView W:0 H:0 DX:0 DY:0];
    
}
-(void)setContentViewOnBottom:(UIView*)view{
    [_contentView removeFromSuperview];
    _contentView = view;
    [self addOnCenterBottom:_contentView W:0 H:0 DB:0 MultCX:1 DX:0];
}

-(void)setOnClose:(void(^)(XDialogFram*dialog))onc
{
    onClose = onc;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 重新布局对话框视图
    //    self.contentView.centerX = self.centerX;
    //    self.contentView.centerY = self.centerY;
    //    [self.contentView layoutIfNeeded];
}
@end
