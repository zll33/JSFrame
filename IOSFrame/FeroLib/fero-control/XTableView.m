//
//  XTableView.m
//  p2p
//
//  Created by kzd on 14-11-19.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XTableView.h"
#import "HelpApi.h"
#import "XHeaderView.h"
#import "ViewFactory.h"
#define iOS9Before ([UIDevice currentDevice].systemVersion.floatValue < 9.0f)
UIView* (^ XTableView_getEv)(XTableView*tabelview);
void setXTableViewDefaultEV(UIView* (^_getEv)(XTableView*tabelview))
{
    XTableView_getEv =_getEv;
}
UIView*getXTableViewDefaultEV(){
    if (XTableView_getEv) {
        return XTableView_getEv(nil);
    }
    return nil;
}
typedef enum {
    Darg_No=0,//无
    Darg_BeginDarg ,// 下拉中（或上拉）
    Darg_MoreDarg ,// 等待释放
    Darg_Loading ,// 刷新（或加载）
    Darg_Recover // 恢复中
    
}DargAct;


@interface XTableViewCellNode : NSObject
@property (nonatomic)  NSString* identifier;
@property (nonatomic)  NSMutableArray* list;

@end

@implementation XTableViewCellNode

@end


@interface XTableView()
{
    DargAct headerStatue;
    DargAct footerStatue;
    XHeaderView *header;
    XHeaderView *footer;
    
    __weak UIView* fhView;
    __weak UIView*fLayout;
    Boolean needMore;
    Boolean needRefresh;
    Boolean bCreate;
    UIView* emptyViewLayout;
    
    NSMutableArray *cellNodes;
    CGRect lastMeRect;
    float lastY;
    
    int count;
    
    __weak UIImageView*emptyImageView;
    __weak UILabel*emptyLabel;
    __weak UILabel*emptyButton;
}

- (void)createHeader;
- (void)createFooter;

@end
@implementation XTableView


@synthesize emptyView;
@synthesize dataLoad;

-(XTableViewCell*)getFreeCell
{
    return [self getFreeCell:@"_XTableCell"];
}
-(XTableViewCell*)getFreeCell:(NSString*)identifier
{
    //找到后添加进去
    for (XTableViewCellNode * node in cellNodes) {
        if ([node.identifier isEqualToString:identifier]) {
            for (XTableViewCell * cell in node.list) {
                //判断是否被list使用
                if ([cell  isFree]) {
                    return cell;
                }
            }
            break;
        }
    }
    
    return nil;
}
-(void)addCell:(XTableViewCell*)cell
{
    [self addCell:cell Identifier:@"_XTableCell"];
}
-(void)addCell:(XTableViewCell*)cell Identifier:(NSString*)identifier
{
    if (cellNodes==nil) {
        cellNodes = [NSMutableArray new];
    }
    if(identifier && cell){
        cell.list = self;
        //找到后添加进去
        for (XTableViewCellNode * node in cellNodes) {
            if ([node.identifier isEqualToString:identifier]) {
                if (![node.list containsObject:cell]) {
                    [node.list addObject:cell];
                }
                return;
            }
        }
        
        //找不到创建添加进去
        XTableViewCellNode * newNode = [XTableViewCellNode new];
        newNode.identifier =[identifier copy];
        newNode.list =[NSMutableArray new];
        [newNode.list addObject:cell];
        [cellNodes addObject:newNode];
    }
    return;
}

/**
 *设置contentView的约束
 *
 */
- (void)setEmptyView:(UIView*)view
{
    [self setEmptyView:view MLeft:0 MTop:0 MRight:0 MBottom:0];
}
-(void)setEmptyView:(UIView *)view MLeft:(float)ml MTop:(float)mt MRight:(float)mr MBottom:(float)mb{

    if (emptyView!=nil && [emptyViewLayout.subviews containsObject:emptyView]) {
        [emptyView removeFromSuperview];
    }
    emptyView = view;
    if (emptyView!=nil) {
        [emptyView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [emptyViewLayout addSubview:emptyView];
        XJson *views = XJsonOfVariableBindings(view);
        [emptyViewLayout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[view]-(%f)-|",ml,mr]
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]];
        
        [emptyViewLayout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[view]-(%f)-|",mt,mb]
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]];
    }
}


- (void)createEmptyViewLayoutForIOS7
{
    emptyViewLayout = [UIView new];
    //emptyViewLayout.backgroundColor = ARGB(44, 0, 0, 0);
    emptyViewLayout.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
    [fhView addSubview:emptyViewLayout];
    
}

- (void)createEmptyViewLayout
{
    
    emptyViewLayout = [UIView new];
    //emptyViewLayout.backgroundColor = ARGB(44, 0, 0, 0);
    [emptyViewLayout setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:emptyViewLayout];
    
    //    XJson *views = XJsonOfVariableBindings(emptyViewLayout);
    //    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emptyViewLayout]-0-|"
    //                                                                 options:0
    //                                                                 metrics:nil
    //                                                                   views:views]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:emptyViewLayout
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:emptyViewLayout
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1
                         constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:emptyViewLayout
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:emptyViewLayout
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1
                         constant:0]];
    //    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[emptyViewLayout]|"
    //                                                                 options:0
    //                                                                 metrics:nil
    //                                                                   views:views]];
    
}
-(void)showEmptyContentView
{
    if (self.emptyView.hidden) {
        self.emptyView.hidden=FALSE;
    }
}
-(void)hideEmptyContentView
{
    if (!self.emptyView.hidden) {
        self.emptyView.hidden=TRUE;
    }
}
-(void)showEmptyView
{
    if (emptyViewLayout.hidden) {
        emptyViewLayout.hidden=FALSE;
    }
}
-(void)hideEmptyView
{
    if (!emptyViewLayout.hidden) {
        emptyViewLayout.hidden=TRUE;
    }
}
- (UIView*)setEmptyViewNibNamed:(NSString*)nibName Index:(int)index
{
    [self setEmptyView:[[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:index]];
    return emptyView;
}

- (UIView*)setEmptyViewNibNamed:(NSString*)nibName
{
    return [self setEmptyViewNibNamed:nibName Index:0];
}
- (UIView*)getEmptyView
{
    return emptyView;
}
-(void)layoutSubviews
{
    if (!CGRectEqualToRect(self.frame, lastMeRect)) {
        lastMeRect = CGRectStandardize(self.frame);
        
        [super reloadData];
        [self setNeedsLayout];
        [self setNeedsUpdateConstraints];
        [self setNeedsDisplay];
        
    }
    [super layoutSubviews];
    
    [self resetFhViewForIOS7];
}
- (id)init
{
    self = [super init];
    if (self) {
        [self XTableView_onCreate];
    }
    return self;
}



-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self XTableView_onCreate];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    [self XTableView_onCreate];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self XTableView_onCreate];
    }
    return self;
    
}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    
//
//}
- (void)needLoadMore:(Boolean)isNeed
{
    needMore = isNeed;
    fLayout.hidden= !needMore;
}
- (void)needTopRefresh:(Boolean)isNeed
{
    needRefresh = isNeed;
    header.hidden= !needRefresh;
}
- (void)createHeaderForIOS7
{
    
    //UIView* hLayout = [UIView new];
    //self.tableHeaderView=hLayout;
    //fhView =hLayout;
    fhView = self;
    
    
    header = [[[NSBundle mainBundle] loadNibNamed:@"XHeaderView" owner:nil options:nil] firstObject];
    header.frame = CGRectMake(0,-50,self.bounds.size.width,50);
    [fhView addSubview:header];
    
     header.hidden = true;
    
    
}
- (void)createHeader
{
    NSLayoutConstraint* layoutConstraint = nil;
    
    header = [[[NSBundle mainBundle] loadNibNamed:@"XHeaderView" owner:nil options:nil] firstObject];
    [self addSubview:header];
    [header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    XJson *views = XJsonOfVariableBindings(header);
    
    
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
    
    [self layoutIfNeeded];
    
    header.hidden = true;
    
}
//注册KVO方法
//[footer addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
////KVO回调
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(XJson *)change context:(void *)context
//{
//    if (object == footer && [keyPath isEqualToString:@"contentOffset"])
//    {
//
//    //    footer.frame =CGRectMake(self.bounds.size.height, 0, 200, 50);
//    }
//
//
//
//
//}
-(void)resetFhViewForIOS7{
    
    float y =self.contentSize.height;
    if (y < self.bounds.size.height) {
        y = self.bounds.size.height;
    }
    
    header.frame = CGRectMake(0,-50,self.bounds.size.width,50);
    emptyViewLayout.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
    footer.frame = CGRectMake(0,y,self.bounds.size.width,50);
  
}
- (void)createFooterForIOS7
{
    
    footer= [[[NSBundle mainBundle] loadNibNamed:@"XHeaderView" owner:nil options:nil] firstObject];
    footer.frame = CGRectMake(0,0,self.bounds.size.width,50);
    [fhView addSubview:footer];
 
    fLayout=footer;
    fLayout.hidden = true;
    
}
- (void)createFooter
{
    footer= [[[NSBundle mainBundle] loadNibNamed:@"XHeaderView" owner:nil options:nil] firstObject];
    [self addSubview:footer];
    
    UIView*tableFooterView=[[UIView alloc]init];
    self.tableFooterView = tableFooterView;
    
    [footer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:footer
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:footer
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:footer
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                         toItem:tableFooterView//self.tableFooterView
                         attribute:NSLayoutAttributeBottom
                         multiplier:1
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:footer
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                         toItem:emptyViewLayout//self.tableFooterView
                         attribute:NSLayoutAttributeBottom
                         multiplier:1
                         constant:0]];
    fLayout.hidden= true;
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    //[self XTableView_onCreate];

}
- (void)XTableView_onCreate
{
    if (!bCreate) {
        bCreate=TRUE;
        needMore = true;
        needRefresh = true;
        self.backgroundColor=UIColor.clearColor;
        //自动车测量
        self.estimatedRowHeight = UITableViewAutomaticDimension;
        self.rowHeight = UITableViewAutomaticDimension;
        
        self.delegate=self;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //[self createEmptyViewLayout];
        //[self setEmptyViewNibNamed:@"ListEmptyView"];
        //[self createHeader];
        //[self createFooter];
        
        //兼容IOS7.1不支持TableView直接添加约束的问题。
        [self createHeaderForIOS7];
        [self createEmptyViewLayoutForIOS7];
        //自定义空页面
        if (XTableView_getEv) {
            UIView*EV = XTableView_getEv(self);
            emptyImageView = (UIImageView*)[EV findViewByTag:XTBEmptyImageTag];
            emptyLabel = (UILabel*)[EV findViewByTag:XTBEmptyLabelTag];
            emptyButton = (UILabel*)[EV findViewByTag:XTBEmptyButtonTag];
            [self setEmptyView:EV];
        }else{
            [self setEmptyViewNibNamed:@"ListEmptyView"];
        }
        
        [self createFooterForIOS7];
        
        
        [self resetStatue];
        [self layoutIfNeeded];
    }
}
-(void)setEmptyMsg:(NSString*)msg
{
    if (emptyLabel) {
        emptyLabel.text=msg;
    }
}
-(void)setEmptyPic:(NSString*)path{
    if(emptyImageView){
        [emptyImageView setImage:[UIImage imageNamed:path]];
    }
}
-(LFLabel *)getEmptyLabel{
   
    if ([emptyView isKindOfClass:[LinearLayout class]]) {
      LinearLayout*  emview=(LinearLayout*)emptyView;
     LFLabel*lflabel = (LFLabel*) [emview getView:1];
        return lflabel;
    }
    
    return nil;
}
-(void)showEmptyButtonTitle:(NSString*)title Target:(id)target Sel:(SEL)action
{
    if(emptyButton){
        emptyButton.hidden=NO;
        emptyButton.text=title;
        [emptyButton setOnClickTarget:target action:action];
    }
}
-(void)hideEmptyButton{
    if(emptyButton){
        emptyButton.hidden=YES;
    }
}

-(void)setDataLoad:(id<XTableViewDataLoad>)dataload_
{
    dataLoad = dataload_;
    header.hidden = (dataLoad==nil);
}
-(void)setDataSource:(id<UITableViewDataSource>)datasource
{
    [super  setDataSource:datasource];
    
    [self reloadData];
//    if (dataLoad!=datasource) {
//        
//    }
}
-(void)reloadData
{
    WS(me);
    runOnUiTread2(^{
        [me WeakreloadData];
       
    });
}

-(void)WeakreloadData
{
    
    if (iOS9Before&&findXBaseViewController(self)==nil) {
        return;//当controller 为空时调用 保护函数异常
    }
          [super reloadData];

    if ([self isDataEmpty]) {
        [self showEmptyView];
    }else{
        
        [self hideEmptyView];
    }

}

-(BOOL)isDataEmpty{
    
    if (iOS9Before&&findXBaseViewController(self)==nil) {
        return TRUE;//当controller 为空时调用 保护函数异常
    }
    
    if (self.dataSource==nil) {
        return TRUE;
    }
    return  ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] && [self.dataSource numberOfSectionsInTableView:self]==0)
    || ([self.dataSource respondsToSelector:@selector(tableView: numberOfRowsInSection:)] && [self.dataSource tableView:self numberOfRowsInSection:0]==0);
    // int num1 = [self.dataSource numberOfSectionsInTableView:self];
    // return [self.dataSource numberOfSectionsInTableView:self]==0 ||
    //        ([self.dataSource numberOfSectionsInTableView:self]==1 && [self.dataSource tableView:self numberOfRowsInSection:0]==0);
}
- (void)resetStatue
{    WS(me);
    runOnUiTread2(^{
        if (iOS9Before&&findXBaseViewController(me)==nil) {
            return;//当controller 为空时调用 保护函数异常
        }
        [me footerChangeDargAct:Darg_No];
        [me headerChangeDargAct:Darg_No];
    });
}

- (void)onComplete
{

    WS(me);
    
    runOnNewUiTread(^{
        //
        [me onWeakComplete];
    });
}

- (void)onWeakComplete
{
  
    if (iOS9Before&&findXBaseViewController(self)==nil) {
        return;//当controller 为空时调用 保护函数异常
    }

    if (headerStatue==Darg_Loading) {
        [self headerChangeDargAct:Darg_Recover];
    }
    if (footerStatue==Darg_Loading) {
        [self footerChangeDargAct:Darg_Recover];
    }
    if ([self isDataEmpty]) {
        [self showEmptyView];
    }else{
        
        [self hideEmptyView];
    }
 
}
- (void)onCompleteNoAnimation
{
    
    if (iOS9Before&&findXBaseViewController(self)==nil) {
        return;//当controller 为空时调用 保护函数异常
    }

    if (headerStatue==Darg_Loading) {
        [self headerChangeDargAct:Darg_Recover];
        [self.layer removeAllAnimations];
    }
    if (footerStatue==Darg_Loading) {
        [self footerChangeDargAct:Darg_Recover];
        [self.layer removeAllAnimations];
    }
    if ([self isDataEmpty]) {
        [self showEmptyView];
    }else{
        
        [self hideEmptyView];
    }
    
}
////每个item的高度[可选]
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
//    [cell layoutIfNeeded];
//    [cell updateConstraintsIfNeeded];
//
//    cell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
//    CGFloat height = [cell systemLayoutSizeFittingSize:CGSizeMake(self.contentSize.width, 0)
//                         withHorizontalFittingPriority: 1000//水平方向约束要求为self.contentSize.width，优先级1000，最高，即必须
//                               verticalFittingPriority: 1//垂直方向约束要求为0，优先级1，最低。即不作约束
//                      ].height;
//
//    return height;
//}

//每个item的高度[可选]∂
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 这里设置单元格内容
    XTableViewCell *cell = [self.dataSource  tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell getContentHeight:CGRectGetWidth(tableView.bounds)];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0){
    
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)z didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [z deselectRowAtIndexPath:indexPath animated:NO];
    //判断是否实现
    if (self!=dataLoad&&[dataLoad respondsToSelector:@selector(tableView: didSelectRowAtIndexPath:)]
        //选择动画执行过程中发生reload  导致数据源不匹配 iOS bug。。
        &&(indexPath.row<[self.dataSource tableView:self numberOfRowsInSection:indexPath.section]) ) {
        [dataLoad tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self!=dataLoad&& [dataLoad respondsToSelector:@selector(tableView: viewForHeaderInSection:)]){
        return [dataLoad tableView:self viewForHeaderInSection:section];
    }else{
        return nil;
    }
}

////每个HeaderInSection的高度[可选]
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView* view =[self tableView:tableView viewForHeaderInSection:section];
    if (view.frame.size.height>0) {
        return view.frame.size.height;
    }
    CGSize size =[view systemLayoutSizeFittingSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)];

    return size.height;
}



//-(BOOL)Xtable_isFirstFinger:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    NSSet *allTouches = [event allTouches];
//    UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
//    UITouch *touchCur = [touches anyObject];
//    if (touchCur==touch1) {
//        return YES;
//    }
//    return NO;
//}



//- (void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    if ([self Xtable_isFirstFinger:touches withEvent:event]) {
//        NSIndexPath *selected = [self indexPathForSelectedRow];
//        [self deselectRowAtIndexPath:selected animated:NO];
//    }
//}
//
//- (void)touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    if ([self Xtable_isFirstFinger:touches withEvent:event]) {
//        NSIndexPath *selected = [self indexPathForSelectedRow];
//        [self deselectRowAtIndexPath:selected animated:NO];
//    }
//}

-(int)getHeaderHeight{
    int h = header.frame.size.height;
    return h;
}

-(int)getFooterHeight{
    
    return footer.frame.size.height;
}
-(void)callRefresh
{   WS(me);
    runOnNewUiTread(^(){
        if (iOS9Before&&findXBaseViewController(me)==nil) {
            return;//当controller 为空时调用 保护函数异常
        }
        
        [me headerChangeDargAct:Darg_Loading];
        [me setContentOffset:CGPointMake(0, -[me getHeaderHeight]) animated:NO];
    });
    
}
-(BOOL)isOnLoading{
    return headerStatue==Darg_Loading;
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
            WS(me);
            runOnNewUiTread(^{
                // 执行动画
                [me weakAnimations];
                
            });
            [self.dataLoad onRefresh];
            [self hideEmptyView];
        }
            break;
            
        default:
            break;
    }
}
-(void)weakAnimations{
      WS(me);
    
    if (iOS9Before&&findXBaseViewController(self)==nil) {
        return;//当controller 为空时调用 保护函数异常
    }
    
    UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
        me.contentInset = UIEdgeInsetsMake([me getHeaderHeight],0,0,me.contentInset.bottom);
        me.contentOffset = CGPointMake(me.contentOffset.x, -[me getHeaderHeight]);
    } completion:nil];

}
- (void)footerChangeDargAct:(DargAct)act
{
    
    switch (act) {
        case Darg_No:
        {
            footerStatue = Darg_No;
            [footer setText:@"上拉加载更多"];
            
            if (!fLayout.hidden) {
                fLayout.hidden=TRUE;
            }
        }
            break;
        case Darg_Recover:
        {
            if (fLayout.hidden) {
                fLayout.hidden=FALSE;
            }
            footerStatue = Darg_Recover;
            [footer stopActView];
            [footer setText:@"加载完毕"];
            UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction;
            [UIView animateWithDuration:0.2 delay:0.2 options:options animations:^
             {
                 self.contentInset  = UIEdgeInsetsMake(self.contentInset.top,0,0,0);
             } completion:^(BOOL finished){
                 //[self footerChangeDargAct:Darg_No];
             }];
            [self footerChangeDargAct:Darg_No];
        }
            break;
        case Darg_BeginDarg:
        {
            if (fLayout.hidden) {
                fLayout.hidden=FALSE;
            }
            footerStatue =  Darg_BeginDarg;
            [footer setText:@"上拉加载更多"];
        }
            break;
        case Darg_MoreDarg:
        {
            if (fLayout.hidden) {
                fLayout.hidden=FALSE;
            }
            footerStatue =  Darg_MoreDarg;
            [footer setText:@"放开以加载更多"];
        }
            break;
        case Darg_Loading:
        {
            if (fLayout.hidden) {
                fLayout.hidden=FALSE;
            }
            footerStatue=Darg_Loading;
            [footer startActView];
            [footer setText:@"正在加载..."];
            self.contentInset  = UIEdgeInsetsMake(self.contentInset.top,0,[self getFooterHeight],0);
            [self.dataLoad onLoadMore];
            [self hideEmptyView];
        }
            break;
            
        default:
            break;
    }
    
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    lastY = scrollView.contentOffset.y;
}

//当scroller滑动时调用
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (dataLoad) {
        
        
        //if(self.contentOffset.y< 0 && footerStatue==Darg_No ){
        if(needRefresh && self.contentOffset.y< 0 ){
            
            if(self.contentOffset.y<- [self getHeaderHeight]){
                if(headerStatue==Darg_No || headerStatue==Darg_BeginDarg){
                    [self headerChangeDargAct:Darg_MoreDarg];
                }
                
            }else{
                if (headerStatue==Darg_No || headerStatue==Darg_MoreDarg) {
                    [self headerChangeDargAct:Darg_BeginDarg];
                }
            }
        }
        
        
        // 调用上拉刷新方法
        float updy = scrollView.contentSize.height-scrollView.frame.size.height;
        if (updy<0) {
            updy = 0;
        }
        if (needMore  && (scrollView.contentOffset.y > updy) && headerStatue == Darg_No ) {
            
            if(self.contentOffset.y>updy+ [self getFooterHeight]){
                if (footerStatue==Darg_No || footerStatue==Darg_BeginDarg) {
                    [self footerChangeDargAct:Darg_MoreDarg];
                }
            }else {
                if(footerStatue==Darg_No || footerStatue==Darg_MoreDarg){
                    [self footerChangeDargAct:Darg_BeginDarg];
                }
            }
            
        }
        
        lastY = scrollView.contentOffset.y;
    }
    
    
    //[self resetFhViewForIOS7];
}

//当滑动结束时调用
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (dataLoad) {
        if (headerStatue==Darg_MoreDarg) {
            [self headerChangeDargAct:Darg_Loading];
        }else if (headerStatue!=Darg_No && headerStatue!=Darg_Recover &&headerStatue!=Darg_Loading) {
            [self headerChangeDargAct:Darg_Recover];
        }
        
        if (needMore && footerStatue==Darg_MoreDarg) {
            [self footerChangeDargAct:Darg_Loading];
        }else if (footerStatue!=Darg_No && footerStatue!=Darg_Recover &&footerStatue!=Darg_Loading) {
            [self footerChangeDargAct:Darg_Recover];
        }
    }
}

@end
