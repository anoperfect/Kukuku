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


@interface UIpConfig ()

@property (nonatomic, strong) NSMutableArray *colorItems;
@property (nonatomic, strong) NSMutableArray *fontItems;



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


- (NSMutableArray*)getUIpConfigFonts
{
    return self.fontItems;
}



@end



@implementation UIColor (Util)

//if use url. it can not running on main thread.
+(UIColor*)colorFromString:(NSString*)string
{
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
                                   
                                   };
    
    UIColor *systemColor = [ksystemColors objectForKey:string];
    if(nil != systemColor) {
        NS0Log(@"system color : %@", systemColor);
        return systemColor;
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
    for(ColorItem *item in [[UIpConfig sharedUIpConfig] getUIpConfigColors]) {
        if([item.name isEqualToString:name]) {
            NS0Log(@"colorWithName : %@ (%@) => %@", name, item.colorstring, item.color);
            return item.color;
        }
    }

    NSLog(@"#error - colorWithName [%@] not found.", name);
    return [UIColor orangeColor];
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
