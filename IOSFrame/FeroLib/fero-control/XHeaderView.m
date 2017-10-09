//
//  XHeaderView.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/9.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XHeaderView.h"
@interface XHeaderView()
{
    Boolean has;
}
@end
@implementation XHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setText:(NSString*)text
{
    [self.title setText:text];
}
-(void)setHasTime:(Boolean) hasTime
{
    has=hasTime;
    self.msg.hidden = hasTime;
}
-(void)startActView
{
    if(![self.avtivityInView isAnimating]){
        
        [self.avtivityInView startAnimating];
    }
    
}
-(void)stopActView
{
    if([self.avtivityInView isAnimating]){
        
        [self.avtivityInView stopAnimating];
    }
}

@end
