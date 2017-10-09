//
//  MainPage.h
//  Banker
//
//  Created by zhangxiuquan on 15/7/24.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XBaseViewController.h"

@interface MainPage : XBaseViewController<NSURLConnectionDelegate>
@property (nonatomic ,assign)BOOL iswhite;
@end

@protocol UpdateContent <NSObject>

-(void)updateContent;

@end
