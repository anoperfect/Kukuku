//
//  NSString+Category.m
//  hacfun
//
//  Created by Ben on 16/4/16.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSString+Category.h"
#import "NSDate+Category.h"
#import <CommonCrypto/CommonDigest.h>
#if ENABLE_IDFA
#import <AdSupport/AdSupport.h>
#endif



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


+ (NSString*)stringFromRelativeDescriptorOfDateForMSec:(long long)msec
{
    long long msecNow = MSEC_NOW;
    NSString *stringDescriptor = [self stringFromMSecondInterval:msec andTimeZoneAdjustSecondInterval:0];
    
    if(msecNow - msec >= 0) {
        long long secSub = (msecNow - msec) / 1000;
        if(secSub < 60) {
            stringDescriptor = [NSString stringWithFormat:@"%zd秒前", secSub>0?secSub:1];
        }
        else if(secSub < 3600) {
            stringDescriptor = [NSString stringWithFormat:@"%zd分钟前", secSub/60];
        }
        else if(secSub < 24 * 3600) {
            stringDescriptor = [NSString stringWithFormat:@"%zd小时前", secSub/3600];
        }
        else if(secSub < 10 * 24 * 3600) {
            stringDescriptor = [NSString stringWithFormat:@"%zd天前", secSub/(24*3600)];
        }
    }
       
    return stringDescriptor;
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
    content = [content stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
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
        
        if([array[index] isKindOfClass:[NSData class]]) {
            [str appendFormat:@"NSData-%zd", ((NSData*)(array[index])).length];
        }
        else {
            [str appendFormat:@"%@", array[index]];
        }
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


+(NSString*)stringLineFromNSDictionary:(NSDictionary*)dict
{
    if(!dict) {
        return @"NSDictionary nil";
    }
    
    NSMutableString *strm = [NSMutableString stringWithString:@"{"];
    
    for(id key in dict.allKeys) {
        id obj = [dict objectForKey:key];
        if([obj isKindOfClass:[NSNumber class]]) {
            [strm appendFormat:@"%@ = %@", key, [dict objectForKey:key]];
        }
        else {
            [strm appendFormat:@"%@ = \"%@\"", key, [dict objectForKey:key]];
        }
        
        if([key isEqual:[dict.allKeys lastObject]]) {
            
        }
        else {
            [strm appendString:@"\t"];
        }
    }
    
    [strm appendString:@"}"];
    
    return [NSString stringWithString:strm];
}


+(NSString*)stringFromTableIndexPath:(NSIndexPath*)indexPath
{
    return [NSString stringWithFormat:@"%zd:%zd", indexPath.section, indexPath.row];
}


- (NSArray*)subStringRangesWithRegularExpression:(NSString*)regularExpression
{
    NSString *searchText = self;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);

    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:regularExpression options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        [ranges addObject:[NSValue valueWithRange:rangeResult]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    return [NSArray arrayWithArray:ranges];
}


- (NSArray*)subStringRangesWithString:(NSString*)substring
{
    NSString *searchText = self;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:substring options:0 range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        [ranges addObject:[NSValue valueWithRange:rangeResult]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    return [NSArray arrayWithArray:ranges];
}


- (NSString*)digitStringFromIndex:(NSInteger)index
{
    if(index >= self.length) {
        return nil;
    }
    
    NSString *subString = [self substringFromIndex:index];
    char cstr[128] = {0};
    for(NSInteger idx = 0; idx < 128 && idx < subString.length; idx ++) {
        unichar ch = [subString characterAtIndex:idx];
        if(ch >= '0' && ch <= '9') {
            cstr[idx] = ch;
        }
        else {
            break;
        }
    }
    
    if(strlen(cstr) > 0) {
        return [NSString stringWithUTF8String:cstr];
    }
    else {
        return nil;
    }
}


+(NSString*)diffFromString:(NSString*)s1 toString:(NSString*)s2 referentceLineNumber:(NSInteger)lineNumber
{
    NSArray *a1 = [s1 componentsSeparatedByString:@"\n"];
    NSArray *a2 = [s2 componentsSeparatedByString:@"\n"];
    
    NSInteger index = 0;
    for(index = 0; index < a1.count && index < a2.count ; index ++) {
        if([a1[index] isEqualToString:a2[index]]) {
            
        }
        else {
            return [NSString stringWithFormat:@"line : %zd .\n1 : [%@]\n2 : [%@]\n", index + 1, a1[index], a2[index]];
        }
    }
    
    if(a1.count > index) {
        return [NSString stringWithFormat:@"1:more strings : %@ ...", a1[index]];
    }
    else {
        return [NSString stringWithFormat:@"2:more strings : %@ ...", a2[index]];
    }
}




#define HEXCHAR_TO_INT(ch, v) \
if(ch >= '0' && ch <= '9')      { v = ch - '0'; } \
else if(ch >= 'A' && ch <= 'F') { v = ch - 'A' + 10; } \
else if(ch >= 'a' && ch <= 'f') { v = ch - 'a' + 10; } \
else { v = -1; }

#define DECCHAR_TO_INT(ch, v) \
if(ch >= '0' && ch <= '9')      { v = ch - '0'; }   \
else { v = -1; }



//对字符串. ff123456类型转换成int.
- (NSInteger)hexValue
{
    
    NSInteger number = 0;
    //NSLog(@"hexValue : [%@] -> [%zd]", self, number);
    NSString *str ;
    if(self.length % 2 == 0) {
        str = self;
    }
    else {
        str = [NSString stringWithFormat:@"0%@", self];
    }
    
    int v;
    NSInteger lenth = str.length;
    for(NSInteger idx = 0; idx < lenth/2; idx ++) {
        number <<= 8;
        
        HEXCHAR_TO_INT([str characterAtIndex:idx*2] , v)
        if(v == -1) {
            NSLog(@"#error - [%@] not hex value format.", self);
            return 0;
        }
        
        number += (v << 4);
        
        HEXCHAR_TO_INT([str characterAtIndex:idx*2 + 1] , v)
        if(v == -1) {
            NSLog(@"#error - [%@] not hex value format.", self);
            return 0;
        }
        
        number += (v);
    }
    
    //NSLog(@"hexValue : [%@] -> [%zd]", self, number);
    return number;
}



//由一个&#xffoc;,或者&#20000; 的字符串转换为可识别字符串.
- (NSString *)NCRToString
{
    NSString *toStr = nil;
    //NSLog(@"NCRToString : [%@] -> [%@]", self, toStr);
    if([self hasPrefix:@"&#"] && [self hasSuffix:@";"]) {
        char cstr[3] = {0};
        if([self characterAtIndex:2] == 'x') {
            NSString *v = [self substringWithRange:NSMakeRange(3, self.length - 4)];
            NSInteger value = [v hexValue];
            cstr[1] = value  & 0x00FF;
            cstr[0] = (value >>8) &0x00FF;
            toStr = [NSString stringWithCString:cstr encoding:NSUnicodeStringEncoding];
            
        }
        else {
            NSString *v = [self substringFromIndex:2];
            NSInteger value = [v integerValue];
            if(value > 0xff) {
                cstr[1] = value  & 0x00FF;
                cstr[0] = (value >>8) &0x00FF;
                toStr = [NSString stringWithCString:cstr encoding:NSUnicodeStringEncoding];
            }
            else {
                cstr[0] = value;
                cstr[1] = '\0';
                toStr = [NSString stringWithCString:cstr encoding:NSASCIIStringEncoding];
            }
        }
    }
    else {
        NSLog(@"#error - [%@] invalue NCR format.", self);
    }
    
    //NSLog(@"NCRToString : [%@] -> [%@]", self, toStr);
    return toStr;
}






//NCR转换.匹配替换部分有问题.
-(NSString *)NCRDecode
{
    NSMutableString *str = [NSMutableString stringWithString:self];
    
    NSArray *ranges = [self subStringRangesWithRegularExpression:@"&#x{0,1}[0-9a-fA-F]+;"];
    NSInteger count = ranges.count;
    //NS0Log(@"ranges : %@", ranges);
    
    for(NSInteger idx = count-1; idx >= 0; idx -- ) {
        NSValue *valueWithRange = ranges[idx];
        //NSLog(@"range : %@", valueWithRange);
        NSRange range = [valueWithRange rangeValue];
        NSString *NCRString = [self substringWithRange:range];
        NSString *decodedString = [NCRString NCRToString];
        //NSLog(@"decode string : [%@]", decodedString);
        if(decodedString.length > 0) {
            [str replaceCharactersInRange:range withString:decodedString];
        }
    }
    
    return [NSString stringWithString:str];
#if 0
    NSMutableString *srcString =    [[NSMutableString alloc]initWithString:self];
    if ([srcString containsString:@"&#"]) {
        [srcString replaceOccurrencesOfString:@"&#" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,     [srcString length])];
        
        NSMutableString *desString = [[NSMutableString alloc]init];
        
        NSArray *arr = [srcString componentsSeparatedByString:@";"];
        
        for(int i=0;i<[arr count]-1;i++){
            
            NSString *v = [arr objectAtIndex:i];
            char *c = malloc(3);
            int value = [v intValue];
            c[1] = value  &0x00FF;
            c[0] = value >>8 &0x00FF;
            c[2] = '\0';
            [desString appendString:[NSString stringWithCString:c encoding:NSUnicodeStringEncoding]];
            free(c);
        }
        
        return desString;
    }
    else
    {
        return self;
    }
#endif
}



- (NSString *)calculateMD5
{
    const char *cStr = [self UTF8String];
    
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return [NSString stringWithString:output];
}


#if ENABLE_IDFA
+ (NSString *)deviceIdfa
{
    NSString *deviceIdfa = @"Idfanotdefine";
    
    //已经限定target版本.
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if([systemVersion floatValue] >= 7.0f )
    {
        deviceIdfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        deviceIdfa = [deviceIdfa stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }else{
        //        deviceIdfa = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    }
    
    return deviceIdfa;
}
#endif



+ (NSString*)deviceUuid
{
    NSString *deviceUuid = @"Uuidnotdefine";
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    deviceUuid = result ;
  
    return deviceUuid;
}



+ (NSURL*)stringToNSURL:(NSString*)urlString
{
    //NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return url;
}


+ (NSString*)stringFromNSURL:(NSURL*)url
{
    //NSString *urlString = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [[url absoluteString] stringByRemovingPercentEncoding];
    return urlString;
}



@end
