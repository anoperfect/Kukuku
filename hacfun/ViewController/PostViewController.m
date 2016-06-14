//
//  PostViewController.m
//  hacfun
//
//  Created by Ben on 15/9/7.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"



@implementation PostViewController









- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"发帖";
        
        
    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBPostGets];
    self.concreteDatasClass = [Post class];
    for(Post *post in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:post.tid]];
    }
    
    self.allTid = [NSArray arrayWithArray:allTidM];
    NSArray<PostData*> *postDatas = [[AppConfig sharedConfigDB] configDBRecordGets:self.allTid];
    
    PostDataPage *page = [[PostDataPage alloc] init];
    page.page = 0;
    page.section = 0;
    page.sectionTitle = [NSString stringWithFormat:@"共%zd条", postDatas.count];
    page.postDatas = [[NSMutableArray alloc] initWithArray:postDatas];
    
    [self appendPostDataPage:page andReload:NO];
}


- (Post *)getCollectionOnIndexPath:(NSIndexPath*)indexPath
{
    return self.concreteDatas[indexPath.row];
}


- (void)removeRecordsWithIndexPath:(NSIndexPath*)indexPath
{
    Post *post = [self getCollectionOnIndexPath:indexPath];
    [[AppConfig sharedConfigDB] configDBCollectionRemoveByTidArray:@[[NSNumber numberWithInteger:post.tid]]];
}












@end