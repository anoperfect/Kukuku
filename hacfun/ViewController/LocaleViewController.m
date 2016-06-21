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
@property (nonatomic, strong, readwrite) NSMutableDictionary *updateResult; //not use. 之前是全部更新完成后刷新, 修改为单条刷新.
@property (nonatomic, strong) NSMutableArray *updateTask; //not use. 之前是全部更新完成后刷新, 修改为单条刷新.
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, NSNumber*> *tidUpdatedAt; //not use. 之前是全部更新完成后刷新, 修改为单条刷新.
@property (nonatomic, assign) BOOL onUpdate;

@property (nonatomic, strong) NSMutableArray *autoLoadOnlyTidThreadTasks;




@end


@implementation LocaleViewController

- (instancetype)init {
    
    self = [super init];
    if(self) {
//        self.numberInOnePage = 10; //一次加载全部.
        self.textTopic = @"本地";
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"checkupdate";
        actionData.imageName    = @"checkupdate";
        [self actionAddData:actionData];
    }
    
    return self;
}


- (void)viewDidLoad {
    LOG_POSTION
    [super viewDidLoad];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"xxxxxxxxx");
    
    
    
}


- (void)startAction
{
    [self refreshPostData];
}


- (void)autoActionAfterRefreshPostData
{
    [self loadLocalData];
}


- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    return 1000;
}


- (void)loadLocalData
{
    [self showfootViewWithTitle:[NSString stringWithFormat:@"加载数据中."] andActivityIndicator:YES andDate:NO];
    
    //直接执行导致上一句footView不显示.
    dispatch_async(dispatch_get_main_queue(), ^{
        //继承类需在此接口中完成self.postDataPages的填写.
        [self getLocaleRecords];
        
        [self postViewReload];
        self.threadsStatus = ThreadsStatusLoadSuccessful;
        
        [self showfootViewWithTitle:[NSString stringWithFormat:@"已加载%zi条", [self numberOfPostDatasTotal]]
               andActivityIndicator:NO andDate:NO];
        
        [self autoLoadOnlyTidThread];
    });
}


- (void)autoLoadOnlyTidThread
{
    self.autoLoadOnlyTidThreadTasks = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(PostData *postData, NSIndexPath *indexPath, BOOL *stop) {
        if(postData.type == PostDataTypeOnlyTid) {
            [self.autoLoadOnlyTidThreadTasks addObject:[NSNumber numberWithInteger:postData.tid]];
            
            __weak typeof(self) _self = self;
            [self reloadThreadByTid:postData.tid
                             onPage:-1
                            success:^(PostData *topic, NSArray *replies) {
                                [_self updateDataSourceByPostData:topic];
                                [_self.autoLoadOnlyTidThreadTasks removeObject:[NSNumber numberWithInteger:postData.tid]];
                                if(_self.autoLoadOnlyTidThreadTasks.count == 0) {
                                    NSLog(@"LocalViewController : finish autoLoadOnlyTidThread. then postViewReload.");
                                    [_self postViewReload];
                                }
                            }
                            failure:^(NSError *error) {
                                [_self.autoLoadOnlyTidThreadTasks removeObject:[NSNumber numberWithInteger:postData.tid]];
                                if(_self.autoLoadOnlyTidThreadTasks.count == 0) {
                                    NSLog(@"LocalViewController : finish autoLoadOnlyTidThread. then postViewReload.");
                                    [_self postViewReload];
                                }
                            }
             ];
        }
    }];
}


- (void)stopCheckUpdate
{
    [HTTPMANAGE.operationQueue cancelAllOperations];
    for(NSNumber *tidNumber in self.updateResult.allKeys) {
        if([[self.updateResult objectForKey:tidNumber] isEqualToString:@"更新中"]) {
            [self.updateResult setObject:@"更新停止" forKey:tidNumber];
        }
    }
    
    [self postViewReload];
}


- (void)resetPostViewDataAdditional
{
    self.allTid             = nil;
    self.concreteDatas      = nil;
    self.concreteDatasClass = nil;
}


- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    PostData *postData = [self postDataOnIndexPath:indexPath];
    NSArray<NSString*> *urlStrings = [postData contentURLStrings];
    postData = nil;
    urlStrings = nil;
    
    NSMutableArray *arrayM = [self actionStringsForRowAtIndexPathStaple:indexPath];
    [arrayM addObject:@"删除"];
    return [NSArray arrayWithArray:arrayM];
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
    if([string isEqualToString:@"checkupdate"]) {
        if(!self.onUpdate) {
            [self checkUpdate];
            self.onUpdate = YES;
            
            //修改选择为取消.
//            [self actionRemoveDataByKeyString:@"checkupdate"];
            [self actionClear];
            //[self actionRefresh];
            
            ButtonData *actionData = nil;
            
            actionData = [[ButtonData alloc] init];
            actionData.keyword      = @"stopcheckupdate";
            actionData.imageName    = @"stopcheckupdate";
            [self actionAddData:actionData];
            [self actionRefresh];
            
            return ;
        }
        else {
            [self showIndicationText:@"请等待上次刷新完成" inTime:2.0];
            return ;
        }
    }
    
    if([string isEqualToString:@"stopcheckupdate"]) {
        [self stopCheckUpdate];
        self.onUpdate = NO;
        
        //修改选择为刷新.
//        [self actionRemoveDataByKeyString:@"stopcheckupdate"];
        [self actionClear];
        //[self actionRefresh];
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"checkupdate";
        actionData.imageName    = @"checkupdate";
        [self actionAddData:actionData];
        [self actionRefresh];
    }
}


- (void)checkUpdate
{
    //将所有需更新的tid记录.
    self.updateResult = [[NSMutableDictionary alloc] init];
    self.updateTask = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(PostData *postData, NSIndexPath *indexPath, BOOL * stop) {
        [self.updateTask addObject:[NSNumber numberWithInteger:postData.tid]];
        [self setStatusInfoOnIndexPath:indexPath withInfo:@"更新中" andReload:NO];
        
        //设置一点延迟时间. 否则showProgressText可能部分不显示.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateThreadById:postData.tid];
        });
    }];
    
    [self.postView reloadData];
    [self showProgressText:[NSString stringWithFormat:@"检查更新中, 剩余%zd条", self.updateTask.count] inTime:60.0];
    NSLog(@"finish checkupdate command.");
}





- (void)updateThreadById:(NSInteger)tid
{
    NSLog(@"tid [%zd] start updateThreadById", tid);
    
    __weak typeof(self) _self = self;
    [self reloadThreadByTid:tid
                    onPage:-1
                   success:^(PostData* topic, NSArray* replies){
                       [_self checkUpdateTidResult:tid withReplyPostDatas:replies andTopic:topic];
                   }
                   failure:^(NSError * error) {
                       [_self checkUpdateTidResult:tid withReplyPostDatas:nil andTopic:nil];
                   }
     ];
}


//将数据更新到用于cell显示的data.
- (void)updateToCellData:(NSInteger)tid withInfo:(NSDictionary*)info
{
    NSLog(@"tid [%zd] updateToCellData", tid);
    NSString *message = [info objectForKey:@"message"];
    if(![message isKindOfClass:[NSString class]]) {
        NSLog(@"#error - message not found.")
        return;
    }
    
    [self.updateResult setObject:message forKey:[NSNumber numberWithInteger:tid]];
    NSLog(@"rty : updateResult count : %zd", self.updateResult.count);
}


//需在主线程执行.
- (void)checkUpdateTidResult:(NSInteger)tid withReplyPostDatas:(NSArray*)replies andTopic:(PostData*)topic
{
    //return ;
    
    NSLog(@"tid [%zd] checkUpdateTidResult", tid);
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
        
        //最新一条reply信息跟之前的Loaded记录, Display记录对比.
        //replies可能是顺序,可能是反序. 直接比较.
        PostData *pdLastReply = nil;
        
        for(PostData *pd in replies) {
            if(pd.tid > pdLastReply.tid) {
                pdLastReply = pd;
            }
        }
        
        NSLog(@"tid [%zd] last reply createdAt : %lld.", tid, pdLastReply.createdAt);
        long long comparedTimestamp = pdLastReply.createdAt;
        
        if(comparedTimestamp > detailHistory.createdAtForLoaded) {
            NSLog(@"tid [%zd] atleast newest loaded timestamp updated.", tid);
            NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                [NSString stringFromRelativeDescriptorOfDateForMSec:comparedTimestamp]];
            [self updateToCellData:tid withInfo:@{@"message":messge}];
        }
        else if(comparedTimestamp > detailHistory.createdAtForDisplay) {
            NSLog(@"tid [%zd] latest displayed timestamp updated.", tid);
            NSString *messge = [NSString stringWithFormat:@"更新于%@",
                                [NSString stringFromRelativeDescriptorOfDateForMSec:comparedTimestamp]];
            [self updateToCellData:tid withInfo:@{@"message":messge}];
        }
        else {
            //没有更新则不修改显示.
            NSLog(@"tid [%zd] no update.", tid);
            NSString *messge = [NSString stringWithFormat:@"无更新."];
            [self updateToCellData:tid withInfo:@{@"message":messge}];
        }
    }
    
//频繁的刷新单行, 导致界面卡顿. 另导致出现蜜汁闪退.
#if 0
    NSIndexPath *indexPath = [self indexPathWithTid:tid];
    if(indexPath) {
        if([self.indexPathsDisplaying indexOfObject:indexPath] != NSNotFound) {
            NSLog(@"tid [%zd] update indexPath %@", tid, [NSString stringFromTableIndexPath:indexPath]);
            [self postViewReloadRow:indexPath];
        }
        else {
            NSLog(@"tid [%zd] update indexPath %@, current not update.", tid, [NSString stringFromTableIndexPath:indexPath]);
        }
    }
    else {
        NSLog(@"#error - tid [%zd] update indexPath  not found.", tid);
    }
#endif
    
    NSLog(@"tid [%zd] check finish.", tid);
    
    NSNumber *number = [NSNumber numberWithInteger:tid];
    [self.updateTask removeObject:number];
    
    if(self.updateTask.count == 0) {
        self.onUpdate = NO;
        NSLog(@"tid [%zd] update finished.", tid);
        
        [self showProgressText:@"检查更新完成" inTime:2.0];
        NS0Log(@"rty%@", self.updateResult);
        [self postViewReload];
        
        //修改选择为刷新.
        [self actionClear];
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"checkupdate";
        actionData.imageName    = @"checkupdate";
        [self actionAddData:actionData];
        [self actionRefresh];
    }
    else {
        NSLog(@"tid [%zd] update not finished.", tid);
        [self showProgressText:[NSString stringWithFormat:@"检查更新中, 剩余%zd条", self.updateTask.count] inTime:60.0];
    }
}


- (void)threadDisplayActionInCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
//    //修改为当cell显示的时候开始执行刷新.
//    if(self.onUpdate) {
//        PostData *postData = [self postDataOnIndexPath:indexPath];
//        
//        //用updateTask标记以防止重复添加任务.
//        if(NSNotFound != [self.updateTask indexOfObject:[NSNumber numberWithInteger:postData.tid]]) {
//            NSLog(@"tid [%zd] update status to refreshing.", postData.tid);
//            [self setStatusInfoOnIndexPath:indexPath withInfo:@"更新中" andReload:YES];
//        
//            NSLog(@"tid [%zd] start update.", postData.tid);
//            [self updateThreadById:postData.tid];
//        }
//    }
}


//重载以定义row行为.
- (BOOL)actionForRowAtIndexPath:(NSIndexPath*)indexPath viaString:(NSString*)string
{
    BOOL finishAction = [super actionForRowAtIndexPath:indexPath viaString:string];
    if(finishAction) {
        return finishAction;
    }
    
    finishAction = YES;

    if([string isEqualToString:@"删除"]){
        
        LOG_POSTION
        [self removeRecordsWithIndexPath:indexPath];
        LOG_POSTION
        
        self.allTid = nil;
        
        [self startAction];
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
    NSString *message = [self.updateResult objectForKey:[NSNumber numberWithInteger:postData.tid]];
    if([message isKindOfClass:[NSString class]]) {
        [postData.postViewData setObject:message forKey:@"statusInfo"];
    }
}


- (void)removeRecordsWithIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"#error - should be override.");
}


@end