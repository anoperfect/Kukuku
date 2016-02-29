//
//  ReplyViewController.m
//  hacfun
//
//  Created by Ben on 15/7/20.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "ReplyViewController.h"
#import "CategoryViewController.h"
#import "PostData.h"
#import "PostDataCellView.h"
#import "FuncDefine.h"
#import "BannerView.h"
#import "CreateViewController.h"

@interface ReplyViewController () <UITableViewDataSource, UITableViewDelegate>




@property (strong,nonatomic) UIButton *btnMenu;
@property (strong,nonatomic) UIButton *btnCategory;
@property (strong,nonatomic) UITableView *postView;

@property (strong,nonatomic) NSString *nameCategory;
@property (strong,nonatomic) NSString *host;
@property (assign,nonatomic) NSInteger pageNum;

@property (strong,nonatomic) PostData *topic;
@property (strong,nonatomic) NSMutableArray* tReplys;

@property (strong,nonatomic) BannerView *bannerView;

@end



@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.host = @"http://hacfun.tv/api";
    self.nameCategory = [@"综合版1" copy];
    
    //模拟的数据部分.
    self.tReplys = [[NSMutableArray alloc] init];
    self.pageNum = 1L;
    
    NSLog(@"num:%zi", self.tReplys.count);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //banner.
    CGFloat yBanner = 20;
    CGFloat heightBanner = 36;
    self.bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, yBanner, self.view.frame.size.width, heightBanner)];
    [self.view addSubview:self.bannerView];
    
    NSArray *aryNameImages = [NSArray arrayWithObjects:@"reply", @"jumppage", @"more", nil];
    [self.bannerView setConfigData:self.nameCategory buttonImages:aryNameImages buttonTexts:nil];
    [self.bannerView.buttonNavigation addTarget:self action:@selector(clickButtonNavigation) forControlEvents:UIControlEventTouchDown];
    
    //tableview
    CGFloat yTableViewBorder = 0;
    CGFloat yTableView = yBanner+heightBanner+yTableViewBorder;
    
    self.postView = [[UITableView alloc] initWithFrame:CGRectMake(0, yTableView, self.view.frame.size.width, self.view.frame.size.height - yTableView) style:UITableViewStyleGrouped];
    [self.view addSubview:self.postView];
    self.postView.delegate = self;
    self.postView.dataSource = self;
    self.postView.tag = 1;
    //WIDTH_FIT(self.postView, 0)
    LOG_VIEW_REC0(self.view, @"view")
    LOG_VIEW_REC0(self.postView, @"postView")
    
    self.postView.backgroundColor = [UIColor orangeColor];
    self.postView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.postView reloadData];
    
    //增加cell长按功能.
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.postView addGestureRecognizer:longPressGr];
}


- (void) setPostTopic:(PostData *)topic {
    NSLog(@"topic = %@", topic);
    
    self.topic = topic;
    self.topic.mode = 2;
    
    [self.bannerView setNavigationText:[NSString stringWithFormat:@"No.%zi", self.topic.id]];
    [self performSelector:@selector(refreshPostData) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    LOG_POSTION
    [self.bannerView setNavigationText:[NSString stringWithFormat:@"No.%zi", self.topic.id]];
}


- (void) clickButtonNavigation {
    
    [self dismissViewControllerAnimated:NO completion:^{ }];
    
}


- (void) reloadPostData{
    
    NSLog(@"%s", __func__);
    
    // 刷新时清空原所有数据.
    self.pageNum ++;
    
    //[self.postView setHidden:YES];
    //加载后续分页, 加载完成活着出错之前, 不能重复刷新.
    
    // 在子线程中调用download方法下载图片
    [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
}


- (void)refreshPostData {
    
    NSLog(@"%s", __func__);
    
    // 刷新时清空原所有数据.
    [self.tReplys removeAllObjects];
    self.pageNum = 1;
    
    [self.postView setHidden:YES];
    
    // 在子线程中调用download方法下载图片
    [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
}


- (void)setBackgroundDownload {
    
    NSString *str = [NSString stringWithFormat:@"%@/t/%zi?page=%zi", self.host, self.topic.id, self.pageNum];
    NSURL *urlstr=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"str:%@", str);
    NSLog(@"url:%@", urlstr);
    
    //把图片转换为二进制的数据
    NSData *data=[NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
    
    [self performSelectorOnMainThread:@selector(parseAndFresh:) withObject:data waitUntilDone:NO];
}


- (void)parseAndFresh:(NSData*)data {
    NSMutableArray* parsePostDatas = [self parseFromJsonData:data];
    if([parsePostDatas count] <= 0) {
        NSLog(@"xxxxxx parse json error");
    }
    else {
        [self.tReplys addObjectsFromArray:parsePostDatas];
        NSLog(@"replys count : %zi", self.tReplys.count);
    }
    
    [self.postView reloadData];
    [self.postView setHidden:NO];
}


- (NSMutableArray*)parseFromJsonData:(NSData*)jsonData {
    
    NSLog(@"%s", __func__);
    
    NSMutableArray *arrPostDatas = [[NSMutableArray alloc] init];
    NSInteger numOfPost = 0;
    
    NSData *data = jsonData;
    if(data) {
        //NSLog(@"%s", [data bytes]);
    }
    else {
        NSLog(@"data null");
        return arrPostDatas;
    }
    
    NSObject *obj;
    NSDictionary *dict;
    NSMutableArray *arr;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj) {
        NSLog(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NSLog(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NSLog(@"obj nil %d", __LINE__);
        return arrPostDatas;
    }
    
    dict = (NSDictionary*)obj;
    
    obj = [dict objectForKey:@"replys"];
    if(obj) {
        NSLog(@"obj class NSMutableArray : %d", [obj isKindOfClass:[NSMutableArray class]]);
        NSLog(@"obj class NSArray        : %d", [obj isKindOfClass:[NSArray class]]);
        NSLog(@"obj class NSDictionary   : %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NSLog(@"obj nil %d", __LINE__);
    }
    
    arr = (NSMutableArray*)obj;
    PostData *pd = nil;
    
    for(obj in arr) {
        
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing obj");
            continue;
        }
        
        dict = (NSDictionary*)obj;
        NS0Log(@"%@", dict);
        
        pd = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == pd) {
            break;
        }
        
        pd.bTopic = NO;
        pd.mode = 2;
        numOfPost ++;
        [arrPostDatas addObject:pd];
    }
    
    NSLog(@"numOfReply = %zi", numOfPost);
    return arrPostDatas;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 100;
    PostData* pd ;
    
    if(0 == indexPath.row) {
        
        pd = self.topic;
        
    }
    else {
        pd = (PostData*)([self.tReplys objectAtIndex:(indexPath.row-1)]);
    }
    
    height = pd.height;
    return height ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tReplys count] + 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //cell.textLabel.text = [NSString stringWithFormat:@"row%ld", indexPath.row];
        cell.backgroundColor = [UIColor redColor];
        CGRect frame = cell.frame;
        frame.size.width = tableView.frame.size.width;
        [cell setFrame:frame];
    }
    else {
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    PostDataCellView *v = nil;
    v = [[PostDataCellView alloc] initWithFrame:CGRectMake(1, 1, 0, 100)];
    [cell addSubview:v];
    WIDTH_FIT(v, 1)
    
    if(0 == indexPath.row) {
        [v setPostData:self.topic];
    }
    else {
        [v setPostData:[self.tReplys objectAtIndex:(indexPath.row-1)]];
    }
    NS0Log(@"[%zi] label height : %lf", indexPath.row, v.frame.size.height);
    LOG_VIEW_REC0(self.view, @"self.view")
    LOG_VIEW_REC0(tableView, @"tableView")
    LOG_VIEW_REC0(cell, @"cell")
    cell.backgroundColor = [UIColor purpleColor];
    LOG_VIEW_REC0(v, @"PostDataCellView")
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击的行数是:%zi", indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    static CreateViewController *kcv = nil;
    if(!kcv) {
        kcv = [[CreateViewController alloc]init];
    }
    
    CreateViewController *vc = kcv;
    //    ReplyViewController *rv = [[ReplyViewController alloc]init];
    [vc setReplyId:self.topic.id];
    //    UIViewController *rv = [[UIViewController alloc]init];
    
    [self presentViewController:vc animated:NO completion:^(void){ }];
    [self performSelector:@selector(dontSleep) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}


- (void)dontSleep {
    
}


- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"longPressToDo %@", gesture);
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.postView];
        NSIndexPath *indexPath = [self.postView indexPathForRowAtPoint:point];
        if(indexPath){
            NSLog(@"long press at row : %zi", indexPath.row);
        }
        else {
            NSLog(@"long press not at tableview");
        }
    }
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        // 标示是否被隐藏
//        self.isHiddenItem = YES;
//
//        // 获取要隐藏item的位置
//        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
//
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.tableView cellForRowAtIndexPath:tmpPath].alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            // 隐藏的对应item
//            [[self.tableView cellForRowAtIndexPath:tmpPath] setHidden:YES];
//            // 刷新被隐藏的item
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//        NSLog(@"点击了第0行");
//    } else if (indexPath.row == 1){
//
//        self.isHiddenItem = NO;
//
//        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
//
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.tableView cellForRowAtIndexPath:tmpPath].alpha = 1.0f;
//        } completion:^(BOOL finished) {
//            [[self.tableView cellForRowAtIndexPath:tmpPath] setHidden:YES];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//        NSLog(@"点击了第1行");
//        
//    }
//}


@end



//@interface ReplyViewController ()
//
//@end
//
//@implementation ReplyViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    [self.view addSubview:btnBack];
//    [btnBack setFrame:CGRectMake(10, 36, 20, 20)];
//    [btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchDown];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (void)clickBack {
//   
//    NSLog(@"click back");
//    [self dismissViewControllerAnimated:NO completion:^{
//        
//    }];
//    
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end



