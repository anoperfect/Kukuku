//
//  PostGroupView.h
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelAndViewInc.h"
@class PostView;
@class PostGroupView;
@protocol PostGroupViewDelegate <NSObject>

@optional
- (void)PostGroupView:(PostGroupView*)postGroupView didSelectOnRow:(NSIndexPath*)indexPath;
- (NSArray<NSString *> *)PostGroupView:(PostGroupView*)postGroupView actionStringsOnRow:(NSIndexPath*)indexPath;
- (void)PostGroupView:(PostGroupView*)postGroupView didActionOnRow:(NSIndexPath*)indexPath withAction:(NSString*)actionString;
- (ThreadDataToViewType)PostGroupView:(PostGroupView*)postGroupView postDataToViewTypeOnRow:(NSIndexPath*)indexPath;
- (void)PostGroupView:(PostGroupView*)postGroupView retreatPostViewDataOnRow:(NSIndexPath*)indexPath presendRetreat:(NSMutableDictionary*)postViewData;
- (void)PostGroupView:(PostGroupView*)postGroupView didClickThumbOnIndexPath:(NSIndexPath*)indexPath thumb:(UIImage*)imageThumb withLink:(NSString*)imageString;
- (void)PostGroupView:(PostGroupView*)postGroupView didClickLinkOnIndexPath:(NSIndexPath*)indexPath link:(NSString*)linkUrlString;


- (void)PostGroupView:(PostGroupView*)postGroupView layoutUITableView:(UITableView*)tableview;

- (void)PostGroupView:(PostGroupView*)postGroupView willDisplayPostView:(PostView*)postView OnRow:(NSIndexPath*)indexPath;
- (void)PostGroupView:(PostGroupView*)postGroupView endDisplayPostView:(PostView*)postView OnRow:(NSIndexPath*)indexPath;



@end



@interface PostGroupView : UIView

@property (nonatomic, assign) UIEdgeInsets edgeViewGroup; //UITableView与UIView的间隔.
@property (nonatomic, assign) UIEdgeInsets edgeView; //PostView与CellView的间隔.



@property (nonatomic, assign) id<PostGroupViewDelegate> delegate;
@property (nonatomic, assign) ThreadDataToViewType type;


- (void)showfooterViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate;
- (void)showHeaderViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate;


- (void)appendDataOnPage:(NSInteger)page with:(NSArray<PostData*>*)postDatas removeDuplicate:(BOOL)remove andReload:(BOOL)reload;
- (void)clearAllDataAndReload:(BOOL)reload;
- (void)reloadPostGroupView;
- (CGFloat)optumizeHeight;





@end

#define TAG_PostView    (4500000 + 1)





#import "CustomViewController.h"
@interface DetailViewControllerTest : CustomViewController

- (void)setPostTid:(NSInteger)tid withData:(PostData*)postDataTopic;

@end
