//
//  GridLayout.m
//  zhaoyinqianhai
//
//  Created by 吴金帆 on 2017/6/16.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "GridLayout.h"
@implementation LCGridLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setView:[GridLayout new]];
    }
    return self;
}

//模块间隔,水平方向


-(CGFloat)modeHSpace{
    return [(GridLayout*)self.getView modeHSpace];
}
-(void)setModeHSpace:(CGFloat)modeHSpace{
    ((GridLayout*)self.getView).modeHSpace=modeHSpace;

}

-(CGFloat)modeVSpace{
    return [(GridLayout*)self.getView modeVSpace];
}
-(void)setModeVSpace:(CGFloat)modeVSpace{
    ((GridLayout*)self.getView).modeVSpace=modeVSpace;
    
}

//行数


-(NSInteger)rowNumber{
    return [(GridLayout*)self.getView rowNumber];
}
-(void)setRowNumber:(NSInteger)rowNumber{
    ((GridLayout*)self.getView).rowNumber=rowNumber;
    
}


//水平间隔均分。 当row个数确认，水平间隔是否均分。

-(BOOL)hSpaceFill{
    return [(GridLayout*)self.getView hSpaceFill];
}
-(void)setHSpaceFill:(BOOL)hSpaceFill{
    ((GridLayout*)self.getView).hSpaceFill=hSpaceFill;
    
}

-(void)setOnbuild:(void (^)(LinearLayoutCell *view, int index))onbuild2{
    ((GridLayout*)self.getView).onbuild=onbuild2;
   
}
-(void)addModeView:(LinearLayoutCell*)modeView{

  [((GridLayout*)self.getView)  addModeView:modeView];

}
-(void)removeModeView:(LinearLayoutCell*)modeView{
  [((GridLayout*)self.getView) removeModeView:modeView];

}
-(void)clearModeView{

  [((GridLayout*)self.getView) clearModeView];
}


@end


@interface GridLayout()
{
    XJsonArray *list;
    BOOL needBuild;
    int lastWide;
}
@end

@implementation GridLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        list=@[].mutableCopy;
    }
    return self;
}
-(void)setModeHSpace:(CGFloat)modeHSpace{
    _modeHSpace=modeHSpace;
   
    [self callreBulid];

}
-(void)setModeVSpace:(CGFloat)modeVSpace{
    _modeVSpace=modeVSpace;
    
    [self callreBulid];
}

-(void)addModeView:(LinearLayoutCell*)view{
    if (view!= nil) {
        
        [list addObject:view];
    }
   
    [self callreBulid];
    
}
-(void)removeModeView:(LinearLayoutCell*)view{

    for (LinearLayoutCell*mode in list) {
        if (mode == view) {
            if (mode.parent != nil) {
                [mode.parent removeViewCell:mode];
                [list removeObject:mode];
                break;
            }
        }
    }
    [self callreBulid];
}

-(void)clearModeView{
     [list removeAllObjects];
     [self removeAllView];
     [self callreBulid];
}

-(void)callreBulid{
     needBuild = true;
    [self setNeedsUpdateConstraints];
    [self needsUpdateConstraints];
}

//
-(void)layoutSubviews
{    [super layoutSubviews];
    if (needBuild||lastWide!=self.frame.size.width) {
        needBuild = false;
        lastWide=self.frame.size.width;
        [self rebuild];
        [self setNeedsLayout];
    }
   
}
//- (void)updateConstraints NS_AVAILABLE_IOS(6_0)
//{
//    if (needBuild) {
//        needBuild = false;
//        [self rebuild];
//    }
//    [super updateConstraints];
//}


-(void)rebuild{
    [self removeAllView];
    //row 固定，则每行直接添加row个view
    if (_rowNumber > 0) {
        
        for (int i = 0; i <list.count; ) {
            //添加一行
            LCLinearLayout* lay = [LCLinearLayout newHorizontal];
            [lay setWidth:MatchPatrent];
            [lay setHeight:WrapContent];
            if ( ceil((double)(i+1) /(double) _rowNumber) < ceil((double)list.count / (double)_rowNumber)) {
                [lay setMBottom: _modeVSpace];
            }
            [self addView:lay];
            
            for (int j = 0; j < _rowNumber; j++, i++) {
                if (i < list.count) {
                    LinearLayoutCell* node = list[i];
                    if (node.parent != nil) {
                        [node.parent removeViewCell:node];
                    }
                   
                    [lay  addView:node];
                    
                    //如果间隔自动填充
                    if (_hSpaceFill) {
                        if (j % _rowNumber != _rowNumber - 1 && i != list.count - 1) {
                            LinearLayoutCell *view = [LinearLayoutCell newWithView:[UIView new]];
                            [view setUse:YES Weight:1];
                            [lay addView:view];
                        }
                    } else if (_modeHSpace > 0) {
                        
                        [node setMLeft:0];
                        
                        if (j % _rowNumber != _rowNumber - 1 && i != list.count - 1) {
                            [node setMRight:_modeHSpace];
                        }
                 
                    }
                    if ( _onbuild!= nil) {
                        _onbuild(node,i);
                  
                    }
                }
            }
        }
        
        
    }
    //row 不固定，自动计算每行需要几个view
    else {
        CGFloat maxWidth = self.frame.size.width;
        
        LCLinearLayout* lay = [LCLinearLayout newHorizontal];
        [lay setWidth:MatchPatrent];
        [lay setHeight:WrapContent];
        [lay setMBottom:_modeVSpace];
        [self addView:lay];
        
        CGFloat leftWidth = maxWidth;
        
        LinearLayoutCell * lastWeiView = nil;
        
        for (LinearLayoutCell *node  in list) {
            if (node.parent != nil) {
                [node.parent removeViewCell:node];
            }
            CGFloat mw = [self mesureModeWidth:node];
            //如果上一个剩余宽度不够添加，则新建一个行lay
            if (leftWidth < maxWidth && leftWidth < mw) {
                if (lastWeiView != nil) {
                    [lay.getLinearLayout removeViewCell:lastWeiView];
                }
                [[[lay getLinearLayout] getView:[lay getLinearLayout].getCount-1] setMRight:0];
                lay = [LCLinearLayout newHorizontal];
                [lay setWidth:MatchPatrent];
                [lay setHeight:WrapContent];
                [lay setMBottom:_modeVSpace];
                [self addView:lay];
                leftWidth = maxWidth;
            }

            [lay addView:node];
            leftWidth -= mw;
            
            //如果间隔自动填充
            if (_hSpaceFill) {
                LinearLayoutCell *view =lastWeiView = [LinearLayoutCell newWithView:[UIView new]];
                [view setUse:YES Weight:1];
               
                [lay addView:view];

            } else if (_modeHSpace > 0) {
 
                
               
                 [node setMLeft:0];
                [node setMRight:_modeHSpace];
               
             
                leftWidth -= _modeHSpace;
            }
            if (_onbuild!= nil) {
                _onbuild(node,[node.parent getCount]-1);
               
            }
        }
        if (lastWeiView != nil) {
            [lay.getLinearLayout removeViewCell:lastWeiView];
        }
        [lay setMBottom:0];
        [[[lay getLinearLayout] getView:[lay getLinearLayout].getCount-1] setMRight:0];
        
  
    }
    if (self.getCount>0) {
        LinearLayoutCell *tianchong=[LinearLayoutCell newWithView:[UIView new]];
        [tianchong setUse:YES Weight:1];
        [self addView:tianchong];
    }
    
}

-(CGFloat)mesureModeWidth:(LinearLayoutCell*)view {
    CGFloat width = [view.getView systemLayoutSizeFittingSize:CGSizeMake(0, 0) withHorizontalFittingPriority:1 verticalFittingPriority:1].width;

    return width;
}




@end
