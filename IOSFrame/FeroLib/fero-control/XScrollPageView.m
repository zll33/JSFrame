//
//  XScrollPageView.m
//  dddd
//
//  Created by kzd on 14-5-13.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import "XScrollPageView.h"
#import "HelpApi.h"
#import "XViewEx.h"

@interface XScrollPageView()<UIScrollViewDelegate>
{
    NSLayoutConstraint * right;
    float pageWidthScal;
    float pageSpace;
    
    BOOL showPagecontrol;
    NSNumber* indexBottom;

}

@property(readwrite)    UIPageControl   *   pagecontrol;
@property(readwrite)    UIScrollView    *   scrollview;
@property(readwrite)    NSTimer         *   nextPageTimer;
@property(strong)       void (^onChangeListen)(int);

@end

@implementation XScrollPageView
@synthesize  pagecontrol;
@synthesize scrollview;
@synthesize nextPageTimer;
@synthesize onChangeListen;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self XScrollPageView_onCreate];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self XScrollPageView_onCreate];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self) {
        [self XScrollPageView_onCreate];
    }
    return self;
}
-(void)setClipsToBounds:(BOOL)clipsToBounds
{
    [super setClipsToBounds:clipsToBounds];
    
    [scrollview setClipsToBounds:clipsToBounds];

}
//-(void)rebuild
//{
//    CGRect rect = self.bounds;
//    scrollview.frame = rect;
//    int index = 0;
//    
//    for(UIView* v in scrollview.subviews)
//    {
//        v.frame = CGRectMake(index*rect.size.width, 0, rect.size.width, rect.size.height);
//        index++;
//    }
//    float  contentSizeW =scrollview.contentSize.width;
//    float  contentSizeH =scrollview.contentSize.height;
//    if ( contentSizeW!=scrollview.frame.size.width*index || contentSizeH!=scrollview.frame.size.height) {
//        scrollview.contentSize = CGSizeMake(scrollview.frame.size.width*index, scrollview.frame.size.height);
//    }
//    
//    if (pagecontrol) {
//        pagecontrol.frame = CGRectMake(0, rect.size.height- PD2PX(20), rect.size.width, PD2PX(20));
//        if (index>1) {
//            pagecontrol.numberOfPages = index;
//        }else{
//            pagecontrol.numberOfPages = 0;
//        }
//    }
//
//}
-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    //[self rebuild];
}
-(void)XScrollPageView_onCreate{
    pageWidthScal = 1;
    scrollview=[[UIScrollView alloc]init];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    showPagecontrol = TRUE;
    scrollview.pagingEnabled = YES;
    scrollview.scrollsToTop = NO;
    scrollview.delegate= self;
    scrollview.bounces=  NO;
    scrollview.directionalLockEnabled = YES;
    [self addSubview:scrollview];
    
    [scrollview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint
                               constraintWithItem:scrollview
                               attribute:NSLayoutAttributeHeight
                               relatedBy:NSLayoutRelationEqual
                               toItem:self
                               attribute:NSLayoutAttributeHeight
                               multiplier:1
                               constant:0]];
    XJson* viewDict = XJsonOfVariableBindings(scrollview);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollview]|" options:0 metrics:0 views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollview]|" options:0 metrics:0 views:viewDict]];

    //scrollview.backgroundColor = COLOR(0xffffffff);
    
    pagecontrol = [[UIPageControl alloc]init];
    pagecontrol.backgroundColor = [UIColor clearColor];
    pagecontrol.hidesForSinglePage = YES;
    pagecontrol.userInteractionEnabled = NO;
    [self addSubview:pagecontrol];
    [pagecontrol setTranslatesAutoresizingMaskIntoConstraints:NO];
    XJson *views2 = XJsonOfVariableBindings(pagecontrol);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0,<=20000)-[pagecontrol(20)]-(20@250)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views2]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[pagecontrol]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views2]];
    //注册监听
//    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
//    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial context:nil];
//    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionPrior context:nil];
//    
}
-(void)setCanScroll:(BOOL)ifCanScroll{
    scrollview.scrollEnabled = ifCanScroll;
}

//处理属性改变事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(XJson *)change context:(void *)context
{
 
    if (object==scrollview) {
        int count = [[scrollview subviews] count];
        scrollview.contentSize = CGSizeMake((scrollview.frame.size.width*pageWidthScal+pageSpace)*count-pageSpace, scrollview.frame.size.height);
    }
}

-(void)layoutSubviews{
    
    
    
    
    [super layoutSubviews];
   // scrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, scrollview.frame.size.width*(1-pageWidthScal));
    //scrollview.contentInset = UIEdgeInsetsMake(0, 100, 0, 100);
    
    if (pagecontrol
        &&scrollview
        &&scrollview.contentOffset.x != pagecontrol.currentPage * (scrollview.frame.size.width*pageWidthScal+pageSpace)-pageSpace
        ) {
        [self changeToPage:(pagecontrol.currentPage)];
        
    }
    
}


-(void)addPageView:(UIView*)view
{
    int count = [[scrollview subviews] count];
//    UIView *v = [[UIView alloc]init];
//    v.clipsToBounds = true;
//    [v addSubview:view];
    
    UIView * lastView =[[scrollview subviews]lastObject];
    UIView * v = view;
    view.clipsToBounds = true;
    [scrollview addSubview:v];
    [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    //不能以self的宽度填写约束，因为scrollview的宽度约束，可以同时改变contentSize的大小，这样才能翻页。
    [scrollview addConstraint:[NSLayoutConstraint
                         constraintWithItem:v
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:scrollview
                         attribute:NSLayoutAttributeWidth
                         multiplier:pageWidthScal
                         constant:0]];
    /*attribute:NSLayoutAttributeCenterX 有BUG，在其他scrollview中使用时，滚动消失后再回来，CenterX 变动了。
    [scrollview addConstraint:[NSLayoutConstraint
                               constraintWithItem:v
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                               toItem:scrollview
                               attribute:NSLayoutAttributeCenterX
                               multiplier:1 + count*2
                               constant:0]];
    */
    
    if (lastView==nil) {
        [scrollview addConstraint:[NSLayoutConstraint
                                   constraintWithItem:v
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:scrollview
                                   attribute:NSLayoutAttributeLeft
                                   multiplier:1
                                   constant:0]];
    }else{
        [scrollview addConstraint:[NSLayoutConstraint
                                   constraintWithItem:v
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:lastView
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1
                                   constant:pageSpace]];
    }
 
    
    //不能以scrollview的高度填写约束，因为scrollview的高度约束，导致contentSize或则contentOffset.y的改变，会有一个系统栏的高度无法充满。
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:v
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1
                         constant:0] P:900];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:v
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1
                         constant:0]];

    if (count==0) {
        XJson* viewDict = XJsonOfVariableBindings(v);
        NSLayoutConstraint*left = [NSLayoutConstraint
         constraintWithItem:scrollview
         attribute:NSLayoutAttributeLeading
         relatedBy:NSLayoutRelationEqual
         toItem:v
         attribute:NSLayoutAttributeLeading
         multiplier:1
         constant:0];
        left.priority=900;
        [scrollview addConstraint:left];
        
    }

    [scrollview layoutIfNeeded];
    
    if (right!=nil) {
        [scrollview removeConstraint:right];
    }
    right =[NSLayoutConstraint
            constraintWithItem:scrollview
            attribute:NSLayoutAttributeTrailing
            relatedBy:NSLayoutRelationGreaterThanOrEqual    //使用大于，多次添加，也仅仅取值最大的右边距
            toItem:v
            attribute:NSLayoutAttributeTrailing
            multiplier:1
            constant:0];
    right.priority=900;
    [scrollview addConstraint:right];
    
    
    if (pagecontrol) {
        if ([[scrollview subviews] count]>1) {
            pagecontrol.numberOfPages = [[scrollview subviews] count];
            if (showPagecontrol) {
                [self showPageIndexView];
            }
        }else{
            //只有1页也不显示pagecontrol
            pagecontrol.numberOfPages = 0;
            if (!showPagecontrol) {
                [self hidePageIndexView];
            }
        }
    }
    
    //[self rebuild];
}
-(void)removeAllPageView;
{
    [scrollview removeAllChild];
   //[self rebuild];
}
-(void)removePageView:(UIView*)view;
{
    if ([scrollview.subviews containsObject:view]) {
        [view removeFromSuperview];
        //[self rebuild];
    }
}
-(void)setIntervalTime:(int)time
{
    NSTimeInterval interval= ((float)time)/1000;
    if (nextPageTimer==nil || [nextPageTimer timeInterval]!= interval) {
        [self stopCallNextPage];
        if (interval>0) {
            nextPageTimer =[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onNextPage) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:nextPageTimer forMode:NSDefaultRunLoopMode];
        }

    }
    
    if (time>0) {
        [self callNextPage];
    }else{
        [self stopCallNextPage];
    }
}
-(void)scrollToPage:(int)index
{
    int count = [scrollview.subviews count];
    if (count>0) {
        if (index >= count) {
            index = 0;
        }
        if (index < 0 ) {
            index = count-1;
        }
        [scrollview setContentOffset:CGPointMake(index * (scrollview.frame.size.width*pageWidthScal+pageSpace), 0) animated:TRUE];
    }
}
-(void)changeToPage:(int)index
{
    int count = [scrollview.subviews count];
    if (count>0) {
        if (index >= count) {
            index = 0;
        }
        if (index < 0 ) {
            index = count-1;
        }
        [scrollview setContentOffset:CGPointMake(index * (scrollview.frame.size.width*pageWidthScal+pageSpace), 0) animated:FALSE];
        [self pageChange];
    }
}
-(int)getPageIndex
{
    int index = fabs(scrollview.contentOffset.x) / (scrollview.frame.size.width*pageWidthScal+pageSpace);
    return index;
}
-(UIView*)getPageView:(int)index
{
    UIView* v=nil;
     int count = [scrollview.subviews count];
    
    if (count>index) {
        return [scrollview.subviews objectAtIndex:index];
    }
    
    return nil;
}
-(void)showPageIndexView
{
    showPagecontrol = TRUE;
    [pagecontrol setHidden:FALSE];
    if (pagecontrol.superview==nil) {
        [self addSubview:pagecontrol];
        [pagecontrol setTranslatesAutoresizingMaskIntoConstraints:NO];
        XJson *views2 = XJsonOfVariableBindings(pagecontrol);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0,<=20000)-[pagecontrol(20)]-(20@250)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views2]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[pagecontrol]-(0)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views2]];
        
        if(indexBottom){
            [self setPageIndexViewMBottom:indexBottom.floatValue];
        }
    }
}
-(void)hidePageIndexView;
{
    showPagecontrol = false;
    [pagecontrol setHidden:TRUE];
    [pagecontrol removeFromSuperview];
}
-(void)setPageIndexViewMBottom:(float)b
{
    if(!indexBottom||indexBottom.floatValue!=b){
        indexBottom =  [NSNumber numberWithFloat:b];
    }
    
    for (NSLayoutConstraint*c in [self constraints]) {
        if (c.firstItem==pagecontrol&&c.firstAttribute==NSLayoutAttributeBottom) {
            [self removeConstraint:c];
            break;
        }
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:pagecontrol
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:-b]];
    
}
-(void)unload
{
    onChangeListen = nil;
    [self stopCallNextPage];
    scrollview.delegate = nil;
    [scrollview removeFromSuperview];
    scrollview = nil;

    [pagecontrol removeFromSuperview];
    pagecontrol = nil;
}



-(void)stopCallNextPage
{
    if (nextPageTimer!=nil && ![nextPageTimer isValid]) {
        [nextPageTimer invalidate];
    }
    
}
-(void)callNextPage
{
    if (nextPageTimer!=nil && [nextPageTimer isValid] && [nextPageTimer timeInterval]>0) {
        [[NSRunLoop currentRunLoop]addTimer:nextPageTimer forMode:NSDefaultRunLoopMode];
    }
    
}
-(void)onNextPage
{
    int count = [scrollview.subviews count];
    int index = fabs(scrollview.contentOffset.x) / (scrollview.frame.size.width*pageWidthScal+pageSpace);
    if (count>1 || index!=0) {
        index+=1;
        if (index>=count) {
            index = 0;
        }
        [self stopCallNextPage];
        [scrollview setContentOffset:CGPointMake(index * (scrollview.frame.size.width*pageWidthScal+pageSpace), 0) animated:TRUE];
    }
}
-(void)setOnPageChange:(void (^)(int index))onChange;
{
    onChangeListen = onChange;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self pageChange];

}
//变动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self stopCallNextPage];
}
//变动将要结束,只要用户松手就会调用 velocity is in points/millisecond.  毫秒
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
 
    if(scrollview.pagingEnabled==NO){
        float currX =scrollview.contentOffset.x;
        
        //根据数据速度，计算最终的位置
        //float t = 2*(targetContentOffset->x -currX)/velocity.x;
        //NSLog(@"ttttt=%f",t);//ttttt=194.833847
        float t =194.833847;
        float s = velocity.x*t/2;
        float lastX = currX+s;
        
        //根据最终位置计算最终的页码
        
        int lastIndex  = (int)(lastX / (scrollview.frame.size.width*pageWidthScal+pageSpace) +0.5f);
        
        //每次只翻动一页(相对于当前位置，不是相对于上一次的的页码)
        int currIndex  = [self getPageIndex];
        if(lastIndex-currIndex>1){
            lastIndex = currIndex+1;
        }else if(lastIndex-currIndex<-1){
            lastIndex = currIndex -1;
        }
        
        //如果显示到最后一个，则根据最后一页位置，判断是否需要翻页
        if((scrollview.contentSize.width - lastX) - scrollview.frame.size.width  < (scrollview.frame.size.width*pageWidthScal)/2){
            lastX = scrollview.contentSize.width - scrollview.frame.size.width;
        }else{
            lastX = lastIndex*(scrollview.frame.size.width*pageWidthScal+pageSpace);
        }
        
        
        
        //是否已经越界
        
        if(lastX> scrollview.contentSize.width - scrollview.frame.size.width){
            lastX = scrollview.contentSize.width - scrollview.frame.size.width;
        }
        
        targetContentOffset->x = lastX;
        
        
//        //如果速度不够，则使用自动滑动
//        if(true){
//            targetContentOffset->x=currX;
//            [self scrollToPage:lastIndex];
//        }
        
        
        
    }
  
   //
    
}
/*
 只要UIScrollview有惯性就会调用,如果没有惯性就不会调用  想要监听UIScrollview停止滚动必须同时实现这两个方法
 */
//变动结束，可能将要执行惯性
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 判断是否有惯性, 如果没有就手动调用scrollViewDidEndDecelerating
    if (NO == decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

//变动结束,惯性结束了
/*
 ◦	只要用户松手就会调用
 ◦	停止拖拽并不代表停止滚动, 也就是说UIScrollView滚动是有惯性的
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //[self scrollToPage:[self getPageIndex]];
    [self pageChange];
    
}


-(void)setPageWidthScal:(float)pWScal PageSpace:(float) pSpace
{
    pageWidthScal = pWScal;
    pageSpace = pSpace;
    //scrollview.decelerationRate = 0;
    scrollview.pagingEnabled = NO;

}
- (void) pageChange
{
    int index = fabs(scrollview.contentOffset.x) / (scrollview.frame.size.width*pageWidthScal+pageSpace);   //当前是第几个视图
    if(index>=pagecontrol.numberOfPages){
        index = pagecontrol.numberOfPages -1;
    }
    if (index<0) {
        index=0;
    }
    pagecontrol.currentPage = index;
    [self callNextPage];
    if (onChangeListen) {
        onChangeListen(index);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
