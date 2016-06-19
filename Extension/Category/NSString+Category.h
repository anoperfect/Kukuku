//
//  NSString+Category.h
//  hacfun
//
//  Created by Ben on 16/4/16.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)




//可定义为对象成员函数. 暂定义为类成员函数.
+ (NSString *)URLEncodedString:(NSString*)urlString;
+ (NSString*)URLDecodedString:(NSString*)urlStringEncoded;


+ (NSString*)stringFromCGRect:(CGRect)rect;
+ (NSString*)stringFromViewFrame:(UIView*)view;
+ (NSString*)stringFromMSecondInterval:(long long) msecs andTimeZoneAdjustSecondInterval:(NSInteger)adjustSeconds;
+ (NSString*)stringFromRelativeDescriptorOfDateForMSec:(long long)msec;

+(NSString*)diffFromString:(NSString*)s1 toString:(NSString*)s2 referentceLineNumber:(NSInteger)lineNumber;


+ (NSString*)stringsCombine:(NSArray*)strings withConnector:(NSString*)stringConnector;
+ (NSString*)stringPaste:(NSString*)string onTimes:(NSInteger)times withConnector:(NSString*)stringConnector;
+ (NSString*)decodeWWWEscape:(NSString*)string;
+ (NSString*)combineArray:(NSArray*)array withInterval:(NSString*)intetval andPrefix:(NSString*)prefix andSuffix:(NSString*)suffix;

+(NSString*)stringFromNSDictionary:(NSDictionary*)dict;
+(NSString*)stringLineFromNSDictionary:(NSDictionary*)dict;

+(NSString*)stringFromTableIndexPath:(NSIndexPath*)indexPath;


//对字符串. ff123456类型转换成int.
- (NSInteger)hexValue;

//由一个&#xffoc;,或者&#20000; 的字符串转换为可识别字符串.
- (NSString *)NCRToString;


//NCR转换.匹配替换部分有问题.
-(NSString *)NCRDecode;


- (NSString *)calculateMD5;
#if ENABLE_IDFA
+ (NSString *)deviceIdfa;
#endif
+ (NSString*)deviceUuid;

@end

