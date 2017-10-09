//
//  XAction.m
//  Banker
//
//  Created by zhangxiuquan on 15/7/30.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XAction.h"


NSMutableArray*actionList;
@interface XActionNode : NSObject
@property (weak) id owner;
@property (nonatomic) NSString*act;
@property (nonatomic,strong) XActionDoAct doAct;

@end
@implementation XActionNode

@end


@implementation XAction
+(void)addAction:(NSString*)act Owner:(id)owner DoAct:(XActionDoAct)bolck{
    if (actionList==nil) {
        actionList = [NSMutableArray new];
    }
    @synchronized(actionList){
        XActionNode* node = [XActionNode new];
        node.owner=owner;
        node.act=act;
        node.doAct=bolck;
        [actionList addObject:node];
    }
    

}
+(void)callAction:(NSString*)act CalkBack:(XActionCallBack)callBack Data:(id)data Code:(int)code
{
    if (actionList==nil) {
        actionList = [NSMutableArray new];
    }
    @synchronized(actionList){
        NSMutableArray * removeList = [NSMutableArray new];
        NSMutableArray * callList = [NSMutableArray new];
        for (XActionNode*node in actionList) {
            if (node.owner==nil) {
                [removeList addObject:node];
            }else if([node.act isEqualToString:act]){
                [callList addObject:node];
            }
        }
        for (XActionNode*node in callList) {
            node.doAct(node.owner,callBack,act,data,code);
        }
        for (XActionNode*node in removeList) {
            node.act=nil;
            node.owner=nil;
            node.doAct=nil;
            [actionList removeObject:node];
        }
        [callList removeAllObjects];
        [removeList removeAllObjects];
    }
}
+(void)removeAction:(NSString*)act Owner:(id)owner
{
    if (actionList==nil) {
        actionList = [NSMutableArray new];
    }
    @synchronized(actionList){
        NSMutableArray * removeList = [NSMutableArray new];
        for (XActionNode*node in actionList) {
            if (node.owner==nil ||
                ((act==nil||[node.act isEqualToString:act])&&(owner==node.owner))) {
                [removeList addObject:node];
            }
        }
        for (XActionNode*node in removeList) {
            node.act=nil;
            node.owner=nil;
            node.doAct=nil;
            [actionList removeObject:node];
        }
        [removeList removeAllObjects];
    }
}
@end
