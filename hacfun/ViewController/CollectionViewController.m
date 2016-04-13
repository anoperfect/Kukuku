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

@property (nonatomic, strong) NSMutableDictionary *updateResult;

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
        
#if 0
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"删除";
//        actionData.image    = @"delete";
        [self actionAddData:actionData];
#endif
    }
    
    return self;
}


- (NSArray*)getAllLocaleData {
    NSArray *localDatas = [[AppConfig sharedConfigDB] configDBCollectionQuery:nil];
    NSLog(@"localDatas count : %zd .", [localDatas count]);
    
    for(NSDictionary *dict in localDatas) {
        long long collectedAt = [(NSNumber*)(dict[@"collectedAt"]) longLongValue];
        NSLog(@"111 - No.%@ at %@", dict[@"id"], [FuncDefine stringFromMSecondInterval:collectedAt andTimeZoneAdjustSecondInterval:0]);
    }
    
    return localDatas;
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    
    PostData *postDataPresent = [self.postDatas objectAtIndex:row];
    NSInteger threadId = postDataPresent.id;
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId withData:postDataPresent];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)actionViaString:(NSString*)string
{
    if([string isEqualToString:@"refresh"]) {
        [self updateThreadsInfo];
    }
}


- (void)updateThreadsInfo
{
    //将所有需更新的tid记录.
    self.updateResult = [[NSMutableDictionary alloc] init];
    
    //所有显示更新中提示.
    for(NSMutableDictionary *dictm in self.postViewCellDatas) {
        [dictm setObject:@"更新中" forKey:@"otherInfo"];
    }
    
    [self.postView reloadData];
    
    for(id obj in self.arrayAllLocale) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"#error not expected class %@", obj);
            break;
        }
        
        NSDictionary *dict = obj;
        NSNumber *number = dict[@"id"];
        [self.updateResult setObject:[NSNumber numberWithBool:NO] forKey:number];
        [self updateThreadById:[number integerValue]];
    }
}


- (void)updateThreadById:(long long)tid
{
    NSLog(@"update %lld", tid);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        //获取last page的信息.
        PostData *topic = [[PostData alloc] init];
        NSMutableArray *postDataArray = [PostData sendSynchronousRequestByThreadId:tid andPage:-1 andValueTopicTo:topic];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self checkUpdateTidResult:tid withReplyPostDatas:postDataArray andTopic:topic];
        });
    });
}


//将数据更新到用于cell显示的data.
- (void)updateToCellData:(NSInteger)tid withInfo:(NSDictionary*)info
{
    BOOL found = NO;
    NSString *message = [info objectForKey:@"message"];
    for(NSMutableDictionary* dict in self.postViewCellDatas) {
        PostData *postData = [dict objectForKey:@"postdata"];
        if(tid == postData.id) {
            NSLog(@"find in ");
            
            [dict setObject:message forKey:@"otherInfo"];
            
            found = YES;
            break;
        }
    }
    
    if(!found) {
        //实际页面未全部显示的时候, 可能导致未在self.postViewCellDatas中找到.
        NSLog(@"#error not found.");
    }
}


//需在主线程执行.
- (void)checkUpdateTidResult:(NSInteger)tid withReplyPostDatas:(NSArray*)postDataArray andTopic:(PostData*)topic
{
    NSNumber *number = [NSNumber numberWithInteger:tid];

    
    if(nil == postDataArray) {
        NSLog(@"tid [%zd] get page last error:%@", tid, @"no PostData parsed.");
        [self updateToCellData:tid withInfo:@{@"message":@"更新出错"}];
    }
    else if([postDataArray count] <= 0){
        NSLog(@"tid [%zd] no reply", tid);
        //没有更新则不修改显示.
    }
    else {
        //跟浏览记录对比.
        PostData *tPostData = postDataArray[0];
        NSLog(@"tid [%zd[]updateAt %lld", tid, tPostData.updatedAt);
        
        //最后一条reply信息跟之前的Loaded记录, Display记录对比.
        PostData *pdLastReply = [postDataArray lastObject];
        NSLog(@"tid [%zd] last reply createdAt : %lld.", tid, pdLastReply.createdAt);
        
        //读取之前的加载与显示记录.
        //获取加载记录和浏览记录. (只记录加载记录和浏览记录的最大值.)
        long long createdAtForLoaded = 0;
        long long createdAtForDisplay = 0;
        BOOL isComparedOK = false;
        
        NSDictionary *dictDatailHistory = [[AppConfig sharedConfigDB] configDBDetailHistoryQuery:@{@"id":[NSNumber numberWithInteger:tid]}];
        NSLog(@"%@", dictDatailHistory);
        
        if(dictDatailHistory) {
            id obj;
            
            obj = [dictDatailHistory objectForKey:@"createdAtForLoaded"];
            if(obj) {
                createdAtForLoaded = [(NSNumber*)obj longLongValue];
            }
            
            obj = [dictDatailHistory objectForKey:@"createdAtForDisplay"];
            if(obj) {
                createdAtForDisplay = [(NSNumber*)obj longLongValue];
            }
        }
        
        if(!(createdAtForLoaded > 0 && createdAtForDisplay > 0)) {
            NSLog(@"#error - tid [%zd] read detail history failed.", tid);
            [self updateToCellData:tid withInfo:@{@"message":@"比较数据出错"}];
        }
        else {
            isComparedOK = YES;
            
            if(pdLastReply.createdAt > createdAtForLoaded) {
                NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                     [FuncDefine stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
                [self updateToCellData:tid withInfo:@{@"message":messge}];
            }
            else if(pdLastReply.createdAt > createdAtForDisplay) {
                NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                     [FuncDefine stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
                [self updateToCellData:tid withInfo:@{@"message":messge}];
            }
            else {
                //没有更新则不修改显示.
                NSString *messge = [NSString stringWithFormat:@"无更新."];
                [self updateToCellData:tid withInfo:@{@"message":messge}];
            }
        }
    }
    
    //判断是否已经执行过全部更新.
    BOOL isUpdateFinished = YES;
    [self.updateResult setObject:[NSNumber numberWithBool:YES] forKey:number];
    
    //得到词典中所有KEY值
    NSEnumerator * enumerator = [self.updateResult objectEnumerator];
    
    //快速枚举遍历所有KEY的值
    for (NSNumber *boolNumber in enumerator) {
        if(![ boolNumber boolValue]) {
            isUpdateFinished = NO;
            break;
        }
    }
    
    if(isUpdateFinished) {
        [self.postView reloadData];
    }
    else {
        NSLog(@"update not finished. %@", self.updateResult);
    }
}


//暂时info中只有message. 未兼容之后可能添加的info信息, 将参数类型设置为NSDictionary.






/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */





@end