//
//  IntroductionViewController.m
//  hacfun
//
//  Created by Ben on 16/5/18.
//  Copyright © 2016年 Ben. All rights reserved.
//
#import "TestViewController.h"
#import "IntroductionViewController.h"
#import "TypeModel.h"
#import "AppConfig.h"
@interface IntroductionViewController () <UIWebViewDelegate>



@property (nonatomic, strong) UIScrollView *imageScrollViewContainer;
@property (nonatomic, strong) UIImageView *imageIntroduction;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) EULAView *eula;
@end

@implementation IntroductionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textTopic = @"简介";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
    [self.webView removeFromSuperview];
    
    self.imageScrollViewContainer = [[UIScrollView alloc] init];
    //[self.view addSubview:self.imageScrollViewContainer];
    
    self.imageIntroduction = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Introduction_Kukuku.jpg"]];
    [self.imageScrollViewContainer addSubview:self.imageIntroduction];
    
    
    self.eula = [[EULAView alloc] initWithFrame:self.view.bounds withAgreement:NO andUserFeedbackHanle:nil];
    [self.view addSubview:self.eula];
}


- (void)viewWillLayoutSubviews
{
    self.webView.frame = self.view.bounds;
    self.imageScrollViewContainer.frame = self.view.bounds;
    
    CGSize sizeImage = self.imageIntroduction.image.size;
    NSLog(@"%f %f", sizeImage.width, sizeImage.height);
    
    CGFloat heightImage = self.view.bounds.size.width * (sizeImage.height/sizeImage.width);
    
    self.imageIntroduction.frame = CGRectMake(0, 0, self.view.bounds.size.width, heightImage);
    self.imageScrollViewContainer.contentSize = self.imageIntroduction.frame.size;
    
    self.eula.frame = self.view.bounds;
}


//# 使用UIWebView则左右滑动不能使用. 导致内存泄漏.
- (void)loadIntroduction
{
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    NSString *urlString = host.urlString;
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    mutableRequest.HTTPMethod = @"GET";
    [self.webView loadRequest:mutableRequest];
}


//点击到其他页面后, 左右滑动受到影响. 设置只能在此界面.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LOG_POSTION
    
    NSURL *url = [request URL];

    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    NSString *urlString = host.urlString;
    if([urlString isEqualToString:url.absoluteString]) {
        return YES;
    }
    else {
        return NO;
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showIndicationText:@"加载失败. 请检查网络." inTime:1.0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
