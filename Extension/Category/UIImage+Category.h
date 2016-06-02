//
//  UIImage+Category.h
//  hacfun
//
//  Created by Ben on 16/6/2.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface UIImage (Category)




+ (UIImage*)circleImageWithImage:(UIImage*)imageOriginal borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


+ (UIImage*)thumbOfImage:(UIImage*)image
               fitToSize:(CGSize)size
             isFillBlank:(BOOL)isFillBlank
               fillColor:(UIColor*)fillColor
             borderColor:(UIColor*)borderColor
             borderWidth:(CGFloat)borderWidth;

+ (UIImage*) imageScale:(UIImage*)image toSize:(CGSize)size;
+ (UIImage*)createImageWithColor:(UIColor*)color;

@end
