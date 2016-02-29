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

@property (strong,nonatomic) NSArray *arrayAllLocale;

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


- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData*)postData {
    
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
        self.pageNum ++;
        for(NSInteger idx = (self.pageNum-1)* 10 ; idx < [self.arrayAllLocale count] && idx < self.pageNum * 10; idx++ ) {
            
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