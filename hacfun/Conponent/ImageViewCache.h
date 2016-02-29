//
//  ImageViewCache.h
//  hacfun
//
//  Created by Ben on 15/8/14.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageViewCache : NSObject




+ (NSData*)getImageViewCache:(NSString*)stringUrl;
+ (void)setImageViewCache:(NSString*)stringUrl withData:(NSData*)data;

+ (NSString*)getImageCacheFolder;

@end
