//
//  TestViewController.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "TestViewController.h"
#import "ModelAndViewInc.h"
#import "MainVC.h"
@interface TestViewController ()




@property (nonatomic, assign) BOOL onAuth;
@property (nonatomic, assign) BOOL finishAuth;

@property (nonatomic, assign) BOOL onUpdateCategory;
@property (nonatomic, assign) BOOL finishUpdateCategory;

@property (nonatomic, assign) NSInteger authTimes;


@property (nonatomic, strong) PushButton *buttonAuth;
@property (nonatomic, strong) PushButton *buttonUpdate;
@property (nonatomic, strong) PushButton *buttonEnter;

@property (nonatomic, strong) AlignTopLabel       *labelInfo;


@end

@implementation TestViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textTopic = @"鉴权";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.buttonAuth = [[PushButton alloc] init];
    [self.view addSubview:self.buttonAuth];
    [self.buttonAuth setTitle:@"重新鉴权" forState:UIControlStateNormal];
    [self.buttonAuth addTarget:self action:@selector(auth) forControlEvents:UIControlEventTouchDown];
    self.buttonAuth.backgroundColor = [UIColor colorWithName:@"CustomButtonBackground"];
    self.buttonAuth.layer.borderWidth = 1;
    self.buttonAuth.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
    self.buttonAuth.layer.cornerRadius = 2.7;
    [self.buttonAuth setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
#if 0
    self.buttonUpdate = [[PushButton alloc] init];
    [self.view addSubview:self.buttonUpdate];
    [self.buttonUpdate setTitle:@"获取栏目" forState:UIControlStateNormal];
    [self.buttonUpdate addTarget:self action:@selector(updateCategory) forControlEvents:UIControlEventTouchDown];
    self.buttonUpdate.backgroundColor = [UIColor colorWithName:@"CustomButtonBackground"];
    self.buttonUpdate.layer.borderWidth = 1;
    self.buttonUpdate.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
    self.buttonUpdate.layer.cornerRadius = 2.7;
    [self.buttonUpdate setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
#endif
    self.buttonEnter = [[PushButton alloc] init];
    [self.view addSubview:self.buttonEnter];
    [self.buttonEnter setTitle:@"进入" forState:UIControlStateNormal];
    [self.buttonEnter addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchDown];
    self.buttonEnter.backgroundColor = [UIColor colorWithName:@"CustomButtonBackground"];
    self.buttonEnter.layer.borderWidth = 1;
    self.buttonEnter.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
    self.buttonEnter.layer.cornerRadius = 2.7;
    [self.buttonEnter setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
    self.buttonEnter.hidden = YES;
    
    self.labelInfo = [[AlignTopLabel alloc] init];
    self.labelInfo.text = @"";
    [self.view addSubview:self.labelInfo];
    //    self.labelInfo0.editable = NO;
    self.labelInfo.backgroundColor = [UIColor colorWithName:@"CustomLabelBackground"];
    self.labelInfo.layer.borderWidth = 1;
    self.labelInfo.layer.borderColor = [UIColor colorWithName:@"CustomLabelBorder"].CGColor;
    self.labelInfo.layer.cornerRadius = 2.7;
    self.labelInfo.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.labelInfo.numberOfLines = 0;
    self.labelInfo.textColor = [UIColor colorWithName:@"CustomLabelText"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self auth];
    });
}


- (void)viewWillLayoutSubviews
{
    self.buttonAuth.frame = CGRectMake(10, 36, 127, 36);
    self.buttonUpdate.frame = CGRectMake(10, 80, 127, 36);
    
    self.labelInfo.frame = CGRectMake(10, 127, self.view.bounds.size.width - 2 * 10, 360);
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.bounds.size];
    [layout arrangeInHerizonIn:FRAMELAYOUT_NAME_MAIN toNameAndPercentageHeights:@[
                                                                                    @{@"top":@0.02},
                                                                                    @{@"bottons":@0.1},
                                                                                    @{@"info":@0.7},
                                                                                    @{@"buttom":@0.02}
                                                                                 ]
    ];
    
    [layout divideInVertical:@"bottons" to:@"buttonAuthAll" and:@"buttonUpdateAll" withPercentage:0.5];
    [layout setUseEdge:@"buttonAuth"    in:@"buttonAuthAll"     withEdgeValue:UIEdgeInsetsMake(6, 10, 6, 10)];
    [layout setUseEdge:@"buttonUpdate"  in:@"buttonUpdateAll"   withEdgeValue:UIEdgeInsetsMake(6, 10, 6, 10)];
    [layout setUseEdge:@"labelInfo"     in:@"info"              withEdgeValue:UIEdgeInsetsMake(6, 10, 6, 10)];

    self.buttonAuth.frame       = [layout getCGRect:@"buttonAuth"];
    self.buttonUpdate.frame     = [layout getCGRect:@"buttonUpdate"];
    self.buttonEnter.frame      = [layout getCGRect:@"buttonUpdate"];
    self.labelInfo.frame        = [layout getCGRect:@"labelInfo"];
    
}


- (void)auth
{
    self.labelInfo.text = @"";

    if(self.onAuth) {
        [self appendInfo:@"正在鉴权.\n"];
        return ;
    }
    
    self.finishAuth             = NO;
    self.finishUpdateCategory   = NO;
    self.authTimes ++;
    if(self.authTimes > 1) {
        [self appendInfo:[NSString stringWithFormat:@"第%zd次鉴权.\n", self.authTimes]];
    }
    
    self.onAuth = YES;
    [self appendInfo:@"鉴权中.\n"];
    [[AppConfig sharedConfigDB] authAsync:^(BOOL result){
        self.onAuth = NO;
        if(result) {
            [self showIndicationText:@"鉴权OK."];
            [self appendInfo:@"鉴权OK.\n"];
            self.finishAuth = YES;
            
            [self appendInfo:@"准备更新栏目信息.\n"];
            [self updateCategory];
        }
        else {
            [self appendInfo:@"鉴权失败.\n"];
            [self showIndicationText:@"鉴权失败."];
        }
    }];
}


- (void)updateCategory
{
    if(self.onUpdateCategory) {
        [self appendInfo:@"正在更新栏目信息.\n"];
        return ;
    }
    
    self.onUpdateCategory = YES;
    //检查category更新.
    [[AppConfig sharedConfigDB] updateCategoryAsync:^(BOOL result, NSInteger total, NSInteger updateNumber){
        self.onUpdateCategory = NO;
        NSLog(@"%d %zd %zd", result, total, updateNumber);
        
        if(result) {
            [self appendInfo:@"更新栏目信息OK.\n"];
            self.finishUpdateCategory = YES;
        }
        else {
            [self appendInfo:@"更新栏目信息失败.\n"];
            self.finishUpdateCategory = NO;
        }
        
        if(total > 0) {
            self.buttonEnter.hidden = NO;
            if(self.authTimes == 1) {
                [self enter];
            }
        }
    }];
}


- (void)enter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MainVC *mainVC = [[MainVC alloc] init];
        [self.navigationController setViewControllers:@[mainVC] animated:NO];
    });
}


#if 0
写一个ios app. 发现一个蜜汁闪退. 请指点一下谢.
试着描述一下问题.
UITableView显示http接口获取的解析后信息.
上拉的时候设置规则是上拉一定高度后, 触发异步网络交互获取下一页, 然后刷新页面.
如果已经触发此事件则继续上拉不会重新进行交互.
一般这个过程是没有问题的.
问题是:
如果用户在这个网络交互的时候, 频繁的进行上拉,弹回,上拉的话, 很可能(60%?)会产生闪退.
大致错误是说操作NSArrayM 的 index 比 count 大.
目前只会通过打印调试.
对这个问题有什么建议呢? 或者调试的方法?

堆栈信息.
Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM objectAtIndex:]: index 2 beyond bounds [0 .. 1]'
*** First throw call stack:
(
	0   CoreFoundation                      0x000000010fcf3d85 __exceptionPreprocess + 165
	1   libobjc.A.dylib                     0x000000010f762deb objc_exception_throw + 48
	2   CoreFoundation                      0x000000010fbd1804 -[__NSArrayM objectAtIndex:] + 212
	3   UIKit                               0x0000000110cd0c88 -[UITableView _existingCellForRowAtIndexPath:] + 159
	4   UIKit                               0x0000000110cd3567 -[UITableView highlightRowAtIndexPath:animated:scrollPosition:] + 613
	5   UIKit                               0x0000000110cd8218 -[UITableView touchesBegan:withEvent:] + 1084
	6   UIKit                               0x0000000110da0227 forwardTouchMethod + 349
	7   UIKit                               0x0000000110da00b9 -[UIResponder touchesBegan:withEvent:] + 49
	8   UIKit                               0x0000000110cb4805 -[UITableViewWrapperView touchesBegan:withEvent:] + 136
	9   UIKit                               0x0000000110da0227 forwardTouchMethod + 349
	10  UIKit                               0x0000000110da00b9 -[UIResponder touchesBegan:withEvent:] + 49
	11  UIKit                               0x0000000110f0d531 -[UITableViewCell touchesBegan:withEvent:] + 132
	12  UIKit                               0x0000000110da0227 forwardTouchMethod + 349
	13  UIKit                               0x0000000110da00b9 -[UIResponder touchesBegan:withEvent:] + 49
	14  UIKit                               0x0000000110da0227 forwardTouchMethod + 349
	15  UIKit                               0x0000000110da00b9 -[UIResponder touchesBegan:withEvent:] + 49
	16  UIKit                               0x0000000110c01790 -[UIWindow _sendTouchesForEvent:] + 308
	17  UIKit                               0x0000000110c026d4 -[UIWindow sendEvent:] + 865
	18  UIKit                               0x0000000110baddc6 -[UIApplication sendEvent:] + 263
	19  UIKit                               0x0000000110b87553 _UIApplicationHandleEventQueue + 6660
	20  CoreFoundation                      0x000000010fc19301 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
	21  CoreFoundation                      0x000000010fc0f22c __CFRunLoopDoSources0 + 556
	22  CoreFoundation                      0x000000010fc0e6e3 __CFRunLoopRun + 867
	23  CoreFoundation                      0x000000010fc0e0f8 CFRunLoopRunSpecific + 488
	24  GraphicsServices                    0x0000000114c8cad2 GSEventRunModal + 161
	25  UIKit                               0x0000000110b8cf09 UIApplicationMain + 171
	26  hacfun                              0x000000010eb8baff main + 111
	27  libdyld.dylib                       0x0000000112d8492d start + 1
	28  ???                                 0x0000000000000001 0x0 + 1

#endif



- (void)appendInfo:(NSString*)info
{
    NSString *text = self.labelInfo.text;
    text = [NSString stringWithFormat:@"%@%@", text?text:@"", info];
    self.labelInfo.text = text;
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
