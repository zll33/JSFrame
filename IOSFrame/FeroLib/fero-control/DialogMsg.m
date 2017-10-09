//
//  DialogMsg.m
//  FreeCondomWeb
//
//  Created by kzd on 14-4-15.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import "DialogMsg.h"
@interface DialogMsg () <UIAlertViewDelegate,UITextFieldDelegate>
{
    Boolean hasInput;
}




@end


@implementation DialogMsg

@synthesize yesFun;
@synthesize noFun;
@synthesize notAllowHide;
//-(void)show
//{
//    [super show];
//}
-(void) callCancelFun{
    if (noFun!=nil) {
        noFun();
    }
}
-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    if(false==notAllowHide){
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}
-(void)hide
{
    if (![self isHidden]) {
        [self dismissWithClickedButtonIndex:0 animated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self callCancelFun];
        [self hide];
    }else if(yesFun!=nil){
        NSString* text=nil;
        
        UITextField *tf = [self textFieldAtIndex:0];
        tf.delegate=self;
        if (tf) {
            text = tf.text;
        }
        
        yesFun(text);
    }
    [self hide];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self callCancelFun];
}


+(DialogMsg*)newWithTitle:(NSString*)title
                     Msg:(NSString*)msg
                HasInput:(BOOL)has
             ConmitTitle:(NSString*)conmitTitle
                  Conmit:(void(^)(NSString* inputText))conmit
             CancelTitle:(NSString*)cancelTitle
                  Cancel:(void(^)(void))cancel;
{
 
    DialogMsg*dialog = [[DialogMsg alloc]initWithTitle:title
                                                  message:msg
                                                 delegate:nil
                                        cancelButtonTitle:cancelTitle
                                        otherButtonTitles:conmitTitle,nil];
    
    if (has) {
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    dialog.delegate=dialog;
    dialog.yesFun = conmit;
    dialog.noFun = cancel;
    dialog.notAllowHide=false;
    return dialog;
}
@end
