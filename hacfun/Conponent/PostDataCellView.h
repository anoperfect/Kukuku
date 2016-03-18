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






@interface PostDataCellView : UIView



- (void)setPostData: (NSDictionary*)data inRow:(NSInteger)row;
- (void)setPostDataInitThreadId:(NSInteger)threadId;
- (void)setFrameObserver:(id)frameObserver;
- (UIView*)getThumbImage;
- (UIView*)getContentLabel;


+ (PostDataCellView*)threadCellViewWithData:(NSDictionary*)dict andInitFrame:(CGRect)frame;


#if 0
typedef void (^blockLayoutPostDataCellView)(PostDataCellView *cell, NSInteger row);
@property (assign,nonatomic)blockLayoutPostDataCellView layout;
#endif








@end
