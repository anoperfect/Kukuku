//
//  ViewController.m
//  Layoutsubviews
//
//  Created by Ben on 15/9/3.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ViewController.h"
#import "View.h"
#define LOG NSLog(@"%d", __LINE__);
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 36, 36)];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(expandHeight) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    
    LOG
    View *view = [[View alloc] initWithFrame:CGRectMake(100, 100, 360, 360)];
    [view setTag:1];
    
    LOG
    [self.view addSubview:view];
    LOG
}


- (void)expandHeight {
    LOG
    
    
    View *view = (View*)[self.view viewWithTag:1];
    CGRect frame = view.frame;
    frame.size.height += 20;
    
    LOG
    [view setFrame:frame];
    LOG
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
