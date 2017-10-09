//
//  BaseView.m
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "BaseView.h"
#import "UIViewBackImage.h"

@interface BaseView()
{
    //文本属性
    float lineSpace;
    float charSpace;
    NSString*text;
    float fontSize;
    int fontColor;
    
    //
    int textGravity;
    //
    int scaleType;
    //
    JSValue*onTextChange;
    JSValue*onClickFun;
    JSValue*onScrollFun;
    //
    UIView*contentView;
    //
    float pLeft;
    float pTop;
    float pRight;
    float pBottom;
}
@end
@implementation BaseView
@synthesize mainView;
@synthesize jsRunner;
@synthesize jsLoader;
@synthesize tv;
-(id)init{
    self = [super init];
    scaleType = -1;
    return self;
}
-(void) setClip:(BOOL) clip{
    [mainView setClipsToBounds:clip];
}
-(void) setRect:(float) x :(float) y :(float) w :(float) h{
    [self setX:x];
    [self setY:x];
    [self setWidth:w];
    [self setHeight:h];
}
-(void) setWidth:(float) w{
    if(w<0){
        w=0;
    }
    [mainView setFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, w, mainView.frame.size.height)];
    if(self.onSetWH){
        self.onSetWH(w,mainView.frame.size.height);
    }
}
-(void) setHeight:(float) h{
    if(h<0){
        h=0;
    }
    [mainView setFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, mainView.frame.size.width, h)];
    if(self.onSetWH){
        self.onSetWH(mainView.frame.size.width,h);
    }
}
-(void) setX:(float) x{
   [mainView setFrame:CGRectMake(x, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
    
}
-(void) setY:(float) y{
    [mainView setFrame:CGRectMake(mainView.frame.origin.x, y, mainView.frame.size.width, mainView.frame.size.height)];
}
-(void) setText:(NSString*) str{
    
    if([tv isKindOfClass:[UILabel class]]){
        text=str;
        [self checkText];
    }else if([mainView isKindOfClass:[UITextField class]]){
        [(UITextField*)mainView setText:str];
    }
}
-(NSString*) getText{
    if([mainView isKindOfClass:[UITextField class]]){
        return ((UITextField*)mainView).text;
    }else if([tv isKindOfClass:[UILabel class]]){
        return text;
    }
    return nil;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    NSMutableString *text = [[self getText] mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    [jsRunner callFunction:onTextChange :@[text]];
    return YES;
}
//文本编辑框
-(void) setOnTextChange:(JSValue*) onchange{
    onTextChange=onchange;
    if([mainView isKindOfClass:[UITextField class]]){
        UITextField*field = mainView;
        [field setDelegate:self];
    }
}
//IOS\DIV没有内边距概念，强制支持TextPadding，正常的pading在XYWH上已经计算完成。 但是内边距不支持clip
-(void) setTextPadding:(float) left :(float) top :(float) right :(float) bottom{
    if([tv isKindOfClass:[UILabel class]]){
        if(pLeft!=left||pTop!=top||pRight!=right||pBottom!=bottom){
            pLeft=left;
            pTop=top;
            pRight=right;
            pBottom=bottom;
            //可以给UILabel增加一个底层UILabel，这个当有边距时，不显示文本
            [self resetTextGravity];
        }
    }
}
-(void)checkText{
    if([tv isKindOfClass:[UILabel class]]){
        UILabel*label = tv;
        [label setTextColor:COLOR(fontColor)];
        [label setFont:[UIFont systemFontOfSize:fontSize]];
        [label setText:text];
        
    }else if([mainView isKindOfClass:[UITextField class]]){
        UITextField*field = mainView;
        [field setTextColor:COLOR(fontColor)];
        [field setFont:[UIFont systemFontOfSize:fontSize]];
        
    }
}
-(void) setLineSpace:(float)value {
    if(lineSpace!=value){
        lineSpace = value;
        [self checkText];
    }
}
-(void)setCharSpace:(float)value {
    if(lineSpace!=value){
        lineSpace = value;
        [self checkText];
    }
}
-(void)setFontSize:(float)value {
    if(fontSize!=value){
        fontSize = value;
        [self checkText];
    }
}
-(void)setFontColor:(int)color {
    if(fontColor !=color){
        fontColor = color;
        [self checkText];
    }
};
-(void) setTextGravity:(int)gravity{
    if(textGravity!=gravity){
        textGravity=gravity;
        [self checkText];
        [self resetTextGravity];
    }
};
-(void)resetTextGravity
{
    if([tv isKindOfClass:[UILabel class]]){
        UILabel*label = tv;
        if ((textGravity&GravityRight)>0){
            [label setTextAlignment:NSTextAlignmentRight];
            [self addOnRight];
        }else if ((textGravity&GravityCenterH)>0){
            [label setTextAlignment:NSTextAlignmentCenter];
            [self addOnCenterH];
        }else{
            [label setTextAlignment:NSTextAlignmentLeft];
            [self addOnLeft];
        }
        //垂直方向需要使用布局
        if ((textGravity&GravityBottom)>0){
            [self addOnBottom];
        }else if ((textGravity&GravityCenterV)>0){
            [self addOnCenterV];
        }else{
            [self addOnTop];
        }
    }
    
}
-(void)addOnLeft{
 
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeLeft];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeRight];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeCenterX];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeWidth];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:pLeft]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:-pRight]];
}
-(void)addOnCenterH{
    
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeLeft];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeRight];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeCenterX];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeWidth];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:pLeft-pRight]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:-(pLeft+pRight)]];
 }
-(void)addOnRight{
    
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeLeft];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeRight];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeCenterX];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeWidth];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:-pRight]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:pLeft]];
}
-(void)addOnTop{
    
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeTop];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeBottom];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeCenterY];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeHeight];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:pTop]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:-pBottom]];
}
-(void)addOnCenterV{
    
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeTop];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeBottom];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeCenterY];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeHeight];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:pTop-pBottom]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:-(pTop+pBottom)]];
}
-(void)addOnBottom{
    
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeTop];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeBottom];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeCenterY];
    [mainView removeConstraintsFirstItem:tv firstAttribute:NSLayoutAttributeHeight];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:-pBottom]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:tv
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:-pTop]];
}
-(void) setBackColor:(int) color{
    [mainView setBackgroundColor:COLOR(color)];
};

-(void) setBackImage:(NSString*)  url{
    //this.div.style.backgroundImage="url("+url+")";
    
    if(![[url lowercaseString] hasPrefix:@"http"]){
        url = [NSString stringWithFormat:@"%@%@",jsLoader.baseUrl,url];
    }
    
  
    [mainView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    /*
    Glide.with(context).load(url).centerCrop().into(new SimpleTarget<GlideDrawable>() {
        @Override
        public void onResourceReady(final GlideDrawable resource, GlideAnimation<? super GlideDrawable> glideAnimation) { 
            final int imageWidth = resource.getIntrinsicWidth();
            final int imageHeight= resource.getIntrinsicHeight();
            if(resource.isAnimated()){
                view.setBackground(resource);
                resource.setLoopCount(-1);
                resource.start();
            }else{
                
                view.setBackground(new SquaringDrawable(resource,0){
                    @Override
                    public int getIntrinsicWidth() {
                        return imageWidth;
                    }
                    @Override
                    public int getIntrinsicHeight() {
                        return imageHeight;
                    }
                    
                    @Override
                    public void setBounds(int left, int top, int right, int bottom) {
                        if(scaleType==ScaleMax){
                            if(imageWidth>0&&imageHeight>0){
                                float w = right - left;
                                float h = bottom - top;
                                //计算最大值
                                float sw =w/imageWidth;
                                float sh =h/imageHeight;
                                
                                if(sw<sh){//宽度比例小，则优先显示宽度。即
                                    float dy = (h - sw*imageHeight )/2;
                                    top+=dy;
                                    bottom-=dy;
                                }else{
                                    float dx = (w - sh*imageWidth)/2;
                                    left+=dx;
                                    right-=dx;
                                }
                            }
                        }else if(scaleType==ScaleCrop){
                            if(imageWidth>0&&imageHeight>0){
                                float w = right - left;
                                float h = bottom - top;
                                //计算最大值
                                float sw =w/imageWidth;
                                float sh =h/imageHeight;
                                if(sw>sh){
                                    float dy = (h - sw*imageHeight )/2;
                                    top+=dy;
                                    bottom-=dy;
                                }else{
                                    float dx = (w - sh*imageWidth)/2;
                                    left+=dx;
                                    right-=dx;
                                }
                            }
                        }else if(scaleType==ScaleFill) {
                            
                        }
                        super.setBounds(left, top, right, bottom);
                        
                    }
                });
            }
        }
    });
     */
    //view.setBackground();
};

-(void) setScaleType:(int) type{
    if(scaleType!=type){
        scaleType = type;
        UIImageView* iv = (UIImageView*)[mainView getXBingDataObject:@"__imageview"];
        
        if(scaleType==ScaleMax){
            mainView.layer.contentsGravity = @"resizeAspect";
            [iv setContentMode:UIViewContentModeScaleAspectFit];
        }else if(scaleType==ScaleCrop){
            mainView.layer.contentsGravity = @"resizeAspectFill";
            [iv setContentMode:UIViewContentModeScaleAspectFill];
        }else{
            mainView.layer.contentsGravity = @"resize";
            [iv setContentMode:UIViewContentModeScaleToFill];
        }
    }
}
-(void) addView:(JSValue*)view :(int)index{
    BaseView*bview = [view toObject];
    if(index<0){
        [mainView addSubview:bview.mainView];
        [bview setRect:0 :0 :0 :0];
    }else{
        [mainView insertSubview:bview.mainView atIndex:index];
        [bview setRect:0 :0 :0 :0];
    }
};
-(void) removeView:(JSValue*) view{
    BaseView*bview = [view toObject];
    bview.onSetWH=nil;
    [bview.mainView removeFromSuperview];
};
-(void)onClick{
    //NSLog(@"onClick");
    [jsRunner callFunction:onClickFun :@[]];
}
-(void) setOnClick:(JSValue*) fun{
    onClickFun = fun;
    [mainView setOnClickTarget:self action:@selector(onClick)];
}
//

-(void) setContentView:(JSValue*) view{
    BaseView*bview = [view toObject];
    if([mainView isKindOfClass:[UIScrollView class]]){
        if(contentView!=nil){
            [contentView removeFromSuperview];
        }
        contentView = bview.mainView;
        UIScrollView*scr = mainView;
        [scr addSubview:contentView];
      
        __weak UIScrollView*tmp =scr;
        [bview setOnSetWH:^(float w, float h) {
            [tmp setContentSize:CGSizeMake(w, h)];
        }];
    }
   
}
//垂直滚动条overflow-y:visible或overflow-y:hidden
-(void) setShowVertical:(BOOL)show
{
    
}

//水平滚动条
-(void) setShowHorizontal:(BOOL)show
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [jsRunner callFunction:onScrollFun :@[@(-scrollView.contentOffset.x),@(-scrollView.contentOffset.y),@(0)]];
}
//设置滚动监听。 向上滚动，滚动的位置为负数，向下滚动滚动的位置为正数
-(void) setOnScroll:(JSValue*) onScroll{
    onScrollFun=onScroll;
    if([mainView isKindOfClass:[UIScrollView class]]){
        UIScrollView*scr = mainView;
        [scr setDelegate:self];
    }
}
//完全隐藏
-(void) setGone{
    [mainView setHidden:YES];
}
//完全可见
-(void) setVisibel{
	[mainView setHidden:NO];
}
-(void) setRotate:(float) rotate :(float) cx :(float)cy{
    //view.setRotation(rotate);
     mainView.transform = CGAffineTransformMakeRotation(rotate *M_PI / 180.0);
}
-(void) setAlpha:(float) alpha{
    mainView.alpha=alpha;
}
-(void) setScale:(float) sx :(float) sy :(float) cx :(float) cy{
    //view.setScaleX(sx);
    //view.setScaleY(sy);
    //mainView.transform = CGAffineTransformScale(transform, 2,0.5);
    mainView.transform = CGAffineTransformMakeScale(sx,sy);//前面的2表示横向放大2倍，后边的0.5表示纵向缩小一半
}

//动画类
-(void) startAnimation{
    
}
-(void) stopAnimation{
    
}
-(void) clearAnimation{
    
}
//动画循环次数
-(void) setAnimationCount{
    
}
//动画结束，保持结束状态
-(void) setAnimationKeep{
    
}
/*
 animation: name duration timing-function delay iteration-count direction;
 name:keyframe的名称，也就是定义了关键帧的动画的名称,这个名称用来区别不同的动画。
 duration:完成动画所需要的时间（2s 或者 2000ms）
 timing-function:完成动画的速度曲线
 delay：动画开始之前的延迟
 iteration-count：动画播放次数
 direction：是否轮流反向播放动画（normal:正常顺序播放，alternate下一次反向播放）如果把动画设置为只播放一次，则该属性没有效果。
 */
-(void) addTranslate:(long long) delayTime :(long long) continueTime :(int) changeType :(float) fromx :(float) tox :(float) fromy :(float) toy{
    
}
-(void) addAlpha:(long long) delayTime :(long long) continueTime :(int) changeType :(float) fromAlpha :(float) toAlpha{
    
}
-(void) addScale:(long long) delayTime :(long long) continueTime :(int) changeType :(float) fromX :(float) toX :(float) fromY :(float) toY :(float) pX :(float) pY{
    
}
-(void) addRotate:(long long) delayTime :(long long) continueTime :(int) changeType  :(float) fromRotate :(float) toRotate :(float) cenerX :(float) cenery{
    
}
@end
