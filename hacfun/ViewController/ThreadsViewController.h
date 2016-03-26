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

#define NSSTRING_CLICK_TO_LOADING   @"点击加载."
#define NSSTRING_LOADING            @"加载中 － 非常努力地加载中."
#define NSSTRING_LOAD_SUCCESSFUL    @"加载成功. - "
#define NSSTRING_LOAD_FAILED        @"加载失败. － oops ! 点击重新加载."
#define NSSTRING_NO_MORE_DATA       @"加载无更多数据. - 已经没有了."
#define NSSTRING_HAA                @"芦苇 芦苇 ......"

#define TAG_PostDataCellView    (4500000 + 1)

@property (assign,nonatomic) NSInteger  numberInOnePage;
@property (assign,nonatomic) NSInteger  numberOfAll;
@property (assign,nonatomic) NSInteger  numberOfLoaded;


//左边的页面信息按钮.
@property (strong,nonatomic) UIButton *buttonCategory;

//显示threads的UITableView.
@property (strong,nonatomic) UITableView *postView;

//显示threads的数据源.
@property (strong,nonatomic) NSMutableArray *postDatas;
@property (strong,nonatomic) NSMutableArray *postViewCellDatas;

//UITableView的footview.
@property (strong,nonatomic) UIButton *footView;
//@property (assign,nonatomic) NSInteger footViewStatus;
//@property (strong,nonatomic) NSArray* footViewStrings;

//下拉刷新.
@property (strong,nonatomic) UIRefreshControl *refresh;


//多页加载模式下的页面序号.
@property (assign,nonatomic) NSInteger pageNum;

//标记时属于加载或者是刷新.
@property (assign,nonatomic) BOOL boolRefresh;

//more按钮显示出的action menu.
@property (strong,nonatomic) UIView *actionMenu;

//自动刷新.
@property (assign,nonatomic) BOOL autoRefresh;

@property (strong,nonatomic) NSString *host;
@property (strong,nonatomic) NSMutableData *jsonData;

//持续加载下一页.
@property (nonatomic, assign) BOOL autoRepeatDownload;


typedef enum : NSUInteger {
    ThreadsStatusInit,
    ThreadsStatusLoading,
    ThreadsStatusLoadFinish,
    ThreadsStatusLoadFailed,
} ThreadsStatus;


@property (nonatomic, assign) ThreadsStatus status;

//UITableView的foot view用于显示状态数据. 使用此接口具体设置.
- (void)showfootViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate;


//显示一个提示信息.
- (void)showIndicationText:(NSString*)text;


- (void)refreshPostData;
- (void)reloadPostData;


//override.
//将刷新页得到的数据append到UITable的数据源时的行为. 可重写用于去重, 加页栏, 屏蔽等行为.
- (NSInteger)appendParsedPostDatas:(NSMutableArray*)parsedPostDatasArray ;


//可重写以修改PostData显示到PostDataView时的数据行为.
- (void)postDatasToCellDataSource ;


//可重写以修改cell显示样式.
- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData ;


//可重写以修改refresh时的数据清楚行为.
- (void)clearDataAdditional ;


//可重写以修改cell显示时的行为.
//目前使用:
//DetailViewController用以记录用户浏览的最新回复. 可用于收藏页判断是否有新回复.
- (void)threadDisplayActionInCell:(UITableViewCell*)cell withRow:(NSInteger)row;


//可重写以判断是否到last page.
- (BOOL)isLastPage;


@end
