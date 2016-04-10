//
//  CategoryViewController.m
//  hacfun
//
//  Created by Ben on 15/8/1.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "CategoryViewController.h"
#import "FuncDefine.h"
#import "CreateViewController.h"
#import "DetailViewController.h"
#import "AppConfig.h"
#import "MainVC.h"


@interface CategoryViewController ()


@property (strong,nonatomic) NSString *nameCategory;
@property (strong,nonatomic) NSString *linkCategory;

@end

@implementation CategoryViewController



- (instancetype)init
{
    self = [super init];
    
    if(nil  != self) {
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"refresh";
        actionData.image    = @"refresh";
        [self actionAddData:actionData];
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword  = @"new";
        actionData.image    = @"edit";
        [self actionAddData:actionData];
        
        NSLog(@"kcountObject %@ : %zd", @"PostDataCellView", [PostDataCellView countObject]);
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"main : %@", [AMSlideMenuMainViewController allInstances]);
    NSLog(@"main getInstanceForVC : %@", [AMSlideMenuMainViewController getInstanceForVC:self]);
    NSLog(@"main nvc : %@", [AMSlideMenuMainViewController getInstanceForVC:self].currentActiveNVC);
    NSLog(@"self nvc : %@", self.navigationController);
}


- (void)setCategoryName:(NSString*)categoryName withLink:(NSString*)cateogryLink{
    LOG_POSTION
    self.nameCategory = [categoryName copy];
    self.linkCategory = [cateogryLink copy];
    NSLog(@"link %@", self.linkCategory);
    self.textTopic = self.nameCategory;
}


- (void)actionViaString:(NSString*)string
{
    NSLog(@"action string : %@", string);
    if([string isEqualToString:@"refresh"]) {
        [self refreshPostData];
        return;
    }
    
    if([string isEqualToString:@"new"]) {
        [self createNewPost];
        return;
    }
}


- (void)createNewPost {
    CreateViewController *createViewController = [[CreateViewController alloc]init];
    [createViewController setCreateCategory:self.nameCategory withOriginalContent:nil];
    
    [self.navigationController pushViewController:createViewController animated:YES];
}


- (NSInteger)numInOnePage {
#define NUM_IN_PAGE 10
    return NUM_IN_PAGE;
}


- (NSString*)getDownloadUrlString {
    NSInteger count = [self.postDatas count];
    self.pageNum = count/[self numInOnePage] + 1;
    return [NSString stringWithFormat:@"%@/%@?page=%zi", self.host, self.linkCategory, self.pageNum];
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    
    NSInteger threadId = ((PostData*)[self.postDatas objectAtIndex:row]).id;
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId];

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData {
    [super layoutCell:cell withRow:row withPostData:postData];
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
