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



@interface CategoryViewController ()


@property (strong,nonatomic) NSString *nameCategory;
@property (strong,nonatomic) NSString *linkCategory;

@end

@implementation CategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setCategoryName:(NSString*)categoryName withLink:(NSString*)cateogryLink{
    LOG_POSTION
    self.nameCategory = [categoryName copy];
    self.linkCategory = [cateogryLink copy];
    NSLog(@"link %@", self.linkCategory);
    self.textTopic = self.nameCategory;
}


- (NSMutableArray*)getButtonDatas {
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    ButtonData *data ;
    
    data = [[ButtonData alloc] init];
    data.keyword = @"refresh";
    data.id = 'r';
    data.superId = 0;
    data.image = @"refresh";
    data.title = @"";
    data.method = 1;
    data.target = self;
    data.sel = @selector(refreshPostData);
    [ary addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"new";
    data.id = 'n';
    data.superId = 0;
    data.image = @"edit";
    data.title = @"";
    data.method = 1;
    data.target = self;
    data.sel = @selector(createNewPost);
    [ary addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"more";
    data.id = 'm';
    data.superId = 0;
    data.image = @"more";
    data.title = @"";
    data.method = 1;
    data.target = self;
//    data.sel = @selector(showMoreMenu);
//    [ary addObject:data];
    
    return ary;
}


- (void)createNewPost {
    CreateViewController *vc = [[CreateViewController alloc]init];
    [vc setCategory:self.nameCategory];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numInOnePage {
#define NUM_IN_PAGE 10
    return NUM_IN_PAGE;
}


- (NSString*)getDownloadUrlString {
    NSInteger count = [self.postDatas count];
    NSInteger pageNum = count/[self numInOnePage] + 1;
    return [NSString stringWithFormat:@"%@/%@?page=%zi", self.host, self.linkCategory, pageNum];
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    
    NSInteger threadId = ((PostData*)[self.postDatas objectAtIndex:row]).id;
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId];

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData {
    NSLog(@"cell %zd layoutCell.", row);
    
    UIView *view = [cell viewWithTag:102];
    if(NULL == view) {
        
        CGRect frame = [cell viewWithTag:100].frame;
        frame.origin.x += 3;
        frame.origin.y += 3;
        frame.size.width -= 2 * 3;
        frame.size.height -= 2 * 3;
        
        view = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:view];
        [cell sendSubviewToBack:view];
        [view setTag:102];
        [view setBackgroundColor:[UIColor whiteColor]];
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
