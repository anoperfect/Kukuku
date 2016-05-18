//
//  UICustmizeViewController.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "UICustmizeViewController.h"

@interface UICustmizeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitle;
@end

@implementation UICustmizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithName:@"UICustmizeTableViewBackground"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.cellTitle = @[
                       @{@"背景图":@[
                                    @[@"导航栏", @"EnableBackgroundImageNavigationBar"],
                                    @[@"内容区", @"EnableBackgroundImageContent"],
                                    @[@"工具栏", @"EnableBackgroundImageToolBar"],
                                    @[@"左设置", @"EnableBackgroundImageLeftMenu"],
                                    @[@"右栏目", @"EnableBackgroundImageRightMenu"],
                                    @[@"弹出区", @"EnableBackgroundImagePupop"]
                                 ]
                         
                         }
                       
                       

                       ];
    
}


- (void)viewWillLayoutSubviews
{
    CGRect frameAll = self.view.bounds;
    CGRect frameTableView = UIEdgeInsetsInsetRect(frameAll, UIEdgeInsetsMake(0, 2, 0, 2));
    self.tableView.frame = frameTableView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.cellTitle[section];
    NSString *sectionString = sectionDict.allKeys[0];
    NSArray *rowStrings = [sectionDict objectForKey:sectionString];
    NSInteger rows = rowStrings.count;
    return rows;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.cellTitle[section];
    NSString *sectionString = sectionDict.allKeys[0];
    
    return sectionString;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = self.cellTitle.count;
    return sections;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *sectionDict   = self.cellTitle[section];
    NSString *sectionString     = sectionDict.allKeys[0];
    NSArray *rowAttributes      = [sectionDict objectForKey:sectionString];
    NSArray *rowAttribute       = rowAttributes[row];
    NSString *title             = rowAttribute[0];
    NSString *settingItem       = rowAttribute[1];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = title;
    
    UISwitch *sw = [[UISwitch alloc] init];
    NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:settingItem] ;
    NSLog(@"kv %@: %@", settingItem, value);
    BOOL b = [value boolValue];
    NSLog(@"BOOL : %d", b);
    [sw setOn:[value boolValue]];
    
    [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;

    return cell;
}


- (void)switchValueChange:(id)sender
{
    
    
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
