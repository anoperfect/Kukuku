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
    [data writeToFile:[self stringUrlToStoredPngName:stringUrl] atomically:YES];
}


+ (NSString*)stringUrlToStoredPngName: (NSString*)stringUrl {
    
    NSString *imageCacheFolder = [self getImageCacheFolder];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
#if 0
    NSString *imageName = [stringUrl stringByReplacingOccurrencesOfString:@":" withString:@"--"];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"/" withString:@"#"];
#endif
    //修改为URL的encode方式.
    NSString *imageName = [NSString URLEncodedString:stringUrl];
    
    NSString *pngPath = [NSString stringWithFormat:@"%@/%@", imageCacheFolder, imageName];
    
    return pngPath;
}


+ (NSString*)getImageCacheFolder {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    
    NSString *imageCacheFolder =
        [NSString stringWithFormat:@"%@/%@/ImageCache", documentPath, host.hostname];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
    return imageCacheFolder;
}


//返回实际获取到的image个数.
+ (NSInteger)inputCacheImagesAndPathWithTopNumber:(NSInteger)topNumber
                                     outputImages:(NSMutableArray*)imageArray
                                 outputFilePathsM:(NSMutableArray*)filePathArray
                                  outputAdditonal:(NSMutableDictionary*)dictm
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = nil; //[[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    
    NSString* imageCacheFolder = [ImageViewCache getImageCacheFolder];
    fileList = [fileManager contentsOfDirectoryAtPath:imageCacheFolder error:&error];
    NSInteger retNumber = 0;
    for(NSString *name in fileList) {
        NSString *fullName = [NSString stringWithFormat:@"%@/%@", imageCacheFolder, name];
        NSLog(@"image file name : %@", fullName);
        
        UIImage *image = [UIImage imageWithContentsOfFile:fullName];
        if(image) {
            [imageArray addObject:image];
            [filePathArray addObject:fullName];
            
            retNumber ++;
            
            if(retNumber >= topNumber) {
                break;
            }
        }
        else {
            NSLog(@"#error - image NULL at : %@", name);
        }
    }
    
    [dictm setObject:[NSNumber numberWithInteger:fileList.count] forKey:@"totalNumber"];
    
    return retNumber;
}


+ (void)deleteCaches
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = nil;
    
    NSString* imageCacheFolder = [ImageViewCache getImageCacheFolder];
    fileList = [fileManager contentsOfDirectoryAtPath:imageCacheFolder error:&error];
    for(NSString *name in fileList) {
        NSString *fullName = [NSString stringWithFormat:@"%@/%@", imageCacheFolder, name];
        [fileManager removeItemAtPath:fullName error:&error];
        NSLog(@"remove %@", fullName);
    }
    
    NSLog(@"路径==%@,fileList%@", imageCacheFolder, fileList);
}


+ (void)deleteCachesAsyncWithProgressHandle:(void (^)(NSInteger total, NSInteger idx))handle
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.deleteImageCache.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *fileList = nil;
        
        NSString* imageCacheFolder = [ImageViewCache getImageCacheFolder];
        fileList = [fileManager contentsOfDirectoryAtPath:imageCacheFolder error:&error];
        NSInteger index = 0;
        NSInteger total = fileList.count;
        for(NSString *name in fileList) {
            NSString *fullName = [NSString stringWithFormat:@"%@/%@", imageCacheFolder, name];
            [fileManager removeItemAtPath:fullName error:&error];
            NSLog(@"remove %@", fullName);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                handle(total, index);
            });
            
            index ++;
        }
        
        NSLog(@"路径==%@,fileList%@", imageCacheFolder, fileList);
    });
}


@end
