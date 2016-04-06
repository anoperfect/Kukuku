//
//  GalleryViewController.m
//  hacfun
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "GalleryViewController.h"
#import "ImagesDisplay.h"
@interface GalleryViewController ()
@property (nonatomic, strong) ImagesDisplay *imageDisplay;
@property (nonatomic, strong) NSArray *imageDatas;
@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageDisplay = [[ImagesDisplay alloc] init];
    [self.view addSubview:self.imageDisplay];
    self.imageDisplay.backgroundColor = [UIColor whiteColor];
    [self.imageDisplay setDisplayedImages:self.imageDatas];
    
    
    [self showImagesNumberAfterDelay:1];
}


- (void)showImagesNumberAfterDelay:(NSInteger)sec
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *indicationString = [NSString stringWithFormat:@"共有图片%zd张", [self.imageDatas count]];
        if(0 == [self.imageDatas count]) {
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


- (void)setDisplayedImages:(NSArray*)imageDatas
{
    self.imageDatas = imageDatas;
    [self.imageDisplay setDisplayedImages:self.imageDatas];
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
