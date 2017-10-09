//
//  GridLayout.h
//  zhaoyinqianhai
//
//  Created by 吴金帆 on 2017/6/16.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "ViewFactory.h"

@interface GridLayout : LinearLayout
//模块间隔,水平方向
@property (nonatomic,assign) CGFloat modeHSpace;
//模块间隔，垂直方向
@property (nonatomic,assign) CGFloat modeVSpace;
//行数
@property (nonatomic,assign) NSInteger rowNumber;
//水平间隔均分。 当row个数确认，水平间隔是否均分。
@property (nonatomic,assign) BOOL hSpaceFill;
@property (nonatomic,copy) void(^onbuild)(LinearLayoutCell*cell,int index);
-(void)addModeView:(LinearLayoutCell*)modeView;
-(void)removeModeView:(LinearLayoutCell*)modeView;
-(void)clearModeView;


@end

@interface LCGridLayout : LinearLayoutCell
//模块间隔,水平方向
@property (nonatomic,assign) CGFloat modeHSpace;
//模块间隔，垂直方向
@property (nonatomic,assign) CGFloat modeVSpace;
//行数
@property (nonatomic,assign) NSInteger rowNumber;
//水平间隔均分。 当row个数确认，水平间隔是否均分。
@property (nonatomic,assign) BOOL hSpaceFill;
@property (nonatomic,copy) void(^onbuild)(LinearLayoutCell*cell,int index);

-(void)addModeView:(LinearLayoutCell*)modeView;
-(void)removeModeView:(LinearLayoutCell*)modeView;
-(void)clearModeView;


@end
