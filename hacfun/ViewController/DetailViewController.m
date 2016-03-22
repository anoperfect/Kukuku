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

@property (assign,nonatomic) NSInteger threadId;

@property (strong,nonatomic) PostData *topic;
@property (strong,nonatomic) NSDictionary *topicDictObj;

//@property (assign,nonatomic) NSInteger idCollection;
//@property (assign,nonatomic) NSInteger idPo;
//@property (assign,nonatomic) BOOL bPo;
//@property (assign,nonatomic) NSInteger idReply;


//记录加载的最新回复.
@property (nonatomic, assign) long long createdAtForLoaded;

//记录浏览的最新回复.
@property (nonatomic, assign) long long createdAtForDisplay;

//记录加载或者浏览的最新回复是否有更新. 以执行是否更新存储.
@property (nonatomic, assign) BOOL isDatailHistoryUpdated;


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
        actionData.keyword  = @"reply";
        actionData.image    = @"reply";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"收藏";
//        actionData.image    = @"edit";
        [self actionAddData:actionData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFromCreateReplyFinish:) name:@"CreateReplyFinish" object:nil];
        self.isDatailHistoryUpdated = NO;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    LOG_POSTION
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取加载记录和浏览记录. (只记录加载记录和浏览记录的最大值.)
    NSDictionary *dictDatailHistory = [[AppConfig sharedConfigDB] configDBDetailHistoryQuery:@{@"id":[NSNumber numberWithInteger:self.threadId]}];
    NSLog(@"%@", dictDatailHistory);
    if(dictDatailHistory) {
        id obj;
        
        obj = [dictDatailHistory objectForKey:@"createdAtForLoaded"];
        //#...obj的class类型怎么对不上.
//        if(obj && [obj isKindOfClass:[NSNumber class]]) {
        if(obj) {
            self.createdAtForLoaded = [(NSNumber*)obj longLongValue];
        }
        
        obj = [dictDatailHistory objectForKey:@"createdAtForDisplay"];
//        if(obj && [obj isKindOfClass:[NSNumber class]]) {
        if(obj) {
            self.createdAtForDisplay = [(NSNumber*)obj longLongValue];
        }
    }
    
    NSLog(@"Detail history [%zd] get : %lld[%@], %lld[%@]",
          self.threadId,
          self.createdAtForLoaded,
          self.createdAtForLoaded  ==0?@"0":[FuncDefine stringFromMSecondInterval:self.createdAtForLoaded  andTimeZoneAdjustSecondInterval:0],
          self.createdAtForDisplay,
          self.createdAtForDisplay ==0?@"0":[FuncDefine stringFromMSecondInterval:self.createdAtForDisplay andTimeZoneAdjustSecondInterval:0]
          );
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Detail history [%zd] set : %lld[%@], %lld[%@]",
          self.threadId,
          self.createdAtForLoaded,
          self.createdAtForLoaded  ==0?@"0":[FuncDefine stringFromMSecondInterval:self.createdAtForLoaded  andTimeZoneAdjustSecondInterval:0],
          self.createdAtForDisplay,
          self.createdAtForDisplay ==0?@"0":[FuncDefine stringFromMSecondInterval:self.createdAtForDisplay andTimeZoneAdjustSecondInterval:0]
          );
    
    if(self.isDatailHistoryUpdated) {
        NSDictionary *infoInsert = @{
                                     @"id":[NSNumber numberWithInteger:self.threadId],
                                     @"createdAtForLoaded":[NSNumber numberWithLongLong:self.createdAtForLoaded],
                                     @"createdAtForDisplay":[NSNumber numberWithLongLong:self.createdAtForDisplay],
                                     };
        
        NSInteger result = [[AppConfig sharedConfigDB] configDBDetailHistoryInsert:infoInsert countBeReplaced:YES];
        NSLog(@"%@ result : %zd", @"configDBDetailHistoryInsert", result);
    }
    else {
        NSLog(@"Detail history [%zd] do not need to update to store.", self.threadId);
    }
    
    [super viewWillDisappear:animated];
}


- (void)reloadFromCreateReplyFinish:(NSNotification*)notification {
    LOG_POSTION
    
    /* 保存json文件. */
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array firstObject];
    
    NSString *jsonCacheFolder =
    [NSString stringWithFormat:@"%@/%@/JsonCache", documentPath, [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    [[NSFileManager defaultManager] createDirectoryAtPath:jsonCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *pathJsonCache = [NSString stringWithFormat:@"%@/collection_%08zi.json", jsonCacheFolder, self.topic.id];
    
    [self.jsonData writeToFile:pathJsonCache atomically:YES];
    
    //纪录发帖记录.
    NSDictionary *dict = [notification userInfo];
    NSLog(@"create reply no : %@", [dict objectForKey:@"no"]);
    
    [self reloadPostData];
}


- (void) setPostThreadId:(NSInteger)id {
    self.threadId = id;
    self.textTopic =[NSString stringWithFormat:@"No.%zi", self.threadId];
}


- (void)toLastPage {
    LOG_POSTION
    
}


- (void)actionViaString:(NSString*)string
{
    NSLog(@"action string : %@", string);
    if([string isEqualToString:@"reply"]) {
        [self createReplyPost];
        return;
    }
    
    if([string isEqualToString:@"收藏"]) {
        [self collection];
        return;
    }
}


- (void)postDatasToCellDataSource {
    LOG_POSTION
    
    //在ThreadsViewController的解析基础上修改.
    [super postDatasToCellDataSource];
    
    NSInteger count = [self.postDatas count];
    if(count >= 1) {
        
        PostData *topic = [self.postDatas objectAtIndex:0];
        NSInteger index = 0;
        for(PostData *pd in self.postDatas) {
            NSMutableDictionary *dict = (NSMutableDictionary*)[self.postViewCellDatas objectAtIndex:index];
            
            //Po的主题及回复 title 加粗.
            if([pd.uid isEqualToString:topic.uid]) {
//                [dict setObject:[NSString stringWithFormat:@"<b>%@</b>", [dict objectForKey:@"title"]] forKey:@"title"];
                [dict setObject:[UIColor blueColor] forKey:@"colorUid"];
            }
            
            //统一显示No.
            [dict setObject:[NSString stringWithFormat:@"No.%@", [dict objectForKey:@"id"]] forKey:@"info"];
            //信息部分显示NO. 主题显示回复数+NO.
            if(index == 0) {
                //主题增加附加显示信息.
//                [dict setObject:[NSString stringWithFormat:@"[%@]No.%@", [dict objectForKey:@"replyCount"], [dict objectForKey:@"id"]] forKey:@"info"];
                NSString *infoAdditionalOriginal = [dict objectForKey:@"infoAdditional"];
                [dict setObject:[NSString stringWithFormat:@"%@ 回应:%@", infoAdditionalOriginal?infoAdditionalOriginal:@"", [dict objectForKey:@"replyCount"]]
                         forKey:@"infoAdditional"];
                NSLog(@"%@", [dict objectForKey:@"infoAdditional"]);
            }
            else {
//                [dict setObject:[NSString stringWithFormat:@"No.%@", [dict objectForKey:@"id"]] forKey:@"info"];
//                NSLog(@"%@", [dict objectForKey:@"info"]);
            }
            
            index ++;
        }
    }
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
    NSDictionary* infoQuery = @{@"id":[NSNumber numberWithInteger:self.threadId],
                                @"threadId":[NSNumber numberWithInteger:self.threadId]};
    NSArray* queryArray = [[AppConfig sharedConfigDB] configDBCollectionQuery:infoQuery];
    if([queryArray count] > 0) {
        
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
    
    NSDate *collectionDate = [NSDate date];
    NSInteger interval = [collectionDate timeIntervalSince1970];
    
    NSInteger result ;
    NSDictionary *infoInsertCollection = @{
                                 @"id":[NSNumber numberWithInteger:self.threadId],
                                 @"collectedAt":[NSNumber numberWithLongLong:(long long)interval]
                                 };
    
    result = [[AppConfig sharedConfigDB] configDBCollectionInsert:infoInsertCollection];
    if(CONFIGDB_EXECUTE_OK == result) {
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


- (void)presentCreateViewControllerWithReferenceId:(NSInteger)referenceId {
    CreateViewController *vc = [[CreateViewController alloc] init];
    if(referenceId == 0) {
        [vc setReplyId:self.threadId];
    }
    else {
        [vc setReplyId:self.threadId withReference:referenceId];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numInOnePage {
#define NUM_IN_PAGE 20
    return NUM_IN_PAGE;
}


- (NSString*)getDownloadUrlString {
    NSInteger count = [self.postDatas count];
    NSInteger pageNum = count==0?1:((count-1)/[self numInOnePage] + 1);
    return [NSString stringWithFormat:@"%@/t/%zi?page=%zi", self.host, self.threadId, pageNum];
}


- (void)didSelectRow:(NSInteger)row {
    NSInteger referenceId = ((PostData*)[self.postDatas objectAtIndex:row]).id;
    NSLog(@"referenceId = %zi", referenceId);
    [self presentCreateViewControllerWithReferenceId:referenceId];
}


- (NSMutableArray*)parseDownloadedData:(NSData*)data {
    NSMutableArray *postDatasArray = [PostData parseFromDetailedJsonData:data];
    return postDatasArray;
}


//---override. pretreat before append to self.postDatas.
- (NSInteger)parsePostDatasPretreat:(NSMutableArray*)parsedPostDatasArray {
   
    PostData *topic = [[parsedPostDatasArray objectAtIndex:0] copy];
    NSInteger numOfReply = 0;
    NSInteger numDuplicate = 0;
    
    //[parsedPostDatasArray removeAllObjects];
    
    if(!self.topic) {
        self.topic = topic;
        numOfReply ++;
        NSLog(@"threads added");
    }
    else {
        if([topic isEqual:self.topic]) {
            NSLog(@"threads not updated.");
        }
        else {
            self.topic = topic;
            NSLog(@"threads updated");
            [self.postDatas replaceObjectAtIndex:0 withObject:topic];
            
        }
    }
    
    self.topic.bTopic = YES;
    self.topic.mode = 1;
    NSMutableIndexSet *removeIndexSet = [[NSMutableIndexSet alloc] init];
    NSInteger index = 0;
    for(PostData* pd in parsedPostDatasArray) {
        
        if([pd isIdInArray:self.postDatas]) {
            numDuplicate ++;
            //[parsedPostDatasArray removeObject:pd];
            [removeIndexSet addIndex:index];
        }
        else {
            numOfReply ++;
        }
        
        index ++;
    }
    
    [parsedPostDatasArray removeObjectsAtIndexes:removeIndexSet];

    return numOfReply;
}


- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData *)postData{
//    [cell.layer removeAllAnimations];
    
    NSLog(@"row at : %zi", row);
    PostDataCellView *cellView = (PostDataCellView*)[cell viewWithTag:TAG_PostDataCellView];
//    cell.backgroundColor = cellView.backgroundColor;
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    [cellView.layer removeAllAnimations];
    
    CALayer *border = [CALayer layer];
    if(0 == row) {
        border.backgroundColor = [[UIColor redColor] CGColor];
        float borderHeight = 1.0;
        border.frame = CGRectMake(0.0f,
                                  cellView.frame.size.height-borderHeight,
                                  cellView.frame.size.width,
                                  borderHeight);
    }
    else {
        border.backgroundColor = [HexRGBAlpha(0x000011, 0.2) CGColor];
        float borderHeight = 1.0;
        border.frame = CGRectMake(0.0f,
                                  cellView.frame.size.height-borderHeight,
                                  cellView.frame.size.width,
                                  borderHeight);
    }
    
    [cellView.layer addSublayer:border];
}


- (void)threadDisplayActionInCell:(UITableViewCell*)cell withRow:(NSInteger)row
{
    PostData *pdDisplay = self.postDatas[row];
    if(pdDisplay && pdDisplay.createdAt > self.createdAtForDisplay) {
        self.createdAtForDisplay = pdDisplay.createdAt;
        NSLog(@"detail history : display update to %lld[%@]",
                self.createdAtForDisplay,
                self.createdAtForDisplay ==0?@"0":[FuncDefine stringFromMSecondInterval:self.createdAtForDisplay andTimeZoneAdjustSecondInterval:0]
              );
        self.isDatailHistoryUpdated = YES;
    }
    else {
        NSLog(@"detail history : display not update.");
    }
}


- (void)clearDataAdditional {
    self.topic = nil;
    self.topicDictObj = nil;
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



@end















