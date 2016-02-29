//
//  PostViewController.m
//  hacfun
//
//  Created by Ben on 15/9/1.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "RecordViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"

@interface RecordViewController()




@end


@implementation RecordViewController

#if 0
- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.loadFromNetwork = false;
        self.numberInOnePage = 10;
        self.textTopic = @"收藏";
    }
    
    return self;
}


- (void)viewDidLoad {
    
    LOG_POSTION
//    self.loadFromNetwork = NO;
//    self.arrayAllRecord = [self getDataFromRecord];
//    if(0 == [self.arrayAllRecord count]) {
//        
//        PopupView *popupView = [[PopupView alloc] init];
//        //popupView.numofTapToClose = 1;
//        //popupView.secondsOfAutoClose = 2;
//        popupView.titleLabel = [self getNofifyStringForNone];
//        [popupView popupInSuperView:self.view];
//        
//        return ;
//    }
    
//    self.textTopic = @"我的发帖";
//    self.pageNum = 0;
    
    
    [super viewDidLoad];
}


- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData {
    NSLog(@"");
    
    UIView *view = [cell viewWithTag:102];
    if(NULL == view) {
        
        CGRect frame = [cell viewWithTag:100].frame;
        frame.origin.x += 3;
        frame.origin.y += 3;
        frame.size.width -= 2 * 3;
        frame.size.height -= 2 * 3;
        
        view = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:view];
        [cell sendSubviewToBack:view];
        [view setTag:102];
        [view setBackgroundColor:[UIColor whiteColor]];
    }
}


#if 0
- (void)reloadPostData {
    NSInteger idx = (self.pageNum - 1) * self.numberInOnePage ;
    NSInteger num = 0;
    
    for(; idx < self.numberOfAll && num < self.numberInOnePage; idx++, num++) {
        
        PostData* postData = [self LocalDataToPostData:idx];
        if(postData) {
            [self.postDatas addObject:postData];
        }
        else {
            NSLog(@"error- record data error");
        }
        
        self.numberOfLoaded ++;
    }
    
    numOfLeft = self.numberOfAll - self.numberOfLoaded;
    if(self.numberOfAll == self.numberOfLoaded) {
        NSLog(@"error- all data loaded.");
        
        //footview 提示信息加载完成.
        stringFootview = [NSString stringWithFormat:@"数据加载完成, 共%zi条", self.numberOfAll] ;
    }
    else {
        self.pageNum ++;
        stringFootview = [NSString stringWithFormat:@"共%zi条, 已加载%zi条", self.numberOfAll, self.numberOfLoaded];
    }
    
    [self postDatasToCellDataSource];
    [self.postView reloadData];
    
    [self showfootViewWithTitle:stringFootview andActivityIndicator:NO andDate:NO];
}
#endif


- (void)reloadPostData {
    LOG_POSTION
    
    if(nil == self.arrayAllRecord) {
        self.arrayAllRecord = [self getAllLocalData];

    }
    
    if([self.postDatas count] >= [self.arrayAllRecord count]) {
        NSLog(@"No more data.");
    }
    else {
        self.pageNum ++;
        for(NSInteger idx = (self.pageNum-1)* 10 ; idx < [self.arrayAllRecord count] && idx < self.pageNum * 10; idx++ ) {
            
            NSDictionary *dict = [self.arrayAllRecord objectAtIndex:idx];
            NSString *jsonstring = [dict objectForKey:@"jsonstring"];
            
            id obj = [NSJSONSerialization JSONObjectWithData:[jsonstring dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            
            PostData *pd = [PostData fromDictData:obj];
            if(pd) {
                pd.type = PostDataTypeLocal;
                [self.postDatas addObject:pd];
            }
            else {
                NSLog(@"error --- ");
            }
        }
    }
    
    [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zi条, 已加载%zi条", [self.arrayAllRecord count], [self.postDatas count]]
           andActivityIndicator:NO andDate:NO];
    
    [self postDatasToCellDataSource];
    [self.postView reloadData];
}


- (NSString*)getNofifyStringForNone {
    return @"无记录信息";
}


- (void)deletePost:(NSInteger)row {
    NSLog(@"---\n%@", self.arrayAllRecord);
    

    
}


- (void)didSelectRow:(NSInteger)row {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    NSInteger threadId = ((PostData*)[self.postDatas objectAtIndex:row]).id;
    
    NSLog(@"threadId = %zi", threadId);
    [vc setPostThreadId:threadId];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)longPressOnRow:(NSInteger)row {
    
    //数据库数据删除.
    [self deletePost:row];
    
    //PostData数据删除.
    [self.postDatas removeObjectAtIndex:row];
    
    //UITableView数据源刷新.
    [self postDatasToCellDataSource];
    
    //UITableView reload.
    [self.postView reloadData];
}





#endif
@end
