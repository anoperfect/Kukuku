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

//返回实际获取到的image个数.
+ (NSInteger)inputCacheImagesAndPathWithTopNumber:(NSInteger)topNumber
                                     outputImages:(NSMutableArray*)imageArray
                                 outputFilePathsM:(NSMutableArray*)filePathArray
                                  outputAdditonal:(NSMutableDictionary*)dictm;

+ (void)deleteCaches;

+ (void)deleteCachesAsyncWithProgressHandle:(void (^)(NSInteger total, NSInteger idx))handle;


@end
