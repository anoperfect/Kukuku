//
//  LocaleViewController.m
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import "LocaleViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"


@interface LocaleViewController ()
@property (nonatomic, strong) NSMutableDictionary *updateResult;

@end


@implementation LocaleViewController

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.numberInOnePage = 10; //一次加载全部.
        self.textTopic = @"本地";
        
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


- (void)viewDidLoad {
    LOG_POSTION
    [super viewDidLoad];

}


//将数据读入arrayAllRecord.
- (void)getAllRecordData
{
    NSLog(@"#error - must override.")
}


- (void)reloadPostData {
    LOG_POSTION
    
    if(nil == self.arrayAllRecord) {
        [self getAllRecordData];
    }
    
    if([self.postDatas count] >= [self.arrayAllRecord count]) {
        NSLog(@"No more data.");
    }
    else {
        self.pageNumLoading ++;
        for(NSInteger idx = (self.pageNumLoading-1)* 10 ; idx < [self.arrayAllRecord count] && idx < self.pageNumLoading * 10; idx++ ) {
            
            NSDictionary *dict = [self.arrayAllRecord objectAtIndex:idx];
            NSString *jsonstring = [dict objectForKey:@"jsonstring"];
            PostData *pd = [PostData fromString:jsonstring atPage:self.pageNumLoading];
            if(pd) {
                pd.type = PostDataTypeLocal;
                [self.postDatas addObject:pd];
            }
            else {
                NSLog(@"error --- ");
            }
        }
    }
    
    [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zi条, 已加载%zi条", [self.arrayAllRecord count], [self.postDatas count]]
           andActivityIndicator:NO andDate:NO];
    
    [self postDatasToCellDataSource];
}


- (NSArray*)actionStringsOnRow:(NSInteger)row
{
    return @[@"复制", @"加入草稿", @"删除"];
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
    
    for(id obj in self.arrayAllRecord) {
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


- (void)updateThreadById:(NSInteger)tid
{
    NSLog(@"update %zd", tid);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        //获取last page的信息.
        PostData *topic = [[PostData alloc] init];
        NSMutableArray *replies = [[NSMutableArray alloc] init];
        topic = [PostData sendSynchronousRequestByThreadId:tid atPage:-1 repliesTo:replies storeAdditional:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self checkUpdateTidResult:tid withReplyPostDatas:replies andTopic:topic];
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
- (void)checkUpdateTidResult:(NSInteger)tid withReplyPostDatas:(NSArray*)replies andTopic:(PostData*)topic
{
    NSNumber *number = [NSNumber numberWithInteger:tid];
    
    if(nil == topic) {
        NSLog(@"tid [%zd] get page last error:%@", tid, @"no PostData parsed.");
        [self updateToCellData:tid withInfo:@{@"message":@"更新出错"}];
    }
    else if([replies count] <= 0){
        NSLog(@"tid [%zd] no reply", tid);
        //没有更新则不修改显示.
    }
    else {
        //跟浏览记录对比.
        PostData *tPostData = replies[0];
        NSLog(@"tid [%zd[]updateAt %lld", tid, tPostData.updatedAt);
        
        //最后一条reply信息跟之前的Loaded记录, Display记录对比.
        PostData *pdLastReply = [replies lastObject];
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
                                    [NSString stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
                [self updateToCellData:tid withInfo:@{@"message":messge}];
            }
            else if(pdLastReply.createdAt > createdAtForDisplay) {
                NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                    [NSString stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
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


//重载以定义row行为.
- (BOOL)actionOnRow:(NSInteger)row viaString:(NSString*)string
{
    BOOL finishAction = [super actionOnRow:row viaString:string];
    if(finishAction) {
        return finishAction;
    }
    
    finishAction = YES;
    PostData *postDataRow = [self.postDatas objectAtIndex:row];
    
    if([string isEqualToString:@"删除"]){
        //从collection表中删除该条记录.
        [[AppConfig sharedConfigDB] configDBCollectionDelete:@{@"id":[NSNumber numberWithInteger:postDataRow.id]}];
        
        //更新表数据源及表显示.
        [self.postDatas         removeObjectAtIndex:row];
        [self.postViewCellDatas removeObjectAtIndex:row];
        [self.arrayAllRecord    removeObjectAtIndex:row];
        [self.postView reloadData];
        
        [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zi条, 已加载%zi条", [self.arrayAllRecord count], [self.postDatas count]]
               andActivityIndicator:NO andDate:NO];
    }
    else {
        finishAction = NO;
    }
    
    return finishAction;
}


@end