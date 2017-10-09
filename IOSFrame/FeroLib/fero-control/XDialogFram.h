//
//  XDialogFram.h
//  moi
//
//  Created by zhangxiuquan on 16/9/6.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDialogFram : UIView
//禁止适应软键盘，默认false
@property (nonatomic) BOOL fobiddenFixKeyBoard;
@property (nonatomic, weak) UIView *frontView;
-(void)setContentViewOnCenter:(UIView*)view;
-(void)setContentViewOnBottom:(UIView*)view;
-(void)show;
-(void)hide;
-(void)setOnClose:(void(^)(XDialogFram*dialog))onclose;
@end
