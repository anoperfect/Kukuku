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
#import "CollectionViewController.h"
#import "PostViewController.h"
#import "ReplyViewController.h"
#import "SettingViewController.h"
#import "AppConfig.h"
#import "PopupView.h"
#import "AMSlideMenuMainViewController.h"
#import "GalleryViewController.h"
#import "TOWebViewController.h"
#import "IntroductionViewController.h"
#import "PostGroupView.h"
#import "ModelAndViewInc.h"
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
    self.tableData = [[NSMutableArray alloc] init];
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    [self.tableData addObject:host.hostname];
    [self.tableData addObjectsFromArray:@[@"搜索",@"收藏", @"发帖", @"回复", @"设置", @"图片"]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(100,0,0,0);
    

    self.tableView.backgroundColor = [UIColor colorWithName:@"LeftMenuBackground"];
    [self custmizeBackgroundView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(custmizeBackgroundView) name:@"custmizeBackgroundViewRightMenu" object:nil];
}


- (void)custmizeBackgroundView
{
    NSString *name = @"LeftMenu";
    NSString *fillColorName = @"LeftMenuBackground";
    NSLog(@"Reset %@ backgroundImage", name);
    BackgroundViewItem *backgroundview = [[AppConfig sharedConfigDB] configDBBackgroundViewGetByName:name];
    UIImage *image = nil;
    if(backgroundview.onUse && backgroundview.imageData.length > 0 && nil != (image = [UIImage imageWithData:backgroundview.imageData])) {
        image = [FuncDefine thumbOfImage:image fitToSize:self.view.frame.size isFillBlank:YES fillColor:[UIColor colorWithName:fillColorName] borderColor:[UIColor orangeColor] borderWidth:0];
        
        [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:image]];
        NSLog(@"ReSet %@ backgroundImage finished.", name);
    }
    else {
        [self.tableView setBackgroundView:nil];
        NSLog(@"Clear %@ backgroundImage finished.", name);
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self custmizeBackgroundView];
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
////            [vc setPostTid:6414910];
////            [vc setPostTid:6434886];
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
    
    if(indexPath.row == 0) {
//        Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
//        TOWebViewController *vc = [[TOWebViewController alloc] initWithURLString:host.urlString];
//        rootVC = vc;
        //rootVC.view.backgroundColor = [UIColor blueColor];
        
        IntroductionViewController *vc = [[IntroductionViewController alloc] init];
        rootVC = vc;

    }
    
    NSString *strItem = [self.tableData objectAtIndex:indexPath.row];
    if([strItem isEqualToString:@"搜索"]) {
//        PopupView *popupView = [[PopupView alloc] init];
//        popupView.numofTapToClose = 0;
//        [popupView popupInSuperView:self.view];
        
//        DetailViewController *vc = [[DetailViewController alloc]init];
        //DetailViewControllerTest *vc = [[DetailViewControllerTest alloc]init];
//        [vc setPostTid:6670627 withData:nil];
//        [vc setPostTid:6477099 withData:nil];
//        [vc setPostTid:6468268 withData:nil];
//        [vc setPostTid:6468276 withData:nil];
//        [vc setPostTid:6624990 withData:nil];
//        [vc setPostTid:6708309 withData:nil];
        
        //rootVC = vc;
        
        
        SearchViewController *vc = [[SearchViewController alloc] init];
        rootVC = vc;
        
    }
    
    if([strItem isEqualToString:@"测试"]) {
        //TestViewController *vc = [[TestViewController alloc] init];
        //rootVC = vc;
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
        ReplyViewController *vc = [[ReplyViewController alloc] init];
        rootVC = vc;
    }
    
    if([strItem isEqualToString:@"设置"]) {
        SettingViewController *vc = [[SettingViewController alloc] init];
        rootVC = vc;
    }
    
    if([strItem isEqualToString:@"图片"]) {
        GalleryViewController *galleryViewController = [[GalleryViewController alloc] init];
        rootVC = galleryViewController;
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
    if(rootVC) {
        nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
        NSLog(@"### create UINavigationController : %@", nvc);
        [self openContentNavigationController:nvc];
    }
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end