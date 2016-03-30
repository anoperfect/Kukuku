//
//  FuncDefine.h
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameLayout.h"
@interface FuncDefine : NSObject
+ (NSTimeInterval)timeIntervalCountWithRecount:(BOOL)recount;
+ (NSString*)stringFromCGRect:(CGRect)rect;
+ (NSString*)stringFromViewFrame:(UIView*)view;
+ (NSString*)stringFromMSecondInterval:(long long) msecs andTimeZoneAdjustSecondInterval:(NSInteger)adjustSeconds;
+ (NSString *)URLEncodedString:(NSString*)urlString;
+ (NSString*)URLDecodedString:(NSString*)urlStringEncoded;
@end











//    CGRect frame = [[UIScreen mainScreen] bounds];


#define CGRECT_BLOW(frame, borderv, heightv) CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + borderv, frame.size.width, heightv)


#define LOG_RECT(rect, name)        NSLog(@"[%@] - %@", [FuncDefine stringFromCGRect:rect], name);
#define LOG_VIEW_RECT(view, name)   NSLog(@"[%@] - %@", [FuncDefine stringFromViewFrame:view], name);





#define LOG_VIEW_REC0(v, name) {}
#define LOG_REC0(v, name) {}
#define NS0Log(x...) {}


#define FRAME_ADD_HEIGHT(view, addHeight) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , frame.size.height + addHeight)]; }

#define FRAME_SET_HEIGHT(view, setHeight) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , setHeight)]; }





#define FRAME_BELOW_TO(view, viewBelowTo, border) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, viewBelowTo.frame.origin.y + viewBelowTo.frame.size.height + border, frame.size.width, frame.size.height)]; }


#define LAYOUT_BORDER_ORANGE(view) { [view.layer setBorderWidth:1]; [view.layer setBorderColor:[UIColor orangeColor].CGColor]; }

#define LAYOUT_BORDER_BLUE(view) { [view.layer setBorderWidth:1]; [view.layer setBorderColor:[UIColor blueColor].CGColor]; }






#define LOG_THREAD {NSLog(@"main thread : %@", [NSThread mainThread]); NSLog(@"curr thread : %@", [NSThread currentThread]);}







//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define RetainCount(objectxxx) (CFGetRetainCount((__bridge CFTypeRef)objectxxx));


#define NSLog(FORMAT, ...) {\
    NSMutableString *str = [[NSMutableString alloc] init];\
    [str appendFormat:@"%60s %6d %3.6f: ", __FUNCTION__, __LINE__, [FuncDefine timeIntervalCountWithRecount:false] ];\
    [str appendFormat:FORMAT, ##__VA_ARGS__];\
    printf("%s\n", [str UTF8String]);\
}





#define LOG_POSTION NSLog(@"postion.");

#define LOG_POSTION0 

//CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
//LOG_RECT(applicationFrame, @"applicationFrame")

//CGRect bounds = [[UIScreen mainScreen] bounds];
//LOG_RECT(bounds, @"bounds")

//判断竖屏横屏.
#define VERTIVAL_SCREEN ([[UIScreen mainScreen] bounds].size.height >= [[UIScreen mainScreen] bounds].size.width)


#define TAGVIEW(tag)                [self.view viewWithTag:tag]
#define TAGVIEW2(tag1, tag2)        [[self.view viewWithTag:tag1] viewWithTag]
#define TAGVIEW3(tag1, tag2, tag3)  [[[self.view viewWithTag:tag1] viewWithTag:tag2] viewWithTag:tag3]



