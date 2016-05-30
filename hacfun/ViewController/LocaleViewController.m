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


- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    return 1000;
}


- (void)startAction
{
    [self loadPage:1];
}


- (void)loadPage:(NSInteger)page
{
    LOG_POSTION
    
    [self getLocaleRecords];
    
    NSMutableArray *appendPostDatas = [NSMutableArray arrayWithArray:self.postDatasAll];
    
    for(NSInteger index = 0; index < appendPostDatas.count; index ++) {
        NSLog(@"index%zd : %@", index, appendPostDatas[index]);
    }
    

    [self appendDataOnPage:self.pageNumLoading with:appendPostDatas removeDuplicate:NO andReload:YES];
    [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zd条, 已加载%zi条", self.allTid.count, [self numberOfPostDatasTotal]]
           andActivityIndicator:NO andDate:NO];
    
    NSLog(@"appendPostDatas %@", appendPostDatas);
}


- (void)resetPostViewDataAdditional
{
    self.allTid             = nil;
    self.concreteDatas      = nil;
    self.concreteDatasClass = nil;
}


- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @[@"复制", @"删除"];
}


- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    DetailViewController *vc = [[DetailViewController alloc]init];

    NSInteger tid = postData.tid;
    NSLog(@"tid = %zi", tid);
    [vc setDetailedTid:tid onCategory:nil withData:postData];
    
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
    NSArray *indexPaths = [self indexPathsPostData];
    for(NSIndexPath *indexPath in indexPaths) {
        [self setStatusInfoOnIndexPath:indexPath withInfo:@"更新中" andReload:NO];
    }
    
    [self.postView reloadData];
    
    for(NSNumber *tidNumber in self.allTid) {
        if(![tidNumber isKindOfClass:[NSNumber class]]) {
            NSLog(@"#error not expected class %@", tidNumber);
            break;
        }
        
        [self.updateResult setObject:[NSNumber numberWithBool:NO] forKey:tidNumber];
        [self updateThreadById:[tidNumber integerValue]];
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
    NSString *message = [info objectForKey:@"message"];
    if(![message isKindOfClass:[NSString class]]) {
        NSLog(@"#error - message not found.")
        return;
    }
    
    NSIndexPath *indexPath = [self indexPathWithTid:tid];
    if(indexPath) {
        [self setStatusInfoOnIndexPath:indexPath withInfo:message andReload:NO];
    }
    else {
        [self setStatusInfoOnTid:tid withInfo:message andReload:NO];
    }
}


//需在主线程执行.
- (void)checkUpdateTidResult:(NSInteger)tid withReplyPostDatas:(NSArray*)replies andTopic:(PostData*)topic
{
    [self updateDataSourceByPostData:topic];
    
    if(nil == topic) {
        NSLog(@"tid [%zd] get page last error:%@", tid, @"no PostData parsed.");
        [self updateToCellData:tid withInfo:@{@"message":@"更新出错"}];
    }
    else if([replies count] <= 0){
        NSLog(@"tid [%zd] no reply", tid);
        //没有回复则显示无更新.
        [self updateToCellData:tid withInfo:@{@"message":@"无更新."}];
    }
    else {
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
            NSLog(@"#error - tid [%zd] detailHistory not found.", tid);
            detailHistory = [[DetailHistory alloc] init];
            detailHistory.tid = tid;
            detailHistory.createdAtForDisplay = 0;
            detailHistory.createdAtForLoaded  = 0;
        }
        
        isComparedOK = YES;
        
        if(pdLastReply.createdAt > detailHistory.createdAtForLoaded) {
            NSLog(@"tid [%zd] atleast newest loaded timestamp updated.", tid);
            NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                [NSString stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
            [self updateToCellData:tid withInfo:@{@"message":messge}];
        }
        else if(pdLastReply.createdAt > detailHistory.createdAtForDisplay) {
            NSLog(@"tid [%zd] latest displayed timestamp updated.", tid);
            NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                [NSString stringFromMSecondInterval:pdLastReply.createdAt andTimeZoneAdjustSecondInterval:0]];
            [self updateToCellData:tid withInfo:@{@"message":messge}];
        }
        else {
            //没有更新则不修改显示.
            NSLog(@"tid [%zd] no update.", tid);
            NSString *messge = [NSString stringWithFormat:@"无更新."];
            [self updateToCellData:tid withInfo:@{@"message":messge}];
        }
    }
    
    NSIndexPath *indexPath = [self indexPathWithTid:tid];
    if(indexPath) {
        
        if([self.indexPathsDisplaying indexOfObject:indexPath] != NSNotFound) {
            NSLog(@"update indexPath [%@] for tid [%zd]", [NSString stringFromTableIndexPath:indexPath], tid);
            [self.postView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
            NSLog(@"update indexPath [%@] for tid [%zd], current not update.", [NSString stringFromTableIndexPath:indexPath], tid);
        }
    }
    else {
        NSLog(@"#error - update indexPath tid [%zd] not found.", tid);
    }
    
#if 0
    NSNumber *number = [NSNumber numberWithInteger:tid];
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
        NSLog(@"update finished.");
        [self.postView reloadData];
    }
    else {
        NSLog(@"update not finished. %@", self.updateResult);
    }
#endif
}


//重载以定义row行为.
- (BOOL)actionForRowAtIndexPath:(NSIndexPath*)indexPath viaString:(NSString*)string
{
    BOOL finishAction = [super actionForRowAtIndexPath:indexPath viaString:string];
    if(finishAction) {
        return finishAction;
    }
    
    finishAction = YES;

    PostData *postDataRow = [self postDataOnIndexPath:indexPath];
    if([string isEqualToString:@"删除"]){
        
        LOG_POSTION
        [self removeRecordsWithTids:@[[NSNumber numberWithInteger:postDataRow.tid]]];
        LOG_POSTION
        
        self.allTid = nil;
        [self refreshPostData];
    }
    else {
        finishAction = NO;
    }
    
    return finishAction;
}


//override. 获取本地记录数据.
- (void)getLocaleRecords
{
    NSLog(@"#error - should be override.");
}


//定制PostView显示的时候的类型.
- (ThreadDataToViewType)postViewPresendTypeOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    return ThreadDataToViewTypeInfoUseReplyCount;
}

//显示之前的特殊定制.
- (void)retreatPostViewDataAdditional:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath
{
    
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    NSLog(@"#error - should be override.");
}

@end