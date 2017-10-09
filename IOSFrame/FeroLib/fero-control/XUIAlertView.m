//
//  XUIAlertView.m
//  moi
//
//  Created by zhangxiuquan on 16/7/7.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import "XUIAlertView.h"
@interface XUIAlertViewDel:NSObject<UIAlertViewDelegate>
@property(nonatomic,weak) id target;
@property(nonatomic) SEL action;
@property(nonatomic) void(^onyes)(void);
@property(nonatomic) BOOL hasTwoButton;
@end
@implementation XUIAlertViewDel
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    if(!self.hasTwoButton || buttonIndex==1){
        if(self.onyes){
            self.onyes();
        }else if(self.target){
            [self.target performSelector:self.action withObject:nil withObject:nil];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)  // after animation
{
    self.target=nil;
    self.action=nil;
    self.onyes=nil;
}
@end

@interface XUIAlertView()
@property(nonatomic) id deletga;
@end

@implementation XUIAlertView


+(XUIAlertView*)newWithTitle:(NSString*)title Msg:(NSString*)msg Cancel:(NSString*)cancel Yes:(NSString*)yes Target:(id)target action:(SEL)action{
    XUIAlertViewDel*delegate= [XUIAlertViewDel new];
    XUIAlertView *alert = [[XUIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:yes , nil];
    delegate.target=target;
    delegate.action=action;
    delegate.hasTwoButton=(cancel!=nil&&yes!=nil);
    //防止自动释放
    alert.deletga=delegate;
    return alert;
}
+(XUIAlertView*)newWithTitle:(NSString*)title Msg:(NSString*)msg Cancel:(NSString*)cancel Yes:(NSString*)yes Action:(void(^)(void))onyes{
    XUIAlertViewDel*delegate= [XUIAlertViewDel new];
    XUIAlertView *alert = [[XUIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:yes , nil];
    delegate.onyes=onyes;
    delegate.hasTwoButton=(cancel!=nil&&yes!=nil);
    //防止自动释放
    alert.deletga=delegate;
    return alert;
}

@end
