//
//  ImageViewController.m
//  hacfun
//
//  Created by Ben on 15/8/2.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ImageViewController.h"
#import "FuncDefine.h"
#import "VIPhotoView.h"
#import "AppConfig.h"
#import "ImageViewCache.h"
#import "PopupView.h"

@interface ImageViewController ()

//@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) VIPhotoView *imageView;
@property (strong,nonatomic) NSURL *url;
@property (strong,nonatomic) NSString *stringUrl;
@property (strong,nonatomic) UIImage *placeHoldImage;
@property (strong,nonatomic) NSMutableData *imageData;
@property (assign) long long expectedContentLength;
@property (strong,nonatomic) UILabel *labelPercentage;
@end

@implementation ImageViewController


-(instancetype) init
{
    if (self = [super init]) {
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"保存";
        //        actionData.image    = @"edit";
        [self actionAddData:actionData];
        
        self.textTopic = @"图片";
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelPercentage = [[UILabel alloc] init];
    [self.view addSubview:self.labelPercentage];
    [self.labelPercentage setFont:[AppConfig fontFor:@"NavigationInfo"]];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.labelPercentage setFrame:CGRectMake((self.view.frame.size.width - 100) / 2, self.yBolowView, 100, 36)];
    [self.labelPercentage setTextAlignment:NSTextAlignmentCenter];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //查看是否有cache数据. 否则重新申请网络下载.
    NSData *dataRead = [ImageViewCache getImageViewCache:self.stringUrl];
    NS0Log(@"%zi", [dataRead length]);
    if([dataRead length] > 0) {
        NS0Log(@"------ use downloaded image.");
        self.imageData =  [[NSMutableData alloc] initWithData:dataRead];
        [self updateImageView];
    }
    else {
        self.labelPercentage.text = @"准备加载";
        NS0Log(@"------ start download.");
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        
        mutableRequest.HTTPMethod = @"GET";
        [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)actionViaString:(NSString*)string
{
    NSLog(@"action string : %@", string);
    if([string isEqualToString:@"保存"]) {
        [self toAlbum];
        return;
    }
}


- (void)toAlbum {
    if(nil == self.imageData) {
        return;
    }
    
    UIActivityViewController *activiryViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageData] applicationActivities:nil];
    [self presentViewController:activiryViewController animated:YES completion:^(void){
        
    }];
    
#if 0
    UIImage *image = [UIImage imageWithData:self.imageData];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    PopupView *popupView = [[PopupView alloc] init];
    popupView.numofTapToClose = 1;
    popupView.secondsOfAutoClose = 2;
    popupView.titleLabel = @"图片已经保存至相册";
    popupView.borderLabel = 30;
    popupView.line = 3;
    [popupView popupInSuperView:self.view];
#endif
}


- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)image {
    self.url = url;
    self.stringUrl = [[self.url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.placeHoldImage = image;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    
    NSLog(@"%lld", response.expectedContentLength);
    self.expectedContentLength = response.expectedContentLength;
    
    self.imageData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NS0Log(@"%@已经接收到数据%s", [NSThread currentThread], __FUNCTION__);
    
    [self.imageData appendData:data];
    
    [self.labelPercentage setText:[NSString stringWithFormat:@"加载中%lld%%", (long long)[self.imageData length] * 100 / self.expectedContentLength]];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    
    [self.labelPercentage setText:@""];
    
    NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"autosaveimagetoalbum"] ;
    BOOL bAutoSaveImageToAlbum = [value boolValue];
    if(bAutoSaveImageToAlbum) {
        UIImage *image = [UIImage imageWithData:self.imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [ImageViewCache setImageViewCache:self.stringUrl withData:self.imageData];
    [self updateImageView];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    [self.labelPercentage setText:@"加载不成功"];
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
}


- (void)updateImageView {
    
    UIImage *image = [UIImage imageWithData:self.imageData];
    CGFloat y = self.yBolowView;
    self.imageView = [[VIPhotoView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y) andImage:image];
    self.imageView.autoresizingMask = (1 << 6) - 1;
    [self.view addSubview:self.imageView];
    
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
