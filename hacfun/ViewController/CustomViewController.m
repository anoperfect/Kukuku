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

@property (nonatomic, strong) NSMutableArray *actionDatas;
@property (nonatomic, strong) NSMutableArray *viewButtons;
@property (nonatomic, assign) NSInteger tagButtons;

@property (nonatomic, strong) BannerView *bannerView;


@property (nonatomic, assign) CGFloat heightBanner ;

@end

@implementation CustomViewController


- (instancetype)init
{
    self = [super init];
    
    if(nil != self) {
        self.viewButtons = [[NSMutableArray alloc] init];
        self.actionDatas = [[NSMutableArray alloc] init];
        self.yBolowView = 0;
        self.heightBanner = 36;
        self.tagButtons = 100;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [AppConfig backgroundColorFor:@"ViewController"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
#if 0
    //隐藏那个导航栏.
    self.navigationController.navigationBar.hidden = NO ;
    NSLog(@"%@", self.navigationController.navigationBar);
    NSLog(@"%@", self.navigationItem);
    LOG_RECT(self.navigationController.navigationBar.frame, @"1");
#endif
    
    //banner.
    self.bannerView = [[BannerView alloc] init];
    [self.bannerView setTag:(NSInteger)@"BannerView"];
    //[self.view addSubview:self.bannerView];
    [self.navigationController.navigationBar addSubview:self.bannerView];
    NSLog(@"%@", self.navigationController.navigationBar);
    NSLog(@"%@", self.navigationController.navigationBar.subviews);
    [self.bannerView.buttonTopic addTarget:self action:@selector(clickButtonTopic) forControlEvents:UIControlEventTouchDown];
    
    // 布局功能键.
    [self loadActionButtons];
}


- (void)viewWillLayoutSubviews {
    LOG_POSTION
    BannerView *bannerView = self.bannerView;
    CGFloat yBanner = 0;
    if(self.view.frame.size.width < self.view.frame.size.height) {
        yBanner = 0;
    }
    CGFloat heightBanner = 36;
    CGRect bannerViewRect = CGRectMake(0, yBanner, self.view.frame.size.width, heightBanner);
    [bannerView setFrame:bannerViewRect];
    [bannerView setNeedsLayout];
    
    [self layoutActionButtons:bannerView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LOG_POSTION
    //[self.navigationController setNavigationBarHidden:YES];
    BannerView *bannerView = self.bannerView;
    [bannerView setTextTopic:self.textTopic];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    
    
}


- (UIImage*) imageScale:(UIImage*)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


- (void)loadActionButtons
{
    NSInteger index = 0;
    for(ButtonData *data in self.actionDatas) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = self.tagButtons + index;
        [self.viewButtons addObject:button];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
        [button setFrame:CGRectMake(0, 0, self.heightBanner, self.heightBanner)];
        if(nil != data.image) {
            UIImage *image = [UIImage imageNamed:data.image];
            image = [self imageScale:image toSize:CGSizeMake(28, 28)];
            //[button setImage:image forState:UIControlStateNormal];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:data.image]];
            [imageView setFrame:CGRectMake(0, 0, 22, 22)];
            imageView.center = button.center;
            [button addSubview:imageView];
            
            
        }
        else {
            [button setTitle:data.keyword forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        index ++;
    }
}


- (void)layoutActionButtons:(UIView*)superView
{
    NSInteger count = [self.actionDatas count];
    NSInteger totalNumberInLine = 3;
    
    CGPoint center = CGPointMake(self.view.frame.size.width, self.heightBanner / 2);
    if(count > totalNumberInLine) {
        center.x -= self.heightBanner;
    }
    
    for(NSInteger index = 0; index < count ; index ++) {
        ButtonData *data = self.actionDatas[index];
        UIView *button = self.viewButtons[index];
        if(nil != data.image) {
            center.x -= self.heightBanner/2;
            [button setCenter:center];
            center.x -= self.heightBanner/2;
        }
        else {
            center.x -= self.heightBanner;
            [button setCenter:center];
            center.x -= self.heightBanner;
        }
        
        [superView addSubview:button];
    }
}


- (void)action:(UIButton*)button
{
    NSLog(@"action %@", button);
    NSInteger index = button.tag - self.tagButtons;
    ButtonData *data = self.actionDatas[index];
    [self actionViaString:data.keyword];
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


- (void)actionAddData:(ButtonData *)actionData
{
    [self.actionDatas addObject:actionData];
}


- (void)actionViaString:(NSString *)string
{
    NSLog(@"need to override.");
    [self doesNotRecognizeSelector:@selector(actionViaString:)];
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
