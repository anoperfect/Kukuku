//
//  PostViewController.m
//  hacfun
//
//  Created by Ben on 15/9/7.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"



@implementation PostViewController









- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"发帖";
        
        
    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBPostGets];
    self.concreteDatasClass = [Post class];
    for(Post *post in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:post.tid]];
    }
    
    self.allTid = [NSArray arrayWithArray:allTidM];
    self.postDatasAll = [[AppConfig sharedConfigDB] configDBRecordGets:self.allTid];
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    [[AppConfig sharedConfigDB] configDBPostRemoveByTidArray:tids];
}












@end