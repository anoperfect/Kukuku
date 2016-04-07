//
//  PostDataViewCell.h
//  hacfun
//
//  Created by Ben on 15/7/15.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PostData.h"
#import "RTLabel.h"
#import "PostImageView.h"
#import "ThreadsViewController.h"
@class ThreadsViewController;


@interface PostDataCellView : UIView

typedef void (^blockRowActionHandle)(NSInteger row, NSString *actionString);

@property (nonatomic, strong) blockRowActionHandle rowAction;

- (UIView*)getThumbImage;
- (UIView*)getContentLabel;





//图片的点击直接设置图片的button target.
//RTLabel中的链接点击直接设置RTLabel的delegate.
//此方式有些许别扭. 同时需暴露出以上两个接口. 统一设置为block或者delegate比较合适.


//PostData需先按照规则转换为PostDataView显示所需要的title, info, content等string数据后才显示.
//这是考虑到不同页面需显示的PostData元素可能不同. 因此在ViewController中先进行这种转化.
+ (PostDataCellView*)threadCellViewWithData:(NSDictionary*)dict andInitFrame:(CGRect)frame;


//+ (PostDataCellView*)PostDatalViewWithTid:(NSInteger)tid andInitFrame:(CGRect)frame;
+ (PostDataCellView*)PostDatalViewWithTid:(NSInteger)tid
                             andInitFrame:(CGRect)frame
                         completionHandle:(void (^)(PostDataCellView* postDataView, NSError* connectionError))handle;



+ (NSInteger)countObject;



@end
