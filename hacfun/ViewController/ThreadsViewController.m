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





@interface ThreadsViewController () <UITableViewDataSource, UITableViewDelegate, RTLabelDelegate, UIActionSheetDelegate>




@end




@implementation ThreadsViewController



-(instancetype) init {
    
    if(self = [super init]) {
        [self initMemberData];
    }
    
    return self;
}


- (void)initMemberData
{
    self.threadsStatus = ThreadsStatusInit;
    self.pageNumLoaded = 0;
    self.numberLoaded = 0;
    self.pageNumLoading = 1; //从page1开始加载.
    self.postDataPages = [[NSMutableArray alloc] init];
    
    self.indexPathsDisplaying = [[NSMutableArray alloc] init];
    self.dynamicPostViewDataOptimumSizeHeight   = [[NSMutableDictionary alloc] init];
    self.dynamicPostViewDataShowActionButtons   = [[NSMutableDictionary alloc] init];
    self.dynamicPostViewDataFold                = [[NSMutableDictionary alloc] init];
    self.dynamicPostViewDataStatusInfo          = [[NSMutableDictionary alloc] init];
    self.dynamicTidStatusInfo                   = [[NSMutableDictionary alloc] init];
}


- (void)viewDidLoad {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    
    //tableview
    self.postView = [[UITableView alloc] init];
    [self.view addSubview:self.postView];
    self.postView.delegate = self;
    self.postView.dataSource = self;
    self.postView.tag = 1;
    self.postView.backgroundColor = [UIColor colorWithName:@"PostTableViewBackground"];
    self.postView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //增加cell长按功能.
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.postView addGestureRecognizer:longPressGr];
    
    //UIRefreshControll
    [self setBeginRefreshing];
    
    //footview.
    self.footView = [[PushButton alloc] init];
    self.footView.backgroundColor = self.postView.backgroundColor;
    [self.footView setTitleColor:[UIColor colorWithName:@"FootViewText"] forState:UIControlStateNormal];
    [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:NO andDate:NO];
    [self.footView.titleLabel setFont:[UIFont fontWithName:@"PostContent"]];
    [self.footView addTarget:self action:@selector(clickFootView) forControlEvents:UIControlEventTouchDown];
    self.postView.tableFooterView = self.footView;
    
    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 0, 36, 36)];
    [activityIndicatorView setColor:[UIColor blackColor]];
    [activityIndicatorView setTag:1];
    [self.footView addSubview:activityIndicatorView];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutCellView:) name:@"CellViewFrameChanged" object:nil];
    
    [self reloadPostView];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self startAction];
    });
    
    //打开浏览器后会设置navigationController的toolbar. 此处消除toolbar.
    self.navigationController.toolbarItems = nil;
    self.navigationController.toolbarHidden = YES;
    
    return;
}


- (void)viewWillLayoutSubviews {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewWillLayoutSubviews];
    
    //tableview
    CGFloat yTableViewBorder = 0;
    CGFloat yTableView = self.yBolowView + yTableViewBorder;
    
    CGFloat xTableViewBorder = 0;
    CGRect framePostView = CGRectMake(xTableViewBorder, yTableView, self.view.frame.size.width - 2*xTableViewBorder, self.view.frame.size.height - yTableView);
    if(FRAMELAYOUT_IS_EQUAL(framePostView, self.postView.frame)) {
        NSLog(@"postView frame not changed.");
    }
    else {
        NSLog(@"postView frame changed.")
        [self.postView setFrame:framePostView];
        
        LOG_VIEW_REC0(self.view, @"view")
        LOG_VIEW_REC0(self.postView, @"postView")
        [self.postView reloadData];
        
        //footview.
        self.footView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.footView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
        self.postView.tableFooterView = self.footView;
    }
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
    if(self.threadsStatus != ThreadsStatusLoading) {
        self.threadsStatus = ThreadsStatusLoading;
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
        titleShow = [NSString stringWithFormat:@"%@\n%@", title, dateString];
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





- (void)showStatusText:(NSString *)text
{
    [self showIndicationText:text];
}


- (void)setBeginRefreshing {
    self.refresh = [[UIRefreshControl alloc]init];
    self.refresh.tintColor = [UIColor colorWithName:@"RefreshTint"];
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
    
    [self initMemberData];
    
    //could be override.
    [self clearDataAdditional];
    
    [self.postView reloadData];
    
    [self loadMore];
}


- (void)clearDataAdditional {
    
}


- (void)reloadPostData{
    LOG_POSTION
    NSLog(@"override for locale or network.");
}


//override.
//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page
{
    NSLog(@"#error - should be override.");
    return 20;
}


//---override. pretreat before append to self postdatas.
- (NSMutableArray*)parsedPostDatasRetreat:(NSMutableArray*)parsedPostDatas onPage:(NSInteger)page
{
    return [NSMutableArray arrayWithArray:parsedPostDatas];
}


- (NSMutableDictionary*)cellPresentDataFromPostData:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"ffflod : %@", self.dynamicPostViewDataFold);
    
    NSMutableDictionary *dict = [postData toViewDisplayData:ThreadDataToViewTypeInfoUseReplyCount];
    [dict setObject:indexPath forKey:@"indexPath"];
    
    NSNumber *isActionButtonsShow = [self.dynamicPostViewDataShowActionButtons objectForKey:indexPath];
    if(isActionButtonsShow && [isActionButtonsShow isKindOfClass:[NSNumber class]] && [isActionButtonsShow boolValue]) {
        [dict setObject:@YES forKey:@"showAction"];
        [dict setObject:[self actionStringsForRowAtIndexPath:indexPath] forKey:@"actionStrings"];
    }
    
    NSArray *foldInfos = [self.dynamicPostViewDataFold objectForKey:indexPath];
    if([foldInfos isKindOfClass:[NSArray class]] && foldInfos.count > 0) {
        [dict setObject:[NSString combineArray:foldInfos withInterval:@", " andPrefix:@"" andSuffix:@""] forKey:@"fold"];
    }
    
    NSString *statusMessage = [self.dynamicPostViewDataStatusInfo objectForKey:indexPath];
    if([statusMessage isKindOfClass:[NSString class]]) {
        [dict setObject:statusMessage forKey:@"statusInfo"];
    }
    
    NSString *statusMessageTid = [self.dynamicTidStatusInfo objectForKey:[NSNumber numberWithInteger:postData.tid]];
    if([statusMessageTid isKindOfClass:[NSString class]]) {
        [dict setObject:statusMessage forKey:@"statusInfo"];
    }
    
    return dict;
}



- (void)clickViewThumb: (PushButton*)button {
    
#if 0
    NSIndexPath *indexPath = [button valueForKey:@"indexPath"];
    
    NSLog(@"clickViewThumb on %@", indexPath);
    
    PostData *pdata = [self postDataOnIndexPath:indexPath];
    if(!(pdata.image && ![pdata.image isEqualToString:@""])) {
        NSLog(@"#error - postData image not found.");
        return;
    }

    NSString *imageHost = [[AppConfig sharedConfigDB] configDBGet:@"imageHost"];
    NSString *downloadString = [NSString stringWithFormat:@"%@/%@", imageHost, pdata.image];
#endif
    
    PostImageView *postImageView = (PostImageView*)button;
    NSString *downloadString = postImageView.linkImageString;

    ImageViewController *vc = [[ImageViewController alloc] init];
    NSURL *url=[[NSURL alloc] initWithString:[downloadString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *placeholdImage = nil;
    if([button isKindOfClass:[PostImageView class]]) {
        placeholdImage = [(PostImageView*)button getDisplayingImage];
    }
    
    [vc sd_setImageWithURL:url placeholderImage:placeholdImage];
//    [self presentViewController:vc animated:NO completion:^(void){ }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    NSLog(@"------tableView------");
//    return 1.0;
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    NSLog(@"------tableView------");
//    return 1.0;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.bounds.size.height;
    NSNumber *numberHeight = [self.dynamicPostViewDataOptimumSizeHeight objectForKey:indexPath];
    if(numberHeight && [numberHeight isKindOfClass:[NSNumber class]]) {
        height = [numberHeight floatValue];
    }
    
    NSLog(@"------tableView[%@] heightForRowAtIndexPath return %.1f", [NSString stringFromTableIndexPath:indexPath], height);
    return height;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.postDataPages.count;
    NSLog(@"------tableView------ numberOfSectionsInTableView : %zd", sections);
    return sections;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PostDataPage *postDataPage = self.postDataPages[section];
    NSInteger rows = postDataPage.postDatas.count;

    //NSLog(@"------tableView numberOfRowsInSection : section:%zd, page:%zd, rows:%zd", section, postViewDataPage.page, rows);
    //PostDataPage *postDataPage = self.postDataPages[section];
    NSLog(@"------ section %zd , rows : %zd", section, rows);
    
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView cellForRowAtIndexPath : %@", [NSString stringFromTableIndexPath:indexPath]);
    
    PostData *postData = [self postDataOnIndexPath:indexPath];
    NSMutableDictionary *postViewDataRow = [self cellPresentDataFromPostData:postData onIndexPath:indexPath];
    NSLog(@"postViewDataRow : %@", postViewDataRow);
    
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
    
    PostDataCellView *v = [PostDataCellView threadCellViewWithData:postViewDataRow
                                                      andInitFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];
    [cell addSubview:v];
    [v setTag:TAG_PostDataCellView];
    
    v.rowAction = ^(NSIndexPath *indexPath, NSString *actionString) {
        NSLog(@"--- row %@, actionString %@", indexPath, actionString);
        [self actionForRowAtIndexPath:indexPath viaString:actionString];
    };

    PostImageView *viewThumb = [v getThumbImage];
    NSString *imageHost = self.host.imageHost;
    NSString *downloadString = [NSString stringWithFormat:@"%@/%@", imageHost, postData.image];
    viewThumb.linkImageString = downloadString;
    
    [(PushButton*)viewThumb addTarget:self action:@selector(clickViewThumb:) forControlEvents:UIControlEventTouchDown];
    
    RTLabel *contentLabel = (RTLabel*)[v getContentLabel];
    contentLabel.delegate = self;
    
    //记录变长高度.
    [self.dynamicPostViewDataOptimumSizeHeight setObject:[NSNumber numberWithFloat:v.frame.size.height] forKey:indexPath];
    
    FRAMELAYOUT_SET_HEIGHT(cell, v.frame.size.height);

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NS0Log(@"点击的行数是:%@", [NSString stringFromTableIndexPath:indexPath]);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PostDataPage *postDataPage = self.postDataPages[indexPath.section];
    PostData *postDataRow = postDataPage.postDatas[indexPath.row];
    
    [self didSelectActionOnIndexPath:indexPath withPostData:postDataRow];
}


- (NSString*)indexPathsDisplayingDescription
{
    NSMutableString *strm = [[NSMutableString alloc] init];
    for(NSIndexPath *indexPath in self.indexPathsDisplaying) {
        [strm appendString:[NSString stringFromTableIndexPath:indexPath]];
        [strm appendString:@" "];
    }
    
    return [NSString stringWithString:strm];
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.indexPathsDisplaying removeObject:indexPath];
    NSLog(@"remove %@, now displaying %@.", [NSString stringFromTableIndexPath:indexPath], [self indexPathsDisplayingDescription]);
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView[%@] willDisplayCell", [NSString stringFromTableIndexPath:indexPath]);
    [self.indexPathsDisplaying addObject:indexPath];
    NSLog(@"add    %@, now displaying %@.", [NSString stringFromTableIndexPath:indexPath], [self indexPathsDisplayingDescription]);
    
    //关于优化后台加载数据后的延迟刷新. 未完成合适方案.
#if UITABLEVIEW_INSERT_OPTUMIZE
    NSLog(@"cell   frame : %@", [NSString stringFromCGRect:cell.frame]);
    NSLog(@"footer frame : %@", [NSString stringFromCGRect:tableView.tableFooterView.frame]);
    
    CGFloat sectionHeight = 1;
    if((cell.frame.origin.y + cell.frame.size.height + sectionHeight + 1) >= (tableView.tableFooterView.frame.origin.y)) {
        NSLog(@"last cell YES");
        
        NSLog(@"indexPath  : section %zd, row %zd", indexPath.section, indexPath.row);
        NSLog(@"datasource : page    %zd, count %zd", self.postViewDataPages.count, ((PostViewDataPage*)[self.postViewDataPages lastObject]).postViewDatas.count);
        
        if((indexPath.section + 1) == self.postViewDataPages.count
           && (indexPath.row + 1) == ((PostViewDataPage*)[self.postViewDataPages lastObject]).postViewDatas.count) {
            NSLog(@"reloaded all datasource.");
        }
        else {
            NSLog(@"not load all datasouce.");
            [tableView reloadData];
        }
    }
    else {
        NSLog(@"last cell NO");
    }
#endif
    
    //让sub class重载以实现不同cell定制.
    [self layoutCell:cell forRowAtIndexPath:indexPath withPostData:[self postDataOnIndexPath:indexPath]];
    
    //让sub class重载以实现显示cell后的行为.
    [self threadDisplayActionInCell:cell forRowAtIndexPath:indexPath];
}


- (void)layoutCell: (UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    PostDataCellView * v = [cell viewWithTag:TAG_PostDataCellView];
    if(v) {
        v.layer.backgroundColor = [UIColor whiteColor].CGColor;
        v.layer.borderWidth = 5;
        v.layer.borderColor = [UIColor colorWithName:@"CategoryCellBorder"].CGColor;
//        v.layer.shadowOpacity = 0.7;
//        v.layer.shadowRadius = 10.0;
    }
}


- (void)threadDisplayActionInCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}


//增加上拉刷新.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat judgeOffsetY = scrollView.contentSize.height
                            + scrollView.contentInset.bottom
                            - scrollView.frame.size.height;
                            //    - self.postView.tableFooterView.frame.size.height;
    
    //拉到低栏20及以上才出发上拉刷新.
    CGFloat heightTrigger = 36.0;
    if(offsetY >= judgeOffsetY + heightTrigger) {
        NSLog(@"pull up trigger loadmore.");
        [self clickFootView];
    }
}


- (BOOL)isLastPage
{
    return NO;
}


- (NSString*)getFooterViewTitleOnStatus:(ThreadsStatus)status
{
    NSString *footViewString = @"";
    
    switch (status) {
        case ThreadsStatusInit:
        case ThreadsStatusLocalInit:
        case ThreadsStatusNetworkInit:
            footViewString = KNSSTRING_CLICK_TO_LOADING;
            break;
            
        case ThreadsStatusLoading:
            footViewString = KNSSTRING_LOADING;
            break;
            
        case ThreadsStatusLoadFailed:
            footViewString = KNSSTRING_LOAD_FAILED;
            break;
            
        case ThreadsStatusLoadSuccessful:
            footViewString = KNSSTRING_LOAD_SUCCESSFUL;
            break;
            
        case ThreadsStatusLoadNoMoreData:
            footViewString = KNSSTRING_NO_MORE_DATA;
            break;
            
        default:
            footViewString = KNSSTRING_HAA;
            break;
    }
    
    return footViewString;
}


- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{

}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSLog(@"url = %@", url);
    
    NSString *str = [NSString stringWithFormat:@"%@", url];
    if([str hasPrefix:@"No."]) {
        NSInteger tid = [str substringWithRange:NSMakeRange(3, str.length-3)].integerValue;
        [self showReferencePostDataView:tid];
        return;
    }
    
    NSString *khttpUrlString = @"http://h.koukuko.com/t/";
    if([str hasPrefix:khttpUrlString]) {
        NSInteger tid = [str substringWithRange:NSMakeRange(khttpUrlString.length, str.length-khttpUrlString.length)].integerValue;
        [self showReferencePostDataView:tid];
        return;
    }
        
    if([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"]) {
        [[ UIApplication sharedApplication] openURL:url];
    }
}


- (PostData*)findInSelfPostDatas:(NSInteger)tid
{
    for(PostDataPage *postDataPage in self.postDataPages) {
        for(PostData *postData in postDataPage.postDatas) {
            if(postData.tid == tid) {
                return [postData copy];
            }
        }
    }
    
    return nil;
}


- (void)showReferencePostDataView:(NSInteger)tid
{
    PostDataCellView *postDataView = nil;
    
    //检查是否在当前列表中.
    PostData *postDataInList = [self findInSelfPostDatas:tid];
    if(postDataInList) {
        NSLog(@"use data in list.");
        postDataView = [PostDataCellView threadCellViewWithData:[postDataInList toViewDisplayData:ThreadDataToViewTypeInfoUseNumber]
                                                   andInitFrame:self.view.bounds
                        ];
    }
    else {
        //不是在列表中的则实时获取.
        NSLog(@"use data from read download.");
        postDataView = [PostDataCellView PostDatalViewWithTid:tid
                                                 andInitFrame:self.view.bounds
                                             completionHandle:^(PostDataCellView *postDataView, NSError *error) {
                                                 postDataView.center = postDataView.superview.center;
                                                [self adjustPopupView:postDataView];
                                             }
                        ];
    }
    
    LOG_POSTION
    [self showPopupView:postDataView];
    
    LOG_POSTION
    [self adjustPopupView:postDataView];
}


//居中显示. 当弹出的PostDataCellView比superView高的时候, 需使用UIScrollView. 接口可移入CustomViewController中.
- (void)adjustPopupView:(UIView*)postDataView
{
    postDataView.center = postDataView.superview.center;
    
    LOG_POSTION
    //当PostDataCellView的高度比superView的高度的一定比例高的时候, 加入UIScrollView.
    if(postDataView.frame.size.height > (postDataView.superview.frame.size.height * 0.8)) {
        UIView *superView = postDataView.superview;
        
        LOG_POSTION
        CGRect frameScrollView = postDataView.superview.bounds;
        frameScrollView.size.height = frameScrollView.size.height * 0.8;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frameScrollView];
        [postDataView.superview addSubview:scrollView];
        scrollView.contentSize = postDataView.frame.size;
        scrollView.center = postDataView.superview.center;
        [postDataView removeFromSuperview];
        
        CGRect framePostDataView = postDataView.frame;
        framePostDataView.origin.x = 0;
        framePostDataView.origin.y = 0;
        postDataView.frame = framePostDataView;
        [scrollView addSubview:postDataView];
        
        NSLog(@"qaz %@", superView.subviews);
    }
}


- (void)showCellActionButtonsOnIndexPath:(NSIndexPath*)indexPath andReload:(BOOL)reload
{
    [self.dynamicPostViewDataShowActionButtons setObject:@YES forKey:indexPath];
    
    if(reload) {
        //设置后刷新.
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)hiddenCellActionButtonsOnIndexPath:(NSIndexPath*)indexPath andReload:(BOOL)reload
{
    [self.dynamicPostViewDataShowActionButtons setObject:@NO forKey:indexPath];
    
    if(reload) {
        //设置后刷新.
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}





- (void)foldCellOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload
{
    NSArray *infos = [self.dynamicPostViewDataFold objectForKey:indexPath];
    if(infos) {
        if([infos indexOfObject:info] != NSNotFound) {
            NSMutableArray *infosM = [NSMutableArray arrayWithArray:infos];
            [infosM addObject:info];
            [self.dynamicPostViewDataFold setObject:[NSArray arrayWithArray:infosM] forKey:indexPath];
        }
    }
    else {
        [self.dynamicPostViewDataFold setObject:@[info] forKey:indexPath];
    }
    
    if(reload) {
        //设置后刷新.
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)unfoldCellOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload
{
    NSArray *infos = [self.dynamicPostViewDataFold objectForKey:indexPath];
    if(infos) {
        if([infos indexOfObject:info] != NSNotFound) {

        }
        else {
            NSMutableArray *infosM = [NSMutableArray arrayWithArray:infos];
            [infosM removeObject:info];
            if(infosM.count > 0) {
                [self.dynamicPostViewDataFold setObject:[NSArray arrayWithArray:infosM] forKey:indexPath];
            }
            else {
                [self.dynamicPostViewDataFold removeObjectForKey:indexPath];
            }
        }
    }
    else {
        
    }
    
    if(reload) {
        //设置后刷新.
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)setStatusInfoOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload
{
    if(info) {
        [self.dynamicPostViewDataStatusInfo setObject:info forKey:indexPath];
    }
    else {
        [self.dynamicPostViewDataStatusInfo removeObjectForKey:indexPath];
    }
    
    if(reload) {
        //设置后刷新.
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)setStatusInfoOnTid:(NSInteger)tid withInfo:(NSString*)info andReload:(BOOL)reload
{
    if(info) {
        [self.dynamicTidStatusInfo setObject:info forKey:[NSNumber numberWithInteger:tid]];
    }
    else {
        [self.dynamicTidStatusInfo removeObjectForKey:[NSNumber numberWithInteger:tid]];
    }
    
    if(reload) {
        //设置后刷新.
        
        NSIndexPath *indexPath = [self indexPathWithTid:tid];
        if(indexPath) {
            NSArray *indexArray=[NSArray arrayWithObject:indexPath];
            [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}


//重载以定义row行为.
- (BOOL)actionForRowAtIndexPath:(NSIndexPath*)indexPath viaString:(NSString*)string
{
    BOOL finishAction = YES;
    PostDataPage *postDataPage = self.postDataPages[indexPath.section];
    PostData *postDataRow = postDataPage.postDatas[indexPath.row];
    
    [self hiddenCellActionButtonsOnIndexPath:indexPath andReload:YES];
    
    if([string isEqualToString:@"复制"]){
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:[NSString decodeWWWEscape:postDataRow.content]];
        [self showStatusText:@"已复制到粘贴板"];
    }
    else if([string isEqualToString:@"举报"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            CreateViewController *createViewController = [[CreateViewController alloc]init];
            NSString *content = [NSString stringWithFormat:@">>NO.%zd\n", postDataRow.tid];
            [createViewController setCreateCategory:@"值班室" withOriginalContent:content];
            [self.navigationController pushViewController:createViewController animated:YES];
        });
    }
    else if([string isEqualToString:@"加入草稿"]) {
        BOOL ret = [[AppConfig sharedConfigDB] configDBDraftAdd:[NSString decodeWWWEscape:postDataRow.content]];
        if(ret) {
            [self showStatusText:@"已加入草稿"];
        }
        else {
            [self showStatusText:@"加入草稿失败"];
        }
    }
    else {
        finishAction = NO;
    }
    
    return finishAction;
}


- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @[@"复制", @"加入草稿"];
}


- (CGPoint)postViewPointToViewPoint:(CGPoint)pointInPostView
{
    CGPoint point = pointInPostView;
    point.x -= self.postView.contentOffset.x;
    point.y -= self.postView.contentOffset.y;
    
    
    point.x += self.postView.frame.origin.x;
    point.y += self.postView.frame.origin.y;
    
    NSLog(@"point in view : %@", NSStringFromCGPoint(point));
    
    return point;
}


- (void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"longPressToDo %@", gesture);
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gesture locationInView:self.postView];
        NSLog(@"%@ %@", @"long press point", NSStringFromCGPoint(point));
        NSLog(@"%@ %@", @"contentOffset", NSStringFromCGPoint(self.postView.contentOffset));
        NSLog(@"%@ %@", @"contentSize", NSStringFromCGSize(self.postView.contentSize));
        NSLog(@"%@ %@", @"contentInset", NSStringFromUIEdgeInsets(self.postView.contentInset));
        
        CGPoint pointInView = [self postViewPointToViewPoint:point];
        NSLog(@"%@ %@", @"long press point", NSStringFromCGPoint(pointInView));
        
        NSIndexPath *indexPath = [self.postView indexPathForRowAtPoint:point];
        if(indexPath){
            NSLog(@"long press at row : %zi", indexPath.row);
            
            [self longPressOnRow:indexPath at:pointInView];
        }
        else {
            NSLog(@"long press not at tableview");
        }
    }
}


//- (void)longPressOnRow:(NSInteger)row at:(CGPoint)pointInView1 {

- (void)longPressOnRow:(NSIndexPath*)indexPath at:(CGPoint)pointInView1 {
    LOG_POSTION
    
    //标记需显示 cell栏的action.
    [self showCellActionButtonsOnIndexPath:indexPath andReload:YES];
    
    
#if 0
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:@"ActionChoose"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:@"Destroy"
                              otherButtonTitles:@"OK", nil];
    
    [mySheet addButtonWithTitle:@"111"];
    [mySheet showInView:self.view];
#endif
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
        //
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
//
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
//
}


- (NSInteger)numberOfPostDatasTotal
{
    NSInteger number = 0;
    
    for(PostDataPage *page in self.postDataPages) {
        number += page.postDatas.count;
    }
    
    return number;
}


- (PostData*)postDataLastObject
{
    PostData *postData = nil;
    
    PostDataPage *postDataPage = [self.postDataPages lastObject];
    if(postDataPage) {
        postData = [postDataPage.postDatas lastObject];
    }
    
    return postData;
}





- (NSIndexPath*)indexPathWithTid:(NSInteger)tid
{

    NSInteger section = 0;
    for(PostDataPage *page in self.postDataPages) {
        NSInteger row = 0;
        for(PostData *postData in page.postDatas) {
            if(postData.tid == tid) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
            
            row ++;
        }
        
        section ++;
    }
    
    return nil;
}


//根据postData的
- (BOOL)updateDataSourceByPostData:(PostData*)postDataUpdate
{
    BOOL updateToNew = NO;
    
    BOOL found = NO;
    NSInteger section = 0;
    for(PostDataPage *page in self.postDataPages) {
        NSInteger row = 0;
        for(PostData *postData in page.postDatas) {
            if(postData.tid == postDataUpdate.tid) {
                found = YES;
                
                if([postData isEqual:postDataUpdate]) {
                    NSLog(@"tid [%zd] data is the same.", postDataUpdate.tid);
                }
                else {
                    NSLog(@"tid [%zd] data is NOT the same, update.", postDataUpdate.tid);
                    NSLog(@"%@", postData);
                    NSLog(@"%@", postDataUpdate);
                    updateToNew = YES;
                    
                    //更新对应的postData.
                    [postData copyFrom:postDataUpdate];
                    
                    //更新对应的postViewData.
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
                    [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                break;
            }
            
            row ++;
        }
        
        if(updateToNew) {
            break;
        }
        
        section ++;
    }
    
    NSLog(@"finish.");
    
    return updateToNew;
}


- (NSArray*)generatePostDataArray
{
    NSMutableArray *postDatasM = [[NSMutableArray alloc] init];
    for(PostDataPage *page in self.postDataPages) {
        for(PostData *postData in page.postDatas) {
            [postDatasM addObject:postData];
        }
    }
    
    return [NSArray arrayWithArray:postDatasM];
}


- (NSInteger)addPostDatas:(NSMutableArray*)appendPostDatas onPage:(NSInteger)page
{
    NSInteger section = NSNotFound;
    if(self.postDataPages.count == 0) {
        PostDataPage *postDataPage = [[PostDataPage alloc] init];
        postDataPage.page = page;
        postDataPage.section = 0;
        [postDataPage.postDatas addObjectsFromArray:appendPostDatas];
        
        [self.postDataPages addObject:postDataPage];
        
        section = 0;
    }
    else {
        PostDataPage *postDataPageLast = [self.postDataPages lastObject];
        if(postDataPageLast.page == page) {
            [postDataPageLast.postDatas addObjectsFromArray:appendPostDatas];
            section = postDataPageLast.section;
        }
        else {
            PostDataPage *postDataPage = [[PostDataPage alloc] init];
            postDataPage.page = page;
            postDataPage.section = postDataPageLast.section + 1;
            [postDataPage.postDatas addObjectsFromArray:appendPostDatas];
            
            [self.postDataPages addObject:postDataPage];
            
            section = postDataPage.section;
        }
    }
    
    return section;
}


- (void)reloadSectionViaAppend:(NSInteger)section
{
    NSLog(@"###### UITableView reload.");
    [self.postView reloadData];
}

- (void)reloadPostView
{
    NSLog(@"###### UITableView reload.");
    [self.postView reloadData];
}


- (NSArray*)indexPathsPostData
{
    NSMutableArray *indexPathsM = [[NSMutableArray alloc] init];
    
    NSInteger sectionTotal = self.postDataPages.count;
    for(NSInteger section = 0; section < sectionTotal; section ++) {
        PostDataPage *postDataPage = self.postDataPages[section];
        NSInteger rowTotal = postDataPage.postDatas.count;
        for(NSInteger row = 0; row < rowTotal; row ++) {
            [indexPathsM addObject:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }

    return [NSArray arrayWithArray:indexPathsM];
}


- (PostData*)postDataOnIndexPath:(NSIndexPath*)indexPath
{
    PostData *postData = nil;
    
    if(indexPath.section >=0 && indexPath.section < self.postDataPages.count) {
        PostDataPage *postDataPage = self.postDataPages[indexPath.section];
        if(indexPath.row >=0 && indexPath.row < postDataPage.postDatas.count) {
            postData = postDataPage.postDatas[indexPath.row];
        }
    }
    
    if(!postData) {
        NSLog(@"#error - PostData nil on %@", indexPath);
    }
    
    return postData;
}








@end







