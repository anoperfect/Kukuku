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
    
    [[AppConfig sharedConfigDB] authAsync:^(BOOL result){
        if(result) {
            [self showIndicationText:@"鉴权OK."];

        }
        else {
            [self showIndicationText:@"鉴权失败."];
        }
    }];
    
    //检查category更新.
    [[AppConfig sharedConfigDB] updateCategoryAsync:^(BOOL result, NSInteger total, NSInteger updateNumber){
        NSLog(@"%d %zd %zd", result, total, updateNumber);
        
        if(total > 0) {
            MainVC *mainVC = [[MainVC alloc] init];
            [self.navigationController setViewControllers:@[mainVC] animated:NO];
        }
        
        
        
    }];
    
    
    
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
