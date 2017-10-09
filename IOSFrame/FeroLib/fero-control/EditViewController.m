//
//  EditViewController.m
//  
//
//  Created by zhangxiuquan on 2017/3/16.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController
@synthesize notiTitle;
@synthesize notiYes;
@synthesize notiNo;
//使用synthesize，子类不能覆盖oldInfo、editInfo
//@synthesize oldInfo;
//@synthesize editInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCanMoveBack:FALSE];
    notiTitle = @"信息未保存，确定要返回？";
    notiYes = @"确定";
    notiNo = @"取消";
}
-(BOOL)hasChange{
    XJson*info1 = self.oldInfo;
    if(info1==nil){
        info1 = [XJson new];
    }
    if ([info1 isIncludChild:self.editInfo]) {
        return  false;
    }
    return  true;
}
-(void)callBack{
    if ([self hasChange]) {
        [[DialogMsg newWithTitle:nil
                             Msg:notiTitle
                        HasInput:false
                     ConmitTitle:notiYes
                          Conmit:^(NSString *inputText) {
                              [super callBack];
                          }
                     CancelTitle:notiNo Cancel:^{
                         
                     }] show];
    }else{
        [self callSuperBack];
    }
}
-(void)callSuperBack{
    [super callBack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
