//
//  XScrollViewForCircle.h
//  p2p
//
//  Created by zhangxiuquan on 14/12/31.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol XScrollViewForCircleCell
-(UIView*) getView;
@end

@protocol XScrollViewForCircleDataSource
-(int)getCount;
-(id<XScrollViewForCircleCell>)getCell:(id<XScrollViewForCircleCell>)cell Index:(int)index;
@end

@interface XScrollViewForCircle : UIView
@property (nonatomic)   id <XScrollViewForCircleDataSource> dataSource;
-(void) reLoad;
@end
