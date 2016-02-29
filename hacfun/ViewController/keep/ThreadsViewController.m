//
//  PostDataViewController.m
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostDataViewController.h"
#import "PostData.h"
#import "PostDataCellView.h"
#import "FuncDefine.h"
#import "ReplyViewController.h"
#import "BannerView.h"
#import "CreateViewController.h"
@interface PostDataViewController () <UITableViewDataSource, UITableViewDelegate>




@property (strong,nonatomic) UIButton *buttonMenu;
@property (strong,nonatomic) UIButton *buttonCategory;
@property (strong,nonatomic) UITableView *postView;
@property (strong,nonatomic) NSMutableArray *postDatas;
@property (strong,nonatomic) NSString *nameCategory;
@property (strong,nonatomic) NSString *host;
@property (assign,nonatomic) NSInteger pageNum;
@property (strong,nonatomic) BannerView *bannerView;
@property (assign,nonatomic) BOOL boolRefresh;
@property (strong,nonatomic) UIRefreshControl *refresh;
@property (strong,nonatomic) UIButton *footView;
@property (assign,nonatomic) NSInteger footViewStatus;
@property (strong,nonatomic) NSArray* footViewStrings;
@property (strong,nonatomic) UIView *viewLoading;
@property (strong,nonatomic) UIView *actionMenu;
@property (strong,nonatomic) NSMutableData *jsonData;
@end



@implementation PostDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.host = @"http://hacfun.tv/api";
    //self.nameCategory = [@"综合版1" copy];
    
    //模拟的数据部分.
    self.postDatas = [[NSMutableArray alloc] init];
    self.pageNum = 1L;
    NSLog(@"num:%zi", self.postDatas.count);
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    //banner.
    CGFloat yBanner = 20;
    CGFloat heightBanner = 36;
    self.bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, yBanner, self.view.frame.size.width, heightBanner)];
    [self.view addSubview:self.bannerView];
    
//    NSArray *aryNameImages = [NSArray arrayWithObjects:@"new", @"more", nil];
//    [self.bannerView setConfigData:self.nameCategory buttonImages:aryNameImages buttonTexts:nil];
    
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    ButtonData *data ;
    data = [[ButtonData alloc] init];
    data.keyword = @"new";
    data.id = 'n';
    data.superId = 0;
    data.image = @"new";
    data.title = @"";
    data.method = 1;
    [ary addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"more";
    data.id = 'm';
    data.superId = 0;
    data.image = @"more";
    data.title = @"";
    data.method = 1;
    [ary addObject:data];
    
    [self.bannerView setButtonData:ary];
    [self.bannerView.buttonNavigation addTarget:self action:@selector(clickButtonNavigation) forControlEvents:UIControlEventTouchDown];
    [[self.bannerView getButtonByKeyword:@"new"] addTarget:self action:@selector(createNewPost) forControlEvents:UIControlEventTouchDown];
    [[self.bannerView getButtonByKeyword:@"more"] addTarget:self action:@selector(showMoreMenu) forControlEvents:UIControlEventTouchDown];
    
    //tableview
    CGFloat yTableViewBorder = 0;
    CGFloat yTableView = yBanner+heightBanner+yTableViewBorder;
    
    CGFloat xTableViewBorder = 0;
    self.postView = [[UITableView alloc] initWithFrame:CGRectMake(xTableViewBorder, yTableView, self.view.frame.size.width - 2*xTableViewBorder, self.view.frame.size.height - yTableView) style:UITableViewStyleGrouped];
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
    
    //隐藏那个导航栏.
    //[self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBar.hidden = YES ;
    
    //UIRefreshControll
    [self setBeginRefreshing];
    
    //footview.
    self.footView = [[UIButton alloc]initWithFrame:CGRectMake(0, -36, self.view.frame.size.width, 36)];
    self.footView.backgroundColor = self.postView.backgroundColor;
    self.footViewStrings = [NSArray arrayWithObjects:
    @"点击加载.",
    @"加载中 － 非常努力地加载中.",
    @"加载成功. - ",
    @"加载失败. － oops ! 点击重新加载.",
    @"加载无更多数据. - 已经没有了,点击刷新.",
                            nil];
    self.footViewStatus = 0;
    [self.footView setTitle:[self.footViewStrings objectAtIndex:self.footViewStatus] forState:UIControlStateNormal];
    [self.footView.titleLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    [self.footView addTarget:self action:@selector(clickFootView) forControlEvents:UIControlEventTouchDown];
    self.postView.tableFooterView = self.footView;
    
    LOG_VIEW_RECT(self.postView, @"post view");
    [self.postView.layer setBorderWidth:1.0];
    [self.postView.layer setBorderColor:[UIColor blueColor].CGColor];
}


- (void)clickButtonNavigation {
    LOG_POSTION
    
    
}


- (void)createNewPost {
    
    static CreateViewController *kcv = nil;
    if(!kcv) {
        kcv = [[CreateViewController alloc]init];
    }
    
    CreateViewController *vc = [[CreateViewController alloc]init];
    [vc setCategory:self.nameCategory];
    //    UIViewController *rv = [[UIViewController alloc]init];
    
    [self presentViewController:vc animated:NO completion:^(void){ }];
    [self performSelector:@selector(dontSleep) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}


- (void)showMoreMenu {
    LOG_POSTION
    
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    ButtonData *data ;
   
    data = [[ButtonData alloc] init];
    data.keyword = @"refresh";
    data.id = 'f';
    data.superId = 'm';
    data.image = @"";
    data.title = @"刷新";
    data.method = 2;
    [ary addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"reload";
    data.id = 'l';
    data.superId = 'm';
    data.image = @"";
    data.title = @"加载";
    data.method = 2;
    [ary addObject:data];
    
    CGFloat width = 100;
    self.actionMenu = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - width, 0, width, 0)];
    //[self.view addSubview:self.actionMenu];
    [self.actionMenu setBackgroundColor:[UIColor blueColor]];
    FRAME_BELOW_TO(self.actionMenu, self.bannerView, 1.0)
    
    NSInteger index = 0;
    CGFloat height = 36;
    for(ButtonData *d in ary) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionMenu addSubview:button];
        [button setFrame:CGRectMake(0, index*height , self.actionMenu.frame.size.width, height)];
        [button setTitle:d.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTag:d.id];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
        
        index ++;
        FRAME_ADD_HEIGHT(self.actionMenu, height)
    }
}


- (void)clickButton : (UIButton*)button {
    
    NSLog(@"clickButton : %c", (char)button.tag);
    FRAME_SET_HEIGHT(self.actionMenu, 0);
    //LOG_VIEW_RECT(self.actionMenu, @"action menu")
    [self.actionMenu removeFromSuperview];
}


- (void)clickFootView {
    LOG_POSTION
    
    if(-1 != self.footViewStatus) {
        [self reloadPostData];
        self.footViewStatus = 1;
        [self.footView setTitle:[self.footViewStrings objectAtIndex:self.footViewStatus] forState:UIControlStateNormal];
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    LOG_POSTION
    [self.bannerView setNavigationText:self.nameCategory];
    //[self.view bringSubviewToFront:self.bannerView];
}


- (void)setBeginRefreshing {
    self.refresh = [[UIRefreshControl alloc]init];
    self.refresh.tintColor = [UIColor redColor];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.postView addSubview:self.refresh];
    
    LOG_POSTION
}


- (void)refreshAction:(UIRefreshControl*)refresh {
    LOG_POSTION
    
    if(refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
        [self performSelector:@selector(refreshPostData) withObject:nil afterDelay:0];
    }
}


- (void)setCategoryName:(NSString*)categoryName {
    LOG_POSTION
    self.nameCategory = [categoryName copy];
    NS0Log(@"%@", self.bannerView);
    [self.bannerView setNavigationText:self.nameCategory];
    [self performSelector:@selector(refreshPostData) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}


- (void) showLoadingView {
    if(!self.viewLoading) {
        self.viewLoading = [[UIView alloc]initWithFrame:self.view.frame];
        [self.viewLoading setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
        [self.viewLoading setBackgroundColor:[UIColor blackColor]];
        [self.viewLoading setAlpha:0.8];
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
        [activityIndicatorView setTag:1];
        [self.viewLoading addSubview:activityIndicatorView];
        [activityIndicatorView setCenter:self.viewLoading.center];
    }
    
    [self.view addSubview:self.viewLoading];
    UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self.viewLoading viewWithTag:1];
    [activityIndicatorView startAnimating];
    
    [self.view bringSubviewToFront:self.viewLoading];
    
}


- (void) dismissLoadingView {
    if(self.viewLoading) {
        
        [self.viewLoading removeFromSuperview];
        UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self.viewLoading viewWithTag:1];
        [activityIndicatorView stopAnimating];
        
        [self.view sendSubviewToBack:self.viewLoading];
    }
}


- (void)refreshPostData {

    LOG_POSTION

    // 刷新时清空原所有数据.
    self.boolRefresh = YES;
    self.pageNum = 1;

    //[self.postView setHidden:YES];

    // 在子线程中调用download方法下载图片
    [self showLoadingView];
    [self setBackgroundDownload];
}


- (void) reloadPostData{
    
    LOG_POSTION
    
    // 刷新时清空原所有数据.
    
    //[self.postView setHidden:YES];
    //加载后续分页, 加载完成活着出错之前, 不能重复刷新.
    
    // 在子线程中调用download方法下载图片
    [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
}


- (void)setBackgroundDownload {
    NSString *str = [NSString stringWithFormat:@"%@/%@?page=%zi", self.host, self.nameCategory, self.pageNum];
    NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"str:%@", str);
    NSLog(@"url:%@", url);
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    mutableRequest.HTTPMethod = @"GET";
    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    
    self.jsonData = [[NSMutableData alloc] init];
    
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NSLog(@"%@已经接收到数据%s", [NSThread currentThread], __FUNCTION__);
    
    [self.jsonData appendData:data];
    //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    [self parseAndFresh:self.jsonData];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
    [self parseAndFresh:nil];
}


- (void)parseAndFresh:(NSData*)data {
    [self dismissLoadingView];
    NSMutableArray* parsePostDatas = [self parseFromJsonData:data];
    if([parsePostDatas count] <= 0) {
        NSLog(@"xxxxxx parse json error");
        self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新完成"];
        [self.refresh endRefreshing];
        self.footViewStatus = 3;
        [self.footView setTitle:[self.footViewStrings objectAtIndex:self.footViewStatus] forState:UIControlStateNormal];
        return;
    }
    
    //加载当前页面成功, 标记下一个待加载的页面.
    self.pageNum ++;
    
    if(self.boolRefresh) {
        [self.postDatas removeAllObjects];
        self.boolRefresh = NO;
    }
    [self.postDatas addObjectsFromArray:parsePostDatas];
    [self.postView reloadData];
    [self.postView setHidden:NO];
    
    //根据刷新的原因分类. 1.栏目刷新. 2.加载. 3.下拉刷新.
    self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新完成"];
    [self.refresh endRefreshing];
    self.footViewStatus = 2;
    [self.footView setTitle:[self.footViewStrings objectAtIndex:self.footViewStatus] forState:UIControlStateNormal];
}


- (NSMutableArray*)parseFromJsonData:(NSData*)jsonData {
    
    LOG_POSTION
    
    NSMutableArray *arrPostDatas = [[NSMutableArray alloc] init];
    NSInteger numOfPost = 0;
    
//    NSString *s = @"http://hacfun.tv/api/综合版1?page=1";
//    NSURL *url = [[NSURL alloc] initWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    
    NSData *data = jsonData;
    if(data) {
        NS0Log(@"%s", [data bytes]);
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
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NSLog(@"obj [%@] nil", @"JSONObjectWithData");
        return arrPostDatas;
    }
    
    dict = (NSDictionary*)obj;
    
    obj = [dict objectForKey:@"data"];
    if(obj) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NSLog(@"obj [%@] nil", @"data");
        return arrPostDatas;
    }
    
    dict = (NSDictionary*)obj;
    
    obj = [dict objectForKey:@"threads"];
    if(obj) {
        NSLog(@"obj class NSMutableArray : %d", [obj isKindOfClass:[NSMutableArray class]]);
        NSLog(@"obj class NSArray        : %d", [obj isKindOfClass:[NSArray class]]);
        NSLog(@"obj class NSDictionary   : %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NSLog(@"obj [%@] nil", @"thread");
        return arrPostDatas;
    }
    
    arr = (NSMutableArray*)obj;
    PostData *pd = nil;
    
    for(obj in arr) {
        
        if(![obj isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"%@ not dictionary", @"parsing obj");
            continue;
        }
        
        pd = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == pd) {
            break;
        }
        
        //PostData各数据获取完成.
        pd.bTopic = YES;
        pd.mode = 1;
        numOfPost ++;
        [arrPostDatas addObject:pd];
    }
    
    NSLog(@"numOfPost = %zi", numOfPost);
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
    
    return 1.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 100;
    PostData* pd = (PostData*)([self.postDatas objectAtIndex:indexPath.row]);
    height = pd.height;
    
    return height ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.postDatas count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"%@ : %ld . row %ld", @"cellForRowAtIndexPath", tableView.tag, indexPath.row);
    
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
    X_CENTER(v, 2)
    [v setPostData:[self.postDatas objectAtIndex:indexPath.row]];
    NS0Log(@"[%zi] label height : %lf", indexPath.row, v.frame.size.height);
    LOG_VIEW_REC0(self.view, @"self.view")
    LOG_VIEW_REC0(tableView, @"tableView")
    LOG_VIEW_REC0(cell, @"cell")
    cell.backgroundColor = [UIColor purpleColor];
    LOG_VIEW_REC0(v, @"PostDataCellView")
    
    
//    CGRect frame = cell.frame;
//    frame.size.height = 200; //v.frame.size.height + 2;
//    [cell setFrame:frame];
    
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"点击0行的时候隐藏第2行";
//    } else if(indexPath.row ==1) {
//        cell.textLabel.text = @"点击1行的时候显示第2行";
//        
//    } else {
//        cell.textLabel.text = [NSString stringWithFormat:@"当前行数%ld",indexPath.row];
//    }
    
    
    
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"点击的行数是:%zi", indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self didSelectRow:indexPath.row];
}


- (void)didSelectRow:(NSInteger)row {
    
    static ReplyViewController *krv = nil;
    if(!krv) {
        krv = [[ReplyViewController alloc]init];
    }
    
    ReplyViewController *rv = krv;
    //    ReplyViewController *rv = [[ReplyViewController alloc]init];
    [rv setPostTopic:[(PostData*)[self.postDatas objectAtIndex:row] copy]];
    //    UIViewController *rv = [[UIViewController alloc]init];
    
    [self presentViewController:rv animated:NO completion:^(void){ }];
    [self performSelector:@selector(dontSleep) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}





- (void)dontSleep {
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger ktimes = 0;
    if(indexPath.row == [self.postDatas count] - 1) {
        ktimes ++ ;
        NSLog(@"last row[%zi] shown %@.", indexPath.row, cell);
        if(ktimes == 1) {
            NSLog(@"ignore it");
        }
        else {
            NSLog(@"treat");
            //[self reloadPostData];
        }
    }
    
    
    
    
    
    
    
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

@end

    
    
    
//    self.buttonMenu = [[UIButton alloc] initWithFrame:CGRectMake(2, buttonY, 90, 20)];
//    [self.view addSubview:self.buttonMenu];
//    self.buttonMenu.backgroundColor = [UIColor blueColor];
//    [self.buttonMenu setTitle:@"综合版1" forState:UIControlStateNormal];
//    //[self.buttonMenu setImage:[UIImage imageNamed:@"appicon"] forState:UIControlStateNormal];
//    
//    UIImage *image = [UIImage imageNamed:@"appicon"];
//    CGSize itemSize = CGSizeMake(self.buttonMenu.frame.size.height, self.buttonMenu.frame.size.height);
//    UIGraphicsBeginImageContext(itemSize);
//    CGRect imageRect = CGRectMake(0, 0, 20, 20);
//    [image drawInRect:imageRect];
//    UIGraphicsEndImageContext();
//    [self.buttonMenu.imageView setFrame:CGRectMake(0, 0, 10, 10)];
//    [self.buttonMenu setImage:image forState:UIControlStateNormal];
//    [self.buttonMenu setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.buttonMenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    
//    NSLog(@"%lf %lf", image.size.width,image.size.height);
//    
//    
//    CGSize size = CGSizeMake(20.0, 20.0);
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, 20.0, 20.0)];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSLog(@"%lf %lf", scaledImage.size.width,scaledImage.size.height);
//    [self.buttonMenu setImage:scaledImage forState:UIControlStateNormal];
    
    
//    UIGraphicsBeginImageContext(size);
//    image = [UIImage imageNamed:@"back"];
//    [image drawInRect:CGRectMake(0, 0, 20.0, 20.0)];
//    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    //UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"appicon"]];
//    UIColor *color = [UIColor colorWithPatternImage:scaledImage];
//    [label setBackgroundColor:color];
//    [self.buttonMenu addSubview:label];
    
//    self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(100, buttonY, 45, 20)];
//    self.buttonCategory.backgroundColor = [UIColor blueColor];
//    [self.buttonCategory setTitle:@"加载" forState:UIControlStateNormal];
//    [self.buttonCategory addTarget:self action:@selector(reloadPostData) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:self.buttonCategory];
//    
//    self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(160, buttonY, 45, 20)];
//    self.buttonCategory.backgroundColor = [UIColor blueColor];
//    [self.buttonCategory setTitle:@"刷新" forState:UIControlStateNormal];
//    [self.buttonCategory addTarget:self action:@selector(refreshPostData) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:self.buttonCategory];
//    
//    self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(300, buttonY, 45, 20)];
//    self.buttonCategory.backgroundColor = [UIColor blueColor];
//    [self.buttonCategory setTitle:@"栏目" forState:UIControlStateNormal];
//    [self.view addSubview:self.buttonCategory];


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


//    NSLog(@"reloadPostData");
//    
//    PostData *d = nil;
//    d = [[PostData alloc] init];
//    d.uid = @"qwertyui";
//    d.replyCount = 10;
//    d.content = @"福建省\n\n看到房间电视";
//    [self.postDatas addObject:d];
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    [indexPaths addObject:indexPath];
//    
//    [self.postView beginUpdates];
//    [self.postView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    [self.postView endUpdates];



//下一次点击同一个cell时,可能不能及时进入跳转的viewcontroller。
//使用dispatch_async的方式,或者随意performSelector一下.
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        [self presentViewController:rv animated:NO completion:^(void){
//
//            }
//        ];
//    });










    //点击加载.
    //加载中 － 非常努力地加载中.
    //加载成功. - [直接加载]
    //加载失败. － oops ! 点击重新加载.
    //加载无更多数据. - 已经没有了,点击刷新.


//- (void)refreshPostData {
//    
//    LOG_POSTION
//    
//    // 刷新时清空原所有数据.
//    self.boolRefresh = YES;
//    self.pageNum = 1;
//    
//    //[self.postView setHidden:YES];
//    
//    // 在子线程中调用download方法下载图片
//    [self showLoadingView];
//    [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
//}
//
//
//- (void)setBackgroundDownload1 {
//    
//    NSString *str = [NSString stringWithFormat:@"%@/%@?page=%zi", self.host, self.nameCategory, self.pageNum];
//    NSURL *urlstr=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"str:%@", str);
//    NSLog(@"url:%@", urlstr);
//    
//    //把图片转换为二进制的数据
//    NSData *data=[NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
//    [self performSelectorOnMainThread:@selector(parseAndFresh:) withObject:data waitUntilDone:NO];
//}




