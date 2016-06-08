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
#import "ButtonData.h"
#import "NSLogn.h"

@interface GalleryViewController ()



@property (nonatomic, strong) ImagesDisplay *imageDisplay;
//@property (nonatomic, strong) UIView        *muiltActions;
//@property (nonatomic, strong) PushButton    *buttonShare;
//@property (nonatomic, strong) PushButton    *buttonSave;
//@property (nonatomic, strong) PushButton    *buttonDelete;

@property (nonatomic, assign) BOOL muiltSelectMode;


//@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *filePaths;
@property (nonatomic, strong) NSMutableArray *thumbs;

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
    self.imageDisplay.backgroundColor = [UIColor clearColor];
    //[self.imageDisplay setDisplayedImages:self.images];
    
    __weak GalleryViewController *selfBlock = self;
    [self.imageDisplay setDidSelectHandle:^(NSInteger row) {
        [selfBlock displayImageInRow:row];
    }];
    
    //indiction message 需等待CustomViewController的viewWillLayoutSubviews调整到最前面猜可以显示出来. 因此reloadDownloadedImage延迟一点等待viewWillLayoutSubviews执行.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadDownloadedImage];
    });
    
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self reloadDownloadedImage];
//    });
//    
//    [self showImagesNumberAfterDelay:1];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.imageDisplay.frame     = self.view.bounds;
    
    
#if 0
    
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
#endif
}


#if 0
- (void)reloadDownloadedImage
{
    NSMutableArray *imageArray = nil; //[[NSMutableArray alloc] init];
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
#endif

- (void)reloadDownloadedImage
{
    [self showProgressText:@"正整理图片数据, 请稍等. " inTime:2.0];
    [self.imageDisplay setDisplayedImages:nil];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        //        self.images     = [[NSMutableArray alloc] init];
        self.filePaths  = [[NSMutableArray alloc] init];
        self.thumbs     = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *additional = [[NSMutableDictionary alloc] init];
        [ImageViewCache inputCacheImagesAndPathWithTopNumber:NSIntegerMax
                                                outputImages:nil
                                                 outputThumb:self.thumbs
                                                    withSize:CGSizeMake(100, 127)
                                            outputFilePathsM:self.filePaths
                                             outputAdditonal:additional
                                                    progress:^(NSInteger number){
                                                        [self showProgressText:[NSString stringWithFormat:@"已整理图片 : %zd", number] inTime:2.0];
                                                    }
         
         ];
        
        self.totalImagesNumber = [[additional objectForKey:@"totalNumber"] integerValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgressText:[NSString stringWithFormat:@"共有图片%zd张", self.totalImagesNumber] inTime:2.0];
            [self.imageDisplay setDisplayedImages:self.thumbs];
    
            
        });
        
    });
}




- (UIImage*)imageAtRow:(NSInteger)row
{
    NSData *data ;
    UIImage *image = nil;
    if(row >= 0
       && self.filePaths.count > row
       && (nil != (data = [NSData dataWithContentsOfFile:self.filePaths[row]]))
       && (nil != (image = [UIImage imageWithData:data]))) {

    }
    
    return image;
    
}




- (void)displayImageInRow:(NSInteger)row
{
    UIImage *image = [self imageAtRow:row];
    if(image) {
        ImageViewController *imageViewController = [[ImageViewController alloc] init];
        [imageViewController setDisplayedImage:image];
        [self.navigationController pushViewController:imageViewController animated:YES];
    }
    else {
        NSLog(@"#error : row error.");
        [self showIndicationText:@"读取图片数据错误." inTime:1.0];
    }
}


- (void)actionViaString:(NSString *)string
{
    if([string isEqualToString:@"选择"]) {
        [self.imageDisplay setMuiltSelectMode:YES];
        //self.muiltActions.hidden = NO;
        self.muiltSelectMode = YES;
        [self showToolBar];
//        [self.view setNeedsLayout];
        
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
//        self.muiltActions.hidden = YES;
        self.muiltSelectMode = NO;
        [self hiddenToolBar];
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
    
    if([string isEqualToString:@"imagesShare"]) {
        [self imagesShare];
        return ;
    }
    
    if([string isEqualToString:@"imagesSave"]) {
        [self imagesSave];
        return ;
    }
    
    if([string isEqualToString:@"imagesDelete"]) {
        [self imagesDelete];
        return ;
    }
    
}


- (NSArray*)toolData
{
    LOG_POSTION
    NSMutableArray *toolDatas = [[NSMutableArray alloc] init];
    
    ButtonData *actionData = nil;
    
    actionData = [[ButtonData alloc] init];
    actionData.keyword      = @"imagesShare";
    actionData.imageName    = @"buttonshare";
    [toolDatas addObject:actionData];
    
    actionData = [[ButtonData alloc] init];
    actionData.keyword      = @"imagesSave";
    actionData.imageName    = @"buttonsave";
    [toolDatas addObject:actionData];
    
    actionData = [[ButtonData alloc] init];
    actionData.keyword      = @"imagesDelete";
    actionData.imageName    = @"buttondelete";
    [toolDatas addObject:actionData];
    
    return [NSArray arrayWithArray:toolDatas];
}






- (void)imagesShare
{
    NSInteger numberEnable = 0;
    NSArray *boolValues = [self.imageDisplay getResultMuiltSelectModeBOOLValues];
    if(boolValues.count != self.filePaths.count) {
        NSLog(@"#error count not match.");
        return;
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < boolValues.count; index ++) {
        if([boolValues[index] boolValue]) {
            UIImage *image = [self imageAtRow:index];
            if(image) {
                [images addObject:image];
                numberEnable ++;
            }
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
    if(boolValues.count != self.filePaths.count) {
        NSLog(@"#error count not match.");
        return;
    }
    
    NSInteger saveToAlbumNumber = 0;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < boolValues.count; index ++) {
        if([boolValues[index] boolValue]) {
            saveToAlbumNumber ++;
            UIImage *image = [self imageAtRow:index];
            if(image) {
                [images addObject:image];
                numberEnable ++;
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
        }
    }
    
    if(saveToAlbumNumber > 0) {
        [self showIndicationText:[NSString stringWithFormat:@"已保存图片到相册 : %zd", saveToAlbumNumber] inTime:2.0];
    }
    else {
        [self showIndicationText:[NSString stringWithFormat:@"未选择保存图片"] inTime:1.0];
    }
}


- (void)imagesDelete
{
    NSArray *boolValues = [self.imageDisplay getResultMuiltSelectModeBOOLValues];
    if(boolValues.count != self.filePaths.count) {
        NSLog(@"#error count not match.");
        return;
    }
    
    NSInteger deleteNumber = 0;
    for(NSInteger index = 0; index < boolValues.count; index ++) {
        if([boolValues[index] boolValue]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.filePaths[index] error:nil];
            deleteNumber ++;
        }
    }
    
    if(deleteNumber > 0) {
        [self showIndicationText:[NSString stringWithFormat:@"已删除图片 : %zd", deleteNumber] inTime:1.0];
    }
    else {
        [self showIndicationText:[NSString stringWithFormat:@"未选择删除图片"] inTime:1.0];
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








#if 0
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

self.toolbarItems = @[
                      [UITabBarItem ]
                      
                      
                      
                      
                      ];

#endif
