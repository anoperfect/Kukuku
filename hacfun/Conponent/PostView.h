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
@property (nonatomic, strong, readonly) PostData *data;


//PostData需先按照规则转换为PostView显示所需要的title, info, content等string数据后才显示.
//这是考虑到不同页面需显示的PostData元素可能不同. 因此在ViewController中先进行这种转化.
+ (PostView*)PostViewWith:(PostData*)postData andFrame:(CGRect)frame;


- (void)setPostData:(PostData *)postData;


////在非主线程中执行.
+ (PostView*)PostDatalViewWithTid:(NSInteger)tid
                         andFrame:(CGRect)frame
                          useType:(ThreadDataToViewType)type
                 completionHandle:(void (^)(PostView* postView, NSError* connectionError))handle;



+ (NSInteger)countObject;


- (NSString*)desc;


+ (NSString*) contentLabelContentRetreat:(NSString*)content;


+ (id)postDataContentTreat:(PostData*)postData; //原始的content转为显示htm内容的控制的可使用数据.
+ (void)postDataContentAsyncTreat:(PostData*)postData; //通常在解析后即调用异步处置. 可能因为时序的原因未能完成异步处置的, 则直接在主线程同步获取之.


@end












