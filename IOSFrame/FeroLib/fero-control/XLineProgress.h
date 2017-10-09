//
//  XLineProgress.h
//  p2p
//
//  Created by zhangxiuquan on 15/4/20.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLineProgress : UIView
@property(nonatomic,copy)            UIColor          *lineColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,copy)            UIColor          *lineBackColor UI_APPEARANCE_SELECTOR;
@property(nonatomic)            float          progress;


-(void)setLineColor:(UIColor *)color :(UIColor *)lineBackColor;
@end
