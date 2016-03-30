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
    
    PostData *d = nil;
    PostDataCellView *v = nil;
    
    d = [[PostData alloc] init];
    d.uid = @"qwertyui";
    d.replyCount = 10;
    d.content = @"应用开发的时候，加载数据的时候需要加载页面，如果没用，那么就缺少人性化设计了。系统自带的是UIActivityIndicatorView，但它缺少文字说明，要加上文字说明的loading view只有自子封装。""应用开发的时候，加载数据的时候需要加载页面，如果没用，那么就缺少人性化设计了。系统自带的是UIActivityIndicatorView，但它缺少文字说明，要加上文字说明的loading view只有自子封装。""应用开发的时候，加载数据的时候需要加载页面，如果没用，那么就缺少人性化设计了。系统自带的是UIActivityIndicatorView，但它缺少文字说明，要加上文字说明的loading view只有自子封装。"
    ;
    
    v = [[PostDataCellView alloc] initWithFrame:CGRectMake(1, 29, 100, 100)];
    [self.view addSubview:v];
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