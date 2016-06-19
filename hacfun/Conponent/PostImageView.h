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


@property (nonatomic, strong) NSString *linkImageString; //点击后的链接地址.
@property (nonatomic, strong) NSString *downloadString ;



@end
