//
//  NSThread.m
//  NoteTask
//
//  Created by Ben on 16/2/24.
//  Copyright © 2016年 Ben. All rights reserved.
//

#include "NSThread+Util.h"

@interface NSThread ()

@property (nonatomic, strong) NSMutableArray *arrayThreads;


@end



@implementation NSThread (Util)


+ (NSInteger)threadIndex
{
    NSInteger indexRet = 0;
    
    static NSMutableArray *karrayThreads = nil;
    static NSObject *klockObj = nil;
    static dispatch_once_t p;
    
    dispatch_once(&p, ^{
        karrayThreads = [[NSMutableArray alloc] init];
        klockObj = [[NSObject alloc] init];
    });
    
    @synchronized(klockObj) {
        NSThread *thread = [NSThread currentThread];
        indexRet = [karrayThreads indexOfObject:thread];
        if(indexRet == NSNotFound) {
            indexRet = [karrayThreads count];
            [karrayThreads addObject:thread];
        }
    }
    
    return indexRet;
}


@end
