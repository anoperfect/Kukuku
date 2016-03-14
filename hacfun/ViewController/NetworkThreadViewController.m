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



- (void)reloadPostData{
    LOG_POSTION
    
    //显示Loading.
    [self showfootViewWithTitle:NSSTRING_LOADING andActivityIndicator:YES andDate:NO];
    [self setBackgroundDownload];
}


- (NSString*)getDownloadUrlString {
    return @"need to be re-defined.";
}


- (void)setBackgroundDownload {
    
    NSString *str = [self getDownloadUrlString];
    NSLog(@"str=%@", str);
    
    //    NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url=[[NSURL alloc] initWithString:str];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    mutableRequest.HTTPMethod = @"GET";
    NS0Log(@"str:%@", str);
    NSLog(@"url:%@", url);
    NS0Log(@"Request : \n\n%@\n\n", mutableRequest);
    
    //    NSDictionary *dict = [mutableRequest allHTTPHeaderFields];
    //    NSLog(@"Request dict: \n\n%@\n\n", dict);
    
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
    [self parseAndFresh:self.jsonData];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
    [self parseAndFresh:nil];
}


//---override. different parse mothod.
- (NSMutableArray*)parseDownloadedData:(NSData*)data {
    return [PostData parseFromCategoryJsonData:data];
}


- (void)parseAndFresh:(NSData*)data {
    [self dismissLoadingView];
    self.boolRefresh = NO;
    
    NSMutableArray* parsedPostDatas = [self parseDownloadedData:data];
    if(nil == parsedPostDatas) {
        NSLog(@"xxxxxx parse json error \n%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
        [self showfootViewWithTitle:NSSTRING_LOAD_FAILED andActivityIndicator:NO andDate:NO];
        
        self.status = ThreadsStatusLoadFailed;
    }
    else if(0 == [parsedPostDatas count]) {
        NSLog(@"xxxxxx no more new data");
        [self showfootViewWithTitle:NSSTRING_NO_MORE_DATA andActivityIndicator:NO andDate:NO];
        self.status = ThreadsStatusLoadFailed;
    }
    else {
        NSInteger numAdd = [self appendParsedPostDatas:parsedPostDatas];
        if(numAdd <= 0) {
            NSLog(@"xxxxxx no more new data");
            [self showfootViewWithTitle:NSSTRING_NO_MORE_DATA andActivityIndicator:NO andDate:NO];
        }
        else {
            NSLog(@"------ reload to count : %zi", self.postDatas.count);
            [self postDatasToCellDataSource];
            [self.postView reloadData];
            [self.postView setHidden:NO];
            [self showfootViewWithTitle:NSSTRING_LOAD_SUCCESSFUL andActivityIndicator:NO andDate:YES];
        }
        self.status = ThreadsStatusLoadFinish;
    }
    
    //根据刷新的原因分类. 1.栏目刷新. 2.加载. 3.下拉刷新.
    self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新完成"];
    [self.refresh endRefreshing];
}


- (void)showLoadingView {
    if(!self.viewLoading) {
        self.viewLoading = [[UIView alloc]initWithFrame:self.view.frame];
        [self.viewLoading setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
        [self.viewLoading setBackgroundColor:[AppConfig backgroundColorFor:@"LoadingView"]];
        [self.viewLoading setAlpha:0.8];
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        [activityIndicatorView setTag:1];
        [self.viewLoading addSubview:activityIndicatorView];
        [activityIndicatorView setCenter:self.viewLoading.center];
    }
    
    [self.view addSubview:self.viewLoading];
    UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self.viewLoading viewWithTag:1];
    [activityIndicatorView startAnimating];
    
    [self.view bringSubviewToFront:self.viewLoading];
    
}


- (void)dismissLoadingView {
    if(self.viewLoading) {
        
        [self.viewLoading removeFromSuperview];
        UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self.viewLoading viewWithTag:1];
        [activityIndicatorView stopAnimating];
        
        [self.view sendSubviewToBack:self.viewLoading];
    }
}







@end
