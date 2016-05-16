//
//  ReplyViewController.m
//  hacfun
//
//  Created by Ben on 15/9/7.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "ReplyViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"


@interface ReplyViewController ()

@property (nonatomic, strong) NSArray *repliesTidNumbers;

@end


@implementation ReplyViewController









- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"回复";
        
        
    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    NSMutableArray *topicsM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBReplyGets];
    self.concreteDatasClass = [Reply class];
    for(Reply *reply in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:reply.tid]];
        
        NSLog(@"%@", reply);
        
        if([topicsM indexOfObject:[NSNumber numberWithInteger:reply.tidBelongTo]] == NSNotFound) {
            [topicsM addObject:[NSNumber numberWithInteger:reply.tidBelongTo]];
        }
    }
    
    NSArray *postDatasTopic = [[AppConfig sharedConfigDB] configDBRecordGets:[NSArray arrayWithArray:topicsM]];

    self.repliesTidNumbers = [NSArray arrayWithArray:allTidM];
    self.allTid = [NSArray arrayWithArray:topicsM];
    self.postDatasAll = [[AppConfig sharedConfigDB] configDBRecordGets:self.allTid];
    self.postDatasAll = postDatasTopic;
}


- (void)removeRecordsWithTids:(NSArray*)tids
{
    [[AppConfig sharedConfigDB] configDBReplyRemoveByTidArray:tids];
}


- (void)retreatPostViewDataAdditional:(PostData *)postData onIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *postViewData = postData.postViewData;
    NSMutableArray *replyTids = [[NSMutableArray alloc] init];
    for(Reply *reply in self.concreteDatas) {
        if(reply.tidBelongTo == postData.tid) {
            [replyTids addObject:[NSNumber numberWithInteger:reply.tid]];
        }
    }
    
    NSArray *postDatasReply = [[AppConfig sharedConfigDB] configDBRecordGets:replyTids];
    if(postDatasReply.count > 0) {
        NSLog(@"topoc [%zd] with replies [%@]", postData.tid, replyTids);
        [postViewData setObject:postDatasReply forKey:@"replies"];
    }
    else {
        NSLog(@"#error ")
    }
}





@end