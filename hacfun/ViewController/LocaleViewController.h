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
@property (nonatomic, strong) NSArray *postDatasAll;
@property (nonatomic, strong) NSArray *allTid;


@property (nonatomic, strong) NSArray *concreteDatas;
@property (nonatomic, strong) Class concreteDatasClass;

@property (nonatomic, strong, readonly) NSMutableDictionary *updateResult; //not use. 之前是全部更新完成后刷新, 修改为单条刷新.


//override. 获取本地记录数据.
- (void)getLocaleRecords;


//override. 
- (void)removeRecordsWithIndexPath:(NSIndexPath*)indexPath;




@end
