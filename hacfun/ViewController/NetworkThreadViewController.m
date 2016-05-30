//
//  NetworkThreadViewController.m
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import "NetworkThreadViewController.h"
#import "FuncDefine.h"
#import "AppConfig.h"
@interface NetworkThreadViewController ()





@end



@implementation NetworkThreadViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.autoRepeatDownload = NO;
}


- (void)startAction
{
    //显示Loading.
    self.threadsStatus = ThreadsStatusLoading;
    [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:YES andDate:NO];
    [self loadPage:1];
}


- (void)loadPage:(NSInteger)page
{
    self.threadsStatus = ThreadsStatusLoading;
    [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:YES andDate:NO];
    [self setBackgroundDownloadPage:page];
}


- (void)actionLoadMore
{
    LOG_POSTION
    
    //显示Loading.
    self.threadsStatus = ThreadsStatusLoading;
    [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:YES andDate:NO];
    [self setBackgroundDownloadPageMore];
}


- (NSString*)getDownloadUrlString {
    return @"need to be re-defined.";
}

//开始下载第page.
- (void)setBackgroundDownloadPage:(NSInteger)page
{
    NSLog(@"setBackgroundDownloadPage : %zd", page);
    self.pageNumLoading = page;
    self.numberLoaded = 0;
    
    [self setBackgroundDownload];
}


//根据当前记录,
- (void)setBackgroundDownloadPageMore
{
    PostDataPage *postDataPage = [self.postDataPages lastObject];
    if(postDataPage) {
        if(postDataPage.page > 0) {
            if(postDataPage.postDatas.count >= [self numberExpectedInPage:self.pageNumLoading]) {
                self.pageNumLoading = postDataPage.page + 1;
                self.numberLoaded = 0;
            }
            else {
                self.pageNumLoading = postDataPage.page;
                self.numberLoaded = 0;
            }
        } //Detail会用到page0用于topic.
        else {
            self.pageNumLoading = 1;
            self.numberLoaded = 0;
        }
    }
    else {
        self.pageNumLoading = 1;
        self.numberLoaded = 0;
    }
    
    [self setBackgroundDownload];
}


- (void)setBackgroundDownload {
    NSString *str = [self getDownloadUrlString];
    NSLog(@"threads download str=%@", str);
    
    //    NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url=[[NSURL alloc] initWithString:str];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    mutableRequest.HTTPMethod = @"GET";
    NSLog(@"url:%@", url);
    NS0Log(@"Request : \n\n%@\n\n", mutableRequest);
    
    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    self.jsonData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NS0Log(@"%@已经接收到数据%s", [NSThread currentThread], __FUNCTION__);
    
    [self.jsonData appendData:data];
    //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    NS0Log(@"connection data : %@", [[NSString alloc] initWithData:self.jsonData encoding:NSUTF8StringEncoding]);
    [self parseAndFresh:self.jsonData onPage:self.pageNumLoading];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
    [self parseAndFresh:nil onPage:self.pageNumLoading];
}


//---override. different parse mothod.
- (NSMutableArray*)parseDownloadedData:(NSData*)data {
    return nil;
}


- (void)parseAndFresh:(NSData*)data onPage:(NSInteger)page{
    self.boolRefresh = NO;
    
    LOG_POSTION
    
    NSMutableArray *appendPostDatas = nil;
    NSMutableArray* parsedPostDatas = [self parseDownloadedData:data];
    self.numberLoaded = parsedPostDatas.count;
    if(nil == parsedPostDatas) {
        NSLog(@"xxxxxx parse json error \n%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
        self.threadsStatus = ThreadsStatusLoadFailed;
        [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:NO andDate:NO];
    }
    else if(0 == [parsedPostDatas count]) {
        NSLog(@"xxxxxx no more new data");
        self.threadsStatus = ThreadsStatusLoadNoMoreData;
        [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:NO andDate:NO];
    }
    else {
        if(-1 == page) {
            page = self.pageSize;
        }
        
        appendPostDatas = [self parsedPostDatasRetreat:parsedPostDatas onPage:page];
        NSLog(@"parsed : %zd, after retreated append : %zd.", parsedPostDatas.count, appendPostDatas.count);
        
        if(appendPostDatas.count <= 0) {
            NSLog(@"xxxxxx no more new data");
            self.threadsStatus = ThreadsStatusLoadNoMoreData;
            [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:NO andDate:NO];
        }
        else {
            [self appendDataOnPage:page with:appendPostDatas removeDuplicate:NO andReload:YES];
            self.threadsStatus = ThreadsStatusLoadSuccessful;
            self.pageNumLoaded = self.pageNumLoading;
            [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:NO andDate:YES];
        }
    }
    
    //根据刷新的原因分类. 1.栏目刷新. 2.加载. 3.下拉刷新.
    self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新完成"];
    [self.refresh endRefreshing];
    
    [self actionAfterParseAndRefresh:data andPostDataParsed:parsedPostDatas andPostDataAppended:appendPostDatas];
}


- (void)actionAfterParseAndRefresh:(NSData*)data
                 andPostDataParsed:(NSMutableArray*)postDataParsed
               andPostDataAppended:(NSMutableArray*)postDataAppended
{
    //关于自动下载.
    //停止自动下载.
    if(postDataAppended.count <= 0) {
        if(self.autoRepeatDownload) {
            self.autoRepeatDownload = NO;
            //[self showIndicationText:@"获取数据失败. 自动加载停止."];
        }
    }
    else {
        if([self isLastPage]) {
            NSLog(@"last page.");
            if(self.autoRepeatDownload) {
                self.autoRepeatDownload = NO;
                //[self showIndicationText:@"加载完成. 自动加载停止."];
            }
        }
        else {
            NSLog(@"not last page.");

        }
    }
}


@end
