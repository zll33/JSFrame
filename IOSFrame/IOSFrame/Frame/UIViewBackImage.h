//
//  UIViewBackImage.h
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/30.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHeader.h"

@interface UIView(UIViewBackImage)
-(void)setBackImage:(UIImage*)image;

- (void)sd_setImageWithURL:(NSURL *)url;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
