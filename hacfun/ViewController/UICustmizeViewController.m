//
//  UICustmizeViewController.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "UICustmizeViewController.h"
#import "ModelAndViewInc.h"
#import "AppConfig.h"




@interface UICustmizeViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<UISwitch*> *backgroundviewSwitchViews;


@property (nonatomic, strong) NSArray *cellTitle;
@property (nonatomic, strong) NSMutableArray *colorItems;
@property (nonatomic, strong) NSMutableArray *fontItems;



@property (nonatomic, strong) NSMutableArray *backgroundviews;
@property (nonatomic, assign) NSInteger backgroundviewRowOnSelected;


@end

@implementation UICustmizeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        if(!self.textTopic) {
            self.textTopic = @"界面设置";
        }
        
//        ButtonData *actionData = nil;
//        
//        actionData = [[ButtonData alloc] init];
//        actionData.keyword  = @"";
//        [self actionAddData:actionData];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithName:@"UICustmizeTableViewBackground"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.cellTitle = @[@"背景图"];
//    self.cellTitle = @[@"背景图", @"颜色", @"字体"];
    
    self.backgroundviews = [NSMutableArray arrayWithArray:[[UIpConfig sharedUIpConfig] getUIpConfigBackgroundViews]];
    NSMutableIndexSet *indexSetRemove = [[NSMutableIndexSet alloc] init];
    NSInteger idx = 0;
    for(BackgroundViewItem *item in self.backgroundviews) {
        if(!item.enableCustmize) {
            [indexSetRemove addIndex:idx];
        }
        
        idx ++;
    }
    
    [self.backgroundviews removeObjectsAtIndexes:indexSetRemove];
    
    NSInteger count = self.backgroundviews.count;
    self.backgroundviewSwitchViews = [NSMutableArray arrayWithCapacity:count];
    for(NSInteger index = 0; index < count; index ++) {
        [self.backgroundviewSwitchViews addObject:[[UISwitch alloc] init]];
    }
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect frameAll = self.view.bounds;
    CGRect frameTableView = UIEdgeInsetsInsetRect(frameAll, UIEdgeInsetsMake(0, 16, 0, 16));
    self.tableView.frame = frameTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    NSString *sectionString = self.cellTitle[section];
    if([sectionString isEqualToString:@"背景图"]) {
        rows = self.backgroundviews.count;
    }
    
    return rows;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionString = self.cellTitle[section];
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"NAN";
    cell.backgroundColor = [UIColor clearColor];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *sectionString = self.cellTitle[section];
    if([sectionString isEqualToString:@"背景图"]) {
        
        BackgroundViewItem* item = self.backgroundviews[row];
        
        cell.textLabel.text = item.title;
        
        UISwitch *switchView = self.backgroundviewSwitchViews[row];
        switchView.tag = row;
        [switchView setOn:item.onUse];
        [switchView addTarget:self action:@selector(backgroundviewsValueChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
        
        cell.imageView.image = [UIImage imageWithData:item.imageData];
    }

    return cell;
}


- (void)executeUpdateBackgroundViewByName:(NSString*)name
{
    if([name isEqualToString:@"LeftMenu"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"custmizeBackgroundViewLeftMenu" object:self userInfo:nil];
    }
    else if([name isEqualToString:@"RightMenu"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"custmizeBackgroundViewRightMenu" object:self userInfo:nil];
    }
}


- (void)backgroundviewsValueChange:(UISwitch *)switchView
{
    NSInteger row = switchView.tag;
    BackgroundViewItem* item = self.backgroundviews[row];
    
    if(switchView.on) {
        NSLog(@"backgroundviewsValueChange : %@ on", item.name);
        
        if(!item.imageData) {
            switchView.on = NO;
            [self showIndicationText:@"请先点击设置图片"];
        }
        else {
            item.onUse = YES;
            BOOL updateResult = [[UIpConfig sharedUIpConfig] updateUIpConfigBackgroundView:item];
            if(updateResult) {
                [self executeUpdateBackgroundViewByName:item.name];
            }
            else {
                switchView.on = NO;
                [self showIndicationText:@"启动背景图片出错"];
                NSLog(@"#error - ");
            }
        }
    }
    else {
        item.onUse = NO;
        BOOL updateResult = [[UIpConfig sharedUIpConfig] updateUIpConfigBackgroundView:item];
        if(updateResult) {
            self.backgroundviewSwitchViews[row].on = NO;
        }
        else {
            NSLog(@"#error - ");
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(0 == section) {
        self.backgroundviewRowOnSelected = row;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}





- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
#if 1
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSInteger row = self.backgroundviewRowOnSelected;
    
    //设置指定BackgroundView为on.
    BackgroundViewItem* item = self.backgroundviews[row];
    NSLog(@"before update : %@", item);
    item.imageData = UIImagePNGRepresentation(image);
    
    NSLog(@"would  update : %@", item);
    
    BOOL updateResult = [[UIpConfig sharedUIpConfig] updateUIpConfigBackgroundView:item];
    if(updateResult) {
        BackgroundViewItem *itemNew = [[AppConfig sharedConfigDB] configDBBackgroundViewGetByName:item.name];
        NSLog(@"after update : %@", itemNew);
        
        [self.backgroundviews replaceObjectAtIndex:row withObject:itemNew];
        [self.tableView reloadData];
    }
    else {
        NSLog(@"#error - ");
    }
#endif
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
