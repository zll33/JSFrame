//
//  LinearLayout.m
//  p2p
//
//  Created by zhangxiuquan on 15/2/10.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "LinearLayout.h"
#import "XViewEx.h"
#import "HelpApi.h"
@interface  LinearLayoutCell()
{
    Boolean hasOncreate;
    float Width;
    float Height;
    int visibel;
}
@property  UIView* mainView;
@end
@implementation  LinearLayoutCell
@synthesize gravity;

-(id)init{
    self = [super init];
    
    [self setMLeft:0] ;
    [self setMRight:0] ;
    [self setMTop:0] ;
    [self setMBottom:0] ;
    [self setUse:false Weight:0];
    Width = MatchPatrent;
    Height = WrapContent;
    visibel = AutoLayoutVisibleShow;
    return self;
}
-(UIView*)getView
{
    return self.mainView;
}

+(LinearLayoutCell*)newWithView:(UIView*)v
                     MarginLeft:(float) ml
                      MarginTop:(float) mt
                   MarginBottom:(float) mb
                    MarginRight:(float) mr
                      UseWeight:(BOOL)use
                         Weight:(float) w
{
    LinearLayoutCell* cell = [LinearLayoutCell new];
    [cell setView:v];
    [cell setMLeft:ml] ;
    [cell setMRight:mr] ;
    [cell setMTop:mt] ;
    [cell setMBottom:mb] ;
    [cell setUse:use Weight:w];
    return cell;
}

-(LinearLayoutCell*)setView:(UIView*)v
{
    if ([ self.mainView isKindOfClass:[LinearLayout class]]) {
        if(((LinearLayout*)self.mainView).thisCell==self){
            ((LinearLayout*)self.mainView).thisCell=nil;
        }
    }
    self.mainView =v;
    if (v) {
        [[self getView ] addConstraintLit:[NSLayoutConstraint
                                           constraintWithItem:[self getView]
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:0
                                           constant:0]];
        [[self getView ] addConstraintLit:[NSLayoutConstraint
                                           constraintWithItem:[self getView]
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:0
                                           constant:0]];
    }
    
    if ([v isKindOfClass:[LinearLayout class]]) {
        ((LinearLayout*)v).thisCell=self;
    }
    return self;
}
+(LinearLayoutCell*)newWithView:(UIView*)v
{
    return [LinearLayoutCell newWithView:v MarginLeft:0 MarginTop:0 MarginBottom:0 MarginRight:0 UseWeight:FALSE Weight:0  ];
    
}
-(float)getWidth
{
    return Width;
}
-(float)getHeight
{
    return Height;
}

-(LinearLayoutCell*)setOnClick:(void(^)())onClick
{
    [[self getView]setOnClick:onClick];
    return self;
}
-(LinearLayoutCell*)setOnClickWeak:(id)weakid Click:(void(^)(id weakid,LinearLayoutCell*view))onClick
{
    __weak id weakTarget = weakid;
    __weak LinearLayoutCell*weakView = self;
    
    
    [self setOnClick:^{
        onClick(weakTarget,weakView);
    }];
    
    return self;
}
-(LinearLayoutCell*)setOnClickTarget:(id)target action:(SEL)action
{
    [[self getView]setOnClickTarget:target action:action];
    return self;
}
-(LinearLayoutCell*)setOnClick:(id)weakid ViewAction:(SEL)action
{
    __weak id weakTarget = weakid;
    __weak LinearLayoutCell*weakView = self;
    
    
    [self setOnClick:^{
        [weakTarget performSelector:action withObject:weakView];
        
    }];
    
    return self;
}
-(LinearLayoutCell*)setNormalColor:(int)color PressColor:(int)sColor
{
    [[self getView] setNormalColor:color PressColor:sColor];
    return self;
}
-(LinearLayoutCell*)setNormalColor:(int)color PressColor:(int)sColor DisabledColor:(int)dColor
{
    [[self getView] setNormalColor:color PressColor:sColor DisabledColor:dColor];
    return self;
}
-(LinearLayoutCell*)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge
{
    [[self getView] setNormalImage:iamge PressImage:sIamge];
    return self;
}
-(LinearLayoutCell*)setNormalImage:(UIImage*)iamge PressImage:(UIImage*)sIamge DisabledImage:(UIImage*)dIamge
{
    [[self getView] setNormalImage:iamge PressImage:sIamge DisabledImage:dIamge];
    return self;
}
-(LinearLayoutCell*)setClickAble:(BOOL)canClick{
    [[self getView] setClickAble:canClick];
    return self;
}
//按下后多次触发事件 间隔事件 interval
-(LinearLayoutCell*)setOnTouchMultTriggerInterval:(double)interval  Target:(id)target Begin:(SEL)begin Touch:(SEL)touch End:(SEL)end
{
    [[self getView] setOnTouchMultTriggerInterval:interval Target:target Begin:begin Touch:touch End:end];
    return self;

}
-(LinearLayoutCell*)setMinWidth:(float)w
{
    [[self getView] addConstraint:[NSLayoutConstraint
                                   constraintWithItem:[self getView]
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:w]];
    return self;
}
-(LinearLayoutCell*)setMaxWidth:(float)w
{
    [[self getView] addConstraint:[NSLayoutConstraint
                                   constraintWithItem:[self getView]
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:w]];
    return self;
}
-(LinearLayoutCell*)setMaxHeight:(float)w
{
    [[self getView] addConstraint:[NSLayoutConstraint
                                   constraintWithItem:[self getView]
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:w]];
    return self;
}
-(LinearLayoutCell*)setWidth:(float)w
{
     Width=w;
    [[self getView] clearConstraintsFirstItem:[self getView] firstAttribute:NSLayoutAttributeWidth];
    
    if (w>=0){
       
        [[self getView] addConstraint:[NSLayoutConstraint
                                       constraintWithItem:[self getView]
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:0
                                       constant:w]];
    }
    
    return self;
}
-(LinearLayoutCell*)setMinHeight:(float)h
{
    [[self getView] addConstraint:[NSLayoutConstraint
                                   constraintWithItem:[self getView]
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:h]];
    return self;
}
-(LinearLayoutCell*)setHeight:(float)h
{
    Height=h;
    [[self getView] clearConstraintsFirstItem:[self getView] firstAttribute:NSLayoutAttributeHeight];
    
    if (h>=0){
        [[self getView] addConstraint:[NSLayoutConstraint
                                       constraintWithItem:[self getView]
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:0
                                       constant:h]];
    }
    
    return self;
}
-(LinearLayoutCell*)setRadius:(float)r borderWidth:(int)bw borderColor:(int)c
{

    //设置圆角边框
    [self getView].layer.cornerRadius = r;
    [self getView].layer.masksToBounds = YES;
    //设置边框及边框颜色
    [self getView].layer.borderWidth = bw;
    [self getView].layer.borderColor = COLOR(c).CGColor;
    
    return self;
}
-(LinearLayoutCell*)setBackColor:(int)c
{
    [self getView].backgroundColor=COLOR(c);
    return self;
}
-(LinearLayoutCell*)setMLeft:(float)l
{
    self.marginLeft =l;
    return self;
}
-(LinearLayoutCell*)setMTop:(float)t
{
    self.marginTop=t;
    return self;
}
-(LinearLayoutCell*)setMBottom:(float)b
{
    self.marginBottom=b;
    return self;
}
-(LinearLayoutCell*)setMRight:(float)r
{
    self.marginRight=r;
    return self;
}

-(LinearLayoutCell*)setMargin:(float)m
{
    [self setMLeft:m];
    [self setMRight:m];
    [self setMTop:m];
    [self setMBottom:m];
    
    return self;
}
-(LinearLayoutCell*)setUse:(BOOL)use Weight:(float)w
{
    self.useWeight=use;
    self.weight=w;
    [self.parent checkUILabel];
    return self;
}
//-(LinearLayoutCell*)setMatchParent:(BOOL)matchParent
//{
//    self.isMatchParent =matchParent;
//    return self;
//}
-(LinearLayoutCell*)setGravity:(int)g
{
    self.gravity =g;
    return self;
}
-(void)setGravity2:(int)g
{
    gravity =g;
}
//可见
-(LinearLayoutCell*)setVisibleVisibel
{
    if (visibel!=AutoLayoutVisibleShow) {
        visibel = AutoLayoutVisibleShow;
        [[self getView] setHidden:NO];
        [[self getView] setNeedsDisplay];
        [[self getView] setNeedsUpdateConstraints];
        [[self getView] setNeedsLayout];
        [self.parent callUpdata];
    }
    return self;
}

-(void)refreshLAY2View:(UIView*)viewa{
    [viewa setNeedsDisplay];
    for (UIView *view in viewa.subviews) {
        [self refreshLAY2View:view];
    }
    
    
}

//不可见
-(LinearLayoutCell*)setVisibleGone
{
    if (visibel!=AutoLayoutVisibleHide) {
        visibel = AutoLayoutVisibleHide;
        [[self getView] setHidden:YES];
        [self.parent callUpdata];
    }
    return self;
}
//不可见，但是占位子
-(LinearLayoutCell*)setVisibleInVisibel
{
    if (visibel!=AutoLayoutVisibleHideAndUsed) {
        visibel = AutoLayoutVisibleHideAndUsed;
        [[self getView] setHidden:YES];
        [self.parent callUpdata];
    }
    return self;
}
-(BOOL)isVisibleVisibel
{
    return visibel==AutoLayoutVisibleShow;
}
//不可见
-(BOOL)isVisibleGone
{
    return visibel==AutoLayoutVisibleHide;
}
//不可见，但是占位子
-(BOOL)isVisibleInVisibel
{
    return visibel==AutoLayoutVisibleHideAndUsed;
}
@end

@interface LinearLayout()
{
    BOOL hasReset;
    NSMutableArray *childList;
    BOOL hasOncreate;
    
    
    UIView* lv;
    UIView* tv;
    UIView* rv;
    UIView* bv;
    void (^onRefresh)(LinearLayoutCell*cell);
    
}
@end
void addFrameV_out(UIView* pview,UIView* view,UIView*outLv,UIView*outTv,UIView*outRv,UIView*outBv){
    if (outLv.superview!=pview) {
        [pview addSubview:outLv];
    }
    if (outTv.superview!=pview) {
        [pview addSubview:outTv];
    }
    if (outRv.superview!=pview) {
        [pview addSubview:outRv];
    }
    if (outBv.superview!=pview) {
        [pview addSubview:outBv];
    }
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outLv
                          attribute:NSLayoutAttributeCenterY
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterY
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outLv
                          attribute:NSLayoutAttributeRight
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeLeft
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outRv
                          attribute:NSLayoutAttributeCenterY
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterY
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outRv
                          attribute:NSLayoutAttributeLeft
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeRight
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outTv
                          attribute:NSLayoutAttributeCenterX
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterX
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outTv
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeTop
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outBv
                          attribute:NSLayoutAttributeCenterX
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterX
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:outBv
                          attribute:NSLayoutAttributeTop
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeBottom
                          multiplier:1
                          constant:0]];
    
    
    
}
void addFrameV_in(UIView* pview,UIView* view,UIView*inLv,UIView*inTv,UIView*inRv,UIView*inBv){
    if (inLv.superview!=pview) {
        [pview addSubview:inLv];
    }
    if (inTv.superview!=pview) {
        [pview addSubview:inTv];
    }
    if (inRv.superview!=pview) {
        [pview addSubview:inRv];
    }
    if (inBv.superview!=pview) {
        [pview addSubview:inBv];
    }
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inLv
                          attribute:NSLayoutAttributeCenterY
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterY
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inLv
                          attribute:NSLayoutAttributeLeft
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeLeft
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inTv
                          attribute:NSLayoutAttributeCenterX
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterX
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inTv
                          attribute:NSLayoutAttributeTop
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeTop
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inRv
                          attribute:NSLayoutAttributeCenterY
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterY
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inRv
                          attribute:NSLayoutAttributeRight
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeRight
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inBv
                          attribute:NSLayoutAttributeCenterX
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeCenterX
                          multiplier:1
                          constant:0]];
    
    [pview addConstraint:[NSLayoutConstraint
                          constraintWithItem:inBv
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:view
                          attribute:NSLayoutAttributeBottom
                          multiplier:1
                          constant:0]];
    
    
    
}
UIView* createFrameV(){
    UIView* v = [UIView new];
    v.backgroundColor = UIColor.clearColor;
    v.translatesAutoresizingMaskIntoConstraints=FALSE;
    [v addConstraint:[NSLayoutConstraint
                      constraintWithItem:v
                      attribute:NSLayoutAttributeHeight
                      relatedBy:NSLayoutRelationEqual
                      toItem:nil
                      attribute:NSLayoutAttributeNotAnAttribute
                      multiplier:0
                      constant:0]
                   P:250];
    
    [v addConstraint:[NSLayoutConstraint
                      constraintWithItem:v
                      attribute:NSLayoutAttributeWidth
                      relatedBy:NSLayoutRelationEqual
                      toItem:nil
                      attribute:NSLayoutAttributeNotAnAttribute
                      multiplier:0
                      constant:0]
                   P:250];
    return v;
}
@implementation LinearLayout
@synthesize orientation;

-(void)_oncreateLinearLayout{
    self.onRefresh = nil;
    if (hasOncreate==false) {
        hasOncreate=true;
        self.translatesAutoresizingMaskIntoConstraints=FALSE;
        self.gravity=GravityLeft_Top;
        [self addConstraintLitLit:[NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:0]];
        [self addConstraintLitLit:[NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:0]];
        
        
        lv = createFrameV();
        tv = createFrameV();
        rv = createFrameV();
        bv = createFrameV();
        addFrameV_in(self,self,lv ,tv,rv,bv);
        
    }
    
    
    
}



-(id)init{
    
    self = [super init];
    [self _oncreateLinearLayout];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self _oncreateLinearLayout];
    return self;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self _oncreateLinearLayout];
    return self;
}
+(LinearLayout*) newVertical
{
    LinearLayout * l = [LinearLayout new];
    l.orientation = LinearLayoutVertical;
    return l;
}
+(LinearLayout*) newHorizontal
{
    LinearLayout * l = [LinearLayout new];
    l.orientation = LinearLayoutHorizontal;
    return l;
}
-(void)callUpdata{
    hasReset = false;
    //检测UILabel
    [self checkUILabel];
    
    [self setNeedsUpdateConstraints];
    [self needsUpdateConstraints];
}
-(void)checkUILabel{
    for (LinearLayoutCell*cell in childList  ) {
        if([[cell getView]  isKindOfClass:[UILabel class]]){
            if(cell.useWeight &&cell.weight>0){
                //判断父窗体布局方向，再处理
                if(orientation == LinearLayoutVertical){
                    [[cell getView] setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisVertical];
                    [[cell getView] setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
                    

                    
                    
                }else{
                    [[cell getView] setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
                    [[cell getView] setContentCompressionResistancePriority:1 forAxis:UILayoutConstraintAxisHorizontal];
                }
            }else{
                [[cell getView] setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
                [[cell getView] setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
            }
           
        }
    }
}
-(LinearLayoutCell*)findViewByCellName:(NSString*)name
{
    //查找最近的子View
    for (LinearLayoutCell*cell in childList) {
        if([cell.cellName isEqualToString:name]){
            return cell;
        }
    }
    //查找子View的的子View
    for (LinearLayoutCell*cell in childList) {
        if([cell.getView isKindOfClass:[LinearLayout class]]){
            LinearLayoutCell*finded= [((LinearLayout*)cell.getView) findViewByCellName:name];
            if(finded){
                 return finded;
            }
        }
    }
    return nil;
}
-(void)addView:(LinearLayoutCell*)v
{
    if (childList==nil) {
        childList= [NSMutableArray new];
    }
    if (v!=nil && [v getView]!=nil) {
        [childList addObject:v];
        [v getView].translatesAutoresizingMaskIntoConstraints=FALSE;
        [self addSubview:[v getView]];
        
        v.parent = self;
        [self callUpdata];
   
    }
    
}
-(void)addView:(LinearLayoutCell*)v Index:(int)index
{
    if (childList==nil) {
        childList= [NSMutableArray new];
    }
    if (v!=nil && [v getView]!=nil) {
        [childList insertObject:v atIndex:index];
        [v getView].translatesAutoresizingMaskIntoConstraints=FALSE;
        [self insertSubview:[v getView] atIndex:index];
        v.parent = self;
        [self callUpdata];
    }
    
}
-(void)setOnRefresh2:(void (^)(LinearLayoutCell *))onRefr{
   
    onRefresh = onRefr;

}
-(void)setOnRefresh:(void (^)(LinearLayoutCell *))onRefr{
    
    onRefresh = onRefr;
    
}

-(LinearLayoutCell*)getView:(int)index
{
    return [childList objectAtIndex:index];
}
-(int)getCount
{
    return childList.count;
}
-(void)removeView:(UIView*)v OrXJson:(XJson* )json OrData:(id)data OrType:(int)type;
{

}
-(void)removeViewCell:(LinearLayoutCell*)cell
{
    for(LinearLayoutCell*c in childList){
        if (c  == cell) {
            [[cell getView]removeFromSuperview];
            [childList removeObject:c];
            [self callUpdata];
            break;
        }
    }
}
-(void)removeViewIndex:(int)index{
    if(index>=0&&index<childList.count){
        LinearLayoutCell*c  =  childList[index];
        [[c getView]removeFromSuperview];
        [childList removeObject:c];
        [self callUpdata];
    }
}
-(void)removeView:(UIView*)v
{

    for(LinearLayoutCell*cell in childList){
        if ([cell getView] == v) {
            [v removeFromSuperview];
            [childList removeObject:cell];
            [self callUpdata];
            return;
        }
    }
    if([v superview]==self){
        [v removeFromSuperview];
    }
}
-(void)removeAllView
{
    [self _clearConstraints];
    for(LinearLayoutCell*cell in childList){
        [[cell getView]removeFromSuperview];
    }
    [childList removeAllObjects];
}
-(void)callRefresh
{
    if (onRefresh) {
        for(LinearLayoutCell*cell in childList){
            onRefresh(cell);
        }
    }
    
    
}
-(void)layoutSubviews
{
    if (!hasReset) {
        hasReset = true;
        [self _reBuild];
    }
    [super layoutSubviews];
}
- (void)updateConstraints NS_AVAILABLE_IOS(6_0)
{
    if (!hasReset) {
        hasReset = true;
        [self _reBuild];
    }
    [super updateConstraints];
}
-(void)_reBuild
{
    NSMutableArray *list1=nil;
    //清楚旧的约束
    [self _clearConstraints];
    
    //0.添加边界约束
//    for(LinearLayoutCell * cell in childList){
//        //addFrameV_out(self,[cell getView],cell.lv ,cell.tv,cell.rv,cell.bv);
//    }
    
    //1.垂直布局
    if (orientation == LinearLayoutVertical) {
        [self _reBuildVertical];
    }
    //2.水平布局
    else if (orientation == LinearLayoutHorizontal){
        [self _reBuildHorizontal];
    }
   
}
-(BOOL)isInChildList:(UIView*)v
{
    for(LinearLayoutCell* cell in childList){
        if ([cell getView] == v) {
            return true;
        }
    }
    return false;
}
-(void)_clearConstraints
{
    NSArray *cList = [self constraints];
    NSMutableArray *reList=  [NSMutableArray new];
    NSMutableArray*childListTemp =[childList copy];
    for (NSLayoutConstraint * c in cList) {
        for(LinearLayoutCell* cell in childListTemp){
            if ([cell getView] == c.firstItem &&
                (c.secondItem==nil || c.secondItem == self||[self isInChildList:c.firstItem])) {
                [reList addObject:c];
            }else if([cell getView] == c.secondItem  &&
                     (c.firstItem==lv||c.firstItem==tv||c.firstItem==rv||c.firstItem==bv || c.firstItem==nil || c.firstItem == self||[self isInChildList:c.firstItem])){
                [reList addObject:c];
            }else if(c.secondItem==lv||c.secondItem==tv||c.secondItem==rv||c.secondItem==bv){
                [reList addObject:c];
            }
        }
    }
    if ([reList count]>0) {
        [self removeConstraints:reList];
    }
    
}

-(BOOL)isOnLeft:(LinearLayoutCell *)cell{
    
    BOOL g =  cell.gravity & GravityLeft
    ||(self.gravity & GravityLeft && cell.gravity==GravityNo);
    
    return g;
}
-(BOOL)isOnHMiddle:(LinearLayoutCell *)cell{
    BOOL g =  cell.gravity & GravityMiddleH
    ||(self.gravity & GravityMiddleH && cell.gravity==GravityNo);
    
    return g;
}
-(BOOL)isOnRight:(LinearLayoutCell *)cell{
    
    BOOL g =  cell.gravity & GravityRight
    ||(self.gravity & GravityRight && cell.gravity==GravityNo);
    
    return g;
}
-(BOOL)isOnTop:(LinearLayoutCell *)cell{
    BOOL g =  cell.gravity & GravityTop
    ||(self.gravity & GravityTop && cell.gravity==GravityNo);
    
    return g;
}
-(BOOL)isOnVMiddle:(LinearLayoutCell *)cell{
    
    BOOL g =  cell.gravity & GravityMiddleV
    ||(self.gravity & GravityMiddleV && cell.gravity==GravityNo);
    
    return g;
}
-(BOOL)isOnBottom:(LinearLayoutCell *)cell{
    BOOL g =  cell.gravity & GravityBottom
    ||(self.gravity & GravityBottom && cell.gravity==GravityNo);
    
    return g;
}
-(void)_reBuildVertical
{
    BOOL isSlefWidthWrapContent = [_thisCell getWidth]==WrapContent && (_thisCell.parent.orientation==LinearLayoutVertical ||  !_thisCell.useWeight);
    
    BOOL isSlefHeightWrapContent = [_thisCell getHeight]==WrapContent && (_thisCell.parent.orientation==LinearLayoutHorizontal ||  !_thisCell.useWeight);
    
    //添加新的约束
    LinearLayoutCell*firstCell = nil;
    LinearLayoutCell*lastCell = nil;
    LinearLayoutCell*fisterWeightCell = nil;
    
    float allWeight = 0;
    
    //1.垂直布局
    if (orientation == LinearLayoutVertical) {
        //float allHeight = 0;
        //水平
        for(LinearLayoutCell* cell in childList){
            
            if ([cell isVisibleGone]) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:0] P:1];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:0] P:1];
                continue;
            }
            
            //如果适应内容. 使用内容的保护约束，需要小于250，否则可能反向拉伸UILabel
            if (isSlefWidthWrapContent && [cell getWidth]!=MatchPatrent) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:[cell getView]
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                     constant:cell.marginLeft+cell.marginRight]
                                  P:200
                 ];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:[cell getView]
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                     constant:cell.marginLeft+cell.marginRight]
                 ];
            }
            
            if ([cell getWidth]==MatchPatrent) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:cell.marginLeft]];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1
                                     constant:-cell.marginRight]];
            }else  if ([self isOnHMiddle:cell]) {
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                     multiplier:1
                                     constant:(cell.marginLeft-cell.marginRight)/2]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:cell.marginLeft]];
                
                
            }else if ([self isOnRight:cell]) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1
                                     constant:-cell.marginRight]];
                [self addConstraintBigBig:[NSLayoutConstraint
                                           constraintWithItem:[cell getView]
                                           attribute:NSLayoutAttributeLeft
                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeLeft
                                           multiplier:1
                                           constant:cell.marginLeft]];
                
            }else{
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:cell.marginLeft]];
                [self addConstraintBigBig:[NSLayoutConstraint
                                           constraintWithItem:[cell getView]
                                           attribute:NSLayoutAttributeRight
                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeRight
                                           multiplier:1
                                           constant:-cell.marginRight]];
                
            }
            //获取固定高度的大小
            if (!cell.useWeight) {
                
                //防止view未设置高度
                NSLayoutConstraint * zoreHeightConstraint = [NSLayoutConstraint
                                                             constraintWithItem:[cell getView]
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:0
                                                             constant:0];
                zoreHeightConstraint.priority = 1;
                [self addConstraint:zoreHeightConstraint];
                
                //                [self addConstraint:[NSLayoutConstraint
                //                                    constraintWithItem:[cell getView]
                //                                    attribute:NSLayoutAttributeWidth
                //                                    relatedBy:NSLayoutRelationEqual
                //                                    toItem:nil
                //                                    attribute:NSLayoutAttributeNotAnAttribute
                //                                    multiplier:0
                //                                     constant:0] P:1];
                
            }
            //            [self addConstraintLit:[NSLayoutConstraint
            //                                    constraintWithItem:self
            //                                    attribute:NSLayoutAttributeRight
            //                                    relatedBy:NSLayoutRelationEqual
            //                                    toItem:cell.rv
            //                                    attribute:NSLayoutAttributeRight
            //                                    multiplier:1
            //                                    constant:cell.marginRight]];
            
        }
        
        //垂直方向
        for(LinearLayoutCell * cell in childList){
            if ([cell isVisibleGone]) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:0] P:1];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:0] P:1];
                continue;
            }
            if (firstCell==nil) {
                firstCell = cell;
            } else {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:[lastCell getView]
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:cell.marginTop+lastCell.marginBottom]];
            }
            
            
            if (cell.weight>=0 && cell.useWeight) {
                
                if (fisterWeightCell==nil) {
                    fisterWeightCell = cell;
  
                    //正常第一个比重设置高度保护：高度等于父窗体。 但权重过高，在UILabel上会出现异常
                    //BOOL isUILabel =[[cell getView]  isKindOfClass:[UILabel class]];
                    //250 和系统UIlabel 冲突导致系统死循环 小于250 导致UIbutton 的适应内容大于实际内容 大于750导致UIlabel的比重会压缩其他适应内容的尺寸
                    BOOL isUILabel = true;
                    if(isUILabel){
                        [self addConstraint:[NSLayoutConstraint
                                                constraintWithItem:[fisterWeightCell getView]
                                                attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeHeight
                                                multiplier:1
                                                constant:-(fisterWeightCell.marginTop+fisterWeightCell.marginBottom)]
                         P:500];
                    }else{
                        [self addConstraintBig:[NSLayoutConstraint
                                                constraintWithItem:[fisterWeightCell getView]
                                                attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeHeight
                                                multiplier:1
                                                constant:-(fisterWeightCell.marginTop+fisterWeightCell.marginBottom)]];
                    }
                    
                    [self  addConstraint:[NSLayoutConstraint
                                          constraintWithItem:[fisterWeightCell getView]
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                          toItem:self
                                          attribute:NSLayoutAttributeHeight
                                          multiplier:1
                                          constant:0]];
                    
                }else{
                    [self addConstraint:[NSLayoutConstraint
                                         constraintWithItem:[cell getView]
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:[fisterWeightCell getView]
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:cell.weight/fisterWeightCell.weight
                                         constant:0]];
                }
                
                
            }
            lastCell = cell;
        }
        
        if (lastCell!=nil) {
            
            if(fisterWeightCell){
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[firstCell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:firstCell.marginTop]
                 ];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[lastCell getView]
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:-lastCell.marginBottom]
                 ];
            }else  if (self.gravity&GravityMiddleV) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[firstCell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:tv
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:firstCell.marginTop]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[lastCell getView]
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:bv
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:-lastCell.marginBottom]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:bv
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:tv
                                     attribute:NSLayoutAttributeHeight
                                     multiplier:1
                                     constant:0]];
                
                
            }else if(self.gravity&GravityBottom){
                //                [self addConstraintBig:[NSLayoutConstraint
                //                                        constraintWithItem:[firstCell getView]
                //                                        attribute:NSLayoutAttributeTop
                //                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                //                                        toItem:self
                //                                        attribute:NSLayoutAttributeTop
                //                                        multiplier:1
                //                                        constant:firstCell.marginTop]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[lastCell getView]
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:-lastCell.marginBottom]];
                
            }else{
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[firstCell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:firstCell.marginTop]];
                
                //                [self addConstraintBig:[NSLayoutConstraint
                //                                        constraintWithItem:[lastCell getView]
                //                                        attribute:NSLayoutAttributeBottom
                //                                        relatedBy:NSLayoutRelationLessThanOrEqual
                //                                        toItem:self
                //                                        attribute:NSLayoutAttributeBottom
                //                                        multiplier:1
                //                                        constant:-lastCell.marginBottom]];
                
            }
            //            //如果自己未设置高度，则设置高度
            //            if (![self hasHeight]) {
            //                //防止self未设高度
            //                [self addConstraintBig:[NSLayoutConstraint
            //                                        constraintWithItem:bv
            //                                        attribute:NSLayoutAttributeBottom
            //                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
            //                                        toItem:[lastCell getView]
            //                                        attribute:NSLayoutAttributeBottom
            //                                        multiplier:1
            //                                        constant:lastCell.marginBottom ]];
            //            }
            //
            [self addConstraintLit:[NSLayoutConstraint
                                    constraintWithItem:bv
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:[lastCell getView]
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                    constant:lastCell.marginBottom ]];
            
            //----适应内容高度
            if ([_thisCell getHeight]==WrapContent) {
                [self addConstraintBig:[NSLayoutConstraint
                                        constraintWithItem:bv
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:[lastCell getView]
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                        constant:lastCell.marginBottom ]];
            }
        }
        
    }
}
-(BOOL)hasHeight{
    NSArray *cList = [self constraints];
    for (NSLayoutConstraint * c in cList) {
        if (self == c.firstItem && c.firstAttribute == NSLayoutAttributeHeight && c.priority>=750) {
            return true;
        }
    }
    return false;
}
-(void)_reBuildHorizontal
{
    BOOL isSlefWidthWrapContent = [_thisCell getWidth]==WrapContent && (_thisCell.parent.orientation==LinearLayoutVertical ||  !_thisCell.useWeight);
    
    BOOL isSlefHeightWrapContent = [_thisCell getHeight]==WrapContent && (_thisCell.parent.orientation==LinearLayoutHorizontal ||  !_thisCell.useWeight);
    
    //添加新的约束
    LinearLayoutCell*firstCell = nil;
    LinearLayoutCell*lastCell = nil;
    LinearLayoutCell*fisterWeightCell = nil;
    
    float allWeight = 0;
    
    //1.水平布局
    if (orientation == LinearLayoutHorizontal) {
        
        //垂直
        for(LinearLayoutCell * cell in childList){
            if ([cell isVisibleGone]) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:0] P:1];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:0] P:1];
                continue;
            }
            //如果适应内容.  拉伸保护约束需要小于250，否则将会反向拉伸UILabel
            if (isSlefHeightWrapContent && [cell getHeight]!=MatchPatrent) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:[cell getView]
                                     attribute:NSLayoutAttributeHeight
                                     multiplier:1
                                     constant:cell.marginTop+cell.marginBottom]
                 P:200
                 ];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:[cell getView]
                                     attribute:NSLayoutAttributeHeight
                                     multiplier:1
                                     constant:cell.marginTop+cell.marginBottom]
                 ];
            }
            
            if ([cell getHeight]==MatchPatrent) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:cell.marginTop]];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:-cell.marginBottom]];
            }else  if ([self isOnVMiddle:cell]) {
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                     multiplier:1
                                     constant:(cell.marginTop-cell.marginBottom)/2]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:cell.marginTop]];
                
            }else if ([self isOnBottom:cell]) {
                [self addConstraintBigBig:[NSLayoutConstraint
                                           constraintWithItem:[cell getView]
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeTop
                                           multiplier:1
                                           constant:cell.marginTop]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:-cell.marginBottom]];
                
            }else{
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:cell.marginTop]];
                [self addConstraintBigBig:[NSLayoutConstraint
                                           constraintWithItem:[cell getView]
                                           attribute:NSLayoutAttributeBottom
                                           relatedBy:NSLayoutRelationLessThanOrEqual
                                           toItem:self
                                           attribute:NSLayoutAttributeBottom
                                           multiplier:1
                                           constant:-cell.marginBottom]];
                
            }
            
            
            //获取固定高度的大小
            if (!cell.useWeight) {
                
                //防止view未设置高度
                NSLayoutConstraint * zoreHeightConstraint = [NSLayoutConstraint
                                                             constraintWithItem:[cell getView]
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:0
                                                             constant:0];
                zoreHeightConstraint.priority = 1;
                [self addConstraint:zoreHeightConstraint];
            }
            
            //            [self addConstraintLit:[NSLayoutConstraint
            //                                    constraintWithItem:self
            //                                    attribute:NSLayoutAttributeBottom
            //                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
            //                                    toItem:cell.bv
            //                                    attribute:NSLayoutAttributeBottom
            //                                    multiplier:1
            //                                    constant:cell.marginBottom]];
            
        }
        
        //水平方向
        for(LinearLayoutCell * cell in childList){
            if ([cell isVisibleGone]) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:0] P:1];
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:0] P:1];
                continue;
            }
            if (firstCell==nil) {
                firstCell = cell;
            } else {
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[cell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:[lastCell getView]
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1
                                     constant:cell.marginLeft+lastCell.marginRight]];
                
            }
            
            if (cell.weight>=0 && cell.useWeight) {
                
                if (fisterWeightCell==nil) {
                    fisterWeightCell = cell;
                    
                    //正常第一个比重设置高度保护：高度等于父窗体。 但权重过高，在UILabel上会出现异常
                    //BOOL isUILabel =[[cell getView]  isKindOfClass:[UILabel class]];
                     //250 和系统UIlabel 冲突导致系统死循环 小于250 导致UIbutton 的适应内容大于实际内容 大于750导致UIlabel的比重会压缩其他适应内容的尺寸
                    BOOL isUILabel = true;
                    if(isUILabel){
                        [self addConstraint:[NSLayoutConstraint
                                                constraintWithItem:[fisterWeightCell getView]
                                                attribute:NSLayoutAttributeWidth
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeWidth
                                                multiplier:1
                                                constant:-(fisterWeightCell.marginLeft+fisterWeightCell.marginRight)]
                         P:500];
                    }else{
                        [self addConstraintBig:[NSLayoutConstraint
                                                constraintWithItem:[fisterWeightCell getView]
                                                attribute:NSLayoutAttributeWidth
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeWidth
                                                multiplier:1
                                                constant:-(fisterWeightCell.marginLeft+fisterWeightCell.marginRight)]];
                    }
                    
                    [self addConstraint:[NSLayoutConstraint
                                         constraintWithItem:[fisterWeightCell getView]
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                         constant:0]];
                    
                }else{
                    [self addConstraint:[NSLayoutConstraint
                                         constraintWithItem:[cell getView]
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:[fisterWeightCell getView]
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:cell.weight/fisterWeightCell.weight
                                         constant:0]];
                }
                
                
            }
            lastCell = cell;
        }
        
        if (lastCell!=nil) {
            
            //如果使用比重，则两边局需要对齐父窗体
            if(fisterWeightCell){
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[firstCell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:firstCell.marginLeft]
                 ];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[lastCell getView]
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1
                                     constant:-lastCell.marginRight]
                 ];
            }else  if (self.gravity&GravityMiddleH) {
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[firstCell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:lv
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1
                                     constant:firstCell.marginLeft]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[lastCell getView]
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:rv
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:-lastCell.marginRight]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:lv
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:rv
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                     constant:0]];
                
            }else if(self.gravity&GravityRight){
                //                [self addConstraint:[NSLayoutConstraint
                //                                     constraintWithItem:[firstCell getView]
                //                                     attribute:NSLayoutAttributeLeft
                //                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                //                                     toItem:self
                //                                     attribute:NSLayoutAttributeLeft
                //                                     multiplier:1
                //                                     constant:firstCell.marginLeft]];
                
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[lastCell getView]
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1
                                     constant:-lastCell.marginRight]];
                
            }else{
                [self addConstraint:[NSLayoutConstraint
                                     constraintWithItem:[firstCell getView]
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:firstCell.marginLeft]];
                
                //                [self addConstraint:[NSLayoutConstraint
                //                                     constraintWithItem:[lastCell getView]
                //                                     attribute:NSLayoutAttributeRight
                //                                     relatedBy:NSLayoutRelationLessThanOrEqual
                //                                     toItem:self
                //                                     attribute:NSLayoutAttributeRight
                //                                     multiplier:1
                //                                     constant:-lastCell.marginRight]
                //                 P:900
                //                 ];
                
                
                
            }
            
            //            //如果自己未设置宽度，则设置宽度
            //            if (![self hasWidth]) {
            //                //防止self未设宽度
            //                [self addConstraintBig:[NSLayoutConstraint
            //                                        constraintWithItem:rv
            //                                        attribute:NSLayoutAttributeLeft
            //                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
            //                                        toItem:[lastCell getView]
            //                                        attribute:NSLayoutAttributeRight
            //                                        multiplier:1
            //                                        constant:lastCell.marginRight]];
            //            }
            
            
            [self addConstraintLit:[NSLayoutConstraint
                                    constraintWithItem:rv
                                    attribute:NSLayoutAttributeLeft
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:[lastCell getView]
                                    attribute:NSLayoutAttributeRight
                                    multiplier:1
                                    constant:lastCell.marginRight]];
            
            //----适应内容高度
            if ([_thisCell getWidth]==WrapContent) {
                [self addConstraintBig:[NSLayoutConstraint
                                        constraintWithItem:rv
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:[lastCell getView]
                                        attribute:NSLayoutAttributeRight
                                        multiplier:1
                                        constant:lastCell.marginRight]];
            }
            
        }
        
    }
}
-(BOOL)hasWidth{
    NSArray *cList = [self constraints];
    for (NSLayoutConstraint * c in cList) {
        if (self == c.firstItem && c.firstAttribute == NSLayoutAttributeWidth && c.priority>=750) {
            return true;
        }
    }
    return false;
}

//猜测垃圾ios 当view不可见或者大小为0 绘制view缓存的时候  发现子view覆盖了drawRact 就不绘制该子view 但是当view恢复可见 或者有大小的时候 view 的缓存不重新绘制 使用老的错误的缓存
-(void)callAllViewDispaly{
    
    [self viewDispaly:self];
    
}

-(void)viewDispaly:(UIView*)view1{
    [view1 setNeedsDisplay];
    for (UIView *view in view1.subviews) {
        [self viewDispaly:view];
    }
    
    
}
-(void)dealloc
{
    self.onRefresh = nil;
    [childList removeAllObjects];
    childList = nil;
}

@end

