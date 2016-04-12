//
//  NSLogn.h
//  hacfun
//
//  Created by Ben on 16/3/29.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLogn : NSObject




+ (NSInteger)retainCount0:(id __weak)myObject;
+ (NSInteger)retainCount:(unsigned long long)objAddr;
+ (NSInteger)retainCount1:(__weak id)anObject;




+ (NSLogn *)sharedNSLogn;
- (void)connect;
- (void)disconnect;
- (void)sendLogContent:(NSString*)logString;
- (void)LogContentRaw:(NSString*)content line:(long)line file:(const char*)file function:(const char*)function;

@end

#if 1
#define NSLog(FORMAT, ...) {\
NSString *content = [NSString stringWithFormat:FORMAT, ##__VA_ARGS__];\
[[NSLogn sharedNSLogn] LogContentRaw:content line:__LINE__ file:__FILE__ function:__FUNCTION__];}
#endif




#if 0
#define NSLogn(FORMAT, ...) {\
NSString *logString = [NSString stringWithFormat:FORMAT, ##__VA_ARGS__];
NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
dictm


NSMutableString *str = [[NSMutableString alloc] init];\
[str appendFormat:@"%60s %6d %3.6f: ", __FUNCTION__, __LINE__, [FuncDefine timeIntervalCountWithRecount:false] ];\
[str appendFormat:FORMAT, ##__VA_ARGS__];\
printf("%s\n", [str UTF8String]);\
[[NSLogn sharedNSLogn] sendLogContent:[NSString stringWithFormat:@"%@\n", str]];\
}
#endif



