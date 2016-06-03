//
//  CustomViewController.m
//  hacfun
//
//  Created by Ben on 15/8/17.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "MBProgressHUD.h"
#import "CustomViewController.h"
#import "FuncDefine.h"
#import "AppConfig.h"
#import "BannerView.h"
#import "ButtonData.h"




@interface CustomViewController () <MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray    *actionDatas;
@property (nonatomic, assign) NSInteger     tagButtons;

@property (nonatomic, strong) BannerView    *bannerView;
//@property (nonatomic, strong) UILabel       *viewIndication;

//显示提示信息.
@property (nonatomic, strong) UILabel       *messageIndication;
//用于定时关闭提示信息.
@property (nonatomic, strong) NSTimer       *messageIndicationAutoCloseTimer;

@property (nonatomic, assign) CGFloat heightBanner ;

@property (nonatomic, assign) CGRect viewFrameRecord;


@property (nonatomic, strong) MBProgressHUD *messageIndicationHUD;
@end

@implementation CustomViewController


static NSMutableArray *kstatisticsCustomViewController = nil;


- (instancetype)init
{
    self = [super init];
    
    if(nil != self) {
        self.actionDatas = [[NSMutableArray alloc] init];
        self.yBolowView = 0;
        self.heightBanner = 36;
        self.tagButtons = 100;
        self.heightWastageByNavigationBar = 64;
        self.frameSoftKeyboard = CGRectZero;
        self.isShowingSoftKeyboard = NO;
    }
    
    if(!kstatisticsCustomViewController) {
        kstatisticsCustomViewController = [[NSMutableArray alloc] init];
    }
    
    NSUInteger addr = (NSUInteger)self;
    [kstatisticsCustomViewController addObject:@{[NSNumber numberWithUnsignedInteger:addr]:[self class]}];
    NSLog(@"///init    %@", self);
    NSLog(@"///kstatisticsCustomViewController count : %zd", [kstatisticsCustomViewController count]);
    
    return self;
}


- (void)viewDidLoad {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageIndication = [[UILabel alloc] init];
    self.messageIndication.backgroundColor = [UIColor colorWithName:@"messageIndicationBackground"];
    self.messageIndication.textColor = [UIColor colorWithName:@"messageIndicationText"];
    self.messageIndication.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.messageIndication];
    
    self.view.backgroundColor = [UIColor colorWithName:@"ContentBackground"];

    //去除哪个什么snapshot的警告.
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
}


- (void)custmizeBackgroundViewNavigationBar
{
    NSString *name = @"NavigationBar";
    NSString *backgroundColorName = @"NavigationBarBackground";
    NSLog(@"Reset %@ backgroundImage", name);
    BackgroundViewItem *backgroundview = [[AppConfig sharedConfigDB] configDBBackgroundViewGetByName:name];
    UIImage *image = nil;
    if(backgroundview.onUse && backgroundview.imageData.length > 0 && nil != (image = [UIImage imageWithData:backgroundview.imageData])) {
        image = [UIImage thumbOfImage:image fitToSize:self.navigationController.navigationBar.frame.size isFillBlank:YES fillColor:[UIColor colorWithName:backgroundColorName] borderColor:[UIColor orangeColor] borderWidth:0];
        
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        NSLog(@"Reset %@ backgroundImage finished.", name);
    }
    else {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithName:@"NavigationBarBackground"];
        self.navigationController.navigationBar.translucent = NO;
    }
}



- (void)custmizeBackgroundViewContent
{
    NSString *name = @"Content";
    NSString *backgroundColorName = @"ContentBackground";
    NSLog(@"Reset %@ backgroundImage", name);
    BackgroundViewItem *backgroundview = [[AppConfig sharedConfigDB] configDBBackgroundViewGetByName:name];
    UIImage *image = nil;
    if(backgroundview.onUse && backgroundview.imageData.length > 0 && nil != (image = [UIImage imageWithData:backgroundview.imageData])) {
        image = [UIImage thumbOfImage:image fitToSize:self.view.frame.size isFillBlank:YES fillColor:[UIColor colorWithName:backgroundColorName] borderColor:[UIColor orangeColor] borderWidth:0];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        NSLog(@"Reset %@ backgroundImage finished.", name);
    }
    else {
        self.view.backgroundColor = [UIColor colorWithName:backgroundColorName];
        NSLog(@"Clear %@ backgroundImage finished.", name);
    }
}


- (void)custmizeBackgroundViewToolBar
{
    NSString *name = @"ToolBar";
    NSString *backgroundColorName = @"ToolBarBackground";
    NSLog(@"Reset %@ backgroundImage", name);
    
    BackgroundViewItem *backgroundview = [[AppConfig sharedConfigDB] configDBBackgroundViewGetByName:name];
    UIImage *image = nil;
    if(backgroundview.onUse && backgroundview.imageData.length > 0 && nil != (image = [UIImage imageWithData:backgroundview.imageData])) {
        image = [UIImage thumbOfImage:image fitToSize:self.navigationController.toolbar.frame.size isFillBlank:YES fillColor:[UIColor colorWithName:backgroundColorName] borderColor:[UIColor orangeColor] borderWidth:0];
        
        self.navigationController.toolbar.backgroundColor = [UIColor colorWithPatternImage:image];
        NSLog(@"Reset %@ backgroundImage finished.", name);
    }
    else {
        self.navigationController.toolbar.backgroundColor = [UIColor colorWithName:backgroundColorName];
        NSLog(@"Clear %@ backgroundImage finished.", name);
        NSLog(@"%@", backgroundview);
    }
}


- (void)viewWillLayoutSubviews {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewWillLayoutSubviews];
    
    if(!CGRectEqualToRect(self.view.frame, self.viewFrameRecord)) {
        [self custmizeBackgroundViewContent];
    }
    
    [self custmizeBackgroundViewToolBar];

    self.viewFrameRecord = self.view.frame;
    
    CGFloat heightViewIndication = 36;
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.frame.size];
    [layout setUseIncludedMode:@"messageIndication" includedTo:FRAMELAYOUT_NAME_MAIN withPostion:FrameLayoutPositionTop andSizeValue:36];
    //    self.messageIndication.frame = [layout getCGRect:@"messageIndication"];
    self.messageIndication.text = @"111111";
    self.messageIndication.frame = CGRectMake(0, -heightViewIndication, self.view.frame.size.width, heightViewIndication);
     
    [self layoutBannerView];
    
    NSLog(@"mnb - %@", [NSString stringFromCGRect:self.view.frame]);
    NSLog(@"mnb - %@", [NSString stringFromCGRect:self.view.bounds]);
}





//经过测试发现. 设置bannerView为leftBarButtonItem的时候, 由于rightbutton的数量的不同, 导致leftBarButtonItem的位置有偏移. 因此仍然沿用之前的addSubView的方式.
//修改右边功能键的布局. 之前是布局到BannerView上. 修改为布局到rightBarButtonItems.
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    

    
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    self.bannerView = [[BannerView alloc] init];
    [self.bannerView setTag:(NSInteger)@"BannerView"];
    [self.navigationController.navigationBar addSubview:self.bannerView];
    [self.bannerView.buttonTopic addTarget:self action:@selector(clickButtonTopic) forControlEvents:UIControlEventTouchDown];
    [self.bannerView setTextTopic:self.textTopic];
    [self layoutBannerView];
    
    
    DISPATCH_ONCE_START
    NSLog(@"x %@- %@", self.navigationController.navigationBar, [self.navigationController.navigationBar subviews]);
    DISPATCH_ONCE_FINISH
    
    [self layoutRightActions];
    
    self.navigationController.toolbarHidden = YES;
    
#if 0
    BackgroundViewItem *backgroundview = [[AppConfig sharedConfigDB] configDBBackgroundViewGetByName:@"NavigationBar"];
    UIImage *image = nil;
    if(backgroundview.onUse && backgroundview.imageData.length > 0 && nil != (image = [UIImage imageWithData:backgroundview.imageData])) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithName:@"NavigationBarBackground"];
        self.navigationController.navigationBar.translucent = NO;
    }

    self.navigationController.toolbar.backgroundColor = [UIColor colorWithName:@"ToolBarBackground"];
#endif
    
    [self custmizeBackgroundViewNavigationBar];
    [self custmizeBackgroundViewToolBar];
    
    [self.navigationItem setHidesBackButton:YES];
    
    return ;
}


- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    
    self.navigationItem.rightBarButtonItems = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewDidAppear:animated];
    [self.messageIndication.superview bringSubviewToFront:self.messageIndication];
}


- (void)layoutBannerView
{
    //banner.
    CGFloat heightBanner = 36;
    
    CGFloat yBanner = -2;
    if(self.view.frame.size.width < self.view.frame.size.height) {
        yBanner = 4;
    }
//    CGRect bannerViewRect = CGRectMake(0, yBanner, self.view.frame.size.width, heightBanner);
    CGRect bannerViewRect = CGRectMake(0, yBanner, self.view.frame.size.width / 2, heightBanner);
    [self.bannerView setFrame:bannerViewRect];
    LOG_RECT(self.bannerView.frame, @"bannerView")
}



- (void)layoutRightActions
{
    self.navigationItem.rightBarButtonItems = nil;
    
    NSMutableArray *rightItems = [[NSMutableArray alloc] init];
    
    //重新加载按钮.
    NSInteger index = 0;
    for(ButtonData *data in self.actionDatas) {
        PushButton *button = [[PushButton alloc] init];
        button.actionData = data;
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
        [button setFrame:CGRectMake(0, 0, self.heightBanner, self.heightBanner)];
        if(nil != data.imageName) {
            UIImage *image = [UIImage imageNamed:data.imageName];
            button.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
            [button setImage:image forState:UIControlStateNormal];
            [rightItems addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
        }
        else {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:data.keyword
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(toolBarAction:)];
            [rightItems addObject:item];
        }
        
        index ++;
    }
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:rightItems];
}


- (void)action:(PushButton*)button
{
    NSLog(@"action %@", button);
    ButtonData *data = button.actionData;
    [self actionViaString:data.keyword];
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


- (void)actionRefresh
{
    [self layoutRightActions];
}


- (void)actionViaString:(NSString *)string
{
    if([string isEqualToString:@"more"]) {
        if(self.navigationController.toolbarHidden) {
            [self showToolBar];
        }
        else {
            [self hiddenToolBar];
        }
        
        return;
    }
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
    containerView.backgroundColor = [UIColor colorWithName:@"PopupContainerBackground"];
    containerView.alpha = 0.9;
    containerView.tag = TAG_popupView_container;
    [self.view addSubview:containerView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopupView)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [containerView addGestureRecognizer:tapGestureRecognizer];
    
    [containerView addSubview:view];
    
    
//    CustomViewController *pvc = [[CustomViewController alloc] init];
//    [pvc.view addSubview:view];
//    pvc.view.backgroundColor = [UIColor colorWithName:@"PopupContainerBackground"];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:pvc action:@selector(dismissPopupView)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    [pvc.view addGestureRecognizer:tapGestureRecognizer];
//    
//    [self presentViewController:pvc animated:NO completion:^{
//        [pvc.navigationController setNavigationBarHidden:YES];
//    }];
////    [self.navigationController pushViewController:pvc animated:NO];
    
    
}


- (void)dismissPopupView
{
    UIView *containerView = [self.view viewWithTag:TAG_popupView_container];
    for(id obj in containerView.subviews) {
        NSLog(@"%@", obj);
//        [obj removeObserver:self forKeyPath:@"frame"];
        [obj removeFromSuperview];
    }
    
    [containerView removeFromSuperview];
    containerView = nil;
}


- (void)dealloc
{
    BOOL found = NO;
    NSUInteger addr = (NSUInteger)self;
    NSInteger count = [kstatisticsCustomViewController count];
    NSInteger index = 0;
    for(index = 0; index < count; index ++) {
        NSDictionary *dict = kstatisticsCustomViewController[index];
        id obj = [dict objectForKey:[NSNumber numberWithUnsignedInteger:addr]];
        if(obj) {
            found = YES;
            NSLog(@"///dealloc %@", self);
            break;
        }
    }
    
    if(found) {
        [kstatisticsCustomViewController removeObjectAtIndex:index];
    }
    else {
        NSLog(@"///#error : not found obj <%@>", self);
    }
    NSLog(@"///kstatisticsCustomViewController count : %zd", [kstatisticsCustomViewController count]);
}


- (void)showIndicationText1:(NSString*)text
{
    NSLog(@"---xxx0 : >>>>>>IndicationText : %@", text);
    //[self.view bringSubviewToFront:self.messageIndication];
    
    NSLog(@"%@", self.messageIndication);
    
    self.messageIndication.text = text;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.messageIndication.frame = CGRectMake(0, 0, self.view.frame.size.width, 36);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    NSLog(@"%@", self.messageIndication);
    
    [self.messageIndicationAutoCloseTimer invalidate];
    self.messageIndicationAutoCloseTimer = nil;
    self.messageIndicationAutoCloseTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                            target:self
                                                                          selector:@selector(hideIndicationText1)
                                                                          userInfo:nil
                                                                           repeats:NO];
}


- (void)hideIndicationText1
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.messageIndication.frame = CGRectMake(0, -36, self.view.frame.size.width, 36);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (void)showIndicationText:(NSString*)text
{
    NSLog(@"---xxx0 : >>>>>>IndicationText : %@", text);
    
    if(!self.messageIndicationHUD) {
        self.messageIndicationHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.messageIndicationHUD.mode = MBProgressHUDModeText;
        self.messageIndicationHUD.userInteractionEnabled = NO;
        self.messageIndicationHUD.delegate = self;
        self.messageIndicationHUD.removeFromSuperViewOnHide = NO; //设置这个.
    }
    
    self.messageIndicationHUD.labelText = text;
    [self.messageIndicationHUD show:YES];
    [self.messageIndicationHUD hide:YES afterDelay:3.0];
}

////一直沿用self.messageIndicationHUD可能导致不能显示. 注意设置self.messageIndicationHUD.removeFromSuperViewOnHide = NO;
//- (void)hudWasHidden:(MBProgressHUD *)hud
//{return ;
//    self.messageIndicationHUD = nil;
//}














- (NSArray*)toolData
{
    LOG_POSTION
    return nil;
}


- (void)showToolBar
{
    LOG_POSTION
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    NSArray *toolDatas = [self toolData];
    NSLog(@"toolbar items : %zd", toolDatas.count);
    
    //重新加载按钮.
    NSInteger index = 0;
    for(ButtonData *data in toolDatas) {
        
        if(index > 0) {
            UIBarButtonItem *flexibleitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
            [toolBarItems addObject:flexibleitem];
        }
        
        NSLog(@"index : %zd, %@ %@", index, data.keyword, data.imageName);
        
        PushButton *button = [[PushButton alloc] init];
        button.actionData = data;
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
        [button setFrame:CGRectMake(0, 0, self.heightBanner, self.heightBanner)];
        if(data.triggerOn) {
            button.backgroundColor = [UIColor colorWithName:@"CustomButtonTriggerOnBackground"];
        }
        UIBarButtonItem *item = nil;
        if(nil != data.imageName) {
            UIImage *image = [UIImage imageNamed:data.imageName];
            button.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
            [button setImage:image forState:UIControlStateNormal];
            item = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
        else {
            //[button setTitle:data.keyword forState:UIControlStateNormal];
            //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            item = [[UIBarButtonItem alloc] initWithTitle:data.keyword
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(toolBarAction:)];

        }
        
        item.tintColor = [UIColor yellowColor];
        [toolBarItems addObject:item];
        
        
        
        index ++;
    }
    
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = [NSArray arrayWithArray:toolBarItems];
}


- (void)hiddenToolBar
{
    self.navigationController.toolbarHidden = YES;
}


- (void)toolBarAction:(UIBarButtonItem *)sender
{
    [self actionViaString:sender.title];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
