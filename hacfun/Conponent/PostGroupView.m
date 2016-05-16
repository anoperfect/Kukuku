//
//  PostGroupView.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "PostGroupView.h"


@interface PostGroupView () <UITableViewDelegate, UITableViewDataSource, PostViewDelegate>

//UI控件.
@property (nonatomic, strong) UITableView *tableView;


//数据源.
@property (strong,nonatomic) NSMutableArray *postDataPages;



@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataOptimumSizeHeight;

@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataShowActionButtons;
@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataFold;
@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataStatusInfo;
@property (nonatomic, strong) NSMutableDictionary *dynamicTidStatusInfo;


@property (nonatomic, strong) NSMutableArray *indexPathsDisplaying;

@property (nonatomic, strong) NSMutableDictionary *optumizeHeights;

@end




@implementation PostGroupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.tableView];
        
        self.type = ThreadDataToViewTypeCustom;
        
        [self initMemberData];
    }
    return self;
}


- (void)initMemberData
{
    self.postDataPages = [[NSMutableArray alloc] init];
    
    self.indexPathsDisplaying = [[NSMutableArray alloc] init];
    self.dynamicPostViewDataOptimumSizeHeight   = [[NSMutableDictionary alloc] init];
    self.dynamicPostViewDataShowActionButtons   = [[NSMutableDictionary alloc] init];
    self.dynamicPostViewDataFold                = [[NSMutableDictionary alloc] init];
    self.dynamicPostViewDataStatusInfo          = [[NSMutableDictionary alloc] init];
    self.dynamicTidStatusInfo                   = [[NSMutableDictionary alloc] init];
}





- (void)layoutSubviews
{
    CGRect frameTableView = self.bounds;
    if(FRAMELAYOUT_IS_EQUAL(frameTableView, self.tableView.frame)) {
        
    }
    else {
        self.tableView.frame = self.bounds;
        [self.tableView reloadData];
    }
}



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
    
    ThreadDataToViewType type = self.type;
    if([self.delegate respondsToSelector:@selector(PostGroupView:postDataToViewTypeOnRow:)]) {
        type = [self.delegate PostGroupView:self postDataToViewTypeOnRow:indexPath];
    }
    [postData generatePostViewData:type];
    
    if([self.delegate respondsToSelector:@selector(PostGroupView:retreatPostViewDataOnRow:presendRetreat:)]) {
        [self.delegate PostGroupView:self retreatPostViewDataOnRow:indexPath presendRetreat:postData.postViewData];
    }
    
    NSLog(@"tid [%zd] postViewDataRow : %@", postData.tid, postData.postViewData);
    
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
    
    CGRect frame = self.frame;
    CGRect frameUITableView = UIEdgeInsetsInsetRect(frame, self.edgeViewGroup);
    CGRect framePostView = UIEdgeInsetsInsetRect(CGRectMake(0, 0, CGRectGetWidth(frameUITableView), 100), self.edgeView);
    
    PostView *v = [PostView PostViewWith:postData andFrame:framePostView];
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
    
    if([self.delegate respondsToSelector:@selector(PostGroupView:didSelectOnRow:)]) {
        [self.delegate PostGroupView:self didSelectOnRow:indexPath];
    }
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
    
    if([self.delegate respondsToSelector:@selector(PostGroupView:willDisplayPostView:OnRow:)]) {
        [self.delegate PostGroupView:self willDisplayPostView:[cell viewWithTag:TAG_PostView] OnRow:indexPath];
    }
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
    }
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


- (void)showfooterViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate
{
    
}


- (void)showHeaderViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate
{
    
    
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
        [self reloadPostGroupView];
    }
}


- (void)clearAllDataAndReload:(BOOL)reload
{
    self.postDataPages = [[NSMutableArray alloc] init];
    if(reload) {
        [self reloadPostGroupView];
    }
}


- (void)reloadPostGroupView
{
    [self.tableView reloadData];
}


- (CGFloat)optumizeHeight
{
    NSArray* indexPaths = [self indexPathsPostData];
    if(indexPaths.count == 0) {
        return 0.0;
    }
    
    [self reloadPostGroupView];
    [self.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    CGSize sizeTableView = self.tableView.contentSize;
    return sizeTableView.height;
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







- (void)PostView:(PostView *)postView actionString:(NSString *)string
{
    NSLog(@"------ %@", string);
    
    if([self.delegate respondsToSelector:@selector(PostGroupView:didActionOnRow:withAction:)]) {
        [self.delegate PostGroupView:self didActionOnRow:postView.indexPath withAction:string];
    }
}


- (void)PostView:(PostView*)postView didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"url = %@", url);
    NSString *str = [NSString stringWithFormat:@"%@", url];
    
    if([self.delegate respondsToSelector:@selector(PostGroupView:didClickLinkOnIndexPath:link:)]) {
        [self.delegate PostGroupView:self didClickLinkOnIndexPath:postView.indexPath link:str];
    }
}


- (void)PostView:(PostView*)postView didSelectThumb:(UIImage*)imageThumb withImageLink:(NSString*)imageString
{
    if([self.delegate respondsToSelector:@selector(PostGroupView:didClickThumbOnIndexPath:thumb:withLink:)]) {
        [self.delegate PostGroupView:self didClickThumbOnIndexPath:postView.indexPath thumb:imageThumb withLink:imageString];
    }
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end














































































































































































@interface DetailViewControllerTest () <PostGroupViewDelegate>

@property (nonatomic, strong) PostGroupView *pgv;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, strong) PostData *topic;

@end



@implementation DetailViewControllerTest



- (void)viewDidLoad
{
    self.pgv = [[PostGroupView alloc] init];
    [self.view addSubview:self.pgv];
    self.pgv.delegate = self;
    
    if(!self.topic) {
        self.topic = [PostData fromOnlyTid:self.tid];
    }
    
    [self.pgv appendDataOnPage:0 with:@[self.topic] removeDuplicate:NO andReload:YES];
}


- (void)viewWillLayoutSubviews
{
    CGRect framePgv = self.view.bounds;
    if(CGRectEqualToRect(framePgv, self.pgv.frame)) {
        
    }
    else {
        self.pgv.frame = framePgv;
        [self.pgv reloadPostGroupView];
    }
}



- (void)setPostTid:(NSInteger)tid withData:(PostData*)postDataTopic
{
    self.tid = tid;
    self.topic = [postDataTopic copy];
}

@end
