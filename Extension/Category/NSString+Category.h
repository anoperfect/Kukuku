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


+ (NSString*)stringsCombine:(NSArray*)strings withConnector:(NSString*)stringConnector;
+ (NSString*)stringPaste:(NSString*)string onTimes:(NSInteger)times withConnector:(NSString*)stringConnector;
+ (NSString*)decodeWWWEscape:(NSString*)string;
+ (NSString*)combineArray:(NSArray*)array withInterval:(NSString*)intetval andPrefix:(NSString*)prefix andSuffix:(NSString*)suffix;

+(NSString*)stringFromNSDictionary:(NSDictionary*)dict;

+(NSString*)stringFromTableIndexPath:(NSIndexPath*)indexPath;

@end

