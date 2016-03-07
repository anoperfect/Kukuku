//
//  LeftMenuTVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//

#import "LeftMenuTVC.h"
#import "FirstVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"
#import "DetailViewController.h"
#import "TestViewController.h"
#import "CollectionViewController.h"
#import "PostViewController.h"
#import "SettingViewController.h"
#import "AppConfig.h"
#import "PopupView.h"
@interface LeftMenuTVC ()

@end

@implementation LeftMenuTVC
@dynamic view;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initilizing data souce
    self.tableData = [@[@"搜索",@"测试",@"收藏", @"发帖", @"回复", @"设置"] mutableCopy];
    
    UITableView *tableView = self.view;
    UIView *viewT = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//    [viewT setBackgroundColor:[AppConfig backgroundColorFor:@"ViewController"]];
//    [viewT setBackgroundColor:[UIColor whiteColor]];
//    [viewT setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
#if 0
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[viewT bounds]];
    [bgImageView setImage:[UIImage imageNamed:@"bg"]];
    [viewT addSubview:bgImageView];
    [viewT sendSubviewToBack:bgImageView];
#endif
    
    self.view = (UITableView*)viewT;
    [self.view addSubview:tableView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [tableView setFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [tableView setBackgroundColor:[UIColor clearColor]];
}


- (void)viewDidAppear:(BOOL)animated {
//        [self.view setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor purpleColor]];
    
    
    
    
    
    
}


#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = self.tableData[indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}
#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nvc;
    UIViewController *rootVC;
//    switch (indexPath.row) {
//        case 0:
//        {
////            rootVC = [[FirstVC alloc] initWithNibName:@"FirstVC" bundle:nil];
////            DetailViewController *vc = [[DetailViewController alloc]init];
////            [vc setPostThreadId:6414910];
////            [vc setPostThreadId:6434886];
////            rootVC = vc;
//            
//            PopupView *popupView = [[PopupView alloc] init];
//            popupView.numofTapToClose = 0;
//            [popupView popupInSuperView:self.view];
//            
//            
//            
//            
//        }
//            break;
//        case 1:
//        {
//            //            rootVC = [[SecondVC alloc] initWithNibName:@"SecondVC" bundle:nil];
//            TestViewController *vc = [[TestViewController alloc] init];
//            rootVC = vc;
//        }
//            break;
//        case 2:
//        {
////            rootVC = [[ThirdVC alloc] initWithNibName:@"ThirdVC" bundle:nil];
//            
//            CollectionViewController *vc = [[CollectionViewController alloc] init];
//            rootVC = vc;
//        }
//            break;
//            
//        case 3:
//        {
////            rootVC = [[ThirdVC alloc] initWithNibName:@"ThirdVC" bundle:nil];
//            
//            SettingViewController *vc = [[SettingViewController alloc] init];
//            rootVC = vc;
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
    
    NSString *strItem = [self.tableData objectAtIndex:indexPath.row];
    if([strItem isEqualToString:@"搜索"]) {
//        PopupView *popupView = [[PopupView alloc] init];
//        popupView.numofTapToClose = 0;
//        [popupView popupInSuperView:self.view];
        
        DetailViewController *vc = [[DetailViewController alloc]init];
        [vc setPostThreadId:6670627];
        rootVC = vc;
 
        
    }
    
    if([strItem isEqualToString:@"测试"]) {
        TestViewController *vc = [[TestViewController alloc] init];
        rootVC = vc;
    }
    
    if([strItem isEqualToString:@"收藏"]) {
        CollectionViewController *vc = [[CollectionViewController alloc] init];
        rootVC = vc;
    }
    
    if([strItem isEqualToString:@"发帖"]) {
        PostViewController *vc = [[PostViewController alloc] init];
        [vc setTopic:strItem];
        rootVC = vc;
    }
    
    if([strItem isEqualToString:@"回复"]) {
//        ReplyViewController *vc = [[ReplyViewController alloc] init];
//        rootVC = vc;
    }
    
    if([strItem isEqualToString:@"设置"]) {
        SettingViewController *vc = [[SettingViewController alloc] init];
        rootVC = vc;
    }
    
    nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    [self openContentNavigationController:nvc];
}


@end
