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





+ (UIImage*) imageScale:(UIImage*)image toSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}





+ (UIImage*)createImageWithColor:(UIColor*)color
{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    //    [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

@end


@implementation Host
@end


@implementation Emoticon
@end





@implementation SettingKV
@end



@implementation Category
@end


@implementation DetailHistory

- (NSString*)description
{
    return [NSString stringWithFormat:@"tid : %zd . LastLoaded : %lld, %@ . LastDisplayed : %lld, %@",
            self.tid,
            self.createdAtForLoaded,
            self.createdAtForLoaded  ==0?@"0":[NSString stringFromMSecondInterval:self.createdAtForLoaded  andTimeZoneAdjustSecondInterval:0],
            self.createdAtForDisplay,
            self.createdAtForDisplay ==0?@"0":[NSString stringFromMSecondInterval:self.createdAtForDisplay andTimeZoneAdjustSecondInterval:0]
    ];
}

@end


@implementation Collection
@end


@implementation Post
@end


@implementation Reply
@end




#if 0


//NSData -> NSString.
NSString *str = [[NSString alloc] initWithData:data];


//NSString -> NSData.
NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];









#endif