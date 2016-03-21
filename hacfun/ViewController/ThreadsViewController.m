//
//  ThreadsViewController.m
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ThreadsViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "CreateViewController.h"
#import "ImageViewController.h"
#import "AppConfig.h"
#import "PopupView.h"
#import "ReferencePopupView.h"





@interface ThreadsViewController () <UITableViewDataSource, UITableViewDelegate, RTLabelDelegate>

@property (nonatomic, strong) UILabel *viewIndication;

@end




@implementation ThreadsViewController



-(instancetype) init {
    
    if(self = [super init]) {
        self.status = ThreadsStatusInit;
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
    self.postView.backgroundColor = [AppConfig backgroundColorFor:@"PostTableView"];
    self.postView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.postView reloadData];
    
    //增加cell长按功能.
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.postView addGestureRecognizer:longPressGr];
    
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
    [activityIndicatorView setColor:[UIColor blackColor]];
    [activityIndicatorView setTag:1];
    [self.footView addSubview:activityIndicatorView];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutCellView:) name:@"CellViewFrameChanged" object:nil];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self startAction];
    });
    
    self.viewIndication = [[UILabel alloc] init];
    
    return;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //tableview
    CGFloat yTableViewBorder = 0;
    CGFloat yTableView = self.yBolowView + yTableViewBorder;
    
    CGFloat xTableViewBorder = 0;
    CGRect framePostView = CGRectMake(xTableViewBorder, yTableView, self.view.frame.size.width - 2*xTableViewBorder, self.view.frame.size.height - yTableView);
    [self.postView setFrame:framePostView];
    
    LOG_VIEW_REC0(self.view, @"view")
    LOG_VIEW_REC0(self.postView, @"postView")
    [self.postView reloadData];
    
    //footview.
    [self.footView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
    self.postView.tableFooterView = self.footView;
    
    CGFloat heightViewIndication = 36;
    CGRect frameViewIndication = framePostView;
    frameViewIndication.origin.x = framePostView.size.width - heightViewIndication;
    frameViewIndication.origin.y = heightViewIndication;
    frameViewIndication.size.width = heightViewIndication;
    frameViewIndication.size.height = heightViewIndication;
    [self.viewIndication setFrame:frameViewIndication];
    [self.viewIndication setBackgroundColor:HexRGBAlpha(0xeeeeee, 0.6)];
    [self.viewIndication setText:@"1"];
    [self.viewIndication setTextAlignment:NSTextAlignmentCenter];
    [self.viewIndication setTextColor:HexRGBAlpha(0x000000, 0.2)];
    [self.viewIndication.layer setCornerRadius:heightViewIndication / 2];
    [self.viewIndication.layer setMasksToBounds:YES];
    [self.view addSubview:self.viewIndication];
}


- (void)startAction {
    LOG_POSTION
    [self refreshPostData];
}


- (void)clickFootView {
    LOG_POSTION
    
    [self loadMore];
}


- (void)loadMore
{
    //判断一下状态.如果是正在reload的状态则进行reload.
    if(self.status != ThreadsStatusLoading) {
        self.status = ThreadsStatusLoading;
        [self reloadPostData];
    }
    else {
        NSLog(@"in loading.");
    }
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
        
    [self loadMore];
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
    NSLog(@"------tableView------");
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSLog(@"------tableView------");
    return 1.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSLog(@"------tableView------");
    return 1.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.bounds.size.height;
    PostData* pd = (PostData*)([self.postDatas objectAtIndex:indexPath.row]);
    if(pd.height > 1.0) {
        height = pd.height;
    }
    
    NSLog(@"------tableView[%zd] heightForRowAtIndexPath return %.1f", indexPath.row, height);
    return height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.postDatas count];
    NSLog(@"------tableView numberOfRowsInSection : %zd", rows);
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView[%zd] cellForRowAtIndexPath", indexPath.row);
    
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
    
    PostDataCellView *v = [PostDataCellView threadCellViewWithData:[self.postViewCellDatas objectAtIndex:indexPath.row]
                                                      andInitFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];
    [cell addSubview:v];
    [v setTag:TAG_PostDataCellView];

    UIView *viewThumb = [v getThumbImage];
    [viewThumb setTag:indexPath.row];
    [(UIButton*)viewThumb addTarget:self action:@selector(clickViewThumb:) forControlEvents:UIControlEventTouchDown];
    
    RTLabel *contentLabel = (RTLabel*)[v getContentLabel];
    contentLabel.delegate = self;
    
    PostData* pd = ((PostData*)[self.postDatas objectAtIndex:indexPath.row]);
    pd.height = v.frame.size.height;
    
    FRAMELAYOUT_SET_HEIGHT(cell, v.frame.size.height);

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NS0Log(@"点击的行数是:%zi", indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView[%zd] willDisplayCell", indexPath.row);
    [self layoutCell:cell withRow:indexPath.row withPostData:[self.postViewCellDatas objectAtIndex:indexPath.row]];
}


- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData {
    PostDataCellView * v = [cell viewWithTag:TAG_PostDataCellView];
    if(v) {
        v.layer.backgroundColor = [UIColor whiteColor].CGColor;
        v.layer.borderWidth = 5;
//        v.layer.borderColor = [UIColor clearColor].CGColor;
        v.layer.borderColor = HexRGBAlpha(0xdddddd, 0.5).CGColor;
//        v.layer.shadowOpacity = 0.7;
//        v.layer.shadowRadius = 10.0;
    }
}


//增加上拉刷新.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"------scrollView------")
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat judgeOffsetY = scrollView.contentSize.height
                            + scrollView.contentInset.bottom
                            - scrollView.frame.size.height;
                            //    - self.postView.tableFooterView.frame.size.height;
    
    //NSLog(@"&&&&&&&&&&&&&&%f %f", offsetY, judgeOffsetY);
    //拉到低栏20及以上才出发上拉刷新.
    CGFloat heightTrigger = 36.0;
    if(offsetY >= judgeOffsetY + heightTrigger) {
        NSLog(@"xxxxx")
        [self clickFootView];
    }
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










