//
//  PostDataCellViewLoad.m
//  hacfun
//
//  Created by Ben on 15/9/3.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostDataCellViewLoad.h"
#import "FuncDefine.h"
#import "AppConfig.h"




@interface PostDataCellViewLoad ()

@property (assign,nonatomic) NSInteger threadId;
@property (strong,nonatomic) NSMutableData *jsonData;

@end



@implementation PostDataCellViewLoad




- (id)initWithFrame:(CGRect)frame andThreadId:(NSInteger)id {
    
    self = [super initWithFrame:frame];
    
    self.threadId = id;
//    [self setPostDataInitThreadId:self.threadId];
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] init];
    [view setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:view];
    [view startAnimating];
    
    [self setBackgroundDownload];
    
    return self;
}


- (NSString*)getDownloadUrlString {
    return [NSString stringWithFormat:@"%@/t/%zi", [[AppConfig sharedConfigDB] configDBGet:@"host"], self.threadId];
}


- (void)setBackgroundDownload {
    NSString *str = [self getDownloadUrlString];
    
    NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    mutableRequest.HTTPMethod = @"GET";
    NS0Log(@"str:%@", str);
    NSLog(@"url:%@", url);
    NSLog(@"Request : \n\n%@\n\n", mutableRequest);
    
    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    
    self.jsonData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NSLog(@"%@已经接收到数据%s", [NSThread currentThread], __FUNCTION__);
    
    [self.jsonData appendData:data];
    //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    [self parseAndFresh:self.jsonData];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
    [self parseAndFresh:nil];
}


- (void)parseAndFresh:(NSData*)data {
#if 0
    PostData *postData = [self parseFromJsonData:data];
    if(nil == postData) {
        NSLog(@"加载失败");
//        [self.labelText setText:@"加载失败."];
    }
    else {
//        [self.labelText setHidden:YES];
        
        NSLog(@"OK.");
        postData.mode = 2;
        [self setPostData:[postData toCellUsingDataWithId] inRow:0];
    }
#endif
}


- (PostData*)parseFromJsonData:(NSData*)jsonData {
    return [PostData parseFromThreadJsonData:jsonData];
}






@end
