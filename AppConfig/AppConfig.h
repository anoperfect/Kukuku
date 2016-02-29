//
//  AppConfig.h
//  hacfun
//
//  Created by Ben on 15/8/6.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject




+ (UIColor*)backgroundColorFor:(NSString*)name;
+ (UIColor*)textColorFor:(NSString*)name;
+ (UIFont*)fontFor:(NSString*)name;

+ (id)configForKey:(id)key;

@end
