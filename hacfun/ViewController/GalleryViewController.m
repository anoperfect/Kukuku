//
//  GalleryViewController.m
//  hacfun
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//
#import "GalleryViewController.h"
#import "ImageViewController.h"
#import "ImagesDisplay.h"
#import "FrameLayout.h"
#import "ImageViewCache.h"



@interface GalleryViewController ()



@property (nonatomic, strong) ImagesDisplay *imageDisplay;
@property (nonatomic, strong) UIView        *muiltActions;
@property (nonatomic, strong) PushButton    *buttonShare;
@property (nonatomic, strong) PushButton    *buttonSave;
@property (nonatomic, strong) PushButton    *buttonDelete;


@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *filePaths;

@property (nonatomic, assign) NSInteger totalImagesNumber;


@end

@implementation GalleryViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        if(!self.textTopic) {
            self.textTopic = @"下载图片";
        }
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"选择";
        [self actionAddData:actionData];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageDisplay = [[ImagesDisplay alloc] init];
    [self.view addSubview:self.imageDisplay];
    self.imageDisplay.backgroundColor = [UIColor whiteColor];
    [self.imageDisplay setDisplayedImages:self.images];
    
    __weak GalleryViewController *selfBlock = self;
    [self.imageDisplay setDidSelectHandle:^(NSInteger row) {
        [selfBlock displayImageInRow:row];
    }];
    
    self.muiltActions = [[UIView alloc] init];
    self.muiltActions.backgroundColor = [UIColor whiteColor];
    self.muiltActions.hidden = YES;
    [self.view addSubview:self.muiltActions];
#if 0
    self.muiltActions = [[UITabBar alloc] init];
    [self.view addSubview:self.muiltActions];
    [self.muiltActions insertSubview:nil atIndex:0];
    
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"保存" image:nil selectedImage:nil];
#endif
    
    self.buttonShare = [[PushButton alloc] init];
    [self.buttonShare setImage:[UIImage imageNamed:@"buttonshare"] forState:UIControlStateNormal];
    [self.buttonShare addTarget:self action:@selector(imagesShare) forControlEvents:UIControlEventTouchDown];
    [self.muiltActions addSubview:self.buttonShare];
    
    self.buttonSave = [[PushButton alloc] init];
    [self.buttonSave setImage:[UIImage imageNamed:@"buttonsave"] forState:UIControlStateNormal];
    [self.buttonSave addTarget:self action:@selector(imagesSave) forControlEvents:UIControlEventTouchDown];
    [self.muiltActions addSubview:self.buttonSave];
    
    self.buttonDelete = [[PushButton alloc] init];
    [self.buttonDelete setImage:[UIImage imageNamed:@"buttondelete"] forState:UIControlStateNormal];
    [self.buttonDelete addTarget:self action:@selector(imagesDelete) forControlEvents:UIControlEventTouchDown];
    [self.muiltActions addSubview:self.buttonDelete];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadDownloadedImage];
    });
    
    [self showImagesNumberAfterDelay:1];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.bounds.size];
    
    CGFloat heightMuiltActions = 44;
    [layout setUseIncludedMode:@"muiltActions" includedTo:FRAMELAYOUT_NAME_MAIN withPostion:FrameLayoutPositionBottom andSizeValue:heightMuiltActions];
    if(self.muiltActions.hidden) {
        [layout setOffset:@"muiltActions" dx:0 dy:heightMuiltActions];
    }
    [layout setUseLeftMode:@"imageDisplay" standardTo:@"muiltActions" withDirection:FrameLayoutDirectionAbove];
    
    self.imageDisplay.frame     = [layout getCGRect:@"imageDisplay"];
    self.muiltActions.frame     = [layout getCGRect:@"muiltActions"];
    NSLog(@"%@", layout);
    
    FrameLayout *layoutTabBar = [[FrameLayout alloc] initWithSize:self.muiltActions.frame.size];
    
    [layoutTabBar setDivideEquallyInVertical:FRAMELAYOUT_NAME_MAIN withNumber:3 to:@[@"buttonShare", @"buttonSave", @"buttonDelete"]];
    self.buttonShare.frame      = [layoutTabBar getCGRect:@"buttonShare"];
    self.buttonSave.frame       = [layoutTabBar getCGRect:@"buttonSave"];
    self.buttonDelete.frame     = [layoutTabBar getCGRect:@"buttonDelete"];
    
#define UIEdgeInsetsMakeSqureFromSize(size, border) (size.width >= size.height? \
     UIEdgeInsetsMake(border, (size.width - size.height) / 2 + border, border, (size.width - size.height) / 2 + border) \
    :UIEdgeInsetsMake((size.height - size.width) / 2 + border, border, (size.height - size.width) / 2 + border, border))
    
    CGFloat border = 6;
    CGSize size ;
    size = self.buttonShare.frame.size;
    self.buttonShare.imageEdgeInsets =  UIEdgeInsetsMakeSqureFromSize(size, border);
    size = self.buttonSave.frame.size;
    self.buttonSave.imageEdgeInsets =  UIEdgeInsetsMakeSqureFromSize(size, border);
    size = self.buttonDelete.frame.size;
    self.buttonDelete.imageEdgeInsets =  UIEdgeInsetsMakeSqureFromSize(size, border);
    
    NSLog(@"%@", [NSValue valueWithCGRect:self.buttonDelete.frame]);
    NSLog(@"%@", [NSValue valueWithUIEdgeInsets:self.buttonDelete.imageEdgeInsets]);
}


- (void)reloadDownloadedImage
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableArray *filePathArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *additonal = [[NSMutableDictionary alloc] init];
    
    //先只加载20张. 一次全部加载的话可能导致慢.
    NSInteger numberGet = [ImageViewCache inputCacheImagesAndPathWithTopNumber:20
                                                                outputImages:imageArray
                                                              outputFilePathsM:filePathArray
                                                               outputAdditonal:additonal];
    NSLog(@"%zd total %@", numberGet, additonal);
    self.totalImagesNumber = [[additonal objectForKey:@"totalNumber"] integerValue];
    
    self.images = [NSArray arrayWithArray:imageArray];
    self.filePaths = [NSArray arrayWithArray:filePathArray];
    

    
    self.images = [NSArray arrayWithArray:imageArray];
    self.filePaths = [NSArray arrayWithArray:filePathArray];
    
    [self.imageDisplay setDisplayedImages:self.images];
    
    //剩下的异步加载.
    if(numberGet >= 20 && self.totalImagesNumber > 20) {
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^(void){
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *filePathArray = [[NSMutableArray alloc] init];
            
            [ImageViewCache inputCacheImagesAndPathWithTopNumber:NSIntegerMax
                                                    outputImages:imageArray
                                                outputFilePathsM:filePathArray
                                                 outputAdditonal:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.images = [NSArray arrayWithArray:imageArray];
                self.filePaths = [NSArray arrayWithArray:filePathArray];
                [self.imageDisplay setDisplayedImages:self.images];
            });
        });
    }
}


- (void)displayImageInRow:(NSInteger)row
{
    if(row >= 0 && self.images.count > row) {
        UIImage *image = [self.images objectAtIndex:row];
        ImageViewController *imageViewController = [[ImageViewController alloc] init];
        [imageViewController setDisplayedImage:image];
        
        [self.navigationController pushViewController:imageViewController animated:YES];
    }
    else {
        NSLog(@"#error : row error.");
    }
}


- (void)showImagesNumberAfterDelay:(NSInteger)sec
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *indicationString = [NSString stringWithFormat:@"共有图片%zd张", self.totalImagesNumber];
        if(0 == [self.images count]) {
            indicationString = [NSString stringWithFormat:@"暂无缓存图片"];
        }
        [self showIndicationText:indicationString];
        
        NSLog(@"--- %@", [self.view subviews]);
        
    });
}



- (void)setDisplayedImages:(NSArray*)images andNames:(NSArray*)filePaths
{
    self.images = images;
    self.filePaths = filePaths;
    [self.imageDisplay setDisplayedImages:self.images];
}


- (void)actionViaString:(NSString *)string
{
    if([string isEqualToString:@"选择"]) {
        [self.imageDisplay setMuiltSelectMode:YES];
        self.muiltActions.hidden = NO;
        [self.view setNeedsLayout];
        
        //修改选择为取消.
        [self actionRemoveDataByKeyString:@"选择"];
        [self actionRefresh];
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"取消";
        //actionData.image    = @"refresh";
        [self actionAddData:actionData];
        [self actionRefresh];
        
        return ;
    }
    
    if([string isEqualToString:@"取消"]) {
        [self.imageDisplay setMuiltSelectMode:NO];
        self.muiltActions.hidden = YES;
        [self.view setNeedsLayout];
        
        //修改取消为选择.
        [self actionRemoveDataByKeyString:@"取消"];
        
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"选择";
        //actionData.image    = @"refresh";
        [self actionAddData:actionData];
        [self actionRefresh];
        
        return ;
    }
}


- (void)imagesShare
{
    NSInteger numberEnable = 0;
    NSArray *boolValues = [self.imageDisplay getResultMuiltSelectModeBOOLValues];
    if(boolValues.count != self.images.count) {
        NSLog(@"#error count not match.");
        return;
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < boolValues.count; index ++) {
        if([boolValues[index] boolValue]) {
            [images addObject:self.images[index]];
            numberEnable ++;
        }
    }
    
    UIActivityViewController *activiryViewController = [[UIActivityViewController alloc] initWithActivityItems:images applicationActivities:nil];
    [self presentViewController:activiryViewController animated:YES completion:^(void){
        
    }];
}


- (void)imagesSave
{
    NSInteger numberEnable = 0;
    NSArray *boolValues = [self.imageDisplay getResultMuiltSelectModeBOOLValues];
    if(boolValues.count != self.images.count) {
        NSLog(@"#error count not match.");
        return;
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < boolValues.count; index ++) {
        if([boolValues[index] boolValue]) {
            [images addObject:self.images[index]];
            numberEnable ++;
            UIImageWriteToSavedPhotosAlbum(self.images[index], nil, nil, nil);
        }
    }
}


- (void)imagesDelete
{
    NSInteger numberEnable = 0;
    NSArray *boolValues = [self.imageDisplay getResultMuiltSelectModeBOOLValues];
    if(boolValues.count != self.images.count || boolValues.count != self.filePaths.count) {
        NSLog(@"#error count not match.");
        return;
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < boolValues.count; index ++) {
        if([boolValues[index] boolValue]) {
            [images addObject:self.images[index]];
            numberEnable ++;
            [[NSFileManager defaultManager] removeItemAtPath:self.filePaths[index] error:nil];
        }
    }
    
    //取消多选模式.
    [self actionViaString:@"取消"];
    
    //重新从cache中读取图片信息.
    [self reloadDownloadedImage];
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
