//
//  ImageViewCache.m
//  hacfun
//
//  Created by Ben on 15/8/14.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ImageViewCache.h"
#import "AppConfig.h"
@implementation ImageViewCache




+ (NSData*)getImageViewCache:(NSString*)stringUrl {
    
    NSString *path = [self stringUrlToStoredPngName:stringUrl];
    NSData *dataRead = [NSData dataWithContentsOfFile:path];
    
    return dataRead;
}


+ (void)setImageViewCache:(NSString*)stringUrl withData:(NSData*)data {
    
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [data writeToFile:[self stringUrlToStoredPngName:stringUrl] atomically:YES];
}


+ (NSString*)stringUrlToStoredPngName: (NSString*)stringUrl {
    
    NSString *imageCacheFolder = [self getImageCacheFolder];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *imageName = [stringUrl stringByReplacingOccurrencesOfString:@":" withString:@"--"];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"/" withString:@"#"];
    NSString *pngPath = [NSString stringWithFormat:@"%@/%@", imageCacheFolder, imageName];
//    NSLog(@"pngPath : %@", pngPath);
    
    return pngPath;
}


+ (NSString*)getImageCacheFolder {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array firstObject];
//    NSLog(@"document path : %@", documentPath);
    
    NSString *imageCacheFolder =
        [NSString stringWithFormat:@"%@/%@/ImageCache", documentPath, [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
    return imageCacheFolder;
}


@end
