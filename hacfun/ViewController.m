//
//  ViewController.m
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ViewController.h"
#import "PostDataCellView.h"
#import "CategoryViewController.h"
#import "FuncDefine.h"
#import "AppConfig.h"





@interface ViewController ()
@property (strong,nonatomic) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(2, 360, 45, 20)];
    self.btn.backgroundColor = [AppConfig backgroundColorFor:@"blueColor"];
    [self.btn setTitle:@"跳转" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnDidPush) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.btn];
    WIDTH_FIT(self.btn, 2)
    
    PostData *d = nil;
    PostDataCellView *v = nil;
    
    d = [[PostData alloc] init];
    d.uid = @"qwertyui";
    d.replyCount = 10;
    d.content = @"应用开发的时候，加载数据的时候需要加载页面，如果没用，那么就缺少人性化设计了。系统自带的是UIActivityIndicatorView，但它缺少文字说明，要加上文字说明的loading view只有自子封装。""应用开发的时候，加载数据的时候需要加载页面，如果没用，那么就缺少人性化设计了。系统自带的是UIActivityIndicatorView，但它缺少文字说明，要加上文字说明的loading view只有自子封装。""应用开发的时候，加载数据的时候需要加载页面，如果没用，那么就缺少人性化设计了。系统自带的是UIActivityIndicatorView，但它缺少文字说明，要加上文字说明的loading view只有自子封装。"
    ;
    
    v = [[PostDataCellView alloc] initWithFrame:CGRectMake(1, 29, 100, 100)];
    [self.view addSubview:v];
    WIDTH_FIT(v, 1)
//    [v setPostData:d inRow:0];
//
//    d = [[PostData alloc] init];
//    d.uid = @"qwertyui";
//    d.replyCount = 36;
//    d.content = @"fjskdf福建省看到分电视和发生的纠纷好是减肥速度房间好电视分活动时间返回 ii 舒服的合法手段发挥电视";
//    
//    v = [[PostDataCellView alloc] initWithFrame:CGRectMake(1, 200, 360, 100)];
//    [v setPostData:d];
//    [self.view addSubview:v];
}


- (void)showGif1 {
    
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
    //将图片转为NSData
    //NSData *gifData = [NSData dataWithContentsOfFile:path];
    //创建一个webView，添加到界面
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 150, 200, 200)];
    [self.view addSubview:webView];
    //自动调整尺寸
    webView.scalesPageToFit = YES;
    //禁止滚动
    webView.scrollView.scrollEnabled = NO;
    //设置透明效果
    webView.backgroundColor = [AppConfig backgroundColorFor:@"clearColor"];
    webView.opaque = 0;
    //加载数据
    //[webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
}


- (void) showGif2 {
    //创建UIImageView，添加到界面
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    [self.view addSubview:imageView];
    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i<7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"clock%02d.png",i]];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    imageView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    imageView.animationDuration = 6*0.15;
    //动画重复次数 （0为重复播放）
    imageView.animationRepeatCount = 0;
    //开始播放动画
    [imageView startAnimating];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gotoMainController {
    ThreadsViewController *pv = [[ThreadsViewController alloc]init];
    [self presentViewController:pv animated:YES completion:^(void){
    
        }
    ];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    
    [self gotoMainController];
}


- (void)btnDidPush {
    
    NSLog(@"执行跳转");
    
    [self gotoMainController];
}

@end