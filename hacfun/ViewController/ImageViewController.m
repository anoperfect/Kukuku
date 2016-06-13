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

#import "FLAnimatedImage.h"
@interface ImageViewController ()

//@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) VIPhotoView *imageView;
@property (strong,nonatomic) UILabel *labelPercentage;

//网络图片模式.
@property (strong,nonatomic) NSURL *url;
@property (strong,nonatomic) NSString *stringUrl;
@property (strong,nonatomic) UIImage *placeHoldImage;

//已有image模式.
@property (strong,nonatomic) UIImage *directDisplayedImage;

@property (nonatomic, strong) UIImage *imageDisplay;
@property (nonatomic, strong) NSData *gifData;


//用于数据下载过程中.
@property (strong,nonatomic) NSMutableData *imageDataDownload;
@property (assign) long long expectedContentLength;



@end

@implementation ImageViewController


-(instancetype) init
{
    if (self = [super init]) {
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"分享";
        actionData.imageName    = @"buttonshare";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"保存";
        actionData.imageName    = @"album";
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
    [self.labelPercentage setFont:[UIFont fontWithName:@"ImageDownloadStatusLabel"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startDisplayAction];
    });
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat heightLabelPercentage = 30;
    [self.labelPercentage setFrame:CGRectMake((self.view.frame.size.width - 100) / 2, self.yBolowView, 100, heightLabelPercentage)];
    [self.labelPercentage setTextAlignment:NSTextAlignmentCenter];
}


- (void)startDisplayAction
{
    if(self.directDisplayedImage) {
        [self updateImageViewByImage:self.directDisplayedImage];
    }
    else if(self.stringUrl) {
        //查看是否有cache数据. 否则重新申请网络下载.
        NSData *dataRead = [ImageViewCache getImageViewCache:self.stringUrl];
        NSLog(@"%zi", [dataRead length]);
        if([dataRead length] > 0) {
            NSLog(@"------ use downloaded image.");
            [self updateImageViewByDownloadOrCachedData:dataRead];
        }
        else {
            //显示下载完成之前的预制image.
            if(self.placeHoldImage) {
                [self updateImageViewByImage:self.placeHoldImage withBorder:UIEdgeInsetsMake(45, 36, 45, 36)];
            }
            
            self.imageDataDownload = [[NSMutableData alloc] init];
            self.labelPercentage.text = @"准备加载";
            NSLog(@"------ start download.");
            NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
            
            mutableRequest.HTTPMethod = @"GET";
            [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
        }
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
        [self storeToAlbum];
        return;
    }
    
    if([string isEqualToString:@"分享"]) {
        [self airdropShare];
        return;
    }
}


- (void)airdropShare {
    if(nil == self.imageDisplay) {
        return;
    }
    
    //数组中放 UIImage. 之前是方 NSData.
    if(!self.gifData) {
        UIActivityViewController *activiryViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageDisplay] applicationActivities:nil];
        [self presentViewController:activiryViewController animated:YES completion:^(void){
            
        }];
    }
    else {
        UIActivityViewController *activiryViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.gifData] applicationActivities:nil];
        [self presentViewController:activiryViewController animated:YES completion:^(void){
            
        }];
    }
}


- (void)storeToAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.imageDisplay, nil, nil, nil);
    [self showIndicationText:@"已保存到相册" inTime:2.0];
}


- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)image {
    self.url = url;
    self.stringUrl = [[self.url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.placeHoldImage = image;
}


- (void)setDisplayedImage:(UIImage*)image
{
    self.directDisplayedImage = image;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    
    NSLog(@"%lld", response.expectedContentLength);
    self.expectedContentLength = response.expectedContentLength;
    if(self.expectedContentLength <= 0) {
        self.expectedContentLength = 1024 * 1024;
    }
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NS0Log(@"%@已经接收到数据%s", [NSThread currentThread], __FUNCTION__);
    
    [self.imageDataDownload appendData:data];
    [self.labelPercentage setText:[NSString stringWithFormat:@"加载中%lld%%", (long long)[self.imageDataDownload length] * 100 / self.expectedContentLength]];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    
    [self.labelPercentage setText:@""];
    
    NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"autosaveimagetoalbum"] ;
    BOOL bAutoSaveImageToAlbum = [value isEqualToString:@"bool1"];
    NSData *imageDataDownload = [NSData dataWithData:self.imageDataDownload];
    if(bAutoSaveImageToAlbum) {
        UIImage *image = [UIImage imageWithData:imageDataDownload];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self showIndicationText:@"自动存图到相册" inTime:1.0];
    }
    
    [ImageViewCache setImageViewCache:self.stringUrl withData:imageDataDownload];
    [self updateImageViewByDownloadOrCachedData:self.imageDataDownload];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    [self.labelPercentage setText:@"加载不成功"];
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
}


- (void)updateImageViewByImage:(UIImage*)image
{
    CGFloat y = self.yBolowView ;
    CGRect imageframe = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    self.imageDisplay = image;
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.imageView = [[VIPhotoView alloc] initWithFrame:imageframe andImage:image];
    self.imageView.autoresizingMask = (1 << 6) - 1;
    [self.view addSubview:self.imageView];
}


- (void)updateImageViewByDownloadOrCachedData:(NSData*)imageData
{
    if(![self.stringUrl hasSuffix:@".gif"]) {
        [self updateImageViewByImage:[UIImage imageWithData:imageData]];
    }
    else {
        [self updateImageViewByGifData:imageData];
    }
}


- (void)updateImageViewByGifData:(NSData*)imageData
{
    [[self.view viewWithTag:1000] removeFromSuperview];
    
    CGFloat y = self.yBolowView ;
    CGRect imageframe = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    self.gifData = imageData;
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:imageData];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.tag = 1000;
    imageView.animatedImage = image;
    
    imageView.frame = [FrameLayout narrow:image.size inContainer:imageframe withBroaden:NO center:YES];
    
//    CGSize size = [FuncDefine ConstrainSize:image.size fitTo:imageframe.size];
//    imageView.frame = CGRectMake(0, 0, size.width, size.height);
//    imageView.center = self.view.center;
    
    [self.view addSubview:imageView];
}


- (void)updateImageViewByImage:(UIImage*)image withBorder:(UIEdgeInsets)border
{
    CGFloat y = self.yBolowView ;
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    CGRect frame = CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - y);
    frame = CGRectMake(border.left, y+border.top, self.view.bounds.size.width - border.left - border.right, self.view.bounds.size.height - y - border.top - border.bottom);
    
    self.imageView = [[VIPhotoView alloc] initWithFrame:frame andImage:image];
    self.imageView.autoresizingMask = (1 << 6) - 1;
    [self.view addSubview:self.imageView];
    
    self.imageDisplay = image;
}





#if 0
- (void)updateImageViewByData:(NSData*)imageData
{
    UIImage *image = [UIImage imageWithData:imageData];
    if(image) {
        [self updateImageViewByImage:image];
    }
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
