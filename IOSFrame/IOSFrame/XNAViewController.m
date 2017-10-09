//
//  XNAViewController.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/18.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XNAViewController.h"
#import "XHeader.h"
#import "MainPage.h"
#import "Splash.h"
#import "MyView.h"
#import "UIImage+GIF.h"

@interface MyPageLoading : PageLoading




@end

@implementation MyPageLoading

-(void)onCreate{
    [super onCreate];
    
    //设置加载动画
//    [self.activityIndicatorView removeFromSuperview];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sgif" ofType:@"gif"];
//    LCImage*git = [LCImage newWithUrl:path Width:136 Height:160];
//    NSData*data = [NSData dataWithContentsOfFile:path];
//    if (data) {
//        [git getImageView].image  = [UIImage sd_animatedGIFWithData:data];
//    }
//    [self.loadingView addOnCenter:[git getView] W:120 H:120 DX:0 DY:0];
    
    
    //设置网络错误图标
    [self.errIcon setUrl:@"pageerr"];
    [self.errIcon setWidth:217];
    [self.errIcon setHeight:160];
    
    [self.errButton setWidth:139];
    [self.errButton setHeight:42];
    [self.errButton setBackColor:0xFFD45D4F];
    //
    
    //
    
    
    
}


@end


@interface XNAViewController ()<XBaseViewControllerListener>

@end
XNAViewController* _XNAViewController=nil;
@implementation XNAViewController

-(void)viewDidUnload{
    [super viewDidUnload];
    _XNAViewController = nil;
}
-(void)onViewLoad:(XBaseViewController*)controller
{
    [controller.xtitleBar setSysBackColor:0xff000000];
    [controller.xtitleBar.middelTitle.getLabel setFont:[UIFont boldSystemFontOfSize:Value_Title_FontSize]];
    [controller.xtitleBar.middelTitle setFontColor:COLOR(0xffffffff)];
    [controller.xtitleBar.midTitle setTextColor:COLOR(0xffffffff)];
    [controller.xtitleBar.midTitle setFont:[UIFont boldSystemFontOfSize:Value_Title_FontSize]];
    [controller.xtitleBar.midTitle setNumberOfLines:1];
    [controller.xtitleBar.titleLayout setWH:controller.xtitleBar.midTitle MultW:1 MultH:1 DW:-120 DH:0];
    
    [controller.xtitleBar.leftImage setUrl:@"backwhite"];
    [controller.xtitleBar.leftImage setPading:8];
    [controller.xtitleBar.leftImage setPRight:4];
    [[controller.xtitleBar.leftImage getContentCell]setHeight:21];
    [[controller.xtitleBar.leftImage getContentCell] setWidth:13];
    [controller.xtitleBar.leftImage setWidth:WrapContent];
    [controller.xtitleBar.leftTitle setFontSize:16];
    [controller.xtitleBar addOnCenterBottom:[LCLine newHeight1Color:Color_Line].getView W:0 H:0 DB:0 MultCX:1 DX:0];
    [controller.xtitleBar setLeftTitleTitle:@"返回"];
    [controller.xtitleBar setLeftTitleForBack:TRUE];
    
    //
    [controller setLoadingView:[MyPageLoading new]];
}

-(XBaseViewController *)appTopViewController
{
    UIViewController* top =  self;
    XBaseViewController* temp= top;
    while (temp) {
        temp = [[temp childViewControllers] lastObject];
        if (temp) {
            top = temp;
        }
    }
    return top;
}
+(XBaseViewController*)getTopController{
    return [_XNAViewController appTopViewController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _XNAViewController = self;
    [XBaseViewController setBaseStyle:UIStatusBarStyleLightContent];
 
    [XBaseViewController setOnInit:self];
    
    //数字 四舍五入
    setNumberFormatRoundingMode(NSNumberFormatterRoundHalfDown);
    
    
    //触发错误码100时，自动清空帐号，并广播@"login"事件。其它页面收到时间后，将刷新登录状态。
    //[DownLoad setLogoutErr:100 Err:100 Act:@"login"];
    [DownLoad setResponseBlockOnFinish:^(DownTask *task) {
       
        
                            }
                             GetStatue:^int(DownTask *task) {
                                 return 0;
                             }
                             IsSuccess:^BOOL(DownTask *task) {
                                 if (task.ResponseStatue==200&&[task.json getBoolean:@"success"]) {
                                     return true;
                                 }
                                 
                                 return false;
                             }
                           IsNeedLogin:^BOOL(DownTask *task) {
                               if (task.ResponseStatue==401||task.ResponseStatue==403) {
                                   return true;
                               }
                               return false;
                           }
                             GetResult:^id(DownTask *task) {
                                 return [task.json objectForKey:@"data"];
                             }
                                GetMsg:^NSString *(DownTask *task) {
                                    //防止二次提示
                                    if(task.forbiddenMsg){
                                        return @"";
                                    }
                                    return [task.json getString:@"message" FailBack:[task isSucc]?nil:@"网络错误"];
                                }
     ];

    //设置一个空页面
    setXTableViewDefaultEV(^UIView *(XTableView *tabelview) {

        
    
        int th = 16;
        int dp =15;
        int ih=136;
        
        UIView *ev = [UIView new];
        
        UILabel*label = [UILabel new];
        [label setText:@"暂无数据，去看看别的～" Color:0xff79818C Size:16];
        label.tag=XTBEmptyLabelTag;
        [ev addOnCenter:label W:0 H:0 DX:0 DY:-(th+dp+ih)/2+th/2];
        
        UIImageView*image = [UIImageView new];
        image.tag=XTBEmptyImageTag;
        image.image = [UIImage imageNamed:@"empty"];
        [ev addOnCenter:image W:120 H:ih DX:0 DY:(th+dp+ih)/2-ih/2];
        
        
        return ev;
    });

    
    [self pushViewController:[Splash new] animated:NO ];
//    [self pushViewController:[MainPage new] animated:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)backToTopControllerAnimated:(BOOL)animated{

}
+(UIViewController*)showNewControllerWithBackToTopController:(UIViewController*)newCon :(NSString*)newConIdentifier  animated:(BOOL)animated
{
    if (_XNAViewController!=nil) {
        if (newCon==nil) {
            newCon = [_XNAViewController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
        }
        if (_XNAViewController) {
            NSArray * list = [NSArray arrayWithArray: [ _XNAViewController childViewControllers]];
            [_XNAViewController pushViewController:newCon animated:animated];
            //在定部时清空所有数据
            if ([newCon conformsToProtocol:@protocol(XControllerProtocol)]) {
                [(id<XControllerProtocol>)newCon setPreviousXControllerProtocol: nil Requset:0];
            }
            for (UIViewController *vc  in list) {
                [vc removeFromParentViewController];
            }
        }
    }

    return newCon;
}

//- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated NS_DEPRECATED_IOS(2_0, 6_0)
//{
//    UIViewController*LAST = [self.childViewControllers lastObject];
//   
//    [super presentModalViewController:modalViewController animated:NO];
//    
//    //[LAST removeFromParentViewController];
//    
//    return;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
