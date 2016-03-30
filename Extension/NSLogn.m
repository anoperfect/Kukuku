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
#if 0
    NSLog(@"Retain count is %ld <%@>", CFGetRetainCount((__bridge CFTypeRef)(mainVC.currentActiveNVC)), mainVC.currentActiveNVC);


//        NSObject *obj1 = mainVC.currentActiveNVC;
//        NSObject *obj2 = mainVC.currentActiveNVC.viewControllers[0];

NSLog(@"Retain count is %ld <%@>", CFGetRetainCount((__bridge CFTypeRef)(mainVC.currentActiveNVC)), mainVC.currentActiveNVC);
NSLog(@"Retain count is %ld <%@>", CFGetRetainCount((__bridge CFTypeRef)(mainVC.currentActiveNVC.viewControllers[0])), mainVC.currentActiveNVC.viewControllers[0]);
//        NSLog(@"Retain count is %ld <%@>", CFGetRetainCount((__bridge CFTypeRef)obj2), obj2);
#endif
}


+ (NSInteger)retainCount1:(__weak id)anObject
{
    __weak id wid = anObject;
    return CFGetRetainCount((CFTypeRef)wid);
}


+ (NSInteger)retainCount0:(id)myObject
{
//    NSLog(@"Retain count is %ld",
    return CFGetRetainCount((__bridge CFTypeRef)myObject);
}



@end
