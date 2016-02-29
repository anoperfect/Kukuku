//
//  ThreadsViewController.m
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ThreadsViewController.h"
#import "PostDataCellView.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "CreateViewController.h"
#import "ImageViewController.h"
#import "AppConfig.h"
#import "PopupView.h"
#import "ReferencePopupView.h"
@interface ThreadsViewController () <UITableViewDataSource, UITableViewDelegate, RTLabelDelegate>



@end




@implementation ThreadsViewController


-(instancetype) init {
    
    if(self = [super init]) {
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.host = [[AppConfig sharedConfigDB] configDBGet:@"host"];
    //self.nameCategory = [@"综合版1" copy];
    
    //模拟的数据部分.
    self.postDatas = [[NSMutableArray alloc] init];
    
    //tableview
    self.postView = [[UITableView alloc] init];
    [self.view addSubview:self.postView];
    self.postView.delegate = self;
    self.postView.dataSource = self;
    self.postView.tag = 1;
    self.postView.backgroundColor = [AppConfig backgroundColorFor:@"PostViewCell"];
    self.postView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.postView reloadData];
    
    //增加cell长按功能.
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.postView addGestureRecognizer:longPressGr];
    
    //隐藏那个导航栏.
    self.navigationController.navigationBar.hidden = YES ;
    
    //UIRefreshControll
    [self setBeginRefreshing];
    
    //footview.
    self.footView = [[UIButton alloc] init];
    self.footView.backgroundColor = self.postView.backgroundColor;
    [self.footView setTitleColor:[AppConfig textColorFor:@"Black"] forState:UIControlStateNormal];
    [self showfootViewWithTitle:NSSTRING_CLICK_TO_LOADING andActivityIndicator:NO andDate:NO];
    [self.footView.titleLabel setFont:[AppConfig fontFor:@"PostContent"]];
    [self.footView addTarget:self action:@selector(clickFootView) forControlEvents:UIControlEventTouchDown];
    self.postView.tableFooterView = self.footView;
    
    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 0, 36, 36)];
    [activityIndicatorView setTag:1];
    [self.footView addSubview:activityIndicatorView];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutCellView:) name:@"CellViewFrameChanged" object:nil];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self startAction];
    });
    
    return;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //tableview
    CGFloat yTableViewBorder = 0;
    CGFloat yTableView = [self getOriginYBelowView] + yTableViewBorder;
    
    CGFloat xTableViewBorder = 0;
    [self.postView setFrame:CGRectMake(xTableViewBorder, yTableView, self.view.frame.size.width - 2*xTableViewBorder, self.view.frame.size.height - yTableView)];
    
    LOG_VIEW_REC0(self.view, @"view")
    LOG_VIEW_REC0(self.postView, @"postView")
    [self.postView reloadData];
    
    //footview.
    [self.footView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
    self.postView.tableFooterView = self.footView;
}



- (void)startAction {
    LOG_POSTION
    [self refreshPostData];
}


- (void)clickFootView {
    LOG_POSTION
    [self reloadPostData];
}


- (void)showfootViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate {
    
    NSString *titleShow = title;
    if(isShowDate) {
        
        NSDate *  freshDate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm"];
        NSString * dateString=[dateformatter stringFromDate:freshDate];
        titleShow = [NSString stringWithFormat:@"%@ %@", title, dateString];
    }
    
    [self.footView setTitle:titleShow forState:UIControlStateNormal];
    
    UIActivityIndicatorView* activityIndicatorView = (UIActivityIndicatorView*)[self.footView viewWithTag:1];
    if(isActive) {
        [activityIndicatorView startAnimating];
    }
    else {
        [activityIndicatorView stopAnimating];
    }
}


- (void)setBeginRefreshing {
    self.refresh = [[UIRefreshControl alloc]init];
    self.refresh.tintColor = [AppConfig textColorFor:@"RefreshTint"];
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


- (void)refreshPostData {
    
    LOG_POSTION
    
    [self.postDatas removeAllObjects];
    [self.postViewCellDatas removeAllObjects];
    [self.postView reloadData];
        
    //could be override.
    [self clearDataAdditional];
        
    [self reloadPostData];
}


- (void)clearDataAdditional {
    
}


- (void)reloadPostData{
    LOG_POSTION
    NSLog(@"override for locale or network.");
}



//---override. pretreat before append to self.postDatas.
- (NSInteger)parsePostDatasPretreat:(NSMutableArray*)parsedPostDatasArray {
    
    return 0;
}


- (NSInteger)appendParsedPostDatas:(NSMutableArray*)parsedPostDatasArray {
    LOG_POSTION
    
    NSInteger returnNum = 0;
    
    if(nil == parsedPostDatasArray) {
        NSLog(@"error - parseDownloadedData return nil.");
        return NSNotFound;
    }
    
    [self parsePostDatasPretreat:parsedPostDatasArray];
    
    [self.postDatas addObjectsFromArray:parsedPostDatasArray];
    returnNum = [parsedPostDatasArray count];
    
    NSLog(@"numOfPost = %zi, array count =%zi", returnNum, [self.postDatas count]);
    return returnNum;
}


- (void)postDatasToCellDataSource {
    self.postViewCellDatas = [[NSMutableArray alloc] init];
    for(PostData* postData in self.postDatas) {
        NSDictionary *dict = [postData toCellUsingDataWithReplyCount];
        [self.postViewCellDatas addObject:dict];
    }
}


- (void)clickViewThumb: (UIButton*)button {
    NSLog(@"%s at tag : %zi .", __func__, button.tag);
    if(!(button.tag < [self.postDatas count])) {
        NSLog(@"error : tag invalid.");
        return;
    }
    
    PostData *pdata = (PostData*)[self.postDatas objectAtIndex:button.tag];
    if(!(pdata.image && ![pdata.image isEqualToString:@""])) {
        return;
    }
    
    ImageViewController *vc = [[ImageViewController alloc] init];
    NSString *imageHost = [[AppConfig sharedConfigDB] configDBGet:@"imageHost"];
    NSString *downloadString = [NSString stringWithFormat:@"%@/%@", imageHost, pdata.image];
    
    NSURL *url=[[NSURL alloc] initWithString:[downloadString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [vc sd_setImageWithURL:url placeholderImage:nil];
//    [self presentViewController:vc animated:NO completion:^(void){ }];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    NSLog(@"cell %zd return height %.1f", indexPath.row, height);
    return height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.postDatas count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell %zd build.", indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        CGRect frame = cell.frame;
        frame.size.width = tableView.frame.size.width;
        [cell setFrame:frame];
    }
    else {
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    }
    cell.tag = indexPath.row;
    cell.backgroundColor = [AppConfig backgroundColorFor:@"PostViewCell"];
    
    PostDataCellView *v = nil;
    v = [[PostDataCellView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];
    [cell addSubview:v];
    [v setTag:100];
    [v setPostData:[self.postViewCellDatas objectAtIndex:indexPath.row] inRow:indexPath.row];
    [v setBackgroundColor:[UIColor clearColor]];
    
    UIView *viewThumb = [v getThumbImage];
    [viewThumb setTag:indexPath.row];
    [(UIButton*)viewThumb addTarget:self action:@selector(clickViewThumb:) forControlEvents:UIControlEventTouchDown];
    
    RTLabel *contentLabel = (RTLabel*)[v getContentLabel];
    contentLabel.delegate = self;
    
    PostData* pd = ((PostData*)[self.postDatas objectAtIndex:indexPath.row]);
    pd.height = v.frame.size.height;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NS0Log(@"点击的行数是:%zi", indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell %zd willDisplayCell.", indexPath.row);
    [self layoutCell:cell withRow:indexPath.row withPostData:[self.postViewCellDatas objectAtIndex:indexPath.row]];
}


- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData {
    NSLog(@"");
    
    
}


- (void)didSelectRow:(NSInteger)row {
    NS0Log(@"didSelectRow : %zi", row);
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSLog(@"url = %@", url);
    
    NSString *str = [NSString stringWithFormat:@"%@", url];
    if([str hasPrefix:@"No."]) {
        ReferencePopupView *popupView = [[ReferencePopupView alloc] init];
        popupView.numofTapToClose = 1;
        [popupView popupInSuperView:self.view];
        
        NSInteger no = [str substringWithRange:NSMakeRange(3, str.length-3)].integerValue;
        NSLog(@"no=%zi", no);
        [popupView setReferenceId1:no];
        
        LOG_VIEW_REC0(popupView, @"popupView")
    }
    else if([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"]) {
        [[ UIApplication sharedApplication] openURL:url];
    }
}


- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"longPressToDo %@", gesture);
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.postView];
        NSIndexPath *indexPath = [self.postView indexPathForRowAtPoint:point];
        if(indexPath){
            NSLog(@"long press at row : %zi", indexPath.row);
            
            [self longPressOnRow:indexPath.row];
        }
        else {
            NSLog(@"long press not at tableview");
        }
    }
}


- (void)longPressOnRow:(NSInteger)row {
    NSLog(@"no action. could override.");
}




@end










