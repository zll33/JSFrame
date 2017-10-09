//
//  XTableViewCell.m
//  p2p
//
//  Created by zhangxiuquan on 15/1/22.
//  Copyright (c) 2015年 zhangxiuquan. All rights reserved.
//

#import "XTableViewCell.h"
#import "XHeader.h"

@interface XTableViewCell()
{
    // 记录代码写的contentView，以便计算高度
    UIView* cView;
    //设置选中时那个View发生改变
    UIView* sview;
    int normalColor;
    int pressColor;
    NSObject*forSelectObject;
    void(^onselect)(BOOL isSelect,NSObject*forSelectObject);
    //
    float mleft;
    float mRight;
    float mTop;
    float mBottom;
    
}
@end

@implementation XTableViewCell

-(id)init{
    self = [super init];
     [self _onXTableViewCellCreate];
    return self;
}
-(void)_onXTableViewCellCreate{
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor=COLOR(0);
    //设置,选中颜色
    [self setSelect:self.contentView NormalColor:ItemNormalColor PressColor:ItemPressColor];
}
-(UIView*)mainContent{
    return cView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    
}
- (void)awakeFromNib {
    // Initialization code

    [self _onXTableViewCellCreate];
}

-(void)setSelectNormalColor:(int)color PressColor:(int)sColor
{
    //[self putXBingDataInt:@"__cellColor" :color];
    //[self putXBingDataInt:@"__cellPressColor" :sColor];
    
    //[self.contentView setNormalColor:color PressColor:sColor];
}
-(void)setSelect:(UIView*)view NormalColor:(int)_color PressColor:(int)_sColor
{
    sview =view;
    normalColor =_color;
    pressColor=_sColor;
}
-(void)setSelectBlock:(void(^)(BOOL isSelect,NSObject*forSelectObject))_onselect Object:(NSObject*)_forSelectObject
{
    onselect =_onselect;
    forSelectObject =_forSelectObject;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (sview) {
        if(highlighted){
            sview.backgroundColor = COLOR(pressColor);
        }else{
            sview.backgroundColor = COLOR(normalColor);
        }
    }
    
    if (onselect) {
        onselect(highlighted,forSelectObject);
    }
}
-(BOOL)isFree
{
    return [self superview]==nil;
}
-(float)getContentHeight:(float)width
{
    if (self.contentHeightBingJson&&[self.contentHeightBingJson getFloat:ContentHeightBingJsonKey FailBack:-1]>=0) {
        return [self.contentHeightBingJson getFloat:ContentHeightBingJsonKey FailBack:-1];
    }
    
    float height=0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1) {
        self.bounds = CGRectMake(0.0f, 0.0f, width-(mleft-mRight), CGRectGetHeight(self.bounds));
        [self updateConstraintsIfNeeded];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        if (cView!=nil) {
            height=cView.frame.size.height-(mTop-mBottom);
        }else{
            height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            height+=1;
        }
        
    }else{
        CGRect rect = CGRectMake(0.0f, 0.0f, width, CGRectGetHeight(self.bounds));
        self.bounds = rect;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        //不能使用self直接测量，否者会有其他乱七八糟的view占用高度，无法准确测量。 垃圾IOS. 不用加0.5了
        height = [self.contentView  systemLayoutSizeFittingSize:CGSizeMake(width, 0)
                     withHorizontalFittingPriority: 1000//水平方向约束要求为self.contentSize.width，优先级1000，最高，即必须
                           verticalFittingPriority: 1//垂直方向约束要求为0，优先级1，最低。即不作约束
                  ].height;
    }
    
    if(self.contentHeightBingJson){
        [self.contentHeightBingJson putFloat:ContentHeightBingJsonKey Value:height];
    }
    return height;
}
+(void)clearContentHeightBingJson:(XJson*)json{
    if(json){
        [json removeObjectForKey:ContentHeightBingJsonKey];
    }
}
-(void)setBingJsonHeight:(float)height{
    [self.contentHeightBingJson putFloat:ContentHeightBingJsonKey Value:height];
}
-(void)addToContent:(UIView*)main
{
    [self addToContent:main MLeft:0 MRight:0 MTop:0 MBottom:0];
}

-(void)addToContent:(UIView*)main MLeft:(float)ml MRight:(float)mr MTop:(float)mt MBottom:(float)mb
{
    mleft=ml;
    mRight=mr;
    mTop=mt;
    mBottom=mb;

    cView = main;
    [cView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //添加
    [self.contentView addSubview:main];
    
    //X位置
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:main
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:ml]];
    
    //宽度
    [self.contentView addConstraintLit:[NSLayoutConstraint
                                     constraintWithItem:self.contentView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:main
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                     constant:ml-mr]];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:main
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                     constant:-(ml-mr)]];
    
    //Y位置
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:main
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:mt]];
    
    //高度
    [self.contentView addConstraintLit:[NSLayoutConstraint
                                        constraintWithItem:self.contentView
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:main
                                        attribute:NSLayoutAttributeHeight
                                        multiplier:1
                                        constant:mt-mb]];
    
}
@end
