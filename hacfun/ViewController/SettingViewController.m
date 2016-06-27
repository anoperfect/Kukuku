//
//  SettingViewController.m
//  hacfun
//
//  Created by Ben on 15/8/15.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "SettingViewController.h"
#import "FuncDefine.h"
#import "AppConfig.h"
#import "ImageViewCache.h"
#import "PopupView.h"



#import "UICustmizeViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate/*, UIPickerViewDataSource, UIPickerViewDelegate*/>



@property (nonatomic, strong) NSMutableArray        *arraySettingItem ;
@property (nonatomic, strong) NSMutableDictionary   *cellDict;
@property (nonatomic, strong) UISegmentedControl    *viewSelectHostName;

@property (nonatomic, strong) UITableView           *tableView ;
@property (nonatomic, strong) UIView                *version;

@end

@implementation SettingViewController

- (instancetype)init
{
    self = [super init];
    if(nil != self) {
        self.textTopic = @"设置"; 
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frameTableView = CGRectZero;
    self.tableView = [[UITableView alloc] initWithFrame:frameTableView style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setBackgroundColor:[UIColor colorWithName:@"SettingTableViewBackground"]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.arraySettingItem = [[NSMutableArray alloc] init];
    [self.arraySettingItem addObject:@"无图模式"];
    [self.arraySettingItem addObject:@"自动存图"];
    [self.arraySettingItem addObject:@"版块排序"];
    [self.arraySettingItem addObject:@"清除缓存"];
    [self.arraySettingItem addObject:@"界面设置"];
    //[self.arraySettingItem addObject:@"饼干管理"];
//    [self.arraySettingItem addObject:@"版本"];
    [self.arraySettingItem addObject:@"反馈建议"];//: Ben.ZhaoBin@qq.com"];
    
    self.cellDict = [[NSMutableDictionary alloc] init];
    
    self.version = [[UIView alloc] init];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon180x180"]];
    [self.version addSubview:logo];
    logo.tag = 10;
    
    UILabel *versionText = [[UILabel alloc] init];
    [self.version addSubview:versionText];
    versionText.tag = 11;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
    NSLog(@"%@",label);
    label = nil;
    versionText.text = [NSString stringWithFormat:@"版本 %@", version];
    versionText.textAlignment = NSTextAlignmentCenter;
    
    self.tableView.tableFooterView = self.version;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frameTableView = CGRectMake(
                                       16,
                                       self.yBolowView,
                                       self.view.frame.size.width - 16*2,
                                       self.view.frame.size.height - self.yBolowView - 20);
//    frameTableView = self.view.bounds;
    [self.tableView setFrame:frameTableView];
    
    CGRect frameVersion = CGRectMake(0, 0, frameTableView.size.width, frameTableView.size.height - 45 * self.arraySettingItem.count/*frameTableView.size.height - self.tableView.contentSize.height*/);
    self.version.frame = frameVersion;
    
    CGFloat heightLogo = 45;
    CGFloat heightLabel = 45;
    
    //self.version.backgroundColor = [UIColor blueColor];
    
    UIImageView *logo = [self.version viewWithTag:10];
    logo.frame = CGRectMake((frameVersion.size.width - 45) / 2, (frameVersion.size.height - (heightLogo + heightLabel)) / 2, heightLogo, heightLogo);
    
    UILabel *versionText = [self.version viewWithTag:11];
    versionText.frame = CGRectMake(0, logo.frame.origin.y + logo.frame.size.height, frameVersion.size.width, heightLabel);
    
    self.tableView.tableFooterView = self.version;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)switchValueChange:(UISwitch*)sw {
    
    NSLog(@"%s sw: %zi, value:%zi", __FUNCTION__, sw.tag, sw.on);
    
    if(sw.tag == (NSInteger)@"无图模式") {
    NSLog(@"-%s sw: %zi, value:%zi", __FUNCTION__, sw.tag, sw.on);
        NSString *value = [NSString stringWithFormat:@"bool%d", sw.on];
        [[AppConfig sharedConfigDB] configDBSettingKVSet:@"disableimageshow" withValue:value];
    }
    
    if(sw.tag == (NSInteger)@"自动存图") {
    NSLog(@"-%s sw: %zi, value:%zi", __FUNCTION__, sw.tag, sw.on);
        NSString *value = [NSString stringWithFormat:@"bool%d", sw.on];
        [[AppConfig sharedConfigDB] configDBSettingKVSet:@"autosaveimagetoalbum" withValue:value];
    }
    
}


- (void)tapHandler:(id)tapGestureRecognizer {
    
    LOG_POSTION
    
    UIView *cell = [self.cellDict objectForKey:[NSNumber numberWithInteger:(NSInteger)tapGestureRecognizer]];
    UISegmentedControl *view = (UISegmentedControl*)[cell viewWithTag:(NSInteger)@"HostNameSelect"];
    
    NSInteger indexSeleted = [[AppConfig sharedConfigDB] configDBHostIndexGet];
    NSLog(@"-%zi", indexSeleted);
    
    [view setSelectedSegmentIndex:indexSeleted];
    [view setHidden:NO];
}


- (void)selectHostName:(UISegmentedControl*)sender {
    NSInteger index = sender.selectedSegmentIndex;
    [[AppConfig sharedConfigDB] configDBHostIndexSet:index];
    
    /* 刷新对应的category. */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCategories" object:self userInfo:nil];
    
    UITableView *tableView = (UITableView*)[self.view viewWithTag:100];
    [tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 45;
    return height ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arraySettingItem count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *settingItem = [self.arraySettingItem objectAtIndex:indexPath.row];
    
    if([settingItem isEqualToString:@"无图模式"]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UISwitch *sw = [[UISwitch alloc] init];
        [sw setTag:(NSInteger)@"无图模式"];
        NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"disableimageshow"] ;
        NSLog(@"kv %@: %@", settingItem, value);
        BOOL on = [value isEqualToString:@"bool1"];
        NSLog(@"BOOL : %d", on);
        [sw setOn:on];
        
        [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"自动存图"]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UISwitch *sw = [[UISwitch alloc] init];
        [sw setTag:(NSInteger)@"自动存图"];
        NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"autosaveimagetoalbum"] ;
        NSLog(@"kv %@: %@", settingItem, value);
        BOOL on = [value isEqualToString:@"bool1"];
        NSLog(@"BOOL : %d", on);
        [sw setOn:on];
        
        [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"界面设置"]) {
        NSLog(@"界面设置");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"版本"]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.detailTextLabel.text = @"V0.1";
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
        NSLog(@"%@",label);
        label = nil;
        
        cell.detailTextLabel.text = version;
        
        UISegmentedControl *view = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width * 0.45, 36)];
        
        NSArray *hostnames = [[AppConfig sharedConfigDB] configDBHostsGetHostnames];
        NSInteger index = 0;
        for(NSString* host in hostnames) {
            [view insertSegmentWithTitle:host atIndex:index animated:YES];
            index ++;
        }
        
        [view setCenter:cell.center];
        [view setTag:(NSInteger)@"HostNameSelect"];
        [view setHidden:YES];
        [view addTarget:self action:@selector(selectHostName:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:view];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        tapGestureRecognizer.numberOfTapsRequired = 10;
        [cell addGestureRecognizer:tapGestureRecognizer];
        [self.cellDict setObject:cell forKey:[NSNumber numberWithInteger:(NSInteger)tapGestureRecognizer]];
        
        self.viewSelectHostName = view;
    }
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"反馈建议"]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.detailTextLabel.text = @"Ben.ZhaoBin@qq.com";
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dev:)];
        tapGestureRecognizer.numberOfTapsRequired = 10;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }

    if(nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [cell.textLabel setText:[self.arraySettingItem objectAtIndex:indexPath.row]];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *s = self.arraySettingItem[indexPath.row];
    if([s isEqualToString:@"无图模式"]
        || [s isEqualToString:@"自动存图"]
        || [s isEqualToString:@"反馈建议"]
        ) {
        return NO;
    }

    return YES;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击的行数是:%zi", indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"版块排序"]) {
        [self showIndicationText:@"版块排序依照点击次数自动排序" inTime:2.0];
    }
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"清除缓存"]) {
        [ImageViewCache deleteCachesAsyncWithProgressHandle:^(NSInteger total, NSInteger index){
            if(total == 0) {
                [self showIndicationText:[NSString stringWithFormat:@"已清除图片缓存"] inTime:1.0];
            }
            else {
                [self showIndicationText:[NSString stringWithFormat:@"已删除%zd, 共%zd张.", index+1, total] inTime:1.0];
            }
        }];
    }
    
    if([[self.arraySettingItem objectAtIndex:indexPath.row] isEqualToString:@"界面设置"]) {
        UICustmizeViewController *vc = [[UICustmizeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)dev:(id)sender
{
    [[AppConfig sharedConfigDB] removeAll];
}


//#pragma mark- 设置数据
////一共多少列
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
////每列对应多少行
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return 2;
//}
//
////每列每行对应显示的数据是什么
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSArray *arrayName = @[@"h1acfun.tv", @"k1ukuku.cc"];
//    return [arrayName objectAtIndex:row];
//}
//
//#pragma mark-设置下方的数据刷新
//// 当选中了pickerView的某一行的时候调用
//// 会将选中的列号和行号作为参数传入
//// 只有通过手指选中某一行的时候才会调用
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    NSLog(@"didSelectRow : %zi", row);
//    
//}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
