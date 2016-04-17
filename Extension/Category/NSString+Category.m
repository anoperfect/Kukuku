//
//  NSString+Category.m
//  hacfun
//
//  Created by Ben on 16/4/16.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
+ (NSString *)URLEncodedString:(NSString*)urlString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)urlString,
                                                              NULL,
                                                              CFSTR("!*'();:@&=+$,/?%#[] "),
                                                              kCFStringEncodingUTF8));
    return result;
}


+ (NSString*)URLDecodedString:(NSString*)urlStringEncoded
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)urlStringEncoded,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}


+ (NSString*)stringFromCGRect:(CGRect)rect
{
    return [NSString stringWithFormat:@
            "%3zd.%zd, "
            "%3zd.%zd, "
            "%3zd.%zd, "
            "%3zd.%zd"
            ,
            (NSInteger)rect.origin.x,       (NSInteger)(rect.origin.x       * 10.0) % 10,
            (NSInteger)rect.origin.y,       (NSInteger)(rect.origin.y       * 10.0) % 10,
            (NSInteger)rect.size.width,     (NSInteger)(rect.size.width     * 10.0) % 10,
            (NSInteger)rect.size.height,    (NSInteger)(rect.size.height    * 10.0) % 10
            ];
}


+ (NSString*)stringFromViewFrame:(UIView*)view
{
    CGRect frame = view.frame;
    return [self stringFromCGRect:frame];
}


+ (NSString*)stringFromMSecondInterval:(long long) msecs andTimeZoneAdjustSecondInterval:(NSInteger)adjustSeconds
{
    long long seconds = msecs / 1000 ;
    NSDate *dateWithNoZone = [NSDate dateWithTimeIntervalSince1970:seconds];
    //从实际测试情况看是没有添加时区影响的.
    //NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //NSInteger interval = [zone secondsFromGMTForDate:dateWithNoZone];
    NSDate *date = [dateWithNoZone dateByAddingTimeInterval:adjustSeconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [dateFormatter stringFromDate:date];
    
    return string;
}


+ (NSString*)stringFromMSecondInterval:(long long)msecs
{
    return [self stringFromMSecondInterval:msecs andTimeZoneAdjustSecondInterval:0];
}


+ (NSString*)stringsCombine:(NSArray*)strings withConnector:(NSString*)stringConnector
{
    NSInteger count = strings.count;
    if(count > 0) {
        NSMutableString *retStringm = [NSMutableString stringWithFormat:@"%@", strings[0]];
        
        //第一个已经添加, 因此序号从1开始.
        for(NSInteger index = 1; index < count; index ++) {
            [retStringm appendFormat:@"%@%@", stringConnector?stringConnector:@" ", strings[index]];
        }
        
        return [NSString stringWithString:retStringm];
    }
    else {
        return nil;
    }
}

+ (NSString*)stringPaste:(NSString*)string onTimes:(NSInteger)times withConnector:(NSString*)stringConnector
{
    NSInteger count = times;
    if(count > 0) {
        NSMutableString *retStringm = [NSMutableString stringWithFormat:@"%@", string];
        
        //第一个已经添加, 因此序号从1开始.
        for(NSInteger index = 1; index < count; index ++) {
            [retStringm appendFormat:@"%@%@", stringConnector?stringConnector:@" ", string];
        }
        
        return [NSString stringWithString:retStringm];
    }
    else {
        return nil;
    }
}


+ (NSString*)decodeWWWEscape:(NSString*)string
{
    NSString *content = [string copy];
    
    //这个特殊字符,编辑或者是NSString的操作接口都有问题. 因此采用临时替换的方式.
    NSString *specialChars = @";ﾟ";
    NSString *specialChar = [specialChars substringWithRange:NSMakeRange(1, 1)];
    NSString *tmpReplace = @"##special char##";
    content = [content stringByReplacingOccurrencesOfString:specialChar withString:tmpReplace];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    content = [content stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:tmpReplace withString:specialChar];
    
    return content;
}


+ (NSString*)combineArray:(NSArray*)array withInterval:(NSString*)intetval andPrefix:(NSString*)prefix andSuffix:(NSString*)suffix
{
    NSMutableString *str = [NSMutableString stringWithString:prefix?prefix:@""];
    for(NSInteger index = 0; index < array.count; index++) {
        if(index > 0) {
            [str appendString:intetval?intetval:@""];
        }
        
        [str appendFormat:@"%@", array[index]];
    }
    
    [str appendString:suffix?suffix:@""];
    
    return [NSString stringWithString:str];
}


+(NSString*)stringFromNSDictionary:(NSDictionary*)dict
{
    if(!dict) {
        return @"NSDictionary nil";
    }
    
    NSMutableString *strm = [NSMutableString stringWithString:@"{\n"];
    for(id key in dict.allKeys) {
        id obj = [dict objectForKey:key];
        if([obj isKindOfClass:[NSNumber class]]) {
            [strm appendFormat:@"%@ = %@\n", key, [dict objectForKey:key]];
        }
        else {
            [strm appendFormat:@"%@ = \"%@\"\n", key, [dict objectForKey:key]];
        }
    }
    [strm appendString:@"}"];
    
    return [NSString stringWithString:strm];
}






@end
