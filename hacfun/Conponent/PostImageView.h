//
//  PostImageView.h
//  hacfun
//
//  Created by Ben on 15/7/29.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushButton.h"
@interface PostImageView : PushButton




- (UIImage*)getDisplayingImage;
- (void)setDownloadUrlString:(NSString*)downloadString;

@property (nonatomic, strong) NSString *linkImageString;

//- (void)setDidSelectedResponseTarget : (id) target selector:(SEL)selector;


@end
