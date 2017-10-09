//
//  XScrollViewForCircle.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/31.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XScrollViewForCircle.h"
#import "HelpApi.h"

@interface XScrollViewForCircle ()<UIScrollViewDelegate>
{
    UIView *contentView;
    UIView *contentFixedView;
    
    UIView *contentViewLeft;
    NSLayoutConstraint* contentViewLeftNSLayoutConstraintV;
    NSLayoutConstraint* contentViewLeftNSLayoutConstraintH;
    UIView *contentViewMiddle;
    NSLayoutConstraint* contentViewMiddleNSLayoutConstraintV;
    NSLayoutConstraint* contentViewMiddleNSLayoutConstraintH;
    UIView *contentViewRight;
    NSLayoutConstraint* contentViewRightNSLayoutConstraintV;
    NSLayoutConstraint* contentViewRightNSLayoutConstraintH;
    UIScrollView * scrollview;
    
    
    id <XScrollViewForCircleCell> leftCell;
    id <XScrollViewForCircleCell> middleCell;
    id <XScrollViewForCircleCell> rightCell;
    
}
//@property (nonatomic)  UIView *contentView;
@end
@implementation XScrollViewForCircle

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self XScrollViewForCircle_onCreate];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self XScrollViewForCircle_onCreate];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self) {
        [self XScrollViewForCircle_onCreate];
    }
    return self;
}
-(void)scrollviewCreate
{
    scrollview = [UIScrollView new];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.scrollsToTop = NO;
    scrollview.delegate= self;
    scrollview.bounces=  NO;
    scrollview.directionalLockEnabled = YES;
    scrollview.backgroundColor=COLOR(0x22555555);
    scrollview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 150, 0, 150);
    [self addSubview:scrollview];
    
    [scrollview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //scrollview的大小位置
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:scrollview
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:scrollview
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1
                         constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:scrollview
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:scrollview
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1
                         constant:0]];
    
    
    
    
}
-(void)contentViewCreate
{
    contentView = [UIView new];
    contentView.backgroundColor = COLOR(0xaa000000);
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollview addSubview:contentView];
    
    //scrollview的内容的大小,3倍scrollview的宽度
    XJson* viewDict = XJsonOfVariableBindings(contentView,scrollview);
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:0 views:viewDict]];
    [scrollview addConstraint:[NSLayoutConstraint
                               constraintWithItem:contentView
                               attribute:NSLayoutAttributeWidth
                               relatedBy:NSLayoutRelationEqual
                               toItem:scrollview
                               attribute:NSLayoutAttributeWidth
                               multiplier:100000
                               constant:0]];
    
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(scrollview)]|" options:0 metrics:0 views:viewDict]];
    
    //[scrollview setContentOffset:CGPointMake(1000, 0)];
}

-(void)fixedForScreenCreate
{
    contentFixedView =  [UIView new];
    [contentFixedView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:contentFixedView];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:contentFixedView
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:contentFixedView
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1
                         constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:contentFixedView
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1
                         constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:contentFixedView
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1
                         constant:0]];
    
}
-(void)createLayoutContainer
{
    if (contentViewLeftNSLayoutConstraintV!=nil) {
        [contentView removeConstraint:contentViewLeftNSLayoutConstraintV];
        contentViewLeftNSLayoutConstraintV=nil;
    }
    if (contentViewLeftNSLayoutConstraintH!=nil) {
        [contentView removeConstraint:contentViewLeftNSLayoutConstraintH];
        contentViewLeftNSLayoutConstraintH=nil;
    }
    
    
    
    
}


-(void)createContainer
{
    
    //    UIView *contentViewLeft;
    //    NSLayoutConstraint* contentViewLeftNSLayoutConstraintV;
    //    NSLayoutConstraint* contentViewLeftNSLayoutConstraintH;
    //    UIView *contentViewMiddle;
    //    NSLayoutConstraint* contentViewMiddleNSLayoutConstraintV;
    //    NSLayoutConstraint* contentViewMiddleNSLayoutConstraintH;
    //    UIView *contentViewRight;
    //    NSLayoutConstraint* contentViewRightNSLayoutConstraintV;
    //    NSLayoutConstraint* contentViewRightNSLayoutConstraintH;
    
    //创建3个view
    contentViewLeft = [UIView new];
    contentViewMiddle = [UIView new];
    contentViewRight = [UIView new];
    //[contentViewLeft  setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[contentViewMiddle  setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[contentViewRight  setTranslatesAutoresizingMaskIntoConstraints:NO];
    contentViewLeft.backgroundColor = COLOR(0xffff0000);
    contentViewMiddle.backgroundColor = COLOR(0xff00ff00);
    contentViewRight.backgroundColor = COLOR(0xff0000ff);
    
    [contentFixedView addSubview:contentViewLeft];
    [contentFixedView addSubview:contentViewMiddle];
    [contentFixedView addSubview:contentViewRight];
    
    
    //    [contentView addConstraint:[NSLayoutConstraint
    //                                constraintWithItem:contentViewLeft
    //                                attribute:NSLayoutAttributeHeight
    //                                relatedBy:NSLayoutRelationEqual
    //                                toItem:contentView
    //                                attribute:NSLayoutAttributeHeight
    //                                multiplier:1
    //                                constant:0]];
    //
    //    [contentView addConstraint:[NSLayoutConstraint
    //                         constraintWithItem:contentViewLeft
    //                         attribute:NSLayoutAttributeCenterY
    //                         relatedBy:NSLayoutRelationEqual
    //                         toItem:contentView
    //                         attribute:NSLayoutAttributeCenterY
    //                         multiplier:1
    //                         constant:0]];
    
    //设置约束
    //[self createLayoutContainer];
    
    [self layoutIfNeeded];
    
    
    [self onPositionChange];
}

-(void) XScrollViewForCircle_onCreate{
    
    [self  setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //添加scrollview，适应父窗体self，HV剧中。
    [self scrollviewCreate];
    
    //添加contentView，内容为3个宽度，以用无限拖动。
    [self contentViewCreate];
    
    //添加一个contentViewFixedForScreen，在scrollview的位置相对于父窗体（或屏幕）是不变的。
    [self fixedForScreenCreate];
    
    //创建3个内部容器，并设置约束
    [self createContainer];
    
    
    
    
    //contentViewLeft = [UIScrollView new];
    //contentViewMiddle = [UIScrollView new];
    //contentViewRight = [UIScrollView new];
    
    //注册监听
    //    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    //    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
    //    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionInitial context:nil];
    //    [scrollview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionPrior context:nil];
    
}
-(int)getCurPageIndex
{
    // 得到每页宽度
    CGFloat pageWidth = scrollview.frame.size.width;
    
    CGFloat dx  =scrollview.contentOffset.x;
    int currentPage = fabs( dx / pageWidth);
    
    return currentPage;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // [self onPageChange];
}
//变动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self onPageChange];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //[self onPageChange];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self onPositionChange];
    
}

- (void)onChangePage
{
    int viewCount = 3;
    int pageCount = [self.dataSource getCount];
    if (pageCount>0) {
        
        
        // 得到每页宽度
        CGFloat pageWidth = scrollview.frame.size.width;
        
        CGFloat dx  =scrollview.contentOffset.x;
        int curPageIndex =0;
        
        // 最低一个不可见时，进行页面变换
        curPageIndex = fabs( (dx + 3 * pageWidth) / pageWidth - 0.5);
        
        
        int leftIndex  = 0;
        int middleIndex = 0;
        int rightIndex = 0;
        
        
        //如果当前的位置在leftView上
        if((curPageIndex%3)==0){
            leftIndex = curPageIndex%pageCount;
            middleIndex = (curPageIndex+1)%pageCount;
            rightIndex = (curPageIndex+2)%pageCount;
        }
        //如果当前的位置在middleView上
        else if((curPageIndex%3)==1){
            middleIndex  = curPageIndex%pageCount;
            rightIndex = (curPageIndex+1)%pageCount;
            leftIndex = (curPageIndex+2)%pageCount;
        }
        //如果当前的位置在rightView上
        else if((curPageIndex%3)==2){
            rightIndex   = curPageIndex%pageCount;
            leftIndex   = (curPageIndex+1)%pageCount;
            middleIndex = (curPageIndex+2)%pageCount;
        }
        
        [self resetLeftView:leftIndex];
        [self resetMiddleView:middleIndex];
        [self resetRightView:rightIndex];
        
        
        NSLog(@"L%d M%d R%d",leftIndex,middleIndex,rightIndex);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //[self onPositionChange];
}

- (void)onPositionChange
{
    int page = [self getCurPageIndex];
    //NSLog(@"当前页数 %d",page);
    
    CGRect rect = contentFixedView.frame;
    CGFloat pageWidth = scrollview.frame.size.width;
    CGFloat pageMiddleX =scrollview.contentOffset.x;
    
    float dxProgress = pageMiddleX/pageWidth;
    
    //大小比例 0.6  -  1  -  0.6
    //在中间滑动
    //if(dxProgress>=-1 && dxProgress<= 2)
    {
        
        int CX = rect.size.width  / 2;
        int CY = rect.size.height / 2;
        int PW = rect.size.width ;
        int PH = rect.size.height;
        
        
        //圆周率
        CGFloat PI=3.1415926;
        //一个圆的page总数
        CGFloat pageNum=3;
        
        //每个page间隔角度
        CGFloat pageDa=2*PI/pageNum;
        
        //转动角度:进度*间隔的角度
        CGFloat a0 = dxProgress*pageDa;
        
        //半径
        CGFloat r = PW/2*0.6;
        //实际宽度
        CGFloat LW = PW*0.6;
        //实际高度
        CGFloat LH  = PH*0.8;
        //眼距
        CGFloat dEye = PW*2;
        
        //计算时的宽度
        CGFloat LWA =LW*(dEye-r)/dEye;
        //计算时的高度
        CGFloat LWH =LH*(dEye-r)/dEye;
        
        
        //开始转动
        
        
        //0.转动角度
        CGFloat a = a0 ;
        
        //1.转动后的缩放比例
        CGFloat sacle = dEye/(dEye-cos(a)*r);
        //2.转动后宽度
        CGFloat LWa = sacle *LWA;
        //3.转动后的x
        CGFloat LWx = sacle*sin(a)*r;
        //4.转动后高度
        CGFloat LHa = sacle *LWH ;
        //5.转动后的y
        CGFloat LHy = CY-LHa/2;
        
        contentViewLeft.frame = CGRectMake(CX-LWx - LWa/2, LHy, LWa , LHa);
        
        //6.离眼睛的距离
        CGFloat dEyeLeft = dEye-cos(a)*r;
        
        
        //<-- -->//
        
        
        
        //0.转动角度
        a = a0 - pageDa;
        
        //1.转动后的缩放比例
        sacle = dEye/(dEye-cos(a)*r);
        //2.转动后宽度
        LWa = sacle *LWA;
        //3.转动后的x
        LWx = sacle*sin(a)*r;
        //4.转动后高度
        LHa = sacle *LWH;
        //5.转动后的y
        LHy = CY-LHa/2;
        
        contentViewMiddle.frame = CGRectMake(CX-LWx - LWa/2, LHy, LWa , LHa);
        //6.离眼睛的距离
        CGFloat dEyeMiddle = dEye-cos(a)*r;
        
        
        //0.转动角度
        a = a0  - pageDa*2;
        
        //1.转动后的缩放比例
        sacle = dEye/(dEye-cos(a)*r);
        //2.转动后宽度
        LWa = sacle *LWA;
        //3.转动后的x
        LWx = sacle*sin(a)*r;
        //4.转动后高度
        LHa = sacle *LWH;
        //5.转动后的y
        LHy = CY-LHa/2;
        
        contentViewRight.frame = CGRectMake(CX-LWx - LWa/2, LHy, LWa , LHa);
        
        //6.离眼睛的距离
        CGFloat dEyeRight = dEye-cos(a)*r;
        
        
        //根据眼睛的距离，设置层次关系
        if (dEyeLeft<dEyeMiddle) {
            if (dEyeRight<=dEyeLeft) {
                [self setCVisibleFont: contentViewRight Back:contentViewMiddle];
            }else if(dEyeRight<=dEyeMiddle){
                [self setCVisibleFont: contentViewLeft Back:contentViewMiddle];
            }else{
                [self setCVisibleFont: contentViewLeft Back:contentViewRight];
            }
            
        }else if (dEyeLeft>=dEyeMiddle){
            if (dEyeRight>=dEyeLeft) {
                [self setCVisibleFont: contentViewMiddle Back:contentViewRight];
            }else if(dEyeRight>=dEyeMiddle){
                [self setCVisibleFont: contentViewMiddle Back:contentViewLeft];
            }else{
                [self setCVisibleFont: contentViewRight Back:contentViewLeft];
            }
        }
        
        //NSLog(@"缩放比例  %f",sacle);
        
        //更新内容
        [self onChangePage];
    }
}
-(void) setCVisibleFont:(UIView*)frontView Back:(UIView*)backView
{
    [contentFixedView bringSubviewToFront:frontView];
    [contentFixedView sendSubviewToBack:backView];
}
-(void) addToContentView:(UIView*)contentView View:(UIView*)view
{
    BOOL bADD = FALSE;
    if ([[contentView subviews] count]==0) {
        bADD = TRUE;
    }else if([[contentView subviews] firstObject]!=view){
        NSMutableArray *arr = [NSMutableArray new];
        [arr addObjectsFromArray:[contentView subviews]];
        for (UIView*v  in arr ) {
            [v removeFromSuperview];
        }
        bADD = TRUE;
    }
    
    if (bADD) {
        [contentView addSubview:view];
        [contentView  setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView addConstraint:[NSLayoutConstraint
                             constraintWithItem:view
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:contentView
                             attribute:NSLayoutAttributeWidth
                             multiplier:1
                             constant:0]];
        
        [contentView addConstraint:[NSLayoutConstraint
                             constraintWithItem:view
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterX
                             multiplier:1
                             constant:0]];
        
        [contentView addConstraint:[NSLayoutConstraint
                             constraintWithItem:view
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:contentView
                             attribute:NSLayoutAttributeHeight
                             multiplier:1
                             constant:0]];
        [contentView addConstraint:[NSLayoutConstraint
                             constraintWithItem:view
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:contentView
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1
                             constant:0]];
        
    }
}
-(void)resetLeftView:(int)leftIndex
{
    if (self.dataSource !=nil) {
       leftCell = [self.dataSource getCell:leftCell Index:leftIndex];
       [self addToContentView:contentViewLeft View:[leftCell getView]];
    }
    
 
}

-(void)resetMiddleView:(int)middleIndex
{
    if (self.dataSource !=nil) {
        middleCell = [self.dataSource getCell:middleCell Index:middleIndex];
        [self addToContentView:contentViewMiddle View:[middleCell getView]];
    }
}

-(void)resetRightView:(int)rightIndex
{

    if (self.dataSource !=nil) {
        rightCell = [self.dataSource getCell:rightCell Index:rightIndex];
        [self addToContentView:contentViewRight View:[rightCell getView]];
    }
}

-(void) reLoad
{
    
    [self onPositionChange];
}

@end
