//
//  UIpConfig.m
//  hacfun
//
//  Created by Ben on 16/3/29.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "UIpConfig.h"
#import "AppConfig.h"




@implementation ColorItem
@end



@implementation FontItem
@end


@implementation BackgroundViewItem

- (NSString*)description
{
    NSString *descriptionString = nil;
    
    UIImage *image = self.imageData?[UIImage imageWithData:self.imageData]:nil;
    
    descriptionString = [NSString stringWithFormat:@"%@ : %@ enableCustmize-%zd   onUse-%d  imageName-%@  imageData-%@", self.name, self.title, self.enableCustmize, self.onUse, self.imageName, image];
    
    return descriptionString;
}

@end


@interface UIpConfig ()

@property (nonatomic, strong) NSMutableArray *colorItems;
@property (nonatomic, strong) NSMutableArray *fontItems;
@property (nonatomic, strong) NSMutableArray *backgroundviewItems;


@end





@implementation UIpConfig





- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colorItems = [[NSMutableArray alloc] init];
        self.fontItems = [[NSMutableArray alloc] init];
        
        
        [self loadItems];
    }
    return self;
}


- (void)loadItems
{
    NSArray *colors = [[AppConfig sharedConfigDB] configDBColorGet];
    for(ColorItem *item in colors) {
        item.color = [UIColor colorFromString:item.colorstring];
        if(!item.color) {
            NSLog(@"#error - color null from [%@]", item.colorstring);
            item.color = [UIColor orangeColor];
        }
        
        item.colornight = [UIColor colorFromString:item.colornightstring];
        if(!item.colornight) {
            NSLog(@"#error - color null from [%@]", item.colorstring);
            item.color = [UIColor blueColor];
        }
    }
    
    self.colorItems = [NSMutableArray arrayWithArray:colors];
    
    NSArray *fonts = [[AppConfig sharedConfigDB] configDBFontGet];
    for(FontItem *item in fonts) {
        item.font = [UIFont fontFromString:item.fontstring];
        if(!item.font) {
            NSLog(@"#error - font null from [%@]", item.fontstring);
            item.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        }
    }
    
    self.fontItems = [NSMutableArray arrayWithArray:fonts];
    
    self.colorItems = [NSMutableArray arrayWithArray:colors];
    
    NSArray *backgroundviews = [[AppConfig sharedConfigDB] configDBBackgroundViewGet];
    self.backgroundviewItems = [NSMutableArray arrayWithArray:backgroundviews];
}


+ (UIpConfig*)sharedUIpConfig
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (NSMutableArray*)getUIpConfigColors
{
    return self.colorItems;
}


- (BOOL)updateUIpConfigColor:(ColorItem*)color
{
    //根据colorstring更新color.
    color.color = [UIColor colorFromString:color.colorstring];
    if(!color.color) {
        NSLog(@"#error - color null from [%@]", color.colorstring);
        color.color = [UIColor orangeColor];
    }
    
    if(!color.colornight) {
        NSLog(@"#error - color null from [%@]", color.colorstring);
        color.colornight = [UIColor blueColor];
    }
    
    BOOL result = [[AppConfig sharedConfigDB] configDBColorUpdate:color];
    if(result) {
        for(NSInteger index = 0; index < self.colorItems.count; index ++) {
            ColorItem* colorUpdate = self.colorItems[index];
            if([color.name isEqualToString:colorUpdate.name]) {
                [self.colorItems replaceObjectAtIndex:index withObject:color];
            }
        }
    }
    else {
        NSLog(@"#error - ");
    }
    
    return result;
}





- (NSMutableArray*)getUIpConfigFonts
{
    return self.fontItems;
}


- (BOOL)updateUIpConfigFont:(FontItem*)font
{
    //根据fontstring更新font.
    font.font = [UIFont fontFromString:font.fontstring];
    if(!font.font) {
        NSLog(@"#error - font null from [%@]", font.fontstring);
        font.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    
    BOOL result = [[AppConfig sharedConfigDB] configDBFontUpdate:font];
    if(result) {
        for(NSInteger index = 0; index < self.fontItems.count; index ++) {
            FontItem* fontUpdate = self.fontItems[index];
            if([font.name isEqualToString:fontUpdate.name]) {
                [self.fontItems replaceObjectAtIndex:index withObject:font];
            }
        }
    }
    else {
        NSLog(@"#error - ");
    }
    
    return result;
}



- (NSMutableArray*)getUIpConfigBackgroundViews
{
    return self.backgroundviewItems;
}


- (BOOL)updateUIpConfigBackgroundView:(BackgroundViewItem *)backgroundview
{
    //根据标记值更新imageData.
    //imageData直接存数据库. 不用更新.
    
    BOOL result = [[AppConfig sharedConfigDB] configDBBackgroundViewUpdate:backgroundview];
    if(result) {
        for(NSInteger index = 0; index < self.backgroundviewItems.count; index ++) {
            BackgroundViewItem* backgroundviewUpdate = self.backgroundviewItems[index];
            if([backgroundview.name isEqualToString:backgroundviewUpdate.name]) {
                [self.backgroundviewItems replaceObjectAtIndex:index withObject:backgroundview];
            }
        }
    }
    else {
        NSLog(@"#error - ");
    }
    
    return result;
}





@end



@implementation UIColor (Util)

//if use url. it can not running on main thread.
+(UIColor*)colorFromString:(NSString*)string
{
    LOG_POSTION
    if(!string || string.length == 0) {
        NSLog(@"#error - invlid color string [%@].", string);
        return [UIColor orangeColor];
    }
    
    NSDictionary *ksystemColors = @{
                                   @"red"       :[UIColor redColor],
                                   @"purple"    :[UIColor purpleColor],
                                   @"black"     :[UIColor blackColor],
                                   @"white"     :[UIColor whiteColor],
                                   @"orange"    :[UIColor orangeColor],
                                   @"blue"      :[UIColor blueColor],
                                   @"cyan"      :[UIColor cyanColor],
                                   @"lightGray" :[UIColor lightGrayColor],
                                   @"clear"     :[UIColor clearColor],
                                   
                                   };
    
    UIColor *systemColor = [ksystemColors objectForKey:string];
    if(nil != systemColor) {
        NS0Log(@"system color : %@", systemColor);
        return systemColor;
    }
    
    if([string hasPrefix:@">>"]) {
        return [self colorWithName:[string substringFromIndex:@">>".length]];
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
        
        NS0Log(@"%zd %zd %zd %f", r, g, b, alpha);
        return [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:alpha];
    }
    else if([string hasPrefix:@"url"]) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[string substringFromIndex:3]]]];
        if(image) {
            NSLog(@"colorWithPatternImage");
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


+ (UIColor*)colorWithName:(NSString*)name
{
    NSArray *a = [[UIpConfig sharedUIpConfig] getUIpConfigColors];
    for(ColorItem *item in a) {
        if([item.name isEqualToString:name]) {
            if(![UIpConfig sharedUIpConfig].nightmode) {
                NS0Log(@"colorWithName : %@ (%@) => %@", name, item.colorstring, item.color);
                return item.color;
            }
            else {
                NS0Log(@"colorWithName : %@ (%@) => %@", name, item.colornightstring, item.colornight);
                return item.colornight;
            }
        }
    }

    NSLog(@"#error - colorWithName [%@] not found.", name);
    return ![UIpConfig sharedUIpConfig].nightmode?[UIColor orangeColor]:[UIColor blueColor];
}



@end




@implementation UIFont (Util)



+ (UIFont*)fontFromString:(NSString*)string
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    if([string hasPrefix:@"wp"]) {
        CGRect frameMain = [[UIScreen mainScreen] bounds];
        CGFloat width = MIN(frameMain.size.width, frameMain.size.height);
        CGFloat size = [[string substringFromIndex:2] floatValue] * width;
        font = [UIFont systemFontOfSize:size];
    }
    else if([string hasPrefix:@"pt"]) {
        CGFloat size = [[string substringFromIndex:2] floatValue];
        font = [UIFont systemFontOfSize:size];
    }
    else if([string hasPrefix:@"small"]) {
        font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    else if([string hasPrefix:@"system"]) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    else {
        NSLog(@"#error - invlid font string [%@].", string);
    }
    
    return font;
}


+ (UIFont*)fontWithName:(NSString*)name
{
    for(FontItem *item in [[UIpConfig sharedUIpConfig] getUIpConfigFonts]) {
        if([item.name isEqualToString:name]) {
            return item.font;
        }
    }
    
    NSLog(@"#error - fontWithName [%@] not found.", name);
    return [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
}


@end
