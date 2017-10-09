//
//  XCircleProgress.h
//  p2p
//
//  Created by zhangxiuquan on 15/4/21.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XLineProgress.h"

@interface XCircleProgress : XLineProgress

@property(nonatomic,copy)            UIColor          *backColor UI_APPEARANCE_SELECTOR;
@property(nonatomic)            int          dr;
@property(nonatomic)            float          lineWide;
@property(nonatomic) BOOL useAnimation;
-(void)setProgresss:(NSMutableArray *)progresss Colors:(NSMutableArray *)colors;
@end
