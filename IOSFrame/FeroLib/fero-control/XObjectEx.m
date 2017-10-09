//
//  XObjectEx.m
//  p2p
//
//  Created by zhangxiuquan on 15/2/6.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XObjectEx.h"
#import "XJson.h"
#import "HelpApi.h"
@implementation XObjectEx
@end


@interface StaticDataNode : NSObject
{
    void (*origDealloc)(id,SEL);
}
@property(weak) NSObject*  owner;
@property(nonatomic) XJson* dataList;
-(void)clear;
-(void)callNodeDealloc:(SEL)cmd;
@end

StaticDataNode* getStaticDataNode(NSObject* owner);
static void StaticDataNode_Dealloc(NSObject*object,SEL cmd)
{
    [getStaticDataNode(object) callNodeDealloc:cmd];
}

@implementation StaticDataNode
+(id)new{
    StaticDataNode* node = [super new];
    [node init];
    return node;
}
@synthesize owner;
@synthesize dataList;
-(id)init{
    self = [super init];
    if (dataList==nil) {
        dataList = [XJson new];
        [self addObserver:self
               forKeyPath:@"owner"
                  options:
         NSKeyValueObservingOptionNew|
         NSKeyValueObservingOptionOld|
         NSKeyValueObservingOptionInitial|
         NSKeyValueObservingOptionPrior
                  context:NULL];
        
    }
    return self;
}
-(void)setOwner:(NSObject*)o{
    owner = o;
    //重写释放函数
    //    Method origMethod =class_getInstanceMethod(o, @selector(dealloc));
    //    origDealloc = (void *)class_replaceMethod(o, @selector(dealloc), (IMP)StaticDataNode_Dealloc,method_getTypeEncoding(origMethod));
    
}
-(void)callNodeDealloc:(SEL)cmd{
    if (origDealloc) {
        origDealloc(owner,cmd);
    }
    origDealloc = nil;
    [self clear];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.owner==nil)
    {
        [self clear];
    }
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"owner"];
}

-(void)clear{
    [dataList removeAllObjects];
    //dataList = nil;
}
-(BOOL)isHas:(NSString*)key{
    return [dataList objectForKey:key]!=nil;
}

-(int)getInt:(NSString*)key  Fail:(int) back{
    return [dataList getInt:key FailBack:back];
}
-(BOOL)getBOOL:(NSString*)key  Fail:(BOOL) back{
    return [dataList getBoolean:key];
}
-(long)getLong:(NSString*)key  Fail:(long) back{
    return [dataList getLong:key FailBack:back];
}
-(double)getDouble:(NSString*)key  Fail:(double) back{
    return [dataList getDouble:key FailBack:back];
}
-(NSString*)getString:(NSString*)key{
    return [dataList getString:key];
}
-(id)getObject:(NSString*)key{
    return [dataList objectForKey:key];
}

-(void)putInt:(NSString*)key :(int)value{
    [dataList putInt:key Value:value];
}
-(void)putBOOL:(NSString*)key :(BOOL)value{
    [dataList putBoolean:key Value:value];
}
-(void)putLong:(NSString*)key :(long)value{
    [dataList putLong:key Value:value];
}
-(void)putDouble:(NSString*)key :(double)value{
    [dataList putDouble:key Value:value];
}
-(void)putString:(NSString*)key :(NSString*)value{
    [dataList putString:key Value:value];
}
-(void)putObject:(NSString*)key :(id)value{
    [dataList setValue:value forKey:key];
}
@end





#import <UIKit/UIKit.h>
NSMutableArray * XBingDataStaticDataNodeList;
BOOL isUse(StaticDataNode* node){
    if (node.owner==nil) {
        return false;
    }
    if (node.dataList.count==0) {
        return false;
    }
    return true;
}

StaticDataNode* getStaticDataNode(NSObject* owner){
    
    if (XBingDataStaticDataNodeList==nil) {
        XBingDataStaticDataNodeList = [NSMutableArray new];
    }
    
    StaticDataNode* ownerNode = nil;
    @synchronized(XBingDataStaticDataNodeList) {
        
        int count = [XBingDataStaticDataNodeList count];
        
        
        NSMutableArray * deleteList = [NSMutableArray new];
        
        //1. 查找目标
        for (StaticDataNode* node in XBingDataStaticDataNodeList) {
            if (!isUse(node)) {
                [deleteList addObject:node];
            }else if(ownerNode ==nil && node.owner==owner){
                ownerNode = node;
            }
        }
        //2. 清楚失效的
        for (StaticDataNode* node in deleteList) {
            [node clear];
            node.owner=nil;
            [XBingDataStaticDataNodeList removeObject:node];
        }
        [deleteList removeAllObjects];
        
        //3.添加
        if (ownerNode ==  nil && owner!=nil) {
            ownerNode = [StaticDataNode new];
            ownerNode.owner = owner;
            [XBingDataStaticDataNodeList addObject:ownerNode];
            
        }
    }
    
    return ownerNode;
}

void checkXBingData(){
    
    if (XBingDataStaticDataNodeList==nil) {
        XBingDataStaticDataNodeList = [NSMutableArray new];
    }
    
    
    @synchronized(XBingDataStaticDataNodeList) {
        
        int count = [XBingDataStaticDataNodeList count];
        
        NSMutableArray * deleteList = [NSMutableArray new];
        
        //1. 查找目标
        for (StaticDataNode* node in XBingDataStaticDataNodeList) {
            if (!isUse(node)) {
                [deleteList addObject:node];
            }
        }
        //2. 清楚失效的
        for (StaticDataNode* node in deleteList) {
            [node clear];
            node.owner=nil;
            [XBingDataStaticDataNodeList removeObject:node];
        }
        [deleteList removeAllObjects];
    }
    return ;
    
}
void clearXBingDataForUIContronller(UIViewController*con)
{
    if (XBingDataStaticDataNodeList==nil) {
        XBingDataStaticDataNodeList = [NSMutableArray new];
    }
    
    
    @synchronized(XBingDataStaticDataNodeList) {
        
        int count = [XBingDataStaticDataNodeList count];
        
        NSMutableArray * deleteList = [NSMutableArray new];
        
        //1. 查找目标
        for (StaticDataNode* node in XBingDataStaticDataNodeList) {
            if ([node.owner isKindOfClass:[UIView class]] && findViewController(node.owner)==con) {
                [deleteList addObject:node];
            }
        }
        //2. 清楚失效的
        for (StaticDataNode* node in deleteList) {
            [node clear];
            node.owner=nil;
            [XBingDataStaticDataNodeList removeObject:node];
        }
        [deleteList removeAllObjects];
    }
    return ;
}
@implementation NSObject(XBingData)
-(BOOL)isHasXBingDataKey:(NSString*)key
{
    return [getStaticDataNode(self) isHas:key];
}
-(int)getXBingDataInt:(NSString*)key   Fail:(int) back
{
    return [getStaticDataNode(self) getInt:key Fail: back];
}
-(BOOL)getXBingDataBOOL:(NSString*)key   Fail:(BOOL) back
{
    return [getStaticDataNode(self) getBOOL:key Fail: back];
}
-(long)getXBingDataLong:(NSString*)key   Fail:(long) back
{
    return [getStaticDataNode(self) getLong:key Fail: back];
}
-(double)getXBingDataDouble:(NSString*)key  Fail:(double) back
{
    return [getStaticDataNode(self) getDouble:key Fail: back];
}
-(NSString*)getXBingDataString:(NSString*)key
{
    return [getStaticDataNode(self) getString:key];
}
-(id)getXBingDataObject:(NSString*)key
{
    return [getStaticDataNode(self) getObject:key];
}
-(void)putXBingDataInt:(NSString*)key :(int)value
{
    [getStaticDataNode(self) putInt:key :value ];
}
-(void)putXBingDataBOOL:(NSString*)key :(BOOL)value
{
    [getStaticDataNode(self) putBOOL:key :value ];
}
-(void)putXBingDataLong:(NSString*)key :(long)value
{
    [getStaticDataNode(self) putLong:key :value ];
}
-(void)putXBingDataDouble:(NSString*)key :(double)value
{
    [getStaticDataNode(self) putDouble:key :value ];
}
-(void)putXBingDataString:(NSString*)key :(NSString*)value
{
    [getStaticDataNode(self) putString:key :value ];
}
-(void)putXBingDataObject:(NSString*)key :(id)value
{
    [getStaticDataNode(self) putObject:key :value ];
}

+(void)checkXBingData
{
    checkXBingData();
}
+(void)clearXBingDataForUIContronller:(UIViewController*)con
{
    clearXBingDataForUIContronller(con);
}
@end
