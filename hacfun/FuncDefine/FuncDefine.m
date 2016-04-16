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



@end















