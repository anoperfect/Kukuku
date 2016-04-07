//
//  ImageViewController.h
//  hacfun
//
//  Created by Ben on 15/8/2.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface ImageViewController : CustomViewController




//直接显示图片.
- (void)setDisplayedImage:(UIImage*)image;

//显示网络下载地址的图片. placeholderImage可设置为下载完成之前的暂时图片.
- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)image ;


@end
