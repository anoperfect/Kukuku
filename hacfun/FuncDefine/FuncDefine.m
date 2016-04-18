//
//  FuncDefine.m
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "FuncDefine.h"

@implementation FuncDefine

+ (NSTimeInterval)timeIntervalCountWithRecount:(BOOL)recount
{
    static NSDate *kdate0 = nil;
    if(nil == kdate0 || recount) {
        kdate0 = [NSDate date];
        return 0.0;
    }
    
    NSDate *date = [NSDate date];
    return [date timeIntervalSinceDate:kdate0];
}


//if use url. it can not running on main thread.
+(UIColor*)colorFromString:(NSString*)string
{
    if(!string) {
        NSLog(@"#error - invlid color string [%@].", string);
        return [UIColor orangeColor];
    }
    
    if([string characterAtIndex:0] != '#') {
        NSLog(@"#error - invlid color string [%@].", string);
        return [UIColor orangeColor];
    }

    NSInteger colorValue = 0;
    CGFloat alpha = 1.0;
    if(string.length == 7 || (string.length == 10 && '@' == [string characterAtIndex:7])) {
        colorValue = [[string substringWithRange:NSMakeRange(1, 6)] integerValue];
        
        char ch;
        int v;
        int vs[6];
        NSInteger r = 0;
        NSInteger g = 0;
        NSInteger b = 0;
        
#define HEXCHAR_TO_INT(ch, v) \
        if(ch >= '0' && ch <= '9')      { v = ch - '0'; } \
        else if(ch >= 'A' && ch <= 'F') { v = ch - 'A' + 10; } \
        else if(ch >= 'a' && ch <= 'f') { v = ch - 'a' + 10; } \
        else { v = -1; }
        
#define DECCHAR_TO_INT(ch, v) \
        if(ch >= '0' && ch <= '9')      { v = ch - '0'; }   \
        else { v = -1; }
        
        
        for(NSInteger index = 1; index <= 6; index++ ) {
            ch = [string characterAtIndex:index];
            HEXCHAR_TO_INT(ch, v);
            if(-1 == v) {
                NSLog(@"#error - invlid color string [%@].", string);
                return [UIColor orangeColor];
            }

            vs[index-1] = v;
        }
        
        r = (vs[0] << 4) + vs[1];
        g = (vs[2] << 4) + vs[3];
        b = (vs[4] << 4) + vs[5];
        
        if(string.length == 10) {
            for(NSInteger index = 8; index <= 9; index++ ) {
                ch = [string characterAtIndex:index];
                DECCHAR_TO_INT(ch, v);
                if(-1 == v) {
                    NSLog(@"#error - invlid color string [%@].", string);
                    return [UIColor orangeColor];
                }
                
                vs[index-8] = v;
            }
            
            alpha = (CGFloat)(vs[0]*10 + vs[1]) / 100.0;
        }
        
        NSLog(@"%zd %zd %zd %f", r, g, b, alpha);
        return [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:alpha];
    }
    else if([string hasPrefix:@"url"]) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[string substringFromIndex:3]]]];
        if(image) {
            return [UIColor colorWithPatternImage:image];
        }
        else {
            NSLog(@"#error - invlid color string [%@].", string);
            return [UIColor orangeColor];
        }
    }
    else {
        NSLog(@"#error - invlid color string [%@].", string);
        return [UIColor orangeColor];
    }
}


//
+ (UIImage*)thumbOfImage:(UIImage*)image
               fitToSize:(CGSize)size
             isFillBlank:(BOOL)isFillBlank
               fillColor:(UIColor*)fillColor
             borderColor:(UIColor*)borderColor
             borderWidth:(CGFloat)borderWidth
{
    UIImage *bgImage = image;
    
    // 1.创建一个基于位图的上下文(开启一个基于位图的上下文)
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGFloat aspectradioSize = size.width / size.height;
    CGFloat aspectradioImage = image.size.width / image.size.height;
    
    CGRect rectImage;
    if(aspectradioSize >= aspectradioImage) {
        //左右空.
        rectImage.size.height = size.height;
        rectImage.size.width = rectImage.size.height * aspectradioImage;
        rectImage.origin.x = (size.width - rectImage.size.width ) / 2 ;
        rectImage.origin.y = 0;
        LOG_RECT(rectImage, @"drawInRect leftright space");
    }
    else {
        //上下空.
        rectImage.size.width = size.width;
        rectImage.size.height = rectImage.size.width / aspectradioImage;
        rectImage.origin.x = 0;
        rectImage.origin.y = (size.height - rectImage.size.height ) / 2 ;
        LOG_RECT(rectImage, @"drawInRect topbottom space");
    }
    
    // 2.画背景
    [bgImage drawInRect:rectImage];
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [borderColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextRef context5 = UIGraphicsGetCurrentContext(); //设置上下文
    CGContextSetLineWidth(context5, borderWidth);
    CGContextSetRGBStrokeColor(context5, red, green, blue, alpha);
    CGContextStrokeRect(context5, CGRectMake(0, 0, size.width, size.height));//画方形边框, 参数2:方形的坐标。
    
#if 0
    // 3.画右下角的水印
    UIImage *waterImage = [UIImage imageNamed:logo];
    CGFloat scale = 0.2;
    CGFloat margin = 5;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
#endif
    
    // 4.从上下文中取得制作完毕的UIImage对象
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.结束上下文
    UIGraphicsEndImageContext();
    
    return thumbImage;
}


+ (UIImage*)circleImageWithImage:(UIImage*)imageOriginal borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    //    UIImage *oldImage = [UIImage imageNamed:name];
    UIImage *oldImage = imageOriginal;
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end















