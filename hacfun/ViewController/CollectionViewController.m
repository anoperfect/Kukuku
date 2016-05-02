//
//  CollectionViewController.m
//  hacfun
//
//  Created by Ben on 15/8/13.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "CollectionViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"



@interface CollectionViewController()


@end

@implementation CollectionViewController




- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"收藏";
        

    }
    
    return self;
}


- (NSArray*)getALLRecordTid
{
    NSArray *allTid = nil;
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    NSArray *collections = [[AppConfig sharedConfigDB] configDBCollectionGets];
    for(Collection *collection in collections) {
        [allTidM addObject:[NSNumber numberWithInteger:collection.tid]];
    }
    
    allTid = [NSArray arrayWithArray:allTidM];
    return allTid;
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    [[AppConfig sharedConfigDB] configDBCollectionRemoveByTidArray:tids];
}







@end