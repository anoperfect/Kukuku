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
@property (strong,nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation RightMenuTVC
@dynamic view;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.categories = [[NSArray alloc] initWithArray:[[AppConfig sharedConfigDB] configDBGet:@"categories"]];
    self.tableData = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in self.categories) {
        [self.tableData addObject:[dic objectForKey:@"name"]];
//        [self.tableData addObject:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"name"], [dic objectForKey:@"click"]]];
    }
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgleft"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCategories) name:@"UpdateCategories" object:nil];
}


- (void)updateCategories {
    
    self.categories = [[NSArray alloc] initWithArray:[[AppConfig sharedConfigDB] configDBGet:@"categories"]];
    self.tableData = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in self.categories) {
        [self.tableData addObject:[dic objectForKey:@"name"]];
//        [self.tableData addObject:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"name"], [dic objectForKey:@"click"]]];
    }
    
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"x-%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
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
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = self.tableData[indexPath.row];
    
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
    //rootVC = [[PostDataViewController alloc] init ];
    rootVC = [[CategoryViewController alloc] init ];
    NSDictionary *dict = [self.categories objectAtIndex:indexPath.row];
    [(CategoryViewController*)rootVC setCategoryName:[dict objectForKey:@"name"] withLink:[dict objectForKey:@"link"]];
    
    [[AppConfig sharedConfigDB] configDBSetAddCategoryClick:[dict objectForKey:@"name"]];
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
