//
//  CustomViewController.m
//  hacfun
//
//  Created by Ben on 15/8/17.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "CustomViewController.h"
#import "FuncDefine.h"
#import "AppConfig.h"
#import "BannerView.h"




@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LOG_RECT(self.view.frame, @"self.view")
    
    self.view.backgroundColor = [AppConfig backgroundColorFor:@"ViewController"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    //banner.
    BannerView *bannerView = [[BannerView alloc] init];
    [bannerView setTag:(NSInteger)@"BannerView"];
    [self.view addSubview:bannerView];
    [bannerView.buttonTopic addTarget:self action:@selector(clickButtonTopic) forControlEvents:UIControlEventTouchDown];
    
    NSMutableArray *ary = [self getButtonDatas];
    [bannerView setButtonData:ary];
    
    //[self viewWillLayoutSubviews];
}


- (void)viewWillLayoutSubviews {
    LOG_POSTION
    BannerView *bannerView = (BannerView*)[self.view viewWithTag:(NSInteger)@"BannerView"];
    CGFloat yBanner = 0;
    if(self.view.frame.size.width < self.view.frame.size.height) {
        yBanner = 20;
    }
    CGFloat heightBanner = 36;
    CGRect bannerViewRect = CGRectMake(0, yBanner, self.view.frame.size.width, heightBanner);
    [bannerView setFrame:bannerViewRect];
    [bannerView setNeedsLayout];
}


- (void)viewWillAppear:(BOOL)animated {
    LOG_POSTION
    [self.navigationController setNavigationBarHidden:YES];
    BannerView *bannerView = (BannerView*)[self.view viewWithTag:(NSInteger)@"BannerView"];
    [bannerView setTextTopic:self.textTopic];
}


- (CGFloat)getOriginYBelowView {
    CGFloat y = 0.0;
    
    BannerView *bannerView = (BannerView*)[self.view viewWithTag:(NSInteger)@"BannerView"];
    if(bannerView) {
        CGRect frame = bannerView.frame;
        y = frame.origin.y + frame.size.height;
    }
    
    NSLog(@"y:%f", y);
    
    return y;
}


- (BannerView*)getBannerView {
    BannerView *bannerView = (BannerView*)[self.view viewWithTag:(NSInteger)@"BannerView"];
    return bannerView;
}


- (void)setTopic:(NSString*)str {
    LOG_POSTION
    self.textTopic = [str copy];
}

//重载按钮行为(默认openLeftMenu).
- (void)clickButtonTopic {
    UINavigationController *navi = self.navigationController;
    if(nil == navi || [[navi viewControllers] count] == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openLeftMenu" object:self userInfo:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


//重载设置按钮参数数据.
- (NSMutableArray*)getButtonDatas {
    return nil;
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
