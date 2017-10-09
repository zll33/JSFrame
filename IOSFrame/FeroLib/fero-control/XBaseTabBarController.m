//
//  XBaseTabBarController.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/18.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XBaseTabBarController.h"
#import "HelpApi.h"
@interface XBaseTabBarController ()
{
    UIView*msgLableBack;
    UILabel*msgLable;
    XJson* paramList;
    
    id<XControllerProtocol> previousXControllerProtocol;
    int requsetCode;
    int backCode;
    XJson* data;
    id data2;
}
@end

@implementation XBaseTabBarController
-(id)init{
    self = [super init];
     [self XBaseTabBarController_onCreate];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self XBaseTabBarController_onCreate];
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self XBaseTabBarController_onCreate];
    return self;
}
-(void)XBaseTabBarController_onCreate{
    paramList = [[XJson alloc]init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)showMsg:(NSString*)msg
{
    
    runOnUiTread2(^(){
        if (msgLable==nil || msgLableBack==nil) {
            
            msgLableBack = [[UIView alloc]init];
            msgLableBack.backgroundColor = COLOR(0xaa000000);
            msgLableBack.clipsToBounds = true;
            msgLable = [[UILabel alloc]init];
            msgLable.clipsToBounds = true;
            msgLable.textAlignment = UITextAlignmentCenter;
            msgLable.numberOfLines = 0;
            [msgLable setTextColor:COLOR(0xffffffff)];
            [msgLable setFont:[UIFont systemFontOfSize:PD2PX(16)]];
            msgLable.backgroundColor = COLOR(0x00000000);
            
            [msgLableBack addSubview: msgLable];
            [self.view addSubview: msgLableBack];
            
        }
        [msgLable setText:msg];
        
        CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:PD2PX(16)]
                      constrainedToSize:CGSizeMake(PD2PX(SCRW - PD2PX(15) - PD2PX(15)), CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByCharWrapping];
        
        msgLable.frame = CGRectMake(PD2PX(15),PD2PX(15),size.width,size.height);
        msgLableBack.frame = CGRectMake(0,0,size.width+PD2PX(15)*2,size.height+PD2PX(15)*2);
        msgLableBack.center = CGPointMake(SCRW/2, SCRH/3);
        [self.view  bringSubviewToFront:msgLableBack];
        msgLableBack.alpha = 0.0;
        UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
        [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^
         {
             msgLableBack.alpha = 1.0;
         } completion:^(BOOL finish){
             msgLableBack.alpha = 1.0;
             [UIView animateWithDuration:0.2 delay:0.8 options:options animations:^{
                 msgLableBack.alpha = 0.0;
             }completion:nil];
         }];
        
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(int)getIntKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [[paramList objectForKey:key] intValue];
    }
    return 0;
}
-(long)getLongKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [[paramList objectForKey:key] longValue];
    }
    return 0;
}
-(NSString*)getStringKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return toString([paramList objectForKey:key]);
    }
    return nil;
}
/**
 *取不到时，返回false
 */
-(Boolean)getBooleanKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [[paramList objectForKey:key] boolValue];
    }
    return false;
}
-(id)getObjectKey:(NSString*)key
{
    if (key && [paramList objectForKey:key]) {
        return [paramList objectForKey:key];
    }
    return nil;
}
-(void)addInt:(int)value Key:(NSString*)key
{
    if (key) {
        [paramList setObject:[[NSNumber alloc]initWithInt:value] forKey:key];
    }
    
}
-(void)addLong:(long)value Key:(NSString*)key
{
    if (key) {
        [paramList setObject:[[NSNumber alloc]initWithLong:value] forKey:key];
    }
}
-(void)addString:(NSString*)value Key:(NSString*)key
{
    if (value && key) {
        [paramList setObject:value forKey:key];
    }
}
-(void)addBoolean:(Boolean)value Key:(NSString*)key
{
    if (key) {
        [paramList setObject:[[NSNumber alloc]initWithBool:value] forKey:key];
    }
}
-(void)addObject:(id)value Key:(NSString*)key
{
    if (value && key) {
        [paramList setObject:value forKey:key];
    }
}
-(void)addMuValue:(XJson*)value
{
    [paramList addEntriesFromDictionary:value];
}

/**
 *
 */

/*
 *获取所在的UIViewController
 */


-(UIViewController*)getUIViewController
{
    return self;
}
-(id<XControllerProtocol>)getPreviousXControllerProtocol
{
    return previousXControllerProtocol;
}
-(void)setPreviousXControllerProtocol:(id<XControllerProtocol>)previous Requset:(int)rcode
{
    previousXControllerProtocol = previous;
    requsetCode = rcode;
}
/*
 *显示一个新页面
 */
-(UIViewController*)showNewControllerIdentifier:(NSString*)newConIdentifier  animated:(BOOL)animated
{
    return [self showNewController:nil Identifier:newConIdentifier RequestCode:0 Param:nil animated:animated];
}
-(UIViewController*)showNewController:(UIViewController*)newCon  animated:(BOOL)animated
{
    return [self showNewController:newCon Identifier:nil RequestCode:0 Param:nil animated:animated];
}
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier RequestCode:(int)rCode Param:(XJson*)param animated:(BOOL)animated
{
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if ([newCon conformsToProtocol:@protocol(XControllerProtocol)]) {
        [(id<XControllerProtocol>)newCon setPreviousXControllerProtocol: self Requset:rCode];
        [(id<XControllerProtocol>)newCon addMuValue:param];
    }
    if (self.navigationController) {
        [self.navigationController pushViewController:newCon animated:animated];
    }
    
    return newCon;
}


/*
 *显示一个新页面,并且关闭一些页面
 */
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier BackToControllerIdentifier:(NSString*)backToConIdentifier  animated:(BOOL)animated
{
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if (self.navigationController) {
        NSMutableArray * list = [NSMutableArray new];
        
        int count = [[self.navigationController childViewControllers] count];
        for (int i= count-1; i>=0; i--) {
            UIViewController *vc = [[self.navigationController childViewControllers] objectAtIndex:i];
            [list addObject:vc];
            if ([vc.restorationIdentifier isEqualToString:backToConIdentifier]) {
                [self showNewController:newCon  animated:animated];
                for (UIViewController *vc  in list) {
                    [vc removeFromParentViewController];
                }
                break;
            }
        }
        
        
    }
    
    return newCon;
    
}
-(UIViewController*)showNewController:(UIViewController*)newCon Identifier:(NSString*)newConIdentifier BackToControllerByCount:(int)backCount  animated:(BOOL)animated
{
    
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if (self.navigationController) {
        NSMutableArray * list = [NSMutableArray new];
        
        int count = [[self.navigationController childViewControllers] count];
        for (int i= count-1; i>=0 && count - i <= backCount; i--) {
            UIViewController *vc = [[self.navigationController childViewControllers] objectAtIndex:i];
            [list addObject:vc];
        }
        
        [self showNewController:newCon  animated:animated];
        
        for (UIViewController *vc  in list) {
            [vc removeFromParentViewController];
        }
        
    }
    
    return newCon;
    
}

-(UIViewController*)showNewControllerWithBackToTopController:(UIViewController*)newCon :(NSString*)newConIdentifier  animated:(BOOL)animated
{
    if (newCon==nil) {
        newCon = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:newConIdentifier];
    }
    if (self.navigationController) {
        NSArray * list = [NSArray arrayWithArray: [ self.navigationController childViewControllers]];
        [self showNewController:newCon  animated:animated];
        //在定部时清空所有数据
        if ([newCon conformsToProtocol:@protocol(XControllerProtocol)]) {
            [(id<XControllerProtocol>)newCon setPreviousXControllerProtocol: nil Requset:0];
        }
        for (UIViewController *vc  in list) {
            [vc removeFromParentViewController];
        }
    }
    
    return newCon;
}

-(NSString  *) getMeIdentifier
{
    NSString *restorationId = self.restorationIdentifier;
    return restorationId;
}

-(void)doBackData
{
    
    if (previousXControllerProtocol && requsetCode>0) {
        [previousXControllerProtocol onBackFromOtherController:self Identifier:[self getMeIdentifier] RequestCode:requsetCode BackCode:backCode Data:data Data2:data2];
        requsetCode = 0;
        backCode = 0;
        data = nil;
        data2 = nil;
    }
    previousXControllerProtocol = nil;
}
/**
 *退出
 */
-(void)callBack
{
    [self back:true];
}

-(void)back:(BOOL)animated
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
        [self doBackData];
    }else{
        [self dismissViewControllerAnimated:animated completion:nil];
        [self doBackData];
    }
}
-(void)backToController:(UIViewController*)c  animated:(BOOL)animated
{
    if (self.navigationController && c) {
        [self.navigationController popToViewController:c animated:animated];
        [self doBackData];
    }
}
-(void)backToControllerByIdentifier:(NSString*)identifier  animated:(BOOL)animated
{
    UIViewController * toCon = nil;
    int count = [[self.navigationController childViewControllers] count];
    for (int i= count-1; i>=0; i--) {
        UIViewController *vc = [[self.navigationController childViewControllers] objectAtIndex:i];
        if ([vc.restorationIdentifier isEqualToString:identifier]) {
            toCon = vc;
            [self backToController:toCon animated:animated];
            break;
        }
    }
}

-(void)backToControllerByBackCount:(int)count  animated:(BOOL)animated
{
    UIViewController * toCon = nil;
    
    for (UIViewController *vc in [self.navigationController childViewControllers]) {
        count --;
        if (count==0) {
            toCon = vc;
            [self backToController:toCon animated:animated];
            break;
        }
    }
    
    
}

//返回时的数据
-(void)setBackCode:(int)bCode Data:(XJson*)d Data2:(id)d2
{
    backCode = bCode;
    data=d;
    data2=d2;
}
-(void)onBackFromOtherController:(UIViewController*)c Identifier:(NSString*)identifier RequestCode:(int)rCode BackCode:(int)bCode Data:(XJson*)data Data2:(id)data2
{
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

@end
