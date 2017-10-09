//
//  Frame.m
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "Frame.h"
#import "XJson.h"
#import "BaseView.h"

/*
public static class  TextSize{
    public float w;
    public float h;
}
 */
@implementation Frame
@synthesize jsLoader;
@synthesize jsRunner;
@synthesize mainLay;

@synthesize onMainSizeChangeFunction;
@synthesize onNeedLayoutIfFunction;

-(int)getFrameVersio{
    return 1;
}
-(NSString*)getFramePlatform{
    return @"IOS";
}
-(id)createView:(int)type{
    BaseView*bview= [BaseView new];
    [bview setJsLoader:jsLoader];
    [bview setJsRunner:jsRunner ];
    
    if(type==TTextView){
        bview.mainView = [UIView new];
        bview.tv = [UILabel new];
        [(UILabel*)bview.tv setNumberOfLines:0];
        [bview.tv sizeToFit];
        [bview.tv setTranslatesAutoresizingMaskIntoConstraints:NO];
        [bview.mainView addSubview:bview.tv];
        [bview resetTextGravity];
        
    }else if(type==TEditView){
        bview.mainView = [UITextField new];
    }else if(type==TScrollView){
        bview.mainView = [UIScrollView new];
    }else{
        bview.mainView = [UIView new];
    }
    
    
    return bview;
}

//设置主界面
-(void)setMainBaseView:(JSValue*)baseView
                      :(JSValue*)onMainSizeChangeFunction_
                      :(JSValue*)onNeedLayoutIfFunction_
{
    BaseView*bv = [baseView toObject];
    onMainSizeChangeFunction = onMainSizeChangeFunction_;
    onNeedLayoutIfFunction = onNeedLayoutIfFunction_;
    
    [mainLay addSubview:bv.mainView];
    
    
    [self setBaseViewNeedLayout];
}

-(void)callChange{
    [self onCallLayout];
}
//调用刷新
-(void)setBaseViewNeedLayout{
    
    //滑动时无法及时触发
    //[self performSelector:@selector(onCallLayout) withObject:nil afterDelay:0.01];
    //调用太开，频繁调用卡
    //[self performSelectorOnMainThread:@selector(onCallLayout) withObject:nil waitUntilDone:NO];
    //NSTimer
    
    if(self.timer==nil){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onCallLayout) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
   
}
-(void)onCallLayout{
    self.timer = nil;
    if(onNeedLayoutIfFunction){
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onCallLayout) object:nil];
        [jsRunner callFunction:onNeedLayoutIfFunction :@[@(mainLay.frame.size.width),@(mainLay.frame.size.height)]];
    }
}
-(float)getDensity{
    float density = [UIScreen mainScreen].scale;
    return density;
}

-(long long)currentTimeMillis{
    return (long long)([[NSDate new]timeIntervalSince1970]*1000);
}
-(void)postDelayed:(JSValue*)fun
                  :(int)delayed
{
    runOnTreadDelay(^{
        [jsRunner callFunction:fun :@[]];
    }, delayed/1000);
}

-(id) measureTextSize:(NSString*)str
                     :(float)maxWidth
                     :(float)fontSize
                     :(float)lineSpace
                     :(float)charSpace
{
    XJson*size =[XJson new];
    /*
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSKernAttributeName:@(charSpace),NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingTruncatesLastVisibleLine
                                             attributes:attributes
                                                context:nil].size;
    */
    
    
  
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    [attDic setValue:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];      // 字体大小
    [attDic setValue:[UIColor redColor] forKey:NSForegroundColorAttributeName];     // 字体颜色
    [attDic setValue:@(charSpace) forKey:NSKernAttributeName];                                // 字间距
    [attDic setValue:[UIColor cyanColor] forKey:NSBackgroundColorAttributeName];    // 设置字体背景色
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attDic];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;                                            // 设置行之间的间距
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range: NSMakeRange(0, str.length)];
    
    CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:nil].size;
    //测试不准确
    if(strSize.width>0){
        [size putInt:@"w" Value:strSize.width+1];
        [size putInt:@"h" Value:strSize.height+1];
    }else{
        [size putInt:@"w" Value:strSize.width];
        [size putInt:@"h" Value:strSize.height];
    }

    return size;
}
-(void)loadJS:(JSValue*)path{
    if([path isKindOfClass:[NSString class]]){
        [jsLoader addPath:path];
    }else{
        [jsLoader addPath:[path toString]];
    }
}
-(void)setLoadJSFinish:(JSValue*)fun{
    [jsLoader startLoading:^(NSString *path, NSString *js, BOOL isEnd) {
        if(js!=nil){
            [jsRunner loadJs:js :path];
        }
        if(isEnd){
            runOnUiTread2(^{
                [jsRunner callFunction:fun :@[]];
            });
        }
    }];
}
@end
