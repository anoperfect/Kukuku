//
//  LeftMenuTVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//
#import "ImageViewCache.h"
#import "LeftMenuTVC.h"
#import "DetailViewController.h"
#import "TestViewController.h"
#import "CollectionViewController.h"
#import "PostViewController.h"
#import "SettingViewController.h"
#import "AppConfig.h"
#import "PopupView.h"
#import "AMSlideMenuMainViewController.h"
#import "GalleryViewController.h"
@interface LeftMenuTVC ()
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation LeftMenuTVC
@dynamic view;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initilizing data souce
    self.tableData = [@[@"搜索",@"收藏", @"发帖", @"回复", @"设置"] mutableCopy];
    [self.tableData addObject:@"测试"];
    [self.tableData addObject:@"图片"];
    
//    [self.view setBackgroundColor:[UIColor blueColor]];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    self.tableView.contentInset = UIEdgeInsetsMake(100,0,0,0);
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgright"]];
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


- (CGFloat)tableView:(UITableView *)tableView h1eightForHeaderInSection:(NSInteger)section
{
    return 100.0;
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
        [vc setPostThreadId:6477099];
        [vc setPostThreadId:6468268];
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
    
    if([strItem isEqualToString:@"图片"]) {

        
        
        
        
        GalleryViewController *galleryViewController = [[GalleryViewController alloc] init];

        rootVC = galleryViewController;
        
#if 0
        NVGalleryViewController *vc = [[NVGalleryViewController alloc] init];
        vc.images = imageArray;
        rootVC = vc;
#endif
        
    }
    
    
#if 0
    if(self.mainVC.currentActiveNVC) {
        self.mainVC.currentActiveNVC.viewControllers = @[rootVC];
        nvc = self.mainVC.currentActiveNVC;
        NSLog(@"### use previous UINavigationController : %@", nvc);
        [self.mainVC closeLeftMenuAnimated:YES];
    }
    else
#endif
    {
        nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
        NSLog(@"### create UINavigationController : %@", nvc);
        [self openContentNavigationController:nvc];
    }
    
}


@end