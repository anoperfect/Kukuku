//
//  LocaleViewController.h
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadsViewController.h"
@interface LocaleViewController : ThreadsViewController
@property (strong,nonatomic) NSMutableArray *arrayAllRecord; //成员为NSDictionary. NSDictionary的核心key是id,jsonstring.



//将数据读入arrayAllRecord.
- (void)getAllRecordData ;
- (void)removeRecordsWithTids:(NSArray*)tids;


@end
