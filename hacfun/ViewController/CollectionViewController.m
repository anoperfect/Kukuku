//
//  CollectionViewController.m
//  hacfun
//
//  Created by Ben on 15/8/13.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "CollectionViewController.h"
#import "FuncDefine.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "AppConfig.h"



@interface CollectionViewController()


@end

@implementation CollectionViewController




- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"收藏";
        

    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBCollectionGets];
    self.concreteDatasClass = [Collection class];
    for(Collection *collection in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:collection.tid]];
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


- (Collection *)getCollectionOnIndexPath:(NSIndexPath*)indexPath
{
    return self.concreteDatas[indexPath.row];
}


- (void)removeRecordsWithIndexPath:(NSIndexPath*)indexPath
{
    Collection *collection = [self getCollectionOnIndexPath:indexPath];
    [[AppConfig sharedConfigDB] configDBCollectionRemoveByTidArray:@[[NSNumber numberWithInteger:collection.tid]]];
}







@end

@interface DetailRecordViewController()


@end

@implementation DetailRecordViewController




- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"收藏";
        
        
    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [[AppConfig sharedConfigDB] configDBDetailRecordGets];
    self.concreteDatasClass = [DetailRecord class];
    for(DetailRecord *DetailRecord in self.concreteDatas) {
        [allTidM addObject:[NSNumber numberWithInteger:DetailRecord.tid]];
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


- (DetailRecord *)getDetailRecordOnIndexPath:(NSIndexPath*)indexPath
{
    return self.concreteDatas[indexPath.row];
}


- (void)removeRecordsWithIndexPath:(NSIndexPath*)indexPath
{
    DetailRecord *detailrecord = [self getDetailRecordOnIndexPath:indexPath];
    [[AppConfig sharedConfigDB] configDBDetailRecordDelete:detailrecord];
}






@end