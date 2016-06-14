//
//  NSDate+Category.h
//  hacfun
//
//  Created by Ben on 16/6/2.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Category)




+ (NSTimeInterval)timeIntervalCountWithRecount:(BOOL)recount;


@end



#define MSEC_NOW    ([[NSDate date] timeIntervalSince1970] * 1000.0)
#define MSEC_1DAY   (24 * 3600 * 1000)


