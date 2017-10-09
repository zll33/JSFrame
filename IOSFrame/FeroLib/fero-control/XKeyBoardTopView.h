//
//  XKeyBoardTopView.h
//  moi
//
//  Created by zhangxiuquan on 16/1/25.
//  Copyright © 2016年 zhangxiuquan. All rights reserved.
//

#import <UIKit/UIKit.h>
void setUseXKeyBoardTopView(BOOL use);
@interface XKeyBoardTopView : UIView
-(instancetype)addToKeyBoardView:(UIView*)view;
@end
@interface UITextField(XKeyBoardTopView)
-(void)hideTopView;

@end
@interface UITextView(XKeyBoardTopView)
-(void)hideTopView;
@end
@interface UISearchBar(XKeyBoardTopView)
-(void)hideTopView;
@end
