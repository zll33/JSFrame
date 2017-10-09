//
//  XScrollView.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/22.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

//多重代理，后添加的优先执行
@interface UIScrollView(KIZMultipleProxyBehavior)
-(void)addDelegate:(NSObject*)deg;
//只调用一次接口
@property(nonatomic)BOOL callDelegateOnce;
@end


@protocol XScrollViewDataLoad<NSObject>
- (void) onRefresh;
@optional

@end

@protocol XScrollViewScrollListener<NSObject>

@optional
- (void) onScroll;
@end

@interface XScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign)  id <XScrollViewDataLoad>  dataLoad;
@property (nonatomic, assign)  id <XScrollViewScrollListener>  scrollListener;
- (void)onComplete;
- (void)callRefresh;
/**
 *自动设置contentView的约束
 *
 */
- (UIView*)setContentViewNibNamed:(NSString*)nibName;
- (UIView*)setContentViewNibNamed:(NSString*)nibName Index:(int)index;
/**
 *设置contentView的约束
 *
 */
- (void)setContentView:(UIView*)view;

@property (nonatomic, assign)  UIView* contentView;

@end
