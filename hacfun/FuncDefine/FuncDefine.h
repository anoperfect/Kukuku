//
//  FuncDefine.h
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FrameLayout.h"
#import "NSLogn.h"
#import "UIpConfig.h"
#import "PostData.h"










@interface FuncDefine : NSObject
+ (NSTimeInterval)timeIntervalCountWithRecount:(BOOL)recount;







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



//host
@interface Host : NSObject

@property (nonatomic, assign) NSInteger     id;
@property (nonatomic, copy  ) NSString     *hostname;
@property (nonatomic, copy  ) NSString     *host;
@property (nonatomic, copy  ) NSString     *imageHost;
@property (nonatomic, copy  ) NSString     *urlString;
@property (nonatomic, assign) NSInteger     status;

@property (nonatomic, assign) NSInteger     numberInCategoryPage;
@property (nonatomic, assign) NSInteger     numberInDetailPage;
@end


//hostindex NSInteger

//emoticon
@interface Emoticon : NSObject

@property (nonatomic, copy  ) NSString     *emoticon;
@property (nonatomic, assign) NSInteger     selectedtimes;

@end

//draft. NSString




@interface SettingKV : NSObject

@property (nonatomic, copy  ) NSString     *key;
@property (nonatomic, copy  ) NSString     *value;

@end



@interface Category : NSObject

@property (nonatomic, assign) NSInteger     id;
@property (nonatomic, copy  ) NSString     *name;
@property (nonatomic, copy  ) NSString     *link;
@property (nonatomic, assign) NSInteger     forum;
@property (nonatomic, assign) NSInteger     click;

@end


@interface DetailHistory : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     createdAtForDisplay;
@property (nonatomic, assign) long long     createdAtForLoaded;

@end



//record . PostData.

//collection.
@interface Collection : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     collectedAt;

@end


@interface Post : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     postedAt;

@end


@interface Reply : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     repliedAt;

@end







//    CGRect frame = [[UIScreen mainScreen] bounds];










#define LAYOUT_VIEW_BORDER(view, uicolor, width) { [view.layer setBorderWidth:width]; [view.layer setBorderColor:(uicolor).CGColor]; }




//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]












#define TAGVIEW(tag)                [self.view viewWithTag:tag]
#define TAGVIEW2(tag1, tag2)        [[self.view viewWithTag:tag1] viewWithTag]
#define TAGVIEW3(tag1, tag2, tag3)  [[[self.view viewWithTag:tag1] viewWithTag:tag2] viewWithTag:tag3]




#define DISPATCH_ONCE_START     do {static dispatch_once_t once; dispatch_once(&once, ^{
#define DISPATCH_ONCE_FINISH    }); }while(0);


