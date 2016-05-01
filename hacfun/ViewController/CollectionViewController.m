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
#if 0
    NSArray *queryDatas = [[AppConfig sharedConfigDB] configDBCollectionQuery:nil];
    NSLog(@"localDatas count : %zd .", [queryDatas count]);

    
    self.arrayAllRecord = [NSMutableArray arrayWithArray:queryDatas];
#endif
}







@end