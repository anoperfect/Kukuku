//
//  RightMenuTVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//
#import "RightMenuTVC.h"
#import "CategoryViewController.h"
#import "AppConfig.h"
#import "AMSlideMenuMainViewController.h"

@interface RightMenuTVC ()
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) NSArray *tableData1;
@end

@implementation RightMenuTVC
@dynamic view;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgleft"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCategories) name:@"UpdateCategories" object:nil];
    
    [self updateCategories];
}


- (void)updateCategories {
    
    self.category = [[AppConfig sharedConfigDB] configDBCategoryGet];
    if(self.category.count <= 0) {
        Category *category = [[Category alloc] init];
        category.name = @"获取栏目出错";
        category.link = @"获取栏目出错";
        self.category = @[category];
    }
    
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"x-%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}


#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.category count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    Category *category = self.category[indexPath.row];
    NSString *name = category.name;
    if(name && [name isKindOfClass:[NSString class]]) {
        
    }
    else {
        name = @"获取栏目出错";
    }
    
    cell.textLabel.text = name;
    
    return cell;
}
#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nvc;
    UIViewController *rootVC;
#if 0
    switch (indexPath.row) {
        case 0:
        {
            rootVC = [[ForthVC alloc] initWithNibName:@"ForthVC" bundle:nil];
        }
            break;
        case 1:
        {
            rootVC = [[FiveVC alloc] initWithNibName:@"FiveVC" bundle:nil];
        }
            break;
        default:
            break;
    }
#endif

    Category *category = self.category[indexPath.row];
    NSString *name = category.name;
    [[AppConfig sharedConfigDB] configDBCategoryAddClick:name];
    
    rootVC = [[CategoryViewController alloc] init ];
    [(CategoryViewController*)rootVC setCategoryPresent:category];
    
    [self updateCategories];
    
    if(self.mainVC.currentActiveNVC) {
        self.mainVC.currentActiveNVC.viewControllers = @[rootVC];
        nvc = self.mainVC.currentActiveNVC;
        NSLog(@"### use previous UINavigationController : %@", nvc);
        [self.mainVC closeRightMenuAnimated:YES];
    }
    else {
        nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
        NSLog(@"### create UINavigationController : %@", nvc);
        [self openContentNavigationController:nvc];
    }
    
}


@end
