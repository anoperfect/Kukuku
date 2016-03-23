//
//  NetworkThreadViewController.h
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import "ThreadsViewController.h"

@interface NetworkThreadViewController : ThreadsViewController




//重写以保存网络下载后解析的数据.
//应用:
//DetailViewController记录加载到的最新回复的createdAt.
- (void)storeLoadedData:(NSData*)data;


@end
