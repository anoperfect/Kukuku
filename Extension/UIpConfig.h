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
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL      enableCustmize;
@property (nonatomic, strong) NSString *colorstring;
@property (nonatomic, strong) UIColor  *color;
@property (nonatomic, strong) NSString *colornightstring;
@property (nonatomic, strong) UIColor  *colornight;
@end


@interface FontItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL      enableCustmize;
@property (nonatomic, strong) NSString *fontstring;
@property (nonatomic, strong) UIFont   *font;
@end


@interface BackgroundViewItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL      enableCustmize;
@property (nonatomic, assign) BOOL      onUse;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSData   *imageData;
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
- (BOOL)updateUIpConfigColor:(ColorItem*)color;



- (NSMutableArray*)getUIpConfigFonts;
- (BOOL)updateUIpConfigFont:(FontItem*)font;



- (NSMutableArray*)getUIpConfigBackgroundViews;
- (BOOL)updateUIpConfigBackgroundView:(BackgroundViewItem *)backgroundview;


@property (nonatomic, assign) BOOL nightmode;


@end
