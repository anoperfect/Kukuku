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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFromCreateReplyFinish:) name:@"CreateReplyFinish" object:nil];
    }
    
    return self;
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


- (NSMutableArray*)getButtonDatas {
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    ButtonData *data ;
    data = [[ButtonData alloc] init];
    data.keyword = @"reply";
    data.id = 'p';
    data.superId = 0;
    data.image = @"reply";
    data.title = @"";
    data.method = 1;
    data.target = self;
    data.sel = @selector(createReplyPost);
    [ary addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"收藏";
    data.id = 's';
    data.superId = 0;
    data.image = @"";
    data.title = @"收藏";
    data.method = 2;
    data.target = self;
    data.sel = @selector(collection);
    [ary addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"more";
    data.id = 'm';
    data.superId = 0;
    data.image = @"more";
    data.title = @"";
    data.method = 1;
    data.target = self;
//    data.sel = @selector(addToPost);
    [ary addObject:data];
    
    return ary;
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
                [dict setObject:[NSString stringWithFormat:@"<b>%@</b>", [dict objectForKey:@"title"]] forKey:@"title"];
            }
            
            //信息部分显示NO. 主题显示回复数+NO.
            if(index == 0) {
                [dict setObject:[NSString stringWithFormat:@"[%@]No.%@", [dict objectForKey:@"replyCount"], [dict objectForKey:@"id"]] forKey:@"info"];
                NSLog(@"%@", [dict objectForKey:@"info"]);
            }
            else {
                [dict setObject:[NSString stringWithFormat:@"No.%@", [dict objectForKey:@"id"]] forKey:@"info"];
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
    
#if 0
    //执行收藏.
    /* 保存json文件. */
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.topicDictObj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
//    if(!([jsonData length] > 0 && error == nil)){
//        NSLog(@"error : ------");
//        return NO;
//    }
    
    NSString *jsonstring = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
#endif
    
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
    
#if 0
    //添加record记录.
    NSDictionary *infoInsertRecord = @{
                                           @"id":[NSNumber numberWithInteger:self.threadId],
                                           @"threadId":[NSNumber numberWithInteger:self.threadId],
                                           @"createdAt":[NSNumber numberWithLongLong:self.topic.createdAt],
                                           @"updatedAt":[NSNumber numberWithLongLong:self.topic.updatedAt],
                                           @"jsonstring":jsonstring
                                           };
    
    result = [[AppConfig sharedConfigDB] configDBRecordInsertOrReplace:infoInsertRecord];
    if(CONFIGDB_EXECUTE_OK == result) {
        
    }
    else {
        NSLog(@"error- ");
    }
#endif
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
    [cell.layer removeAllAnimations];
    
    NSLog(@"row at : %zi", row);
    PostDataCellView *cellView = (PostDataCellView*)[cell viewWithTag:100];
//    cell.backgroundColor = cellView.backgroundColor;
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    [cellView.layer removeAllAnimations];
    
    float borderHeight = 0.3;
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0.0f, cellView.frame.size.height-borderHeight, cellView.frame.size.width, borderHeight);
    border.backgroundColor = [[UIColor blueColor] CGColor];
    if(0 == row) {
        border.backgroundColor = [[UIColor redColor] CGColor];
    }
    
    [cellView.layer addSublayer:border];
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















