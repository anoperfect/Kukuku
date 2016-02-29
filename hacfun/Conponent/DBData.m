//
//  DBData.m
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import "DBData.h"
#import "FMDB.h"
#import "FuncDefine.h"




@interface DBData ()
@property (strong,nonatomic) FMDatabase *configDataBase ;
@property (strong,nonatomic) FMDatabase *hostDataBase ;

@end

@implementation DBData




- (NSInteger)DBCollectionInsert:(NSDictionary*)infoInsert {
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"collection"];
    NSInteger id;
    //NSInteger threadId;
    long long collectedAt;
    
    NSObject* obj;
    
    obj = [infoInsert objectForKey:@"id"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"id");
        return DB_EXECUTE_ERROR_DATA;
    }
    id = [(NSNumber*)obj integerValue];
    
    obj = [infoInsert objectForKey:@"collectedAt"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"collectedAt");
        return DB_EXECUTE_ERROR_DATA;
    }
    collectedAt = [(NSNumber*)obj longLongValue];
    
    BOOL couldBeReplaced = NO;
    
    if(couldBeReplaced) {
        NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(id, collectedAt) VALUES(%zi,%llu)", tableName, id, collectedAt];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return DB_EXECUTE_ERROR_SQL;
        }
    }
    else {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(id, collectedAt) VALUES(%zi,%llu)", tableName, id, collectedAt];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return DB_EXECUTE_ERROR_SQL;
        }
    }
    
    //insert record.
    //[self DBRecordInsertOrReplace:infoInsert];
    
    return DB_EXECUTE_OK;
}


- (BOOL)DBCollectionDelete:(NSDictionary*)infoDelete {
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"collection"];
    
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@", tableName, [infoDelete objectForKey:@"id"]];
    if(![infoDelete objectForKey:@"id"]) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        NSLog(@"error- delete table %@ FAILED (need info %@).", tableName, @"id");
        return NO;
    }
    
    BOOL executeResult = [self.hostDataBase executeUpdate:delete];
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED (executeUpdate [%@] error).", tableName, delete);
        return NO;
    }
    
    return YES;
}


- (NSArray*)DBCollectionQuery:(NSDictionary*)infoQuery {
    
    NSString *query = [NSString stringWithFormat:@"SELECT collection.id, record.jsonstring FROM collection,record WHERE collection.id = record.id"];
    
    NSObject *obj = [infoQuery objectForKey:@"id"];
    if(obj && [obj isKindOfClass:[NSNumber class]]) {
        query = [NSString stringWithFormat:@"SELECT collection.id, record.jsonstring FROM collection,record WHERE collection.id = %@ AND collection.id = record.id", obj];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSInteger id = [rs intForColumn:@"id"];
        //        NSLog(@"%@", [rs stringForColumn:@"jsonstring"]);
        NSDictionary *dict = @{
                               @"id":[NSNumber numberWithInteger:id],
                               @"jsonstring":[rs stringForColumn:@"jsonstring"]
                               };
        [array addObject:dict];
    }
    NSLog(@"%s count : %zi", __FUNCTION__, [array count]);
    
    return [NSArray arrayWithArray:array];
}









@end
