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
@interface GalleryViewController ()



@property (nonatomic, strong) ImagesDisplay *imageDisplay;
@property (nonatomic, strong) UIView        *muiltActions;
@property (nonatomic, strong) PushButton    *buttonShare;
@property (nonatomic, strong) PushButton    *buttonSave;
@property (nonatomic, strong) PushButton    *buttonDelete;


@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *filePaths;


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
#if 0
    self.muiltActions = [[UITabBar alloc] init];
    [self.view addSubview:self.muiltActions];
    self.muiltActions.backgroundColor = [UIColor yellowColor];
    [self.muiltActions insertSubview:nil atIndex:0];
    
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"保存" image:nil selectedImage:nil];
#endif
    
    self.buttonShare = [[PushButton alloc] init];
    [self.buttonShare setImage:[UIImage imageNamed:@"buttonshare"] forState:UIControlStateNormal];
    [self.buttonShare addTarget:self action:@selector(imagesShare) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.buttonShare];
    
    self.buttonSave = [[PushButton alloc] init];
    [self.buttonSave setImage:[UIImage imageNamed:@"buttonsave"] forState:UIControlStateNormal];
    [self.buttonSave addTarget:self action:@selector(imagesSave) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.buttonSave];
    
    self.buttonDelete = [[PushButton alloc] init];
    [self.buttonDelete setImage:[UIImage imageNamed:@"buttondelete"] forState:UIControlStateNormal];
    [self.buttonDelete addTarget:self action:@selector(imagesDelete) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.buttonDelete];
    
    [self showImagesNumberAfterDelay:1];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.bounds.size];
    
    [layout setUseIncludedMode:@"imageDisplay" includedTo:NAME_MAIN_FRAME withPostion:FrameLayoutPositionTop andSizePercentage:1.0];
    [layout setUseIncludedMode:@"muiltActions" includedTo:NAME_MAIN_FRAME withPostion:FrameLayoutPositionBottom andSizeValue:36];
    [layout setDivideEquallyInVertical:@"muiltActions" withNumber:3 to:@[@"buttonShare", @"buttonSave", @"buttonDelete"]];
    
    self.imageDisplay.frame     = [layout getCGRect:@"imageDisplay"];
    self.muiltActions.frame     = [layout getCGRect:@"muiltActions"];
    self.buttonShare.frame      = [layout getCGRect:@"buttonShare"];
    self.buttonSave.frame       = [layout getCGRect:@"buttonSave"];
    self.buttonDelete.frame     = [layout getCGRect:@"buttonDelete"];
    
#define UIEdgeInsetsMakeSqureFromSize(size, border) (size.width >= size.height? \
     UIEdgeInsetsMake(border, (size.width - size.height) / 2 - border, border, (size.width - size.height) / 2 - border) \
    :UIEdgeInsetsMake((size.height - size.width) / 2 - border, border, (size.height - size.width) / 2 - border, border))
    
    CGFloat border = 3;
    CGSize size ;
    size = self.buttonShare.frame.size;
    self.buttonShare.imageEdgeInsets =  UIEdgeInsetsMakeSqureFromSize(size, border);
    size = self.buttonSave.frame.size;
    self.buttonSave.imageEdgeInsets =  UIEdgeInsetsMakeSqureFromSize(size, border);
    size = self.buttonDelete.frame.size;
    self.buttonDelete.imageEdgeInsets =  UIEdgeInsetsMakeSqureFromSize(size, border);
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
        NSString *indicationString = [NSString stringWithFormat:@"共有图片%zd张", [self.images count]];
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
        
        return ;
    }
    
    if([string isEqualToString:@"取消"]) {
        [self.imageDisplay setMuiltSelectMode:NO];
        self.muiltActions.hidden = YES;
        
        return ;
    }
    
    
}


- (void)imagesShare
{
    NSArray *indexs = [self.imageDisplay getSelectSnInMuiltSelectMode];
    NSLog(@"%@", indexs);
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        if(index >= 0 && index < self.images.count) {
            [images addObject:self.images[index]];
        }
    }
    
    UIActivityViewController *activiryViewController = [[UIActivityViewController alloc] initWithActivityItems:images applicationActivities:nil];
    [self presentViewController:activiryViewController animated:YES completion:^(void){
        
    }];
    
}


- (void)imagesSave
{
    NSArray *indexs = [self.imageDisplay getSelectSnInMuiltSelectMode];
    NSLog(@"%@", indexs);
    
    for(NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        if(index >= 0 && index < self.images.count) {
            UIImageWriteToSavedPhotosAlbum(self.images[index], nil, nil, nil);
        }
    }
}


- (void)imagesDelete
{
    NSArray *indexs = [self.imageDisplay getSelectSnInMuiltSelectMode];
    NSLog(@"%@", indexs);
    
    for(NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        if(index >= 0 && index < self.images.count) {
            [[NSFileManager defaultManager] removeItemAtPath:self.filePaths[[number integerValue]] error:nil];
        }
    }
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
