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






@interface ThreadsViewController () <UITableViewDataSource, UITableViewDelegate, RTLabelDelegate>




@end




@implementation ThreadsViewController



-(instancetype) init {
    
    if(self = [super init]) {
        self.threadsStatus = ThreadsStatusInit;
        self.pageNumLoaded = 0;
        self.pageNumLoading = 1; //从page1开始加载.
        self.postDatas = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.host = [[AppConfig sharedConfigDB] configDBGet:@"host"];
    
    //tableview
    self.postView = [[UITableView alloc] init];
    [self.view addSubview:self.postView];
    self.postView.delegate = self;
    self.postView.dataSource = self;
    self.postView.tag = 1;
    self.postView.backgroundColor = [AppConfig backgroundColorFor:@"PostTableView"];
    self.postView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //增加cell长按功能.
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.postView addGestureRecognizer:longPressGr];
    
    //UIRefreshControll
    [self setBeginRefreshing];
    
    //footview.
    self.footView = [[PushButton alloc] init];
    self.footView.backgroundColor = self.postView.backgroundColor;
    [self.footView setTitleColor:[AppConfig textColorFor:@"Black"] forState:UIControlStateNormal];
    [self showfootViewWithTitle:[self getFooterViewTitleOnStatus:self.threadsStatus] andActivityIndicator:NO andDate:NO];
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
    
    return;
}


- (void)viewWillLayoutSubviews {
    LOG_POSTION
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
    self.footView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.footView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
    self.postView.tableFooterView = self.footView;
    

    
    
    
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
    //could be override.
    [self clearDataAdditional];
    
    [self postDatasToCellDataSource];
    
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


//---override. pretreat before append to self.postDatas.
- (NSInteger)parsePostDatasPretreat:(NSMutableArray*)parsedPostDatasArray {
    
    return 0;
}


- (NSMutableArray*)parsedPostDatasRetreat:(NSMutableArray*)parsedPostData
{
    return [NSMutableArray arrayWithArray:parsedPostData];
}






- (void)postDatasToCellDataSource {
    self.postViewCellDatas = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for(PostData* postData in self.postDatas) {
        NSMutableDictionary *dict = [postData toViewDisplayData:ThreadDataToViewTypeInfoUseReplyCount];
        [dict setObject:[NSNumber numberWithInteger:index] forKey:@"row"];
        index ++;
        [self.postViewCellDatas addObject:dict];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.postView reloadData];
    });
}


- (void)clickViewThumb: (PushButton*)button {
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
    if(pd.optimumSizeHeight > 1.0) {
        height = pd.optimumSizeHeight;
    }
    
    NSLog(@"------tableView[%zd] heightForRowAtIndexPath return %.1f", indexPath.row, height);
    return height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.postViewCellDatas count];
    NSLog(@"------tableView numberOfRowsInSection : %zd [%zd]", rows, self.postDatas.count);
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
    
    v.rowAction = ^(NSInteger row, NSString *actionString) {
        NSLog(@"--- row %zd, actionString %@", row, actionString);
        [self actionOnRow:row viaString:actionString];
    };

    UIView *viewThumb = [v getThumbImage];
    [viewThumb setTag:indexPath.row];
    [(PushButton*)viewThumb addTarget:self action:@selector(clickViewThumb:) forControlEvents:UIControlEventTouchDown];
    
    RTLabel *contentLabel = (RTLabel*)[v getContentLabel];
    contentLabel.delegate = self;
    
    PostData* pd = ((PostData*)[self.postDatas objectAtIndex:indexPath.row]);
    pd.optimumSizeHeight = v.frame.size.height;
    
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
    [self threadDisplayActionInCell:cell withRow:indexPath.row];
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


- (void)threadDisplayActionInCell:(UITableViewCell*)cell withRow:(NSInteger)row
{
    NSLog(@"tid [%zd] display.", ((PostData*)self.postDatas[row]).id);
}


//增加上拉刷新.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"------scrollView------")
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


- (void)didSelectRow:(NSInteger)row {
    NS0Log(@"didSelectRow : %zi", row);
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
    for(PostData *postData in self.postDatas) {
        if(postData.id == tid) {
            return [postData copy];
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
        NSLog(@"use data in list.")
        postDataView = [PostDataCellView threadCellViewWithData:[postDataInList toViewDisplayData:ThreadDataToViewTypeInfoUseNumber]
                                                   andInitFrame:self.view.bounds
                        ];
    }
    else {
        //不是在列表中的则实时获取.
        NSLog(@"use data from read download.")
        postDataView = [PostDataCellView PostDatalViewWithTid:tid
                                                 andInitFrame:self.view.bounds
                                             completionHandle:^(PostDataCellView *postDataView, NSError *error) {
                                                 postDataView.center = postDataView.superview.center;
                                                [self adjustPopupView:postDataView];
                                             }
                        ];
    }
    
    [self showPopupView:postDataView];
    
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


//重载以定义row行为.
- (BOOL)actionOnRow:(NSInteger)row viaString:(NSString*)string
{
    BOOL finishAction = YES;
    PostData *postDataRow = [self.postDatas objectAtIndex:row];
    
    NSMutableDictionary * dictm = self.postViewCellDatas[row];
    [dictm setObject:@NO forKey:@"showAction"];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:row inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([string isEqualToString:@"复制"]){
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:[postDataRow.content copy]];
        [self showStatusText:@"已复制到粘贴板"];
    }
    else if([string isEqualToString:@"举报"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            CreateViewController *createViewController = [[CreateViewController alloc]init];
            NSString *content = [NSString stringWithFormat:@">>NO.%zd\n", postDataRow.id];
            [createViewController setCreateCategory:@"值班室" withOriginalContent:content];
            [self.navigationController pushViewController:createViewController animated:YES];
        });
    }
    else if([string isEqualToString:@"加入草稿"]) {
        NSInteger ret = [[AppConfig sharedConfigDB] configDBDraftInsert:@{@"content":[NSString decodeWWWEscape:postDataRow.content]}];
        if(DB_EXECUTE_OK == ret) {
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


- (NSArray*)actionStringsOnRow:(NSInteger)row
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
            
            [self longPressOnRow:indexPath.row at:pointInView];
        }
        else {
            NSLog(@"long press not at tableview");
        }
    }
}


- (void)longPressOnRow:(NSInteger)row at:(CGPoint)pointInView {
    LOG_POSTION
    
    //标记需显示 cell栏的action.
    NSMutableDictionary * dictm = self.postViewCellDatas[row];
    NSNumber *numberBOOLShowAction = [dictm objectForKey:@"showAction"];
    if(!numberBOOLShowAction || ![numberBOOLShowAction boolValue]) {
        [dictm setObject:@YES forKey:@"showAction"];
        [dictm setObject:[self actionStringsOnRow:row] forKey:@"actionStrings"];
    }
    else {
        [dictm setObject:@NO forKey:@"showAction"];
    }
    
    //刷新指定row.
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:row inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.postView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}




@end










