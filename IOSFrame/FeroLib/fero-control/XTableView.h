//
//  XTableView.h
//  p2p
//
//  Created by kzd on 14-11-19.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//
@class XTableView;
@class LFLabel;
#import <UIKit/UIKit.h>
#import "XTableViewCell.h"

#define XTBEmptyLabelTag 9799
#define XTBEmptyButtonTag 9798
#define XTBEmptyImageTag 9797

@protocol XTableViewDataLoad<NSObject>
- (void) onRefresh;
- (void) onLoadMore;

@optional
- (void) tableView:(XTableView *)z didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
@end


@interface XTableView : UITableView

@property (nonatomic, weak)  id <XTableViewDataLoad>  dataLoad;

- (void)onComplete;
- (void)onCompleteNoAnimation;
- (void)needLoadMore:(Boolean)isNeed;
- (void)needTopRefresh:(Boolean)isNeed;
- (void)callRefresh;
-(BOOL)isOnLoading;

-(void)showEmptyContentView;
-(void)hideEmptyContentView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *自动设置contentView的约束
 *
 */
- (UIView*)setEmptyViewNibNamed:(NSString*)nibName;
- (UIView*)setEmptyViewNibNamed:(NSString*)nibName Index:(int)index;
@property (nonatomic, assign)  UIView* emptyView;
-(void)setEmptyView:(UIView *)view MLeft:(float)ml MTop:(float)ml MRight:(float)mr MBottom:(float)mb;
-(void)showEmptyView;
-(void)hideEmptyView;
-(void)setEmptyMsg:(NSString*)msg;
-(void)setEmptyPic:(NSString*)path;
-(LFLabel*)getEmptyLabel;
-(void)showEmptyButtonTitle:(NSString*)title Target:(id)target Sel:(SEL)action;
-(void)hideEmptyButton;

-(XTableViewCell*)getFreeCell:(NSString*)identifier;
-(void)addCell:(XTableViewCell*)cell Identifier:(NSString*)identifier;


-(XTableViewCell*)getFreeCell;
-(void)addCell:(XTableViewCell*)cell;
@end


void setXTableViewDefaultEV(UIView* (^getEv)(XTableView*tabelview));
UIView*getXTableViewDefaultEV();
