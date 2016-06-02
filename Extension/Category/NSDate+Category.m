//
//  NSDate+Category.m
//  hacfun
//
//  Created by Ben on 16/6/2.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate(Category)




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

@end
