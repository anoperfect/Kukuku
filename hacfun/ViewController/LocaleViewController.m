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
//        self.numberInOnePage = 10; //一次加载全部.
        self.textTopic = @"本地";
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"refresh";
        actionData.imageName    = @"refresh";
        [self actionAddData:actionData];
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


- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    return 10;
}


- (void)reloadPostData {
    LOG_POSTION
    
    if(nil == self.arrayAllRecord) {
        [self getAllRecordData];
    }
    
    if([self numberOfPostDatasTotal] >= [self.arrayAllRecord count]) {
        NSLog(@"No more data.");
    }
    else {
        NSMutableArray *appendPostDatas = [[NSMutableArray alloc] init];
        
        //一次全部加载.
        for(NSInteger idx = (self.pageNumLoading-1)* 1000 ; idx < [self.arrayAllRecord count] && idx < self.pageNumLoading * 1000; idx++ ) {
            
            NSDictionary *dict = [self.arrayAllRecord objectAtIndex:idx];
            NSString *jsonstring = [dict objectForKey:@"jsonstring"];
            PostData *pd = [PostData fromString:jsonstring atPage:self.pageNumLoading];
            if(pd) {
                pd.type = PostDataTypeLocal;
                [appendPostDatas addObject:pd];
            }
            else {
                NSLog(@"error --- ");
            }
        }
                 
        [self addPostDatas:appendPostDatas onPage:self.pageNumLoading];
        
    }
    
    [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zi条, 已加载%zi条", [self.arrayAllRecord count], [self numberOfPostDatasTotal]]
           andActivityIndicator:NO andDate:NO];
    
    [self postDatasToCellDataSource];
}


- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @[@"复制", @"加入草稿", @"删除"];
}


- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    DetailViewController *vc = [[DetailViewController alloc]init];

    NSInteger tid = postData.tid;
    NSLog(@"tid = %zi", tid);
    [vc setPostTid:tid withData:postData];
    
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
    for(PostViewDataPage *postViewDataPage in self.postViewDataPages) {
        for(NSMutableDictionary *dictm in postViewDataPage.postViewDatas) {
            [dictm setObject:@"更新中" forKey:@"otherInfo"];
        }
    }
    
    [self.postView reloadData];
    
    for(id obj in self.arrayAllRecord) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"#error not expected class %@", obj);
            break;
        }
        
        NSDictionary *dict = obj;
        NSNumber *number = dict[@"tid"];
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
        topic = [PostData sendSynchronousRequestByTid:tid atPage:-1 repliesTo:replies storeAdditional:nil];
        
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
    
    for(PostViewDataPage *postViewDataPage in self.postViewDataPages) {
        for(NSMutableDictionary *dictm in postViewDataPage.postViewDatas) {
            PostData *postData = [dictm objectForKey:@"postdata"];
            if(tid == postData.tid) {
                NSLog(@"find in ");
                
                [dictm setObject:message forKey:@"otherInfo"];
                
                found = YES;
                break;
            }
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
        BOOL isComparedOK = false;
        DetailHistory *detailHistory = [[AppConfig sharedConfigDB] configDBDetailHistoryGetByTid:tid];
        if(detailHistory) {
            
        }
        else {
            detailHistory = [[DetailHistory alloc] init];
            detailHistory.tid = tid;
            detailHistory.createdAtForDisplay = 0;
            detailHistory.createdAtForLoaded  = 0;
        }
        
        if(!(detailHistory.createdAtForLoaded > 0 && detailHistory.createdAtForDisplay > 0)) {
            NSLog(@"#error - tid [%zd] read detail history failed.", tid);
            [self updateToCellData:tid withInfo:@{@"message":@"比较数据出错"}];
        }
        else {
            isComparedOK = YES;
            
            if(pdLastReply.createdAt > detailHistory.createdAtForLoaded) {
                NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                    [NSString stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
                [self updateToCellData:tid withInfo:@{@"message":messge}];
            }
            else if(pdLastReply.createdAt > detailHistory.createdAtForDisplay) {
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
- (BOOL)actionForRowAtIndexPath:(NSIndexPath*)indexPath viaString:(NSString*)string
{
    BOOL finishAction = [super actionForRowAtIndexPath:indexPath viaString:string];
    if(finishAction) {
        return finishAction;
    }
    
    finishAction = YES;
    PostDataPage *postDataPage = self.postDataPages[indexPath.section];
    PostData *postDataRow = postDataPage.postDatas[indexPath.row];
    
    PostViewDataPage *postViewDataPage = self.postViewDataPages[indexPath.section];
    //PostData *postViewDataRow = postViewDataPage.postViewDatas[indexPath.row];
    
    if([string isEqualToString:@"删除"]){
        
        [self removeRecordsWithTids:@[[NSNumber numberWithInteger:postDataRow.tid]]];
        
        //更新表数据源及表显示.
        [postDataPage.postDatas                         removeObjectAtIndex:indexPath.row];
        [postViewDataPage.postViewDatas removeObjectAtIndex:indexPath.row];
        [self.arrayAllRecord                            removeObjectAtIndex:indexPath.row];
        
        //更新该扇区.
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.postView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        NSInteger number = [self numberOfPostDatasTotal];
        [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zi条, 已加载%zi条", [self.arrayAllRecord count], number]
               andActivityIndicator:NO andDate:NO];
    }
    else {
        finishAction = NO;
    }
    
    return finishAction;
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    NSLog(@"#error - should be override.");
}

@end