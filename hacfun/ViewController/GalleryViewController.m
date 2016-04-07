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
@interface GalleryViewController ()
@property (nonatomic, strong) ImagesDisplay *imageDisplay;
@property (nonatomic, strong) NSArray *images;
@end

@implementation GalleryViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        if(!self.textTopic) {
            self.textTopic = @"下载图片";
        }
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
    
    [self showImagesNumberAfterDelay:1];
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


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.imageDisplay.frame = self.view.bounds;
}


- (void)setDisplayedImages:(NSArray*)images
{
    self.images = images;
    [self.imageDisplay setDisplayedImages:self.images];
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
