//
//  DetailViewController.m
//  hacfun
//
//  Created by Ben on 15/7/20.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "CategoryViewController.h"
#import "FuncDefine.h"
#import "CreateViewController.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"


@interface DetailViewController ()

@property (assign,nonatomic) NSInteger tid;
@property (nonatomic, strong) Category *category;

@property (strong,nonatomic) PostData *topic;
@property (nonatomic,strong) NSMutableDictionary *threadsInfo;

//@property (assign,nonatomic) NSInteger idCollection;
//@property (assign,nonatomic) NSInteger idPo;
//@property (assign,nonatomic) BOOL bPo;
//@property (assign,nonatomic) NSInteger idReply;


//记录加载的最新回复.
@property (nonatomic, assign) long long createdAtForLoaded1;

//记录浏览的最新回复.
@property (nonatomic, assign) long long createdAtForDisplay1;

@property (nonatomic, strong) DetailHistory *detailHistory;


//记录加载或者浏览的最新回复是否有更新. 以执行是否更新存储.
@property (nonatomic, assign) BOOL isDatailHistoryUpdated;

@property (nonatomic, assign) BOOL isOnlyShowPo;

@property (nonatomic, assign) BOOL pageDescMode;


@property (nonatomic,strong)  NSMutableDictionary *parseAddtional;


@end

@implementation DetailViewController


//在init注册观察者
-(instancetype) init
{
    if (self = [super init]) {
        
//        [self addObserver:self
//               forKeyPath:@"idCollection"
//                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                  context:nil];
//        
//        [self addObserver:self
//               forKeyPath:@"idPo"
//                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                  context:nil];
//        
//        [self addObserver:self
//               forKeyPath:@"idReply"
//                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                  context:nil];
        
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"more";
        actionData.imageName    = @"more";
        [self actionAddData:actionData];
        
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"reply";
        actionData.imageName    = @"reply";
        [self actionAddData:actionData];
        
//        actionData = [[ButtonData alloc] init];
//        actionData.keyword      = @"收藏";
//        actionData.imageName    = @"collection";
//        [self actionAddData:actionData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFromCreateReplyFinish:) name:@"CreateReplyFinish" object:nil];
        self.isDatailHistoryUpdated = NO;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    LOG_POSTION
    [super viewWillAppear:animated];
    //获取加载记录和浏览记录. (只记录加载记录和浏览记录的最大值.)
    DetailHistory *detailHistory = [[AppConfig sharedConfigDB] configDBDetailHistoryGetByTid:self.tid];
    if(detailHistory) {
        self.detailHistory = detailHistory;
    }
    else {
        self.detailHistory = [[DetailHistory alloc] init];
        self.detailHistory.tid = self.tid;
        self.detailHistory.createdAtForDisplay = 0;
        self.detailHistory.createdAtForLoaded = 0;
    }
    
    NSLog(@"Detail history get : %@", self.detailHistory);
}


- (void)viewWillDisappear:(BOOL)animated
{
    if(self.isDatailHistoryUpdated) {
        NSLog(@"Detail history [%zd] update to : %@", self.tid, self.detailHistory);
        [[AppConfig sharedConfigDB] configDBDetailHistoryUpdate:self.detailHistory];
    }
    else {
        NSLog(@"Detail history [%zd] do not need to update to store.", self.tid);
    }
    
    [super viewWillDisappear:animated];
}


- (void)reloadFromCreateReplyFinish:(NSNotification*)notification {
    [self actionViaString:@"lastpage"];
}


- (void)setDetailedTid:(NSInteger)tid onCategory:(Category*)category withData:(PostData*)postDataTopic
{
    self.tid = tid;
    self.category = category;
    self.textTopic =[NSString stringWithFormat:@"No.%zi", self.tid];
    if(postDataTopic) {
        self.topic = [postDataTopic copy];
    }
    else {
        self.topic = [PostData fromOnlyTid:tid];
    }
    
    PostDataPage *postDataPage = [[PostDataPage alloc] init];
    postDataPage.page = 0;
    postDataPage.section = 0;
    postDataPage.postDatas = [NSMutableArray arrayWithObject:self.topic];
    
    [self.postDataPages addObject:postDataPage];
    
}


- (void)toLastPage {
    LOG_POSTION
    
}


- (void)actionViaString:(NSString*)string
{
    NSLog(@"action string : %@", string);
    

    
    if([string isEqualToString:@"reply"]) {
        [self createReplyPost];

#if 0
        CGFloat width = 100;
        CGFloat height = 180;
        CGRect frame = CGRectMake(0, 0, width, height);
        frame = CGRectOffset(frame, self.view.frame.size.width - width, 0);
        
        ViewContainer *view = [[ViewContainer alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        [self zoomIn1:view andAnimationDuration:0.6];
        
        [self showPopupView:view];
#endif
        
        return;
    }
    
    if([string isEqualToString:@"收藏"]) {
        [self hiddenToolBar];
        [self collection];
        
        return;
    }
    
    if([string isEqualToString:@"加载全部"]) {
        [self hiddenToolBar];
        [self showProgressText:[NSString stringWithFormat:@"开始加载全部回复"] inTime:2.0];
        
        [self downloadAllDetail];
        
        return;
    }
    
    if([string isEqualToString:@"停止加载全部"]) {
        [self hiddenToolBar];
        [self showProgressText:[NSString stringWithFormat:@"停止自动加载全部回复"] inTime:1.0];
        [self stopDownloadAllDetail];
        
        return ;
    }
    
    if([string isEqualToString:@"onlyShowPo"] && !self.isOnlyShowPo){
        [self hiddenToolBar];
        [self showIndicationText:@"当前为只看Po模式" inTime:2.0];
        
        self.isOnlyShowPo = YES;
#if 0
        NSArray *indexPaths = [self indexPathsPostData];
        for(NSIndexPath *indexPath in indexPaths) {
            PostData *postData = [self postDataOnIndexPath:indexPath];
            if([postData.uid isEqualToString:self.topic.uid]) {
                [self unfoldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
            }
            else {
                [self foldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
            }
        }
#endif
        [self.postView reloadData];
        
        return ;
    }
    
    if([string isEqualToString:@"onlyShowPo"] && self.isOnlyShowPo){
        [self hiddenToolBar];
        [self showIndicationText:@"已关闭只看Po模式" inTime:2.0];
        
        self.isOnlyShowPo = NO;
#if 0
        NSArray *indexPaths = [self indexPathsPostData];
        for(NSIndexPath *indexPath in indexPaths) {
            [self unfoldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
        }
#endif
        [self.postView reloadData];
        
        return ;
    }
    
    if([string isEqualToString:@"lastpage"]) {
        [self hiddenToolBar];
        
        if(self.pageSize > 0) {
            [self showIndicationText:@"加载最后一页" inTime:2.0];
            self.pageDescMode = YES;
            [self refreshPostDataToPage:self.pageSize];
        }
        else {
            [self showIndicationText:@"未加载到详细回复信息" inTime:1.0];
        }
        
        return ;
    }
    
    [super actionViaString:string];
}


- (NSArray*)toolData
{
    LOG_POSTION
    NSMutableArray *toolDatas = [[NSMutableArray alloc] init];
    
    ButtonData *actionData = nil;
    
    actionData = [[ButtonData alloc] init];
    actionData.keyword      = @"收藏";
    actionData.imageName    = @"collection";
    [toolDatas addObject:actionData];
    
    actionData = [[ButtonData alloc] init];
    actionData.keyword      = @"lastpage";
    actionData.imageName    = @"lastpage";
    [toolDatas addObject:actionData];
    
    if(!self.autoRepeatDownload) {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"加载全部";
        actionData.imageName    = @"loadall";
        [toolDatas addObject:actionData];
    }
    else {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"停止加载全部";
        actionData.imageName    = @"loadall";
        actionData.triggerOn    = YES;
        [toolDatas addObject:actionData];
    }
    
    if(!self.isOnlyShowPo) {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"onlyShowPo";
        actionData.imageName    = @"folding";
        [toolDatas addObject:actionData];
    }
    else {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"onlyShowPo";
        actionData.imageName    = @"folding";
        actionData.triggerOn    = YES;
        [toolDatas addObject:actionData];
    }
    
    NSLog(@"---%zd", toolDatas.count);
    
    return [NSArray arrayWithArray:toolDatas];
}


//定制PostView显示的时候的类型.
- (ThreadDataToViewType)postViewPresendTypeOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    if(indexPath.section == 0 && indexPath.row == 0) {
        return ThreadDataToViewTypeAdditionalInfoUseReplyCount;
    }
    else {
        return ThreadDataToViewTypeInfoUseNumber;
    }
}


//显示之前的特殊定制.
- (void)retreatPostViewDataAdditional:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath
{
    if([postData.uid isEqualToString:self.topic.uid]) {
        [postData.postViewData setObject:@YES forKey:@"uidUnderLine"];
        [postData.postViewData setObject:@YES forKey:@"uidBold"];
    }
    
    if(self.isOnlyShowPo) {
        if([postData.uid isEqualToString:self.topic.uid]) {
            
        }
        else {
            [postData updatePostViewDataViaAddFoldInfo:@"只看Po"];
        }
    }
    else {
        if([postData.uid isEqualToString:self.topic.uid]) {
            
        }
        else {
            [postData updatePostViewDataViaRemoveFoldInfo:@"只看Po"];
        }
    }
}


- (void)createReplyPost {
    [self presentCreateViewControllerWithReferenceId:0];
}


- (void)collection {
    if(!self.topic) {
        [self showIndicationText:@"主题未加载成功" inTime:3.0];
        return;
    }
    
    //查看是否已经收藏过.
    Collection *collection = [[AppConfig sharedConfigDB] configDBCollectionGetByTid:self.tid];
    NSLog(@"collection : %@", collection);
    if(collection) {
        NSLog(@"duplicate");
        [self showIndicationText:@"该主题已收藏" inTime:2.0];
        return;
    }
    
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
    //使用msec.
    long long collectedAt = t * 1000.0;
    NSLog(@"111 %lld, %@", collectedAt, [NSString stringFromMSecondInterval:collectedAt andTimeZoneAdjustSecondInterval:0]);
    
    collection = [[Collection alloc] init];
    collection.tid          = self.tid;
    collection.collectedAt  = collectedAt;
    
    BOOL result = [[AppConfig sharedConfigDB] configDBCollectionAdd:collection];
    if(result) {
        [self showIndicationText:@"收藏成功" inTime:2.0];
    }
    else {
        NSLog(@"error- ");
        [self showIndicationText:@"主题收藏失败" inTime:3.0];
    }
    
    //添加record记录.
    //thread的记录设定在解析的时候保存.
}


- (void)downloadAllDetail
{
    self.autoRepeatDownload = YES;
    self.autoRepeatDownloadPages = NSIntegerMax;
    [self actionLoadMore];
}


- (void)stopDownloadAllDetail
{
    self.autoRepeatDownload = NO;
    self.autoRepeatDownloadPages = 0;
}



- (void)presentCreateViewControllerWithReferenceId:(NSInteger)referenceId {
    CreateViewController *vc = [[CreateViewController alloc] init];
    NSString *originalContent = nil;
    if(referenceId > 0) {
        originalContent = [NSString stringWithFormat:@">>No.%zd\n", referenceId];
    }
    [vc setCreateCategory:self.category replyTid:self.tid withOriginalContent:originalContent];
    
    [self.navigationController pushViewController:vc animated:YES];
}


//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    return host.numberInDetailPage;
}


- (NSString*)getDownloadUrlString {
    NSLog(@"numberLoaded : %zd", self.numberLoaded);
    NSLog(@"pageNumLoading : %zd", self.pageNumLoading);
    
    //上一次加载满一个page的话, 才可以加载下一个page.
    if(self.numberLoaded == [self numberExpectedInPage:self.pageNumLoading]) {
        self.pageNumLoading ++;
    }
    
    NSString *urlString = [[AppConfig sharedConfigDB] generateRequestURL:@"v2/topic/getTopicReplyPage"
                                                             andArgument:@{
                                                                           @"page":[NSNumber numberWithInteger:self.pageNumLoading],
                                                                           @"pageSize":@20,
                                                                           @"topicId":[NSNumber numberWithInteger:self.tid]
                                                                           }];
    return urlString;
    
    
#if 0
    if(self.pageNumLoading != -1) {
        NSString *urlString = [NSString stringWithFormat:@"%@/t/%zi?page=%zi", self.host.host, self.tid, self.pageNumLoading];
        NSLog(@"urlString : %@", urlString);
        return urlString;
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"%@/t/%zi?page=last", self.host.host, self.tid];
        NSLog(@"urlString : %@", urlString);
        return urlString;
    }
#endif
}


- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    NSInteger tidReference = postData.tid;
    NSLog(@"tidReference = %zi", tidReference);
    [self presentCreateViewControllerWithReferenceId:tidReference];
}


- (NSInteger)parseAddtionalGetPageSize
{
    NSArray *xpathSize = @[
                       @{@"totalPage":[NSDictionary class]},
                       ];
    
    NSNumber *pageSizeNumber = [FuncDefine objectParseFromDict:self.parseAddtional WithXPath:xpathSize];
    if([pageSizeNumber isKindOfClass:[NSNumber class]]) {
        return [pageSizeNumber integerValue];
    }
    else {
        return NSNotFound;
    }
}


- (id)parseAddtionalGetPage
{
    NSArray *xpathPage = @[
                           @{@"page":[NSDictionary class]},
                           ];
    
    id pageObject = [FuncDefine objectParseFromDict:self.parseAddtional WithXPath:xpathPage];
    return pageObject;
}


- (void)parseAdditionalInfo
{
    NSLog(@"parseAdditionalInfo : %@", [NSString stringFromNSDictionary:self.parseAddtional]);
    self.pageSize = [self parseAddtionalGetPageSize];
    if(self.pageSize == NSNotFound) {
        NSLog(@"#errror - Detail Additonal : update pageSize not found.");
    }
    else {
        NSLog(@"Detail Additonal : update pageSize to %zd.", self.pageSize);
    }
    
    id pageObject = [self parseAddtionalGetPage];
    if(pageObject == nil) {
        NSLog(@"#errror - Detail Additonal : update pageSize not found.");
    }
    else {
        NSLog(@"Detail Additonal : update page to %@.", pageObject);
    }
    
    if(self.pageNumLoading == -1) {
        if([pageObject isEqual:@"last"] || [pageObject isEqual:[NSNumber numberWithInteger:self.pageSize]]) {
            self.pageNumLoading = self.pageSize;
            NSLog(@"Detail Additonal : page (last) checked.");
        }
        else {
            NSLog(@"#errror - Detail Additonal : page (last) checked error.");
        }
        
        self.pageNumLoading = self.pageSize;
        NSLog(@"Detail Additonal : update pageNumLoading to %zd.", self.pageNumLoading);
    }
    else {
        if([pageObject isEqual:[NSNumber numberWithInteger:self.pageNumLoading]]) {
            NSLog(@"Detail Additonal : page (%zd) checked.", self.pageNumLoading);
        }
        else {
            NSLog(@"#errror - Detail Additonal : page (%zd) checked error.", self.pageNumLoading);
        }
    }
}


- (NSMutableArray*)parseDownloadedData:(NSData*)data
{
    LOG_POSTION
    
    self.parseAddtional = [[NSMutableDictionary alloc] init];
    NSMutableArray *replies = [[NSMutableArray alloc] init];
    PostData *topic = [PostData parseFromDetailedJsonData:data atPage:self.pageNumLoading repliesTo:replies storeAdditional:self.parseAddtional onHostName:self.host.hostname];
    if(!topic) {
        NSLog(@"#error - parseFromDetailedJsonData failed.");
        return nil;
    }
    
    [self parseAdditionalInfo];
    
    //查看是否需更新主题.
    //确认主题内容是否更新. 更新的话需保存主题的高度. 否则在主题不显示在屏幕的时候导致当前页面显示的原cell移动.
    if(!self.topic) {
        NSLog(@"previous no topic, then add.")
        self.topic = topic;
        PostDataPage *postDataPage = [[PostDataPage alloc] init];
        postDataPage.page = 0;
        [postDataPage.postDatas addObject:self.topic];
        
        [self.postDataPages insertObject:postDataPage atIndex:0];
        
        NSLog(@"threads added");
    }
    else {
        if([topic isEqual:self.topic]) {
            NSLog(@"topic not updated.");
        }
        else {
            NSLog(@"topic updated");
            topic.optimumSizeHeight = self.topic.optimumSizeHeight;
            [self updateDataSourceByPostData:topic];
        }
    }
    
    return replies;
}

//override.
//将刷新页得到的数据append到UITable的数据源时的行为. 可重写用于去重, 加页栏, 屏蔽等行为.
- (NSMutableArray*)parsedPostDatasRetreat:(NSMutableArray*)parsedPostDatas onPage:(NSInteger)page
{
    if(!parsedPostDatas) {
        return nil;
    }
    
    if(self.postDataPages.count == 0) {
        return [NSMutableArray arrayWithArray:parsedPostDatas];
    }
    
    PostDataPage *postDataPage = [self.postDataPages lastObject];
    if(postDataPage.page != page) {
        NSLog(@"it's new page. add all.");
        return [NSMutableArray arrayWithArray:parsedPostDatas];
    }
    
    NSMutableArray *retreatedPostDatas = [[NSMutableArray alloc] init];
    NSInteger numOfReply = 0;
    NSInteger numDuplicate = 0;
    
    self.topic.bTopic = YES;
    self.topic.mode = 1;
    NSMutableIndexSet *removeIndexSet = [[NSMutableIndexSet alloc] init];
    NSInteger index = 0;
    
    for(PostData* pd in parsedPostDatas) {
        
        if([pd isIdInArray:postDataPage.postDatas]) {
            numDuplicate ++;
            [removeIndexSet addIndex:index];
        }
        else {
            numOfReply ++;
            [retreatedPostDatas addObject:pd];
        }
        
        index ++;
    }
    
    return retreatedPostDatas;
}


- (void)layoutCell: (UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath withPostData:(PostData *)postData
{
//    [cell.layer removeAllAnimations];
    NSLog(@"row at : %@", indexPath);
    PostView *postView = (PostView*)[cell viewWithTag:TAG_PostView];
//    cell.backgroundColor = postView.backgroundColor;
    [postView setBackgroundColor:[UIColor whiteColor]];
    
    [postView.layer removeAllAnimations];
    
    CALayer *border = [CALayer layer];
    if(0 == indexPath.section && 0 == indexPath.row) {
        border.backgroundColor = [[UIColor colorWithName:@"DetailPostViewTopicBorder"] CGColor];
        float borderHeight = 1.0;
        border.frame = CGRectMake(0.0f,
                                  postView.frame.size.height-borderHeight,
                                  postView.frame.size.width,
                                  borderHeight);
    }
    else {
        border.backgroundColor = [[UIColor colorWithName:@"DetailPostViewReplyBorder"] CGColor];
        float borderHeight = 1.0;
        border.frame = CGRectMake(0.0f,
                                  postView.frame.size.height-borderHeight,
                                  postView.frame.size.width,
                                  borderHeight);
    }
    
    [postView.layer addSublayer:border];
}


- (void)threadDisplayActionInCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    PostData *postDataRow = [self postDataOnIndexPath:indexPath];
    
    if(postDataRow && postDataRow.createdAt > self.detailHistory.createdAtForDisplay) {
        self.detailHistory.createdAtForDisplay = postDataRow.createdAt;
        NSLog(@"detail history : Display update to %lld[%@]",
                self.detailHistory.createdAtForDisplay,
                self.detailHistory.createdAtForDisplay ==0?@"0":[NSString stringFromMSecondInterval:self.detailHistory.createdAtForDisplay andTimeZoneAdjustSecondInterval:0]
              );
        self.isDatailHistoryUpdated = YES;
    }
    else {
        NSLog(@"detail history : Display not update.");
    }
}


- (void)actionAfterParseAndRefresh:(NSData *)data andPostDataParsed:(NSMutableArray *)postDataParsed andPostDataAppended:(NSMutableArray *)postDataAppended
{
    [super actionAfterParseAndRefresh:data andPostDataParsed:postDataParsed andPostDataAppended:postDataAppended];
    
    //保存最新回复CreatedAt.
    [self storeLoadedInfo];
}


- (void)storeLoadedInfo
{
    LOG_POSTION
    if([self numberOfPostDatasTotal] > 0) {
        PostData *pdLoaded = [self postDataLastObject];
        if(pdLoaded && pdLoaded.createdAt > self.detailHistory.createdAtForLoaded) {
            self.detailHistory.createdAtForLoaded = pdLoaded.createdAt;
            NSLog(@"detail history : Loaded update to %lld[%@]",
                  self.detailHistory.createdAtForLoaded,
                  self.detailHistory.createdAtForLoaded ==0?@"0":[NSString stringFromMSecondInterval:self.detailHistory.createdAtForLoaded andTimeZoneAdjustSecondInterval:0]
                  );
            self.isDatailHistoryUpdated = YES;
        }
        else {
            NSLog(@"detail history : Loaded not update.");
        }
    }
}


- (void)resetPostViewDataAdditional {
    //refresh的时候, 一直显示已有的topic.
    if(self.topic) {
        PostDataPage *postDataPage = [[PostDataPage alloc] init];
        postDataPage.page = 0;
        postDataPage.section = 0;
        [postDataPage.postDatas addObject:self.topic];
        
        [self.postDataPages addObject:postDataPage];
        
        self.pageSize = 0;
    }
}


- (NSString*)getFooterViewTitleOnStatus:(ThreadsStatus)status
{
    if(status == ThreadsStatusLoadSuccessful) {
        return [NSString stringWithFormat:@"加载成功, 已加载回复%zd条.", [self numberOfPostDatasTotal]];
    }
    
    return [super getFooterViewTitleOnStatus:status];
}


//重载以定义cell能支持的动作. NSArray成员为 NSString.
- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    PostData *postData = [self postDataOnIndexPath:indexPath];
    NSArray<NSString*> *urlStrings = [postData contentURLStrings];
    if(urlStrings.count > 0) {
        
//        return @[@"复制", @"举报", @"链接"];
        return @[@"复制", @"举报"];
    }
    else {
        return @[@"复制", @"举报"];
    }
}



- (BOOL)actionForRowAtIndexPath:(NSIndexPath*)indexPath viaString:(NSString*)string
{
    BOOL finishAction = [super actionForRowAtIndexPath:indexPath viaString:string];
    if(finishAction) {
        return finishAction;
    }
    
    finishAction = YES;
    //PostData *postDataRow = [self postDataOnIndexPath:indexPath];
    
    if([string isEqualToString:@"开启只看Po"]){
        self.isOnlyShowPo = YES;

#if 0
        NSArray *indexPaths = [self indexPathsPostData];
        for(NSIndexPath *indexPath in indexPaths) {
            PostData *postData = [self postDataOnIndexPath:indexPath];
            if(postData.uid == self.topic.uid) {
                [self unfoldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
            }
            else {
                [self foldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
            }
        }
#endif
        
        [self.postView reloadData];
        
        [self showfootViewWithTitle:[NSString stringWithFormat:@"当前为只看Po模式"]
               andActivityIndicator:NO andDate:NO];
    }
    else if([string isEqualToString:@"关闭只看Po"]){
        self.isOnlyShowPo = NO;
        
#if 0
        NSArray *indexPaths = [self indexPathsPostData];
        for(NSIndexPath *indexPath in indexPaths) {
            [self unfoldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
        }
#endif
        [self.postView reloadData];
        
        [self showfootViewWithTitle:[NSString stringWithFormat:@"已关闭只看Po模式"]
               andActivityIndicator:NO andDate:NO];
    }
    else {
        finishAction = NO;
    }
    
    return finishAction;
}


- (NSString*)headerStringOnSection:(NSInteger)section
{
    LOG_POSTION
    NSString *headerString = nil;
    
    if(self.pageDescMode) {
        PostDataPage *postDataPage = self.postDataPages[section];
        
        if(postDataPage.page == -1) {
            headerString = [NSString stringWithFormat:@"最后一页, 共%zd页.", self.pageSize];
        }
        else if(postDataPage.page == 0) {
            //不显示.
        }
        else {
            headerString = [NSString stringWithFormat:@"第%zd页, 共%zd页.", postDataPage.page, self.pageSize];
        }
    }
    else {
        //不显示.
    }
    
    return headerString;
}


- (void)headerActionOnSection:(NSInteger)section
{
    PostDataPage *postDataPage = self.postDataPages[section];
    NSInteger page = postDataPage.page;
    if(page > 1) {
        self.numberLoaded = 0;
        [self loadPage:page-1];
    }
}


- (NSInteger)numberOfPostDatasTotal
{
    NSInteger number = 0;
    
    for(PostDataPage *page in self.postDataPages) {
        if(page.page != 0) {
            number += page.postDatas.count;
        }
    }
    
    NSLog(@"self.postDataPages count : %zd", self.postDataPages.count);
    NSLog(@"numberOfPostDatasTotal : %zd", number);
    
    return number;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (void)zoomIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait
{
    __block BOOL done = wait;
    view.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        done = NO;
    }];
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}


- (void)zoomIn1: (UIView *)view andAnimationDuration: (float) duration
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    //animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [view.layer addAnimation:animation forKey:nil];
}



@end


















