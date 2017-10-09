//
//  XScrollPageView.h
//  dddd
//
//  Created by kzd on 14-5-13.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XScrollPageView : UIView
-(void)setPageWidthScal:(float)pageWidthScal PageSpace:(float) pageSpace;
-(void)addPageView:(UIView*)view;
-(void)removePageView:(UIView*)view;
-(void)removeAllPageView;
-(void)setIntervalTime:(int)time;
-(void)scrollToPage:(int)index;
-(void)changeToPage:(int)index;
-(int)getPageIndex;
-(UIView*)getPageView:(int)index;
-(void)showPageIndexView;
-(void)hidePageIndexView;
-(void)setPageIndexViewMBottom:(float)b;
-(void)setOnPageChange:(void (^)(int index))onChange;
//-(void)rebuild;
-(void)unload;
-(void)setCanScroll:(BOOL)ifCanScroll;
@end
