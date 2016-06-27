//
//  ThreadsViewController.h
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PostData.h"
#import "ModelAndViewInc.h"
#import "CustomViewController.h"
#import "PostGroupView.h"



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


typedef NS_ENUM(NSInteger, ThreadsType) {
    ThreadsTypeRoot,
    ThreadsTypeNetwork,
    ThreadsTypeCategory,
    ThreadsTypeDetail,
    ThreadsTypeCreate,
    ThreadsTypeSearch, 
    ThreadsTypeLocal
};


#define TAG_PostView    (4500000 + 1)

@property (assign,nonatomic) NSInteger  numberOfAll;
@property (assign,nonatomic) NSInteger  numberOfLoaded;


//左边的页面信息按钮.
@property (strong,nonatomic) PushButton *buttonCategory;

//显示threads的UITableView.
@property (strong,nonatomic) UITableView *postView;

//显示threads的数据源.
@property (strong,nonatomic) NSMutableArray *postDataPages;



@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataOptimumSizeHeight;

@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataShowActionButtons;
@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataFold;
@property (nonatomic, strong) NSMutableDictionary *dynamicPostViewDataStatusInfo;
@property (nonatomic, strong) NSMutableDictionary *dynamicTidStatusInfo;




@property (strong,nonatomic) UILabel *footView;
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
@property (nonatomic, assign) NSInteger autoRepeatDownloadPages;

@property (nonatomic, assign) ThreadsStatus threadsStatus;



//总的page数量. 可在解析中根据解析的数据更新.
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL showSection;

@property (nonatomic, strong) NSIndexPath *rowActionIndexPath;

//UITableView的foot view用于显示状态数据. 使用此接口具体设置.
- (void)showfootViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate;//###



- (void)refreshPostData;
- (void)refreshPostDataToPage:(NSInteger)page;



- (BOOL)updateDataSourceByPostData:(PostData*)postDataUpdate;
//- (NSInteger)addPostDatas:(NSMutableArray*)appendPostDatas onPage:(NSInteger)page;
- (void)appendDataOnPage:(NSInteger)page with:(NSArray<PostData*>*)postDatas removeDuplicate:(BOOL)remove andReload:(BOOL)reload;

- (void)appendPostDataPage:(PostDataPage*)postDataPage andReload:(BOOL)reload;

- (NSInteger)numberOfPostDatasTotal;
- (PostData*)postDataLastObject;


- (NSArray*)generatePostDataArray;

//折叠和取消折叠.
- (void)foldCellOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload;
- (void)unfoldCellOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload;

//设置一些状态信息.
- (void)setStatusInfoOnIndexPath:(NSIndexPath*)indexPath withInfo:(NSString*)info andReload:(BOOL)reload;
- (void)setStatusInfoOnTid:(NSInteger)tid withInfo:(NSString*)info andReload:(BOOL)reload;

- (void)reloadThreadByTid:(NSInteger)tid
                   onPage:(NSInteger)page
                  success:(void(^)(PostData* topic, NSArray* replies))successHandle
                  failure:(void(^)(NSError * error))failureHandle;


- (void)postViewReloadSectionViaAppend:(NSInteger)section;
- (void)postViewReload;
- (void)postViewReloadRow:(NSIndexPath*)indexPath;


- (NSIndexPath*)indexPathWithTid:(NSInteger)tid;
- (NSArray*)indexPathsPostData;
- (PostData*)postDataOnIndexPath:(NSIndexPath*)indexPath;//###


- (void)enumerateObjectsUsingBlock:(void (^)(PostData * postData, NSIndexPath * indexPath, BOOL *stop))block;


- (void)resetPostViewData;


- (NSMutableArray*)actionStringsForRowAtIndexPathStaple:(NSIndexPath*)indexPath;
- (void)showRowActionMenuOnIndexPath:(NSIndexPath*)indexPath;


//override.

- (void)loadPage:(NSInteger)page;
- (void)startAction ;
- (void)actionLoadMore;


- (void)clickFootView;

- (void)autoActionAfterRefreshPostData;


//一个满的page是多少. 用于判断是否进入下一个page的加载.
- (NSInteger)numberExpectedInPage:(NSInteger)page;

//将刷新页得到的数据append到UITable的数据源时的行为. 可重写用于去重, 加页栏, 屏蔽等行为.
- (NSMutableArray*)parsedPostDatasRetreat:(NSMutableArray*)parsedPostDatas onPage:(NSInteger)page;


//定制PostView显示的时候的类型.
- (ThreadDataToViewType)postViewPresendTypeOnIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData;
- (void)retreatPostViewDataAdditional:(PostData*)postData onIndexPath:(NSIndexPath*)indexPath;



//可重写以修改cell显示样式.
- (void)layoutCell: (UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath withPostData:(PostData*)postData;

//可重写以修改refresh时的数据清楚行为.
- (void)resetPostViewDataAdditional ;

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


- (NSString*)headerStringOnSection:(NSInteger)section;
- (void)headerActionOnSection:(NSInteger)section;

@end
