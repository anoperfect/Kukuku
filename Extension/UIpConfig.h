//
//  UIpConfig.h
//  hacfun
//
//  Created by Ben on 16/3/29.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *colorstring;
@property (nonatomic, strong) UIColor  *color;
@end

@interface FontItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fontstring;
@property (nonatomic, strong) UIFont   *font;
@end


@interface BackgoundImageItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL  enabled;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;

@end


@interface UIColor (Util)

+ (UIColor*)colorFromString:(NSString*)string;
+ (UIColor*)colorWithName:(NSString*)name;

@end


@interface UIFont (Util)

+ (UIFont*)fontFromString:(NSString*)string;
+ (UIFont*)fontWithName:(NSString*)name;


@end




@interface UIpConfig : NSObject


+ (UIpConfig*)sharedUIpConfig;
- (NSMutableArray*)getUIpConfigColors;
- (NSMutableArray*)getUIpConfigFonts;


@end
