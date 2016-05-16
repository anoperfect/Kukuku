//
//  NetworkThreadViewController.h
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import "ThreadsViewController.h"

@interface NetworkThreadViewController : ThreadsViewController




//开始下载第page.
- (void)setBackgroundDownloadPage:(NSInteger)page ;
//根据当前记录,
- (void)setBackgroundDownloadPageMore;


//重写以在下载解析后执行的任务.
//应用: 未下载到新数据时停止执行自动下载.
//DetailViewController记录加载到的最新回复的createdAt.
- (void)actionAfterParseAndRefresh:(NSData*)data
                 andPostDataParsed:(NSMutableArray*)postDataParsed
               andPostDataAppended:(NSMutableArray*)postDataAppended;





@end

