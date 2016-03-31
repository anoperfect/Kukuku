//
//  NSLogn.m
//  hacfun
//
//  Created by Ben on 16/3/29.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSLogn.h"

@interface NSLogn ()

@end

@implementation NSLogn


+ (NSInteger)retainCount:(unsigned long long)objAddr
{
    return CFGetRetainCount((CFTypeRef)objAddr);
}


+ (NSInteger)retainCount1:(__weak id)anObject
{
    __weak id wid = anObject;
    return CFGetRetainCount((CFTypeRef)wid);
}


+ (NSInteger)retainCount0:(id)myObject
{
    return CFGetRetainCount((__bridge CFTypeRef)myObject);
}





@end