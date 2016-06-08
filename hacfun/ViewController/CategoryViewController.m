//
//  CategoryViewController.m
//  hacfun
//
//  Created by Ben on 15/8/1.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "CategoryViewController.h"
#import "FuncDefine.h"
#import "CreateViewController.h"
#import "DetailViewController.h"
#import "AppConfig.h"
#import "MainVC.h"


@interface CategoryViewController ()


@property (strong,nonatomic) Category *category;
@property (nonatomic, strong) NSMutableDictionary *forumInfo;

@end

@implementation CategoryViewController

- (instancetype)init
{
    self = [super init];
    
    if(nil  != self) {
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"more";
        actionData.imageName    = @"more";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"new";
        actionData.imageName    = @"edit";
        [self actionAddData:actionData];
        
        NSLog(@"kcountObject %@ : %zd", @"PostView", [PostView countObject]);
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"main : %@", [AMSlideMenuMainViewController allInstances]);
    NSLog(@"main getInstanceForVC : %@", [AMSlideMenuMainViewController getInstanceForVC:self]);
    NSLog(@"main nvc : %@", [AMSlideMenuMainViewController getInstanceForVC:self].currentActiveNVC);
    NSLog(@"self nvc : %@", self.navigationController);
}


- (void)setCategoryPresent:(Category*)category
{
    self.category = category;
    self.textTopic = self.category.name;
    
    NSLog(@"category : %@", category);
}


- (void)actionViaString:(NSString*)string
{
    NSLog(@"action string : %@", string);
    
    if([string isEqualToString:@"refresh"]) {
        [self hiddenToolBar];
        [self refreshPostData];
        return;
    }
    
    if([string isEqualToString:@"new"]) {
        [self hiddenToolBar];
        [self createNewPost];
        return;
    }
    
    if([string isEqualToString:@"版规"]) {
        [self hiddenToolBar];
        UIWebView *view = [[UIWebView alloc] init];
        view.frame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(60, 10, 60, 10));
        [view loadHTMLString:self.category.content baseURL:nil];
        
        [self showPopupView:view];
    }
    
    if([string isEqualToString:@"load10"]) {
        [self hiddenToolBar];
        [self showProgressText:[NSString stringWithFormat:@"开始自动加载"] inTime:2.0];
        
        [self load10];
        
        return;
    }
    
    if([string isEqualToString:@"load10stop"]) {
        [self hiddenToolBar];
        [self showProgressText:[NSString stringWithFormat:@"停止自动加载"] inTime:1.0];
        [self load10stop];
        
        return ;
    }
    
    [super actionViaString:string];
}


- (void)load10
{
    self.autoRepeatDownload = YES;
    self.autoRepeatDownloadPages = 10;
    [self actionLoadMore];
}


- (void)load10stop
{
    self.autoRepeatDownload = NO;
    self.autoRepeatDownloadPages = 0;
}


- (NSArray*)toolData
{
    LOG_POSTION
    NSMutableArray *toolDatas = [[NSMutableArray alloc] init];
    
    ButtonData *actionData = nil;
    
    if(self.category.content.length > 0) {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"版规";
        actionData.imageName    = @"rule";
        [toolDatas addObject:actionData];
    }
    
    actionData = [[ButtonData alloc] init];
    actionData.keyword      = @"refresh";
    actionData.imageName    = @"refresh";
    [toolDatas addObject:actionData];
    
    if(!self.autoRepeatDownload) {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"load10";
        actionData.imageName    = @"load10";
        [toolDatas addObject:actionData];
    }
    else {
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"load10stop";
        actionData.imageName    = @"load10";
        actionData.triggerOn    = YES;
        [toolDatas addObject:actionData];
    }

    NSLog(@"---%zd", toolDatas.count);
    
    return [NSArray arrayWithArray:toolDatas];
}




- (void)createNewPost {
    CreateViewController *createViewController = [[CreateViewController alloc]init];
    [createViewController setCreateCategory:self.category replyTid:NSNotFound withOriginalContent:nil];
    
    [self.navigationController pushViewController:createViewController animated:YES];
}


//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    //kukuku是10个.
    //hacfun是20个.
    //这个配置写到配库.
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    return host.numberInCategoryPage;
}


- (NSString*)getDownloadUrlString {
    //上一次加载满一个page的话, 才可以加载下一个page.
    
    NSLog(@"&&&&&&%zd %zd", self.numberLoaded, self.pageNumLoading);
    
    if(self.numberLoaded >= [self numberExpectedInPage:self.pageNumLoading]) {
        self.pageNumLoading ++;
    }
    
    NSString *urlString = [[AppConfig sharedConfigDB] generateRequestURL:@"v2/topic/page"
                                                             andArgument:@{
                                                                           @"page":[NSNumber numberWithInteger:self.pageNumLoading],
                                                                           @"pageSize":@20,
                                                                           @"groupId":[NSNumber numberWithInteger:self.category.forum]
                                                                           }];
    return urlString;
    
    //return [NSString stringWithFormat:@"%@/%@?page=%zi", self.host.host, self.category.link, self.pageNumLoading];
}


//---override. different parse mothod.
- (NSMutableArray*)parseDownloadedData:(NSData*)data {
    NSMutableDictionary *addtional = [[NSMutableDictionary alloc] init];
    NSMutableArray *postDatas = [PostData parseFromCategoryJsonData:data atPage:self.pageNumLoading storeAdditional:addtional onHostName:self.host.hostname];
    NSLog(@"addtional : %@", addtional);
    
    NSString *key = @"forum";
    if([addtional[key] isEqual:self.forumInfo]) {
        NSLog(@"%@ info not change.", key)
    }
    else {
        NSLog(@"%@ info updated. \n%@\n%@", key, addtional[@"forum"], self.forumInfo);
        self.forumInfo = addtional[@"forum"];
    }
    
    return postDatas;
}


- (NSString*)getFooterViewTitleOnStatus:(ThreadsStatus)status
{
    if(status == ThreadsStatusLoadSuccessful) {
        return [NSString stringWithFormat:@"加载成功, 已加载%zd条.", [self numberOfPostDatasTotal]];
    }
    
    return [super getFooterViewTitleOnStatus:status];
}


- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    DetailViewController *vc = [[DetailViewController alloc]init];

    NSInteger tid = postData.tid;
    NSLog(@"tid = %zi", tid);
    [vc setDetailedTid:tid onCategory:self.category withData:postData];

    [self.navigationController pushViewController:vc animated:YES];
}


//重载以定义cell能支持的动作. NSArray成员为 NSString.
- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    PostData *postData = [self postDataOnIndexPath:indexPath];
    if(postData.recentReply.count > 0) {
        return @[@"复制", @"举报", @"最近回复"];
    }
    else {
        return @[@"复制", @"举报"]; 
    }
}


- (BOOL)actionForRowAtIndexPath:(NSIndexPath *)indexPath viaString:(NSString *)string
{
    if([super actionForRowAtIndexPath:indexPath viaString:string]) {
        return YES;
    }
    
    if([string isEqualToString:@"最近回复"]) {
        PostData *postData = [self postDataOnIndexPath:indexPath];
        
        NSLog(@"recentReply : %@", postData.recentReply);
        NSArray *postDatasRecentReply = [[AppConfig sharedConfigDB] configDBRecordGets:postData.recentReply];
        
        PostGroupView *view = [[PostGroupView alloc] init];
        CGFloat widthPercentage = 0.8;
        view.frame = CGRectMake(self.view.frame.size.width * (1-widthPercentage), 0, self.view.frame.size.width * widthPercentage, self.view.frame.size.height);
        [view appendDataOnPage:0 with:postDatasRecentReply removeDuplicate:NO andReload:YES];
        [self showPopupView:view];
        
        return YES;
    }
    
    
    return NO;
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
