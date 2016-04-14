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
#import "AppConfig.h"



@implementation DBColumnValue
@end


@implementation DBTableValue
@end


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





- (BOOL)DBDataDetectTableExist:(FMDatabase *)db withTableName:(NSString*)tableName
{
    BOOL isExist = NO;
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        if(count > 0) {
            isExist = YES;
            break;
        }
    }
    
    return isExist;
}


//各表属性.
- (DBTableValue*)getInitDBTableValue:(FMDatabase*)db withTableName:(NSString*)tableName
{
    if([tableName isEqualToString:@"draft"]) {
        NSMutableArray *columnsm = [[NSMutableArray alloc] init];
        DBColumnValue *column;
        column = [[DBColumnValue alloc] init];
        column.columnName = @"sn";
        column.dataType = DBDataColumnTypeNumberInteger;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = YES;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"content";
        column.dataType = DBDataColumnTypeString;
        column.isNeedForInsert = YES;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"selectedtimes";
        column.dataType = DBDataColumnTypeNumberInteger;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        column.defaultValue = @0;
        [columnsm addObject:column];
        
        DBTableValue *table = [[DBTableValue alloc] init];
        table.tableName = tableName;
        table.columns = [NSArray arrayWithArray:columnsm];
        table.forHost = NO;
        table.primaryKey = nil;//@[@"sn"];
        
        return table;
    }
    
    if([tableName isEqualToString:@"record"]) {
        NSMutableArray *columnsm = [[NSMutableArray alloc] init];
        DBColumnValue *column;
        column = [[DBColumnValue alloc] init];
        column.columnName = @"id";
        column.dataType = DBDataColumnTypeNumberInteger;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"threadId";
        column.dataType = DBDataColumnTypeNumberInteger;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
    
        column = [[DBColumnValue alloc] init];
        column.columnName = @"createdAt";
        column.dataType = DBDataColumnTypeNumberLongLong;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"updatedAt";
        column.dataType = DBDataColumnTypeNumberLongLong;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"jsonstring";
        column.dataType = DBDataColumnTypeString;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"belongTo";
        column.dataType = DBDataColumnTypeNumberInteger;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        DBTableValue *table = [[DBTableValue alloc] init];
        table.tableName = tableName;
        table.columns = [NSArray arrayWithArray:columnsm];
        table.forHost = NO;
        table.primaryKey = @[@"id"];
        
        return table;
    }
    
    if([tableName isEqualToString:@"collection"]) {
        NSMutableArray *columnsm = [[NSMutableArray alloc] init];
        DBColumnValue *column;
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"id";
        column.dataType = DBDataColumnTypeNumberInteger;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        column = [[DBColumnValue alloc] init];
        column.columnName = @"collectedAt";
        column.dataType = DBDataColumnTypeNumberLongLong;
        column.isNeedForInsert = NO;
        column.isAutoIncrement = NO;
        [columnsm addObject:column];
        
        DBTableValue *table = [[DBTableValue alloc] init];
        table.tableName = tableName;
        table.columns = [NSArray arrayWithArray:columnsm];
        table.forHost = NO;
        table.primaryKey = @[@"id"];
        
        return table;
    }
    
    return nil;
}





//创建.
- (NSInteger)DBDataCreateTable:(FMDatabase*)db tableName:(NSString*)tableName
{
    LOG_POSTION
    //需替换为检查列信息.
    if([self DBDataDetectTableExist:db withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return DB_EXECUTE_OK;
    }
    
    DBTableValue *table = [self getInitDBTableValue:db withTableName:tableName];
    NSString *createTableSQLString = [self generateCreateSQLWithTableValue:table];
    BOOL executeResult = [db executeUpdate:createTableSQLString];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED \n%@\n", tableName, createTableSQLString);
        return DB_EXECUTE_ERROR_SQL;
    }
    
    return DB_EXECUTE_OK;
}


//增
- (NSInteger)DBDataInsert:(FMDatabase*)db toTable:(NSString*)tableName withInfo:(NSDictionary*)infoInsert countReplace:(BOOL)couldReplace
{
    LOG_POSTION
    NSArray *infoInsertColumnNames = infoInsert.allKeys;
    NSArray *infoInsertValues = infoInsert.allValues;
    
#if 0 //暂时不加检测.
    //根据tableName查找table信息.
    DBTableValue *table = [self getDBTableValueByTableName:tableName];
    
    //获取insert时的必须填写字段.
    for(DBColumnValue *column in table.columns) {
        if(column.isNeedForInsert) {
            NSObject* obj = [infoInsert objectForKey:column.columnName];
            if(!(obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]))) {
                NSLog(@"error- insert table %@ FAILED (need value %@).", tableName, column.columnName);
                return DB_EXECUTE_ERROR_DATA;
            }
        }
    }
    
    //检查infoInsert中是否含该地段, 同时进行类型检查.
    for(NSString *key in infoInsertColumnNames) {
        NSInteger index = [key indexOfAccessibilityElement:table.columns];
        if(index != NSNotFound) {
            
        }
        else {
            NSLog(@"error- insert table %@ FAILED (column not exist %@).", tableName, key);
            return DB_EXECUTE_ERROR_DATA;
        }
    }
#endif
    
    //获取insert信息值. 组成sql语句.
    //执行.
    NSString *insert = [NSString stringWithFormat:@"INSERT %@ INTO %@(%@) VALUES(%@)",
                        couldReplace?@"OR REPLACE":@"",
                        tableName,
                        [FuncDefine stringsCombine:infoInsertColumnNames withConnector:@","],
                        [FuncDefine stringPaste:@"?" onTimes:infoInsertColumnNames.count withConnector:@","]
                        ];
    
    BOOL executeResult = [db executeUpdate:insert withArgumentsInArray:infoInsertValues];
    if(executeResult) {
        NSLog(@"insert table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
        return DB_EXECUTE_ERROR_SQL;
    }
    
    return DB_EXECUTE_OK;
}


//删
- (NSInteger)DBDataDelete:(FMDatabase*)db toTable:(NSString*)tableName withInfo:(NSDictionary*)infoDelete
{
    NSMutableString *deletem ;
    BOOL executeResult ;
    if(!infoDelete) {
        deletem = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
        executeResult = [db executeUpdate:[NSString stringWithString:deletem]];
    }
    else {
        NSArray *infoDeleteKeys = infoDelete.allKeys;
        NSArray *infoDeleteValues = infoDelete.allValues;
        deletem = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", tableName, infoDeleteKeys[0]];
        NSInteger count = infoDeleteKeys.count;
        for(NSInteger index = 1; index < count; index ++) {
            [deletem appendFormat:@" and %@ = ?", infoDeleteKeys[index]];
        }
        executeResult = [db executeUpdate:[NSString stringWithString:deletem] withArgumentsInArray:infoDeleteValues];
    }
    
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED (executeUpdate [%@] error).", tableName, deletem);
        return DB_EXECUTE_ERROR_SQL;
    }
    
    return DB_EXECUTE_OK;
}


//查
- (NSArray*)DBDataQuery:(FMDatabase*)db toTable:(NSString*)tableName withInfo:(NSDictionary*)infoQuery1
{
    //获取表信息.
    DBTableValue *table = [self getInitDBTableValue:db withTableName:tableName];
    NSMutableString *querym ;
    NSMutableArray *queryResultm = [[NSMutableArray alloc] init];
    
    NSString *orderQueryString = nil;
    NSMutableDictionary *infoQueryUsing = [NSMutableDictionary dictionaryWithDictionary:infoQuery1];
    orderQueryString = [infoQueryUsing objectForKey:@"orderString"];
    if(orderQueryString) {
        [infoQueryUsing removeObjectForKey:@"orderString"];
    }
    
    FMResultSet *rs ;
    if(0 == infoQueryUsing.count) {
        querym = [NSMutableString stringWithFormat:@"SELECT *%@ FROM %@", table.primaryKey.count==0?@",rowid":@"", tableName];
        //table.primaryKey.count==0?@",row":@""用于在主键缺省的时候使用隐藏主键rowid.
        [querym appendFormat:@" %@", orderQueryString?orderQueryString:@""];
        rs = [db executeQuery:[NSString stringWithString:querym]];
        NSLog(@"query string : %@", querym);
    }
    else {
        NSArray *infoQueryKeys = infoQueryUsing.allKeys;
        NSArray *infoQueryValues = infoQueryUsing.allValues;
        NSMutableArray *infoQueryPrameterm = [[NSMutableArray alloc] init];
        
        querym = [NSMutableString stringWithFormat:@"SELECT rowid,* FROM %@ WHERE", tableName];
        for(NSInteger index = 0; index < infoQueryKeys.count; index++) {
            if(index > 0) {
                [querym appendString:@" and"];
            }
            
            if([infoQueryValues[index] isKindOfClass:[NSArray class]]) {
//                [querym appendFormat:@" %@ in (?)", infoQueryKeys[index]];
//                [infoQueryPrameterm addObject:@"6624990, 6678673, 6686117, 6688224]"];
                [querym appendFormat:@" %@ IN (%@)", infoQueryKeys[index], @"6624990, 6678673, 6686117, 6688224"];
            }
            else {
                [querym appendFormat:@" %@ = ?", infoQueryKeys[index]];
                [infoQueryPrameterm addObject:infoQueryValues];
            }
        }
        
#if 0
        querym = [NSMutableString stringWithFormat:@"SELECT *%@ FROM %@ WHERE %@ = ?", tableName, table.primaryKey.count==0?@",rowid":@"", infoQueryKeys[0]];
        NSInteger count = infoQueryKeys.count;
        for(NSInteger index = 1; index < count; index ++) {
            [querym appendFormat:@" and %@ = ?", infoQueryKeys[index]];
        }
        
        rs = [db executeQuery:[NSString stringWithString:querym] withArgumentsInArray:infoQueryValues];
#endif
        
        [querym appendFormat:@" %@", orderQueryString?orderQueryString:@""];
        NSLog(@"query string : %@", querym);
        rs = [db executeQuery:[NSString stringWithString:querym] withArgumentsInArray:infoQueryPrameterm];
    }
    
    while ([rs next]) {
        NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
        dictm[@"rowid"] = [NSNumber numberWithInteger:[rs intForColumn:@"rowid"]];
        for(DBColumnValue *column in table.columns) {
            switch (column.dataType) {
                case DBDataColumnTypeNumberInteger:
                    dictm[column.columnName] = [NSNumber numberWithInteger:[rs intForColumn:column.columnName]];
                    break;
                    
                case DBDataColumnTypeNumberLongLong:
                    dictm[column.columnName] = [NSNumber numberWithLongLong:[rs longLongIntForColumn:column.columnName]];
                    break;
                    
                case DBDataColumnTypeString:
                    dictm[column.columnName] = [rs stringForColumn:column.columnName];
                    break;
                    
                default:
                    NSLog(@"#error - not expected default value(%zd)", column.dataType);
                    break;
            }
        }
        
        [queryResultm addObject:dictm];
    }
    NSLog(@"%s count : %zi", __FUNCTION__, [queryResultm count]);
    
    return [NSArray arrayWithArray:queryResultm];
 
#if 0
    //默认按照最新收藏的放最前面.
    NSString *query = [NSString stringWithFormat:@"SELECT collection.id, collection.collectedAt, record.jsonstring FROM collection,record WHERE collection.id = record.id ORDER BY collection.collectedAt DESC"]; //ASC
    
    NSObject *obj = [infoQuery objectForKey:@"id"];
    if(obj && [obj isKindOfClass:[NSNumber class]]) {
        query = [NSString stringWithFormat:@"SELECT collection.id, record.jsonstring FROM collection,record WHERE collection.id = %@ AND collection.id = record.id", obj];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSInteger id = [rs intForColumn:@"id"];
        long long collectedAt = [rs longLongIntForColumn:@"collectedAt"];
        NSDictionary *dict = @{
                               @"id":[NSNumber numberWithInteger:id],
                               @"collectedAt":[NSNumber numberWithLongLong:collectedAt],
                               @"jsonstring":[rs stringForColumn:@"jsonstring"]
                               };
        [array addObject:dict];
    }
    NSLog(@"%s count : %zi", __FUNCTION__, [array count]);
    
    return [NSArray arrayWithArray:array];
#endif
}


//改. 暂时不实现.
//删. 暂时不实现.






- (NSString*)columnTypeToString:(DBDataColumnType)type
{
    switch (type) {
        case DBDataColumnTypeNumberInteger:
            return @"integer";
            break;
            
        case DBDataColumnTypeNumberLongLong:
            return @"longlong";
            break;
            
        case DBDataColumnTypeString:
            return @"var";
            break;
            
        default:
            return @"var";
            break;
    }
    
    return @"var";
}


- (NSString*)generateCreateSQLWithTableValue:(DBTableValue*)table
{
    NSMutableString *strm = [NSMutableString stringWithFormat:@"create table if not exists %@(", table.tableName];
    NSInteger count = table.columns.count;
    for(NSInteger index = 0; index < count ; index ++) {
        if(index > 0) {
            [strm appendFormat:@", "];
        }
        
        DBColumnValue *column = table.columns[index];
        [strm appendFormat:@"%@ %@", column.columnName, [self columnTypeToString:column.dataType]];
        
        if(index == (count - 1)) {
            [strm appendFormat:@")"];
        }
    }
    
    return [NSString stringWithString:strm];
}


@end
