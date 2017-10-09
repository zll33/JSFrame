//
//  XHeaderView.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/9.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avtivityInView;
@property (weak, nonatomic) IBOutlet UILabel *msg;



-(void)setText:(NSString*)text;
-(void)setHasTime:(Boolean) has;
-(void)startActView;
-(void)stopActView;

@end
