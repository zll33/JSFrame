//
//  XScrollView.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/22.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XScrollView.h"

#import "HelpApi.h"
#import "XHeaderView.h"
#import "KIZMultipleProxyBehavior.h"
#import "XObjectEx.h"

//多重代理，后添加的优先执行
@implementation UIScrollView(KIZMultipleProxyBehavior)
-(void)addDelegate:(NSObject*)deg{
    if([self.delegate isKindOfClass:[KIZMultipleProxyBehavior class]]){
        KIZMultipleProxyBehavior* md= self.delegate;
        [md addDelegate:deg];
    }else{
        KIZMultipleProxyBehavior* md= [KIZMultipleProxyBehavior new];
        if(self.delegate){
            [md addDelegate:self.delegate];
        }
        [md addDelegate:deg];
        self.delegate = (id<UIScrollViewDelegate>)md;
        //delegate弱引用会释放，强引用一下
        [self putXBingDataObject:@"___KIZMultipleProxyBehavior" :md];
    }
}
-(BOOL) callDelegateOnce{
    if([self.delegate isKindOfClass:[KIZMultipleProxyBehavior class]]){
        KIZMultipleProxyBehavior* md= self.delegate;
        return md.callDelegateOnce;
    }
    return false;
}
-(void)setCallDelegateOnce:(BOOL)callDelegateOnce{
    
    if([self.delegate isKindOfClass:[KIZMultipleProxyBehavior class]]){
        KIZMultipleProxyBehavior* md= self.delegate;
        md.callDelegateOnce = callDelegateOnce;
    }
    return;
}
@end



typedef enum {
    Darg_No=0,//无
    Darg_BeginDarg ,// 下拉中（或上拉）
    Darg_MoreDarg ,// 等待释放
    Darg_Loading ,// 刷新（或加载）
    Darg_Recover // 恢复中
    
}DargAct;


@interface XScrollView()
{
    DargAct headerStatue;
    XHeaderView *header;
    
}

- (void)createHeader;

@property (nonatomic, assign)  BOOL bCreate;
@end




@implementation XScrollView


@synthesize bCreate;
@synthesize contentView;
@synthesize dataLoad;
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self XScrollView_onCreate];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self XScrollView_onCreate];
    }
    return self;

}
- (id)init
{
    self = [super init];
    if (self) {
        [self XScrollView_onCreate];
    }
    return self;
}
-(void)setDataLoad:(id <XScrollViewDataLoad>)load
{
    dataLoad = load;
    if (dataLoad) {
        header.hidden = FALSE;
    }
    
}

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];

}
/**
 *设置contentView的约束
 *
 */
- (void)setContentView:(UIView*)view
{
    
//    if (contentView!=view && contentView!=nil) {
//        [contentView removeFromSuperview];
//        contentView = view;
//    }
// 
//    if (![self.subviews containsObject:view]) {
//        [self addSubview:view];
//    }
   [contentView removeFromSuperview];
    contentView = view;
   [self addSubview:contentView];
   
    if (contentView!=nil) {
        [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:contentView
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeWidth
                             multiplier:1
                             constant:0]];
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:contentView
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterX
                             multiplier:1
                             constant:0]];
        
        
        XJson *views = XJsonOfVariableBindings(contentView,self);
        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView(self)]|"
//                                                                     options:0
//                                                                     metrics:nil
//                                                                       views:views]];
        
//        [self addConstraint:[NSLayoutConstraint
//                             constraintWithItem:contentView
//                             attribute:NSLayoutAttributeHeight
//                             relatedBy:NSLayoutRelationGreaterThanOrEqual
//                             toItem:self
//                             attribute:NSLayoutAttributeHeight
//                             multiplier:1
//                             constant:0]];
//        
//        [self addConstraint:[NSLayoutConstraint
//                             constraintWithItem:contentView
//                             attribute:NSLayoutAttributeTop
//                             relatedBy:NSLayoutRelationEqual
//                             toItem:self
//                             attribute:NSLayoutAttributeTop
//                             multiplier:1
//                             constant:0]];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(>=self@300)]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
    }
}
- (UIView*)setContentViewNibNamed:(NSString*)nibName Index:(int)index
{
    [self setContentView:[[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:index]];
    return contentView;
}

- (UIView*)setContentViewNibNamed:(NSString*)nibName
{
    return [self setContentViewNibNamed:nibName Index:0];
}
- (UIView*)getContentView
{
    return contentView;
}
- (void)createHeader
{
    NSLayoutConstraint* layoutConstraint = nil;
    
    header = [[[NSBundle mainBundle] loadNibNamed:@"XHeaderView" owner:nil options:nil] firstObject];
    [self addSubview:header];
    [header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(header);
    
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:header
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:header
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1
                         constant:0]];
    
    //header 宽度等于父窗体，放在最上面
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-50)-[header(50)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self updateConstraints];
    
    [self layoutIfNeeded];
    
}
- (void)createHeader2
{
    NSLayoutConstraint* layoutConstraint = nil;
    
    header = [[[NSBundle mainBundle] loadNibNamed:@"XHeaderView" owner:nil options:nil] firstObject];
    [super addSubview:header];
    
    [header setTranslatesAutoresizingMaskIntoConstraints:NO];
    header.hidden = TRUE;
    
    XJson *views = XJsonOfVariableBindings(header);
    //header 宽度等于父窗体，放在最上面
    layoutConstraint= [NSLayoutConstraint
                       constraintWithItem:header
                       attribute: NSLayoutAttributeWidth
                       relatedBy: NSLayoutRelationEqual
                       toItem:self
                       attribute: NSLayoutAttributeWidth
                       multiplier:1.0
                       constant:0];
    [self addConstraint:layoutConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-50)-[header(50)]-(>=0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self layoutIfNeeded];
    
    
}


- (void)XScrollView_onCreate
{
    if (!bCreate) {
        bCreate = TRUE;
        self.directionalLockEnabled = YES; //只能一个方向滑动
        self.pagingEnabled = NO; //是否翻页
        self.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        self.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
        self.alwaysBounceVertical =YES;//垂直方向允许反弹
        self.delegate = self;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        if ([[self subviews] count]>0) {
            contentView =[[self subviews] firstObject];
            [self setContentView:contentView];
        }
        [self createHeader];
        [self resetStatue];
        [self updateConstraints];
        [self layoutIfNeeded];
        [self updateConstraintsIfNeeded];
        
        if (dataLoad==nil) {
            header.hidden = TRUE;
        }
        
        
    }
    
}



- (void)resetStatue
{
    [self headerChangeDargAct:Darg_No];
}

- (void)onComplete
{
    
    if (headerStatue==Darg_Loading) {
        [self headerChangeDargAct:Darg_Recover];
    }
}


-(int)getHeaderHeight{
    int h = header.frame.size.height;
    return h;
}


-(void)callRefresh
{
    runOnNewUiTread(^(){
        [self headerChangeDargAct:Darg_Loading];
        [self setContentOffset:CGPointMake(0, -[self getHeaderHeight]) animated:NO];
    });
    
}

- (void)headerChangeDargAct:(DargAct)act
{

    switch (act) {
        case Darg_No:
        {
            headerStatue = Darg_No;
            [header setText:@"下拉刷新"];
            
        }
            break;
            
        case Darg_Recover:
        {
            headerStatue = Darg_Recover;
            [header stopActView];
            [header setText:@"刷新完毕"];
            UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
            [UIView animateWithDuration:0.2 delay:0.2 options:options animations:^
             {
                 self.contentInset  = UIEdgeInsetsMake(0,0,0,self.contentInset.bottom);
                 [self headerChangeDargAct:Darg_No];
             } completion:^(BOOL finished){
                 //这里有可能执行不到. 当header不可见时(即动画变化看不见，垃圾系统ios 默认不执行了)，执行不到此处
                 //[self headerChangeDargAct:Darg_No];

             }];
            
        }
            break;
        case Darg_BeginDarg:
        {
         
            headerStatue = Darg_BeginDarg;
            [header setText:@"下拉刷新"];
        }
            break;
        case Darg_MoreDarg:
        {
            headerStatue = Darg_MoreDarg;
            [header setText:@"放开以刷新"];
        }
            break;
        case Darg_Loading:
        {
            headerStatue=Darg_Loading;
            [header startActView];
            [header setText:@"正在载入..."];
            //不能直接设置contentInset，否者会出现一次contentOffSet.y =[self getHeaderHeight] 的闪烁。
            //self.contentInset  = UIEdgeInsetsMake([self getHeaderHeight],0,0,self.contentInset.bottom);
           
            //修复方法
            runOnNewUiTread(^{
                // 执行动画
                UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
                [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
                    self.contentInset = UIEdgeInsetsMake([self getHeaderHeight],0,0,self.contentInset.bottom);
                    self.contentOffset = CGPointMake(self.contentOffset.x, -[self getHeaderHeight]);
                } completion:nil];

            });
           
            
            [self.dataLoad onRefresh];
        }
            break;
            
        default:
            break;
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.dataLoad && self.contentOffset.y<=0  && headerStatue==Darg_No ){
        [self headerChangeDargAct:Darg_BeginDarg];
    }
    

}


//当scroller滑动时调用
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.dataLoad && self.contentOffset.y< 0 ){
        
        if(self.contentOffset.y<- [self getHeaderHeight]){
            
            if(headerStatue==Darg_BeginDarg){
                [self headerChangeDargAct:Darg_MoreDarg];
            }
            
        }else{
            
            if (headerStatue==Darg_MoreDarg) {
                [self headerChangeDargAct:Darg_BeginDarg];
            }
            
        }
    }
    
    if (self.scrollListener &&
        [self.scrollListener respondsToSelector:@selector(onScroll)]) {
        
        [self.scrollListener onScroll];
    }
}

//当滑动结束时调用
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.dataLoad &&  headerStatue==Darg_MoreDarg) {
        [self headerChangeDargAct:Darg_Loading];
    }else if (self.dataLoad &&  headerStatue!=Darg_No && headerStatue!=Darg_Recover &&headerStatue!=Darg_Loading) {
        [self headerChangeDargAct:Darg_Recover];
    }
    
}


@end
