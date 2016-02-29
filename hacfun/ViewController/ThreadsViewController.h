//
//  ThreadsViewController.h
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostData.h"
#import "CustomViewController.h"




@interface ThreadsViewController : CustomViewController

#define NSSTRING_CLICK_TO_LOADING   @"点击加载."
#define NSSTRING_LOADING            @"加载中 － 非常努力地加载中."
#define NSSTRING_LOAD_SUCCESSFUL    @"加载成功. - "
#define NSSTRING_LOAD_FAILED        @"加载失败. － oops ! 点击重新加载."
#define NSSTRING_NO_MORE_DATA       @"加载无更多数据. - 已经没有了."
#define NSSTRING_HAA                @"芦苇 芦苇 ......"

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

//网络加载时的等待提示.
@property (strong,nonatomic) UIView *viewLoading;

//more按钮显示出的action menu.
@property (strong,nonatomic) UIView *actionMenu;

//自动刷新.
@property (assign,nonatomic) BOOL autoRefresh;

@property (strong,nonatomic) NSString *host;
@property (strong,nonatomic) NSMutableData *jsonData;



- (void)showfootViewWithTitle:(NSString*)title andActivityIndicator:(BOOL)isActive andDate:(BOOL)isShowDate;
- (NSInteger)appendParsedPostDatas:(NSMutableArray*)parsedPostDatasArray ;

//override.
- (void)refreshPostData;
- (void)reloadPostData;

- (void)postDatasToCellDataSource ;

- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData ;
- (void)clearDataAdditional ;


@end
