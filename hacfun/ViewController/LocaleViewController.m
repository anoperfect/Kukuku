//
//  LocaleViewController.m
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import "LocaleViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"


@interface LocaleViewController ()


@end


@implementation LocaleViewController

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.numberInOnePage = 10;
        self.textTopic = @"本地";
    }
    
    return self;
}


- (void)viewDidLoad {
    LOG_POSTION
    [super viewDidLoad];

}


//将数据读入arrayAllRecord.
- (void)getAllRecordData
{
    NSLog(@"#error - must override.")
}


- (void)reloadPostData {
    LOG_POSTION
    
    if(nil == self.arrayAllRecord) {
        [self getAllRecordData];
    }
    
    if([self.postDatas count] >= [self.arrayAllRecord count]) {
        NSLog(@"No more data.");
    }
    else {
        self.pageNumLoading ++;
        for(NSInteger idx = (self.pageNumLoading-1)* 10 ; idx < [self.arrayAllRecord count] && idx < self.pageNumLoading * 10; idx++ ) {
            
            NSDictionary *dict = [self.arrayAllRecord objectAtIndex:idx];
            NSString *jsonstring = [dict objectForKey:@"jsonstring"];
            PostData *pd = [PostData fromString:jsonstring atPage:self.pageNumLoading];
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
}


- (NSArray*)actionStringsOnRow:(NSInteger)row
{
    return @[@"复制", @"加入草稿", @"删除"];
}


@end