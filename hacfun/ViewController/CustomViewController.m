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
        self.heightWastageByNavigationBar = 64;
        self.frameSoftKeyboard = CGRectZero;
        self.isShowingSoftKeyboard = NO;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [AppConfig backgroundColorFor:@"ViewController"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutBannerView];
    [self layoutActionButtons:self.bannerView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    self.bannerView = [[BannerView alloc] init];
    [self.bannerView setTag:(NSInteger)@"BannerView"];
    [self.navigationController.navigationBar addSubview:self.bannerView];
    [self.bannerView.buttonTopic addTarget:self action:@selector(clickButtonTopic) forControlEvents:UIControlEventTouchDown];
    [self.bannerView setTextTopic:self.textTopic];
    
    NSLog(@"x %@- %@", self.navigationController.navigationBar, [self.navigationController.navigationBar subviews]);

    [self layoutBannerView];

    // 布局功能键.
    [self loadActionButtons];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}


- (UIImage*) imageScale:(UIImage*)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


- (void)layoutBannerView
{
    //banner.
    CGFloat heightBanner = 36;
    
    CGFloat yBanner = -2;
    if(self.view.frame.size.width < self.view.frame.size.height) {
        yBanner = 4;
    }
    CGRect bannerViewRect = CGRectMake(0, yBanner, self.view.frame.size.width, heightBanner);
    [self.bannerView setFrame:bannerViewRect];
    LOG_RECT(self.bannerView.frame, @"bannerView")
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
    
    [self layoutActionButtons:self.bannerView];
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


- (void)setTopic:(NSString*)str {
    LOG_POSTION
    self.textTopic = str;
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


- (void)actionAddData:(ButtonData *)actionData
{
    [self.actionDatas addObject:actionData];
}


- (void)actionRemoveDataByKeyString:(NSString*)string
{
    for(ButtonData* data in self.actionDatas) {
        if([string isEqualToString:data.keyword]) {
            [self.actionDatas removeObject:data];
            break;
        }
    }
}


- (void)actionViaString:(NSString *)string
{
    NSLog(@"need to override.");
    [self doesNotRecognizeSelector:@selector(actionViaString:)];
}


- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}


#define TAG_popupView_container     1000000002

- (void)showPopupView:(UIView*)view
{
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.backgroundColor = [UIColor grayColor];
    containerView.alpha = 0.9;
    containerView.tag = TAG_popupView_container;
    [self.view addSubview:containerView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopupView)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [containerView addGestureRecognizer:tapGestureRecognizer];
    
    [containerView addSubview:view];
    view.center = view.superview.center;
    
    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)dismissPopupView
{
    UIView *containerView = [self.view viewWithTag:TAG_popupView_container];
    for(id obj in containerView.subviews) {
        NSLog(@"%@", obj);
        [obj removeObserver:self forKeyPath:@"frame"];
        [obj removeFromSuperview];
    }
//    [containerView.subviews makeObjectsPerformSelector:@selector(removeObserver:) withObject:self];
//    [containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [containerView removeFromSuperview];
    containerView = nil;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    LOG_POSTION
    if([keyPath isEqualToString:@"frame"]){//这里只处理balance属性
        LOG_POSTION
//        NSLog(@"keyPath=%@,object=%@,newValue=%.2f,context=%@",keyPath,object,[[change objectForKey:@"new"] floatValue],context);
        NSLog(@"%@", object);
        NSLog(@"%@", change);
        UIView *view = object;
        view.center = view.superview.center;
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
