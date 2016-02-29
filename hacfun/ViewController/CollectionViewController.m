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


- (NSArray*)getAllLocaleData {
    NSArray *localDatas = [[AppConfig sharedConfigDB] configDBCollectionQuery:nil];
    NSLog(@"localDatas count : %zd .", [localDatas count]);
    return localDatas;
}


- (void)deleteCollection:(NSInteger)row {
    
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    NSInteger threadId = ((PostData*)[self.postDatas objectAtIndex:row]).id;
    
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId];
    
    [self.navigationController pushViewController:vc animated:YES];
}


//信息部分显示NO.
- (void)postDatasToCellDataSource {
    LOG_POSTION
    
    //在ThreadsViewController的解析基础上修改.
    [super postDatasToCellDataSource];
    
    for(NSMutableDictionary *dict in self.postViewCellDatas) {
        //信息部分显示NO.
        [dict setObject:[NSString stringWithFormat:@"No.%@", [dict objectForKey:@"id"]] forKey:@"info"];
    }
}


- (void)longPressOnRow:(NSInteger)row {
    LOG_POSTION

//    //数据库数据删除.
//    [self deleteCollection:row];
//    
//    //PostData数据删除.
//    [self.postDatas removeObjectAtIndex:row];
//    
//    //UITableView数据源刷新.
//    [self postDatasToCellDataSource];
//    
//    //UITableView reload.
//    [self.postView reloadData];
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */





@end