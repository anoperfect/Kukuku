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


//将数据读入arrayAllRecord.
- (void)getAllRecordData
{
    NSArray *queryDatas = [[AppConfig sharedConfigDB] configDBCollectionQuery:nil];
    NSLog(@"localDatas count : %zd .", [queryDatas count]);
    
    for(NSDictionary *dict in queryDatas) {
        long long timestampMsecAt = [(NSNumber*)(dict[@"collectedAt"]) longLongValue];
        NSLog(@"111 - No.%@ at %@", dict[@"id"], [NSString stringFromMSecondInterval:timestampMsecAt andTimeZoneAdjustSecondInterval:0]);
    }
    
    self.arrayAllRecord = [NSMutableArray arrayWithArray:queryDatas];
}







@end