//
//  DialogMsg.h
//  FreeCondomWeb
//
//  Created by kzd on 14-4-15.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import <UIKit/UIKit.h>

// showmsg :(NSString *) title : (NSString *) msg : (NSString *) yes : (NSString *) no :  (NSString *) yeaJs :  (NSString *) noJs
@class DialogMsg;


@interface DialogMsg : UIAlertView
@property(nonatomic) BOOL notAllowHide;
@property (nonatomic, strong) void(^yesFun)(NSString* inputText) ;
@property (nonatomic, strong) void(^noFun)(void);
-(void)show;
-(void)hide;

+(DialogMsg*)newWithTitle:(NSString*)title
                Msg:(NSString*)msg
           HasInput:(BOOL)has
        ConmitTitle:(NSString*)conmitTitle
             Conmit:(void(^)(NSString* inputText))conmit
        CancelTitle:(NSString*)cancelTitle
             Cancel:(void(^)(void))cancel;

@end
