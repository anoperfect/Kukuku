//
//  DetailViewController.h
//  hacfun
//
//  Created by Ben on 15/7/20.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkThreadViewController.h"
@interface DetailViewController : NetworkThreadViewController




//alloc init后调用设置tid.
//- (void)setDetailedTid:(NSInteger)tid onCategory:(PCategory*)category withData:(PostData*)postDataTopic;
- (void)setDetailedTid:(NSInteger)tid withData:(PostData*)postDataTopic from:(ThreadsType)type addtional:(id)addtional;




@end
