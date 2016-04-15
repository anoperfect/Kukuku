//
//  TestViewController.m
//  hacfun
//
//  Created by Ben on 15/8/9.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "TestViewController.h"
#import "RTLabel.h"
#import "ReferencePopupView.h"
#import "AppConfig.h"
#import "FuncDefine.h"


#import "PostDataCellViewLoad.h"
#import "NSLogn.h"
@interface TestViewController () <RTLabelDelegate>

@end

@implementation TestViewController

static UIView *kv = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSString *str = @"123";
    //NSLog(@"---%zi", [str integerValue]);
    
    
    NSInteger count;
    UIView *v = [[UIView alloc] init];
    
//    count = RetainCount(v); NSLog(@"retainCount : %zd", count);
    
    kv = v;
//    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
//    __weak UIView *vvvp = v;
//    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
//    UIView *v1 = v;
//    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
    [self.view addSubview:v];
//    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
    [v removeFromSuperview];
//    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
    v = nil;
//    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
    LOG_POSTION
    
    NSString *searchText = @"1>>123 abc >>4567890 def";
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length-1);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@">>[0-9]+" options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound) {
            break;
        }
        
        [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
        [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - 1 - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NSLog(@"%zi %zi",
              [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
              [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
              [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
              [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *sub = [searchText substringWithRange:NSMakeRange(range.location+2, range.length-2)];
        NSString *replacement = [NSString stringWithFormat:@"<a href='NO.%@'>>>%@</a>", sub, sub];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    NSLog(@"after : \n%@", searchText);
    
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(20, 100, 360, 36)];
    [self.view addSubview:label];
    label.delegate = self;
    [label setText:searchText];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    [self.view addSubview:button];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 450, 100, 36)];
    [self.view addSubview:button1];
    [button1 setBackgroundColor:[UIColor blueColor]];
    [button1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    [button1 setTag:0];
    [button1 setTitle:@"重建数据库" forState:UIControlStateNormal];
    
    button1 = [[UIButton alloc] initWithFrame:CGRectMake(111, 450, 100, 36)];
    [self.view addSubview:button1];
    [button1 setBackgroundColor:[UIColor blueColor]];
    //[button1 addTarget:self action:@selector(postDataCellViewTest:) forControlEvents:UIControlEventTouchDown];
    [button1 setTag:0];
    [button1 setTitle:@"postDataCellViewTest" forState:UIControlStateNormal];
    
    button1 = [[UIButton alloc] initWithFrame:CGRectMake(222, 450, 100, 36)];
    [self.view addSubview:button1];
    [button1 setBackgroundColor:[UIColor blueColor]];
    [button1 addTarget:self action:@selector(testAppConfig) forControlEvents:UIControlEventTouchDown];
    [button1 setTag:0];
    [button1 setTitle:@"AppConfig" forState:UIControlStateNormal];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    view2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view2];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view2.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view2.bounds;
    maskLayer.path = maskPath.CGPath;
    view2.layer.mask = maskLayer;
    
    NSDate *collectionDate = [NSDate date];
    NSInteger interval = [collectionDate timeIntervalSince1970];
    NSLog(@"inteval = %zd.", interval);
    
    NSLog(@"%@------", [NSThread currentThread]);
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array firstObject];
    NSLog(@"document path : %@", documentPath);
    
    count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
    
    NSString *sqlString;
    sqlString = @"create table if not exists draft(sn integer, content var, selectedtimes integer)";
    NSLog(@"-/- test config : [%@]", sqlString);
    [[AppConfig sharedConfigDB] configDBTestOnConfig:sqlString];
    
    
    
    
    
}


- (void)viewWillLayoutSubviews {
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    LOG_RECT(applicationFrame, @"applicationFrame")
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    LOG_RECT(bounds, @"bounds")
    
    CGRect rectView = self.view.frame;
    LOG_RECT(rectView, @"self.view")
    
    
    NSInteger count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSInteger count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
    
    NSLogn *log = [[NSLogn alloc] init];
    log = nil;
//    [log sendTcpContent];
}


- (void)testAppConfig {
    LOG_POSTION
   
//    NSInteger result = 0;
//    result = [[AppConfig sharedConfigDB] configDBPostInsert:@{@"id":@(100)} orReplace:NO];
//    NSLog(@"result : %zi", result);
    
    
    
    
}





- (void)click:(UIButton*)button {
    
    if(0 == button.tag) {
        //NSLog(@"rebuild database.");
        //[[AppConfig sharedConfigDB] configDBBuildWithForceRebuild:YES];
        
        NSLog(@"delete database.");
        [[AppConfig sharedConfigDB] configDBTestClearForRebuild];
    }
}








- (void)click {
    NSLog(@"click");
//    
////    ReferencePopupView *popupView = [ReferencePopupView PopopInView:self.view];
//        ReferencePopupView *popupView = [[ReferencePopupView alloc] initWithSuperView:self.view numOfTapToClose:1 secondsOfAutoClose:0];
//    
//    CGRect frame = popupView.frame;
//    NSLog(@"%lf %lf %lf %lf", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
//    
//    NSInteger no = 6460295;
//    [popupView setReferenceId1:no];
    
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", array);
    NSString *documentPath = [array firstObject];
    
    NSLog(@"%@", documentPath);
    NSString *imageCachePath = [NSString stringWithFormat:@"%@/h1acfun.tv/ImageCache", documentPath];
    
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSLog(@"result : %zi", bo);
    
    
    
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSLog(@"url = %@", url);
}


- (NSString*)addLinkForReferenceNumber:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length-1);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@">>[0-9]+" options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound) {
            break;
        }
        
        [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
        [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - 1 - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NSLog(@"%zi %zi",
              [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
              [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *sub = [searchText substringWithRange:NSMakeRange(range.location+2, range.length-2)];
        NSString *replacement = [NSString stringWithFormat:@"<a href='NO.%@'>>>%@</a>", sub, sub];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return searchText;
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSInteger count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
}


- (void)viewDidDisappear:(BOOL)animated
{
    NSInteger count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
}



- (void)dealloc
{
    NSInteger count = RetainCount(kv); NSLog(@"retainCount : %zd", count);
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






