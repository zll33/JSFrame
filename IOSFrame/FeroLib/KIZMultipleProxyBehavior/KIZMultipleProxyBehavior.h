//
//  KIZMultipleProxyBehavior.h
//  KIZParallaTableDemo https://github.com/zziking/KIZBehavior
//
//  Created by kingizz on 15/8/17.
//  Copyright (c) 2015年 kingizz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIZMultipleProxyBehavior : NSObject

-(void)addDelegate:(NSObject*)delg;
//只调用一次接口
@property(nonatomic)BOOL callDelegateOnce;
@end
