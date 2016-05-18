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
#import "ModelAndViewInc.h"




@interface ThreadsViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PostViewDelegate>




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
    
    
    
    //###
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
    
    [self addObserver:self
           forKeyPath:@"pageNumLoading"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    return;
}


- (void)viewWillLayoutSubviews {
    NSLog(@"/vc\\ %s", __FUNCTION__);
    [super viewWillLayoutSubviews];
    
//    //tableview
//    CGFloat yTableViewBorder = 0;
//    CGFloat yTableView = self.yBolowView + yTableViewBorder;
//    
//    CGFloat xTableViewBorder = 0;
//    CGRect framePostView = CGRectMake(xTableViewBorder, yTableView, self.view.frame.size.width - 2*xTableViewBorder, self.view.frame.size.height - yTableView);
    
    CGRect framePostView = self.view.bounds;
    
    NSLog(@"xyu : %@", [NSString stringFromCGRect:framePostView]);
    
    
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
    NSLog(@"#error - need to be override.");
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
        [self actionLoadMore];
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
    
    [self clearPostData];
    
    [self resetPostViewData];
    [self reloadPostView];
    [self loadMore];
}


- (void)refreshPostDataToPage:(NSInteger)page
{
    LOG_POSTION
    
    [self clearPostData];
    [self showfootViewWithTitle:@"" andActivityIndicator:NO andDate:NO];
    
    [self resetPostViewData];
    [self reloadPostView];
    
    [self showfootViewWithTitle:@"" andActivityIndicator:NO andDate:NO];
    [self loadPage:page];
}


- (void)clearPostData
{
    self.postDataPages = [[NSMutableArray alloc] init];
    [self reloadPostView];
}




- (void)resetPostViewData
{
    [self initMemberData];
    [self resetPostViewDataAdditional];
}


- (void)loadPage:(NSInteger)page
{
    NSLog(@"#error - need to be override.");
}




- (void)resetPostViewDataAdditional {
    NSLog(@"#error - need to be override.");
}


- (void)actionLoadMore
{
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


//增加折叠,cell功能栏,状态信息等.
- (void)retreatPostViewData:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"ffflod : %@", self.dynamicPostViewDataFold);
    
    NSMutableDictionary *dict = postData.postViewData;
    
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
}






//定制PostView显示的时候的类型.
- (ThreadDataToViewType)postViewPresendTypeOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData
{
    return ThreadDataToViewTypeCustom;
}


- (void)retreatPostViewDataAdditional:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath
{
    
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
    ThreadDataToViewType type = [self postViewPresendTypeOnIndexPath:indexPath withPostData:postData]; //override.
    [postData generatePostViewData:type];
    [self retreatPostViewData:postData onIndexPath:indexPath];
    [self retreatPostViewDataAdditional:postData onIndexPath:indexPath];//override.
    
    NSLog(@"tid [%zd] postViewDataRow : %@", postData.tid, [NSString stringFromNSDictionary:postData.postViewData]);
    
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
    
    PostView *v = [PostView PostViewWith:postData andFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];
    [cell addSubview:v];
    [v setTag:TAG_PostView];
    
    v.delegate = self;
    v.indexPath = indexPath;
    
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
    UIView * v = [cell viewWithTag:TAG_PostView];
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

    CGFloat heightTrigger = 36.0;

#if 0
    NSLog(@"%@ : %f", @"scrollView.contentSize.height", scrollView.contentSize.height);
    NSLog(@"%@ : %f", @"scrollView.frame.size.height", scrollView.frame.size.height);
    NSLog(@"%@ : %f", @"scrollView.contentOffset.y", scrollView.contentOffset.y);
#endif
    
    BOOL trigger = NO;
    if(scrollView.contentSize.height <= scrollView.frame.size.height) {
        if(scrollView.contentOffset.y  >= heightTrigger) {
            trigger = YES;
        }
    }
    else {
        if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + heightTrigger) {
            trigger = YES;
        }
        
    }
    
    NS0Log(@"000000trigger : %zd", trigger);
    
    if(trigger) {
        NSLog(@"pull up trigger loadmore.");
        [self clickFootView];
    }
}


- (NSString*)headerStringOnSection:(NSInteger)section
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString * headerString = [self headerStringOnSection:section];
    return headerString.length > 0 ? 36 : 0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString * headerString = [self headerStringOnSection:section];
    if(headerString.length == 0) {
        return nil;
    }
    
    UIView* sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor colorWithName:@"SectionHeaderBackground"];
    PushButton *sectionHeaderButton = [[PushButton alloc] initWithFrame:CGRectMake(36, 0, tableView.frame.size.width - 36 * 2, 36)];
    [sectionHeaderButton setTitle:headerString forState:UIControlStateNormal];
    [sectionHeaderButton setTitleColor:[UIColor colorWithName:@"SectionHeaderButtonText"] forState:UIControlStateNormal];
    sectionHeaderButton.backgroundColor = [UIColor colorWithName:@"SectionHeaderButtonBackground"];
    
    [sectionHeaderButton addTarget:self action:@selector(sectionHeaderAction:) forControlEvents:UIControlEventTouchDown];
    sectionHeaderButton.tag = section;
    
    
    [sectionHeaderView addSubview:sectionHeaderButton];
    return sectionHeaderView;
}


- (void)sectionHeaderAction:(id)sender
{
    LOG_POSTION
    
    PushButton *sectionHeaderButton = sender;
    NSInteger section = sectionHeaderButton.tag;
    NSLog(@"section %zd header action.", section);
    
    [self headerActionOnSection:section];
}


- (void)headerActionOnSection:(NSInteger)section
{
    
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
        [self showReferencePostView:tid];
        return;
    }
    
    NSString *khttpUrlString = @"http://h.koukuko.com/t/";
    if([str hasPrefix:khttpUrlString]) {
        NSInteger tid = [str substringWithRange:NSMakeRange(khttpUrlString.length, str.length-khttpUrlString.length)].integerValue;
        [self showReferencePostView:tid];
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


- (void)showReferencePostView:(NSInteger)tid
{
    PostView *postViewPopup = nil;
    
    //检查是否在当前列表中.
    PostData *postDataInList = [self findInSelfPostDatas:tid];
    if(postDataInList) {
        [postDataInList generatePostViewData:ThreadDataToViewTypeInfoUseNumber];
        
        NSLog(@"use data in list.");
        postViewPopup = [PostView PostViewWith:postDataInList andFrame:self.view.bounds];
    }
    else {
        //不是在列表中的则实时获取.
        NSLog(@"use data from read download.");
        postViewPopup = [PostView PostDatalViewWithTid:tid
                                              andFrame:self.view.bounds
                                               useType:ThreadDataToViewTypeInfoUseNumber
                                             completionHandle:^(PostView *postView, NSError *error) {
                                                 postView.center = postView.superview.center;
                                                [self adjustPopupView:postView];
                                             }
                        ];
    }
    
    postViewPopup.backgroundColor = [UIColor colorWithName:@"PostViewPopupBackground"];
    
    [self showPopupView:postViewPopup];
    [self adjustPopupView:postViewPopup];
}


//居中显示. 当弹出的PostView比superView高的时候, 需使用UIScrollView. 接口可移入CustomViewController中.
- (void)adjustPopupView:(UIView*)postView
{
    postView.center = postView.superview.center;
    
    LOG_POSTION
    //当PostView的高度比superView的高度的一定比例高的时候, 加入UIScrollView.
    if(postView.frame.size.height > (postView.superview.frame.size.height * 0.8)) {
        UIView *superView = postView.superview;
        
        LOG_POSTION
        CGRect frameScrollView = postView.superview.bounds;
        frameScrollView.size.height = frameScrollView.size.height * 0.8;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frameScrollView];
        [postView.superview addSubview:scrollView];
        scrollView.contentSize = postView.frame.size;
        scrollView.center = postView.superview.center;
        [postView removeFromSuperview];
        
        CGRect framePostView = postView.frame;
        framePostView.origin.x = 0;
        framePostView.origin.y = 0;
        postView.frame = framePostView;
        [scrollView addSubview:postView];
        
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
    NSLog(@"fold %@ with info : %@", [NSString stringFromTableIndexPath:indexPath], info);
    NSLog(@"before : %@", [self indexPathsFoldingDescription]);
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
    NSLog(@"after  : %@", [self indexPathsFoldingDescription]);
    
    if(reload) {
        //设置后刷新.
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



- (NSString*)indexPathsFoldingDescription
{
    NSMutableString *strm = [[NSMutableString alloc] init];
    for(NSIndexPath *indexPath in self.dynamicPostViewDataFold.allKeys) {
        [strm appendString:[NSString stringFromTableIndexPath:indexPath]];
        [strm appendFormat:@" : %@\n", [NSString combineArray:[self.dynamicPostViewDataFold objectForKey:indexPath] withInterval:@"," andPrefix:@"[" andSuffix:@"]"]];
    }
    
    return [NSString stringWithString:strm];
}



- (void)unfoldCellOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload
{
    NSLog(@"unfold %@ with info : %@", [NSString stringFromTableIndexPath:indexPath], info);
    NSLog(@"before : %@", [self indexPathsFoldingDescription]);
    
    NSArray *infos = [self.dynamicPostViewDataFold objectForKey:indexPath];
    if(infos) {
        if([infos indexOfObject:info] == NSNotFound) {
            LOG_POSTION
        }
        else {
            NSMutableArray *infosM = [NSMutableArray arrayWithArray:infos];
            [infosM removeObject:info];
            if(infosM.count > 0) {
                LOG_POSTION
                [self.dynamicPostViewDataFold setObject:[NSArray arrayWithArray:infosM] forKey:indexPath];
            }
            else {
                LOG_POSTION
                [self.dynamicPostViewDataFold removeObjectForKey:indexPath];
            }
        }
    }
    else {
        LOG_POSTION
    }
    NSLog(@"after  : %@", [self indexPathsFoldingDescription]);
    
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
    
    NSLog(@"self.postDataPages count : %zd", self.postDataPages.count);
    NSLog(@"numberOfPostDatasTotal : %zd", number);
    
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


- (void)appendDataOnPage:(NSInteger)page with:(NSArray<PostData*>*)postDatas removeDuplicate:(BOOL)remove andReload:(BOOL)reload
{
    
    NSInteger indexInsert = NSNotFound;
    BOOL finished = NO;
    NSInteger section = 0;
    for(; section < self.postDataPages.count; section ++) {
        PostDataPage *postDataPage = self.postDataPages[section];
        if(postDataPage.page < page) {
            continue;
        }
        
        if(postDataPage.page == page) {
            NSLog(@"Append on section : %zd.", section);
            
            if(!remove) {
                [postDataPage.postDatas addObjectsFromArray:postDatas];
            }
            else {
                NSLog(@"#error - not implenent remove duplicate.")
                [postDataPage.postDatas addObjectsFromArray:postDatas];
            }
            
            finished = YES;
            indexInsert = NSNotFound;
            
            break;
        }
        else {
            indexInsert = section;
            break;
        }
    }
    
    if(finished) {
        //已经完成Append.
    }
    else {
        if(indexInsert == NSNotFound) {
            indexInsert = section;
        }
        
        PostDataPage *postDataPage = [[PostDataPage alloc] init];
        postDataPage.page = page;
        postDataPage.postDatas = [NSMutableArray arrayWithArray:postDatas];
        
        NSLog(@"insert at section : %zd.", indexInsert);
        [self.postDataPages insertObject:postDataPage atIndex:indexInsert];
        NSLog(@"insert at section : %zd.", indexInsert);
    }
    
    if(reload) {
        [self reloadPostView];
    }
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


- (void)PostView:(PostView *)postView actionString:(NSString *)string
{
    NSLog(@"------ [%@] %@", [NSString stringFromTableIndexPath:postView.indexPath], string);
    
    [self actionForRowAtIndexPath:postView.indexPath viaString:string];
}


- (void)PostView:(PostView*)postView didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"url = %@", url);
    
    NSString *str = [NSString stringWithFormat:@"%@", url];
    if([str hasPrefix:@"No."]) {
        NSInteger tid = [str substringWithRange:NSMakeRange(3, str.length-3)].integerValue;
        [self showReferencePostView:tid];
        return;
    }
    
    NSString *khttpUrlString = @"http://h.koukuko.com/t/";
    if([str hasPrefix:khttpUrlString]) {
        NSInteger tid = [str substringWithRange:NSMakeRange(khttpUrlString.length, str.length-khttpUrlString.length)].integerValue;
        [self showReferencePostView:tid];
        return;
    }
    
    if([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"]) {
        [[ UIApplication sharedApplication] openURL:url];
    }
}


- (void)PostView:(PostView*)postView didSelectThumb:(UIImage*)imageThumb withImageLink:(NSString*)imageString
{
    ImageViewController *vc = [[ImageViewController alloc] init];
    NSURL *url=[[NSURL alloc] initWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [vc sd_setImageWithURL:url placeholderImage:imageThumb];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"pageNumLoading"]){//这里只处理balance属性
        NSLog(@"keyPath=%@,object=%@,newValue=%@,context=%@",keyPath,object,[change objectForKey:@"new"],context);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"pageNumLoading"];
}



@end







