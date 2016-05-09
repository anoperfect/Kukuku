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


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBCollectionGets];
    self.concreteDatasClass = [Collection class];
    for(Collection *collection in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:collection.tid]];
    }
    
    self.allTid = [NSArray arrayWithArray:allTidM];
    self.postDatasAll = [[AppConfig sharedConfigDB] configDBRecordGets:self.allTid];
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    [[AppConfig sharedConfigDB] configDBCollectionRemoveByTidArray:tids];
}







@end