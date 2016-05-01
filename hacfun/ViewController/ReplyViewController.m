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


//将数据读入arrayAllRecord.
- (void)getAllRecordData
{
#if 0
    NSArray *queryDatas = [[AppConfig sharedConfigDB] configDBReplyQuery:nil];
    NSLog(@"localDatas count : %zd .", [queryDatas count]);
    
    for(NSDictionary *dict in queryDatas) {
        long long timestampMsecAt = [(NSNumber*)(dict[@"repliedAt"]) longLongValue];
        NSLog(@"111 - No.%@ at %@", dict[@"tid"], [NSString stringFromMSecondInterval:timestampMsecAt andTimeZoneAdjustSecondInterval:0]);
    }
    
    self.arrayAllRecord = [NSMutableArray arrayWithArray:queryDatas];
#endif
}







@end