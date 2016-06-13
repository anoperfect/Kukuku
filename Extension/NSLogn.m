//
//  NSLogn.m
//  hacfun
//
//  Created by Ben on 16/3/29.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSLogn.h"
#import "FuncDefine.h"
#import "NSDate+Category.h"
/*
  NSLog重新定义.
  此文件中所有接口不能调用NSLog, 
  否则触发循环调用.
  调用NSLogo,
  调用NSLog0 取消打印.
 */
#define NSLogo(FORMAT, ...) { NSString *content = [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]; printf("------ %s\n", [content UTF8String]);}
#define NSLog0(FORMAT, ...)
 

@interface NSLogn ()



@end



@implementation NSLogn




+ (NSLogn *)sharedNSLogn {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    NSLogo(@"dealloc.");
}


- (void)LogContentRaw:(NSString*)content line:(long)line file:(const char*)file function:(const char*)function
{
    double interval = [NSDate timeIntervalCountWithRecount:false];
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%90s %6ld %3.6f: %@", function, line, interval, content];
    printf("%s\n", [str UTF8String]);
}


@end



