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




//override. 获取本地记录数据.
- (NSArray*)getALLRecordTid;


//override. 
- (void)removeRecordsWithTids:(NSArray*)tids;


@end
