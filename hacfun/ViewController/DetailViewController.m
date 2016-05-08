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
#import "AppConfig.h"
#import "PopupView.h"
#import "PostDataCellView.h"


@interface DetailViewController ()

@property (assign,nonatomic) NSInteger tid;

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
        
//        actionData = [[ButtonData alloc] init];
//        actionData.keyword      = @"more";
//        actionData.imageName    = @"more";
//        [self actionAddData:actionData];
        
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"reply";
        actionData.imageName    = @"reply";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"收藏";
        actionData.imageName    = @"collection";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"加载全部";
        actionData.imageName    = @"loadall";
        [self actionAddData:actionData];
        
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
    LOG_POSTION
}


- (void)setPostTid:(NSInteger)tid withData:(PostData *)postDataTopic
{
    self.tid = tid;
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
    
    if([string isEqualToString:@"more"]) {
        
        NSInteger number = 6;
        
        CGFloat widthButton = 100;
        CGFloat heightButton = 36;
        
        UIView *buttonsContainer = [[UIView alloc] init];
        buttonsContainer.frame = CGRectMake(self.view.bounds.size.width - widthButton, 0, widthButton, number * heightButton + 10);
        buttonsContainer.backgroundColor = [UIColor whiteColor];
        
        PushButton *button = [[PushButton alloc] init];
        button.frame = CGRectMake(0, 0, widthButton, heightButton);
        
        
        ButtonData *actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"收藏";
        actionData.imageName    = @"collection";
        [button setActionData:actionData];
        
        [buttonsContainer addSubview:button];
        
        [self showPopupView:buttonsContainer];
        
        return;
    }
    
    
    
    
    if([string isEqualToString:@"reply"]) {
#if 1
//        [self createReplyPost];
        self.navigationController.toolbarHidden = NO;
#else
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
        [self collection];
        return;
    }
    
    if([string isEqualToString:@"加载全部"]) {
        
#if 0
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"将加载全部回复信息" message:@"将加载全部信息" delegate:self
    cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
#endif
        
        [self showIndicationText:[NSString stringWithFormat:@"开始加载全部回复"]];
        [self downloadAllDetail];
        return;
    }
}


- (NSMutableDictionary*)cellPresentDataFromPostData:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"-=-=-= %zd-%zd", indexPath.section, indexPath.row);
    
    NSMutableDictionary *dict = [super cellPresentDataFromPostData:postData onIndexPath:indexPath];
    if([self numberOfPostDatasTotal] >= 1) {
        PostData *topic = self.topic;
        PostData *postData = [self postDataOnIndexPath:indexPath];
        
        if(indexPath.section == 0 || [postData.uid isEqualToString:topic.uid]) {
            [dict setObject:[UIColor blueColor] forKey:@"colorUidSign"];
        }
        
        //统一显示No.
        [dict setObject:[NSString stringWithFormat:@"No.%zd", postData.tid] forKey:@"info"];
        //信息部分显示NO. 主题显示回复数+NO.
        if(indexPath.section == 0 && indexPath.row == 0) {
            //主题增加附加显示信息.
            [dict setObject:[NSString stringWithFormat:@"回应 : %zd", postData.replyCount] forKey:@"otherInfo"];
        }
        
    }
    else {
        NSLog(@"no post data.");
    }
    
    return dict;
}


- (void)createReplyPost {
    [self presentCreateViewControllerWithReferenceId:0];
}


- (void)collection {
    if(!self.topic) {
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"主题未加载成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
        return;
    }
    
    //查看是否已经收藏过.
    Collection *collection = [[AppConfig sharedConfigDB] configDBCollectionGetByTid:self.tid];
    NSLog(@"collection : %@", collection);
    if(collection) {
        
        NSLog(@"duplicate");
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"该主题已收藏";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
        
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
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"收藏成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
    else {
        NSLog(@"error- ");
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"主题收藏失败";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
    
    //添加record记录.
    //thread的记录设定在解析的时候保存.
}


- (void)downloadAllDetail
{
    self.autoRepeatDownload = YES;
    [self reloadPostData];
}


- (void)presentCreateViewControllerWithReferenceId:(NSInteger)referenceId {
    CreateViewController *vc = [[CreateViewController alloc] init];
    if(referenceId == 0) {
        [vc setReplyId:self.tid];
    }
    else {
        [vc setReplyId:self.tid withReference:referenceId];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    return host.numberInDetailPage;
}


- (NSString*)getDownloadUrlString {
    //上一次加载满一个page的话, 才可以加载下一个page.
    if(self.numberLoaded == [self numberExpectedInPage:self.pageNumLoading]) {
        self.pageNumLoading ++;
    }
    
    return [NSString stringWithFormat:@"%@/t/%zi?page=%zi", self.host.host, self.tid, self.pageNumLoading];
}


- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    NSInteger tidReference = postData.tid;
    NSLog(@"tidReference = %zi", tidReference);
    [self presentCreateViewControllerWithReferenceId:tidReference];
}


- (NSMutableArray*)parseDownloadedData:(NSData*)data
{
    LOG_POSTION
    
    NSMutableDictionary *addtional = [[NSMutableDictionary alloc] init];
    NSMutableArray *replies = [[NSMutableArray alloc] init];
    PostData *topic = [PostData parseFromDetailedJsonData:data atPage:self.pageNumLoading repliesTo:replies storeAdditional:addtional];
    if(!topic) {
        return nil;
    }
    
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
    
    //检查附属信息是否更新.
    NSString *key = @"threads";
    if([addtional[key] isEqual:self.threadsInfo]) {
        NSLog(@"%@ info not change.", key)
    }
    else {
        self.threadsInfo = addtional[key];
        NSLog(@"%@ info updated.", key);
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
    PostDataCellView *cellView = (PostDataCellView*)[cell viewWithTag:TAG_PostDataCellView];
//    cell.backgroundColor = cellView.backgroundColor;
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    [cellView.layer removeAllAnimations];
    
    CALayer *border = [CALayer layer];
    if(0 == indexPath.section && 0 == indexPath.row) {
        border.backgroundColor = [[UIColor colorWithName:@"DetailCellTopicBorder"] CGColor];
        float borderHeight = 1.0;
        border.frame = CGRectMake(0.0f,
                                  cellView.frame.size.height-borderHeight,
                                  cellView.frame.size.width,
                                  borderHeight);
    }
    else {
        border.backgroundColor = [[UIColor colorWithName:@"DetailCellReplyBorder"] CGColor];
        float borderHeight = 1.0;
        border.frame = CGRectMake(0.0f,
                                  cellView.frame.size.height-borderHeight,
                                  cellView.frame.size.width,
                                  borderHeight);
    }
    
    [cellView.layer addSublayer:border];
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
    
    //自动加载的时候的提示信息.
    if(self.autoRepeatDownload) {
        if(![self isLastPage]) {
            [self showIndicationText:[NSString stringWithFormat:@"已加载第%zd页, 共%zd条.", self.pageNumLoaded, [self numberOfPostDatasTotal] - 1]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadPostData];
            });
        }
    }
    
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


- (void)clearDataAdditional {
    //refresh的时候, 一直显示已有的topic.
    if(self.topic) {
        PostDataPage *postDataPage = [[PostDataPage alloc] init];
        postDataPage.page = 0;
        postDataPage.section = 0;
        [postDataPage.postDatas addObject:self.topic];
        
        [self.postDataPages addObject:postDataPage];
    }
}


- (NSString*)getFooterViewTitleOnStatus:(ThreadsStatus)status
{
    if(status == ThreadsStatusLoadSuccessful) {
        return [NSString stringWithFormat:@"加载成功, 已加载回复%zd条.", [self numberOfPostDatasTotal] - 1 ];
    }
    
    return [super getFooterViewTitleOnStatus:status];
}


//重载以定义cell能支持的动作. NSArray成员为 NSString.
- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(0 == indexPath.section) {
        if(!self.isOnlyShowPo) {
            return @[@"复制", @"举报", @"开启只看Po", @"链接"];
        }
        else {
            return @[@"复制", @"举报", @"关闭只看Po", @"链接"];
        }
    }
    else {
        return @[@"复制", @"举报", @"链接"];
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
        
        [self.postView reloadData];
        
        [self showfootViewWithTitle:[NSString stringWithFormat:@"当前为只看Po模式"]
               andActivityIndicator:NO andDate:NO];
    }
    else if([string isEqualToString:@"关闭只看Po"]){
        self.isOnlyShowPo = NO;
        
        NSArray *indexPaths = [self indexPathsPostData];
        for(NSIndexPath *indexPath in indexPaths) {
            [self unfoldCellOnIndexPath:indexPath withInfo:@"只看Po" andReload:NO];
        }
        
        [self.postView reloadData];
        
        [self showfootViewWithTitle:[NSString stringWithFormat:@"已关闭只看Po模式"]
               andActivityIndicator:NO andDate:NO];
    }
    else {
        finishAction = NO;
    }
    
    return finishAction;
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


















