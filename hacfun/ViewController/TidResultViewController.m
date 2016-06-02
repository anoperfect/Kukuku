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
    self.postDatasAll = [[AppConfig sharedConfigDB] configDBRecordGets:self.allTid];
}


- (void)assignTidResult:(NSArray<NSNumber*> *)tidResult
{
    _tidResult = [tidResult copy];
}





@end
