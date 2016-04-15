//
//  ReferencePopupView.m
//  hacfun
//
//  Created by Ben on 15/8/9.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ReferencePopupView.h"
#import "FuncDefine.h"
#import "AppConfig.h"
#import "PostData.h"
#import "PostDataCellView.h"

#define X_CENTER(v, mx) { CGRect frameOriginal = v.frame; CGFloat width = v.superview.frame.size.width - 2.0 * mx ; width = width > 0 ? width : 0; [v setFrame: CGRectMake(mx, frameOriginal.origin.y, width, frameOriginal.size.height)]; }


@interface ReferencePopupView ()

@property (assign,nonatomic) NSInteger threadId;
@property (strong,nonatomic) NSMutableData *jsonData;


@end


@implementation ReferencePopupView


- (void)popupInSuperView:(UIView *)aSuperview {

    self.rectPadding = 1;
    self.rectCornerRadius = 2;
    
    self.titleLabel = @"加载中";
    self.borderLabel = 1;
    self.line = 3;
    self.stringIncrease = @".";
    self.secondsOfstringIncrease = 1;
    
    [super popupInSuperView:aSuperview];
}


- (void)setReferenceId1:(NSInteger)referenceId {
    LOG_POSTION
    self.threadId = referenceId;
    [self setBackgroundDownload];
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
        [self.labelText setText:@"加载失败."];
    }
    else {
        [self.labelText setHidden:YES];
        
        postData.mode = 2;
        PostDataCellView *v = nil;
        v = [[PostDataCellView alloc] initWithFrame:CGRectMake(3, 3, 0, 100)];
        [v setTag:100];
        [self addSubview:v];
        X_CENTER(v, (2*self.rectPadding + 2*self.borderLabel))
        [v setPostData:[postData toCellUsingDataWithId] inRow:0];
        [v setCenter:self.center];
    }
#endif
}


#if 0
- (PostData*)parseFromJsonData:(NSData*)jsonData {

    PostData *postData = nil;
    NSData *data = jsonData;
    if(data) {
        //NSLog(@"%s", [data bytes]);
    }
    else {
        NSLog(@"data null");
        return nil;
    }
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NS0Log(@"obj nil %d", __LINE__);
        return nil;
    }
    
    dict = (NSDictionary*)obj;
    
    NS0Log(@"%@", dict);
    
    obj = [dict objectForKey:@"threads"];
    if(obj) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing threads obj");
            return nil;
        }
        
        postData = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == postData) {
            NSLog(@"error : PostData formDictData with content %@", obj);
            return nil;
        }
        
        postData.bTopic = YES;
        postData.mode = 1;
    }
    else {
        NSLog(@"obj nil %d", __LINE__);
        return nil;
    }
    
    return postData;
}
#endif





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
