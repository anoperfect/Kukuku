//
//  FuncDefine.h
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import <Foundation/Foundation.h>







@interface FuncDefine : NSObject
+ (id)objectParseFromDict:(NSDictionary*)dict WithXPath:(NSArray*)xpath;
@end




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


