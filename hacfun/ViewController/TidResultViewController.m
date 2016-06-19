//
//  TidResultViewController.m
//
//
//  Created by Ben on 16/5/17.
//
//

#import "TidResultViewController.h"
#import "Extension.pch"
#import "AppConfig.h"
@interface TidResultViewController ()




@property (nonatomic, strong) NSArray<NSNumber*> *tidResult;


@end

@implementation TidResultViewController

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.textTopic = @"列表";
        
        
    }
    
    return self;
}


- (void)getLocaleRecords
{
    NSMutableArray *allTidM = [[NSMutableArray alloc] init];
    
    self.concreteDatas = [self.tidResult copy];
    self.concreteDatasClass = [NSNumber class];
    for(NSNumber *tidNumber in self.concreteDatas) {
        [allTidM addObject:tidNumber];
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


- (void)assignTidResult:(NSArray<NSNumber*> *)tidResult
{
    _tidResult = [tidResult copy];
}


- (NSArray*)actionStringsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    PostData *postData = [self postDataOnIndexPath:indexPath];
    NSArray<NSString*> *urlStrings = [postData contentURLStrings];
    postData = nil;
    urlStrings = nil;
    
    NSMutableArray *arrayM = [self actionStringsForRowAtIndexPathStaple:indexPath];
    return [NSArray arrayWithArray:arrayM];
}




@end
