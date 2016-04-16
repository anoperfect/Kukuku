//
//  NSObject+Util.m
//  NoteTask
//
//  Created by Ben on 16/3/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSObject+Util.h"

@implementation NSObject(Util)

+ (void)objectClassTest:(NSObject*)obj
{
    if(nil != obj) {
        NSLog(@"%20@ : %d", @"NSDictionary",    [obj isKindOfClass:[NSDictionary class]]);
        NSLog(@"%20@ : %d", @"NSArray",         [obj isKindOfClass:[NSArray class]]);
        NSLog(@"%20@ : %d", @"NSString",        [obj isKindOfClass:[NSString class]]);
        NSLog(@"%20@ : %d", @"NSNumber",        [obj isKindOfClass:[NSNumber class]]);
        NSLog(@"%20@ : %d", @"NSData",          [obj isKindOfClass:[NSData class]]);
        NSLog(@"obj content = [%@]", obj);
    }
    else {
        NSLog(@"obj nil");
    }
}





@end
