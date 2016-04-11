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

@property (strong,nonatomic) NSArray *arrayAllLocaleMoveToPublic;

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


- (NSArray*)getAllLocaleData {
    NSLog(@"error - must override.")
    return nil;
}


- (void)reloadPostData {
    LOG_POSTION
    
    if(nil == self.arrayAllLocale) {
        self.arrayAllLocale = [self getAllLocaleData];
    }
    
    if([self.postDatas count] >= [self.arrayAllLocale count]) {
        NSLog(@"No more data.");
    }
    else {
        self.pageNumLoading ++;
        for(NSInteger idx = (self.pageNumLoading-1)* 10 ; idx < [self.arrayAllLocale count] && idx < self.pageNumLoading * 10; idx++ ) {
            
            NSDictionary *dict = [self.arrayAllLocale objectAtIndex:idx];
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
    
    [self showfootViewWithTitle:[NSString stringWithFormat:@"共%zi条, 已加载%zi条", [self.arrayAllLocale count], [self.postDatas count]]
           andActivityIndicator:NO andDate:NO];
    
    [self postDatasToCellDataSource];
    [self.postView reloadData];
}


@end