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
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"refresh";
        actionData.image    = @"refresh";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"删除";
//        actionData.image    = @"delete";
        [self actionAddData:actionData];
    }
    
    return self;
}


- (NSArray*)getAllLocaleData {
    NSArray *localDatas = [[AppConfig sharedConfigDB] configDBCollectionQuery:nil];
    NSLog(@"localDatas count : %zd .", [localDatas count]);
    return localDatas;
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    NSInteger threadId = ((PostData*)[self.postDatas objectAtIndex:row]).id;
    
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId];
    
    [self.navigationController pushViewController:vc animated:YES];
}


//信息部分显示更改为回复数.
- (void)postDatasToCellDataSource {
    LOG_POSTION
    
    //在ThreadsViewController的解析基础上修改.
    [super postDatasToCellDataSource];
    
#if 0
    for(NSMutableDictionary *dict in self.postViewCellDatas) {
        //信息部分显示NO.
        [dict setObject:[NSString stringWithFormat:@"No.%@", [dict objectForKey:@"id"]] forKey:@"info"];
    }
#endif
}


- (void)actionViaString:(NSString*)string
{
    if([string isEqualToString:@"refresh"]) {
        [self updateThreadsInfo];
    }
}


- (void)updateThreadsInfo
{
    for(id obj in self.arrayAllLocale) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"#error not expected class %@", obj);
            break;
        }
        
        NSDictionary *dict = obj;
        NSNumber *number = dict[@"id"];
        [self updateThreadById:[number integerValue]];
    }
}


- (void)updateThreadById:(long long)tid
{
    NSLog(@"update %lld", tid);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        //获取last page的信息.
        NSMutableArray *postDataArray = [PostData sendSynchronousRequestByThreadId:tid andPage:-1];
        if(nil == postDataArray) {
            NSLog(@"tid [%lld] get page last error.", tid);
        }
        else {
            //跟浏览记录对比.
            PostData *tPostData = postDataArray[0];
            NSLog(@"%lld updateAt %lld", tid, tPostData.updatedAt);
        }
    });
}


- (void)longPressOnRow:(NSInteger)row {
    LOG_POSTION


    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */





@end