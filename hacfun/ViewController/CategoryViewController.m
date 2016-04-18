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

@property (nonatomic, strong) NSMutableDictionary *forumInfo;

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


//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    //kukuku是10个.
    //hacfun是20个.
    //这个配置写到配库.
    return [[[AppConfig sharedConfigDB] configDBGet:@"numberInCategoryPage"] integerValue ];
}


- (NSString*)getDownloadUrlString {
    //上一次加载满一个page的话, 才可以加载下一个page.
    if(self.numberLoaded == [self numberExpectedInPage:self.pageNumLoading]) {
        self.pageNumLoading ++;
    }
    
    return [NSString stringWithFormat:@"%@/%@?page=%zi", self.host, self.linkCategory, self.pageNumLoading];
}


//---override. different parse mothod.
- (NSMutableArray*)parseDownloadedData:(NSData*)data {
    NSMutableDictionary *addtional = [[NSMutableDictionary alloc] init];
    NSMutableArray *postDatas = [PostData parseFromCategoryJsonData:data atPage:self.pageNumLoading storeAdditional:addtional];
    NSLog(@"addtional : %@", addtional);
    
    NSString *key = @"forum";
    if([addtional[key] isEqual:self.forumInfo]) {
        NSLog(@"%@ info not change.", key)
    }
    else {
        NSLog(@"%@ info updated. \n%@\n%@", key, addtional[@"forum"], self.forumInfo);
        self.forumInfo = addtional[@"forum"];
    }
    
    return postDatas;
}


- (NSString*)getFooterViewTitleOnStatus:(ThreadsStatus)status
{
    if(status == ThreadsStatusLoadSuccessful) {
        return [NSString stringWithFormat:@"加载成功, 已加载%zd条.", self.postDatas.count];
    }
    
    return [super getFooterViewTitleOnStatus:status];
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    
    PostData *postDataPresent = [self.postDatas objectAtIndex:row];
    NSInteger threadId = postDataPresent.id;
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId withData:postDataPresent];

    [self.navigationController pushViewController:vc animated:YES];
}


//重载以定义cell能支持的动作. NSArray成员为 NSString.
- (NSArray*)actionStringsOnRow:(NSInteger)row
{
    return @[@"复制", @"举报", @"加入草稿"];
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
