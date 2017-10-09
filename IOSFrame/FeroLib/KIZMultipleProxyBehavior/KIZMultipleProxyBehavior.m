//
//  KIZMultipleProxyBehavior.m
//  KIZParallaTableDemo
//
//  Created by kingizz on 15/8/17.
//  Copyright (c) 2015年 kingizz. All rights reserved.
//

#import "KIZMultipleProxyBehavior.h"
#import "HelpApi.h"
@interface KIZMultipleProxyBehavior ()

@property (nonatomic, strong) NSMutableArray *arr;

@end


@implementation KIZMultipleProxyBehavior

-(id)init{
    self =[super init];
    self.arr = [NSMutableArray new];
    return self;
}
-(void)addDelegate:(NSObject*)delg{
    [self.arr insertObject:[WeakObject newWeakObject:delg] atIndex:0];
}
- (BOOL)respondsToSelector:(SEL)aSelector{
//    if ([super respondsToSelector:aSelector]) {
//        return YES;
//    }
    for (id target in self.arr) {
        if ([((WeakObject*)target).object respondsToSelector:aSelector]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *sig ;//= [super methodSignatureForSelector:aSelector];
    if (!sig) {
        for (id target in self.arr) {
            if ((sig = [((WeakObject*)target).object methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    
    return sig;
}

//转发方法调用给所有delegate
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    for (id target in self.arr) {
        if ([((WeakObject*)target).object respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:((WeakObject*)target).object];
            if(self.callDelegateOnce){
                return;
            }
        }
    }
}

@end
