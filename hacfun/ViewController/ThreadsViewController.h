//
//  ThreadsViewController.h
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PostData.h"
#import "PostDataCellView.h"
#import "CustomViewController.h"
@interface ThreadsViewController : CustomViewController

#define KNSSTRING_CLICK_TO_LOADING   @"点击加载."
#define KNSSTRING_LOADING            @"加载中 － 非常努力地加载中."
#define KNSSTRING_LOAD_SUCCESSFUL    @"加载成功. - "
#define KNSSTRING_LOAD_FAILED        @"加载失败. － oops ! 点击重新加载."
#define KNSSTRING_NO_MORE_DATA       @"加载无更多数据. - 已经没有了."
#define KNSSTRING_HAA                @"芦苇 芦苇 ......"

typedef NS_ENUM(NSInteger, ThreadsStatus) {
    ThreadsStatusInit,
    ThreadsStatusLocalInit,
    ThreadsStatusNetworkInit,
    ThreadsStatusLoading,
    ThreadsStatusLoadSuccessful,
    ThreadsStatusLoadFailed,
    ThreadsStatusLoadNoMoreData,
};


#define TAG_PostDataCellView    (4500000 + 1)

@property (assign,nonatomic) NSInteger  numberOfAll;
@property (assign,nonatomic) NSInteger  numberOfLoaded;


//左边的页面信息按钮.
@property (strong,nonatomic) PushButton *buttonCategory;

//显示threads的UITableView.
@property (strong,nonatomic) UITableView *postView;

//显示threads的数据源.
@property (strong,nonatomic) NSMutableArray *postDataPages;
@property (strong,nonatomic) NSMutableArray *postViewDataPages;

@property (strong,nonatomic) PushButton *footView;
//@property (assign,nonatomic) ThreadLoadStatus footViewStatus;

//下拉刷新.
@property (strong,nonatomic) UIRefreshControl *refresh;

//多页加载模式下的页面序号. 已加载. 在加载成功后更新.
@property (assign,nonatomic)    NSInteger pageNumLoaded;
@property (nonatomic, assign)   NSInteger numberLoaded;

//多页加载模式下的页面序号. 正加载或刚加载完成的页面序号.
@property (assign,nonatomic) NSInteger pageNumLoading;


//标记时属于加载或者是刷新.
@property (assign,nonatomic) BOOL boolRefresh;

//more按钮显示出的action menu.
@property (strong,nonatomic) UIView *actionMenu;

//自动刷新.
@property (assign,nonatomic) BOOL autoRefresh;

@property (strong,nonatomic) Host *host;
@property (strong,nonatomic) NSMutableData *jsonData;

//持续加载下一页.
@property (nonatomic, assign) BOOL autoRepeatDownload;

@property (nonatomic, assign) ThreadsStatus threadsStatus;

@property (nonatomic, strong) NSMutableArray *indexPathsDisplaying;




//UITableView的foot view用于显示状态数据. 使用此接口具体设置.
- (void)showfootViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate;

//显示状态信息.
- (void)showStatusText:(NSString*)text;

- (void)refreshPostData;
- (void)reloadPostData;
- (BOOL)updateDataSourceByPostData:(PostData*)postDataUpdate;
- (void)postDatasToCellDataSource ;
- (PostViewDataPage*)postDataPageToPostViewData:(PostDataPage*)postDataPage onSection:(NSInteger)section andReload:(BOOL)reload;
- (NSInteger)addPostDatas:(NSMutableArray*)appendPostDatas onPage:(NSInteger)page;

- (NSInteger)numberOfPostDatasTotal;
- (PostData*)postDataLastObject;


- (PostData*)postDataOnIndexPath:(NSIndexPath*)indexPath;
- (NSMutableDictionary*)postViewDataOnIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathWithTid:(NSInteger)tid;
- (NSArray*)generatePostDataArray;


//override.


//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page;

//将刷新页得到的数据append到UITable的数据源时的行为. 可重写用于去重, 加页栏, 屏蔽等行为.
- (NSMutableArray*)parsedPostDatasRetreat:(NSMutableArray*)parsedPostDatas onPage:(NSInteger)page;


//可重写以修改PostData显示到PostDataView时的数据行为.
- (NSMutableDictionary*)cellPresentDataFromPostData:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath;


//可重写以修改cell显示样式.
- (void)layoutCell: (UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData;

//可重写以修改refresh时的数据清楚行为.
- (void)clearDataAdditional ;

//可重写以修改cell显示时的行为.
//目前使用:
//DetailViewController用以记录用户浏览的最新回复. 可用于收藏页判断是否有新回复.
- (void)threadDisplayActionInCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath;

//可重写以判断是否到last page.
- (BOOL)isLastPage;

//可重写以针对不同状态提示不同显示内容.
- (NSString*)getFooterViewTitleOnStatus:(ThreadsStatus)status;

//重载以定义点击row后的行为.
- (void)didSelectActionOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData;

//重载以定义row行为. 定义为BOOL以实现让super尝试先处置.

- (BOOL)actionForRowAtIndexPath:(NSIndexPath*)indexPath viaString:(NSString*)string;


//重载以定义cell能支持的动作. NSArray成员为 NSString.
- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath;


@end
