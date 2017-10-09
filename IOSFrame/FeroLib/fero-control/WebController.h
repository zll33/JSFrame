//
//  WebController.h
//  p2p
//
//  Created by zhangxiuquan on 15/5/28.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XBaseViewController.h"

@interface WebController : XBaseViewController

@property(nonatomic) UIWebView* webView;
@property(nonatomic) UIActivityIndicatorView*activityIndicatorView;
- (void)loadWebPageWithString:(NSString*)urlString;
@property (nonatomic) BOOL useHTMLTitle;
@end
