//
//  EditViewController.h
//  
//
//  Created by zhangxiuquan on 2017/3/16.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "XBaseViewController.h"

//当新的输入数据，比旧的数据多，则认为数据有变动，弹出提示是否退出
@interface EditViewController : XBaseViewController
@property(nonatomic)NSString*notiTitle;
@property(nonatomic)NSString*notiYes;
@property(nonatomic)NSString*notiNo;

@property(nonatomic)XJson*oldInfo;
@property(nonatomic)XJson*editInfo;

-(void)callSuperBack;
@end
