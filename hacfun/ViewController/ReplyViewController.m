//
//  ReplyViewController.m
//  hacfun
//
//  Created by Ben on 15/9/7.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ReplyViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"



@implementation ReplyViewController









- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"回复";
        
        
    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    //NSMutableArray *topicsM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBReplyGets];
    self.concreteDatasClass = [Reply class];
    for(Reply *reply in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:reply.tid]];
        
        NSLog(@"%@", reply);
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    self.allTid = [NSArray arrayWithArray:allTidM];
    self.postDatasAll = [[AppConfig sharedConfigDB] configDBRecordGets:self.allTid];
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    [[AppConfig sharedConfigDB] configDBReplyRemoveByTidArray:tids];
}







@end