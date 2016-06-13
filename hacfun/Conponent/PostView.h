//
//  PostView.h
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ModelAndViewInc.h"

@class PostView;
@protocol PostViewDelegate <NSObject>



- (void)PostView:(PostView*)postView actionString:(NSString*)string;
- (void)PostView:(PostView*)postView didSelectLinkWithURL:(NSURL*)url;
- (void)PostView:(PostView*)postView didSelectThumb:(UIImage*)imageThumb withImageLink:(NSString*)imageString;
@end








@interface PostView : UIView
@property (nonatomic, assign) id<PostViewDelegate> delegate;
@property (nonatomic, assign) NSIndexPath *indexPath;


//PostData需先按照规则转换为PostView显示所需要的title, info, content等string数据后才显示.
//这是考虑到不同页面需显示的PostData元素可能不同. 因此在ViewController中先进行这种转化.
+ (PostView*)PostViewWith:(PostData*)postData andFrame:(CGRect)frame;


////在非主线程中执行.
+ (PostView*)PostDatalViewWithTid:(NSInteger)tid
                         andFrame:(CGRect)frame
                          useType:(ThreadDataToViewType)type
                 completionHandle:(void (^)(PostView* postView, NSError* connectionError))handle;



+ (NSInteger)countObject;


@end












