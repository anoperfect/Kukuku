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


//将数据读入arrayAllRecord.
- (void)getAllRecordData
{
    NSArray *queryDatas = [[AppConfig sharedConfigDB] configDBPostQuery:nil];
    NSLog(@"localDatas count : %zd .", [queryDatas count]);
    
    for(NSDictionary *dict in queryDatas) {
        long long timestampMsecAt = [(NSNumber*)(dict[@"postedAt"]) longLongValue];
        NSLog(@"111 - No.%@ at %@", dict[@"id"], [NSString stringFromMSecondInterval:timestampMsecAt andTimeZoneAdjustSecondInterval:0]);
    }
    
    self.arrayAllRecord = [NSMutableArray arrayWithArray:queryDatas];
}






@end