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



@implementation DBColumnAttribute
- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ description not implemente", [self class]];
}
@end


@implementation DBTableAttribute
- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ description not implemente", [self class]];
}
@end


@interface DBData ()

@property (atomic, strong) NSMutableDictionary *dataBases; //name:db


@end

@implementation DBData


- (BOOL)DBDataDetectTableExist:(FMDatabase *)db withTableName:(NSString*)tableName
{
    BOOL isExist = NO;
    FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as 'count' FROM sqlite_master WHERE type ='table' AND name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        if(count > 0) {
            isExist = YES;
            break;
        }
    }
    [rs close];
    return isExist;
}


- (DBTableAttribute*)getDBTableAttribute:(NSString*)databaseName withTableName:(NSString*)tableName
{
    NSLog(@"self.tableAttributess.count : %zd", self.tableAttributes.count);
    
    for(DBTableAttribute *tableAttribute in self.tableAttributes) {
        if([tableAttribute.tableName isEqualToString:tableName]) {
            if([tableAttribute.databaseNames indexOfObject:databaseName] != NSNotFound) {
                NSLog(@"<%@ : %@> table value found.", databaseName, tableName);
                return tableAttribute;
            }
            else {
                NSLog(@"#error - <%@ : %@> table value not found.", databaseName, tableName);
            }
        }
    }
    
    return nil;
}


- (DBColumnAttribute*)getDBColumnAttributeFromTableAttribute:(DBTableAttribute*)tableAttributes withColumnName:(NSString*)columnName
{
    for(DBColumnAttribute *columnAttribute in tableAttributes.columnAttributes) {
        if([columnAttribute.columnName isEqualToString:columnName]) {
            return columnAttribute;
        }
    }
    
    return nil;
}


-(NSArray*)getColumnNamesFromTableAttribute:(DBTableAttribute*)tableAttributes
{
    NSMutableArray *columnNamesM = [[NSMutableArray alloc] init];
    for(DBColumnAttribute *columnAttribute in tableAttributes.columnAttributes) {
        [columnNamesM addObject:columnAttribute.columnName];
    }
    
    return [NSArray arrayWithArray:columnNamesM];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableAttributes = [[NSMutableArray alloc] init];
        self.dataBases = [[NSMutableDictionary alloc] init];
        
        DISPATCH_ONCE_START
        //测试阶段一直删除重建数据库.
        BOOL rebuildDB = NO;
        if(rebuildDB) {
            NSString *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *folder = [NSString stringWithFormat:@"%@/%@", documentPath, @"sqlite"];
            NSLog(@"#error - delete database folder.");
            [[NSFileManager defaultManager] removeItemAtPath:folder error:nil];
        }
        DISPATCH_ONCE_FINISH
    }
    return self;
}







//增
- (NSInteger)DBDataInsert:(FMDatabase*)db toTable:(DBTableAttribute*)tableAttribute withInfo:(NSDictionary*)infoInsert countReplace:(BOOL)couldReplace
{
    //检查infoInsert.
    //检查columnNames.
    NSArray *columnNames = [infoInsert objectForKey:DBDATA_STRING_COLUMNS];
    BOOL columnNamesChecked = YES;
    if(columnNames && [columnNames isKindOfClass:[NSArray class]]) {
        for(NSString *columnName in columnNames) {
            if([columnName isKindOfClass:[NSString class]]) {
                
            }
            else {
                NSLog(@"#error - columnName (%@) is not string.", columnName);
                columnNamesChecked = NO;
                break;
            }
        }
    }
    else {
        NSLog(@"#error - %@ (%@) is not columnName array.", DBDATA_STRING_COLUMNS, columnNames);
        columnNamesChecked = NO;
    }
    
    if(!columnNamesChecked) {
        NSLog(@"#error - %@ check error. (%@).", DBDATA_STRING_COLUMNS, columnNames);
        return DB_EXECUTE_ERROR_DATA;
    }
    
    //检查values.
    NSArray *values = [infoInsert objectForKey:DBDATA_STRING_VALUES];
    BOOL valuesChecked = YES;
    if(values && [values isKindOfClass:[NSArray class]]) {
        for(NSArray *value in values) {
            if([value isKindOfClass:[NSArray class]]) {
                NSInteger countValue = value.count;
                //＃检查value值个数和属性是否跟对应的ColumnAttribute匹配.
                if(countValue != columnNames.count) {
                    NSLog(@"#error - value count is not fit to %@ count.", DBDATA_STRING_COLUMNS);
                    valuesChecked = NO;
                    break;
                }
                
                for(NSInteger index = 0; index < countValue; index ++) {
                    DBColumnAttribute *columnAttribute = [self getDBColumnAttributeFromTableAttribute:tableAttribute withColumnName:columnNames[index]];
                    if(columnAttribute) {
                        if(columnAttribute.dataType == DBDataColumnTypeNumberInteger || columnAttribute.dataType == DBDataColumnTypeNumberLongLong) {
                            if([value[index] isKindOfClass:[NSNumber class]]) {
                                
                            }
                            else {
                                NSLog(@"#error - columnName (%@) value type not checked.", columnNames[index]);
                                valuesChecked = NO;
                                break;
                            }
                        }
                        else if(columnAttribute.dataType == DBDataColumnTypeString) {
                            if([value[index] isKindOfClass:[NSString class]]) {
                                
                            }
                            else {
                                NSLog(@"#error - columnName (%@) value type not checked.", columnNames[index]);
                                valuesChecked = NO;
                                break;
                            }
                        }
                    }
                    else {
                        NSLog(@"#error - columnName (%@) not found.", columnNames[index]);
                        valuesChecked = NO;
                        break;
                    }
                }
                
                if(!valuesChecked) {
                    break;
                }
                
            }
            else {
                NSLog(@"#error - value (%@) is not array.", value);
                valuesChecked = NO;
                break;
                
            }
        }
    }
    else {
        NSLog(@"#error - %@ (%@) is not values array.", DBDATA_STRING_VALUES, values);
        valuesChecked = NO;
    }
    
    if(!valuesChecked) {
        NSLog(@"#error - %@ check error. (%@).", DBDATA_STRING_VALUES, values);
        return DB_EXECUTE_ERROR_DATA;
    }
    
    NSLog(@"infoInsert checked OK.");
    
    NSMutableArray *infoInsertValuesM = [[NSMutableArray alloc] init];
    
    //获取insert信息值. 组成sql语句.
    //执行.
    NSMutableString *insert = [NSMutableString stringWithFormat:@"INSERT %@ INTO %@(%@) VALUES ",
                        couldReplace?@"OR REPLACE":@"",
                        tableAttribute.tableName,
                        [NSString stringsCombine:columnNames withConnector:@","]
                        ];
    
    
    NSInteger countOfValues = values.count;
    BOOL addJoiner = NO;
    for(NSArray *value in values) {
        //执行语句.
        if(addJoiner) {
            [insert appendString:@", "];
        }
        [insert appendFormat:@"(%@)", [NSString stringPaste:@"?" onTimes:columnNames.count withConnector:@","]];
        
        //?对应的参数.
        [infoInsertValuesM addObjectsFromArray:value];
        
         addJoiner = YES;
    }
    
    BOOL executeResult = [db executeUpdate:insert withArgumentsInArray:infoInsertValuesM];
    if(executeResult) {
        NSLog(@"insert table %@ [%zd] OK.", tableAttribute.tableName, countOfValues);
    }
    else {
        NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableAttribute.tableName, insert);
        return DB_EXECUTE_ERROR_SQL;
    }
    
    return DB_EXECUTE_OK;
}


//增
- (NSInteger)DBDataInsertDBName:(NSString*)databaseName toTable:(NSString*)tableName withInfo:(NSDictionary*)infoInsert countReplace:(BOOL)couldReplace
{
    if(![NSThread isMainThread]) {NSLog(@"#error - should excute db in MainThread.");}
    
    
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@>", databaseName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find database <%@>", databaseName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    return [self DBDataInsert:db toTable:tableAttribute withInfo:infoInsert countReplace:couldReplace];
}







//删
- (NSInteger)DBDataDelete:(FMDatabase*)db toTable:(DBTableAttribute*)tableAttribute withQuery:(NSDictionary*)infoQuery
{
    NSMutableString *deletem ;
    BOOL executeResult ;
    
#if 0
    if(!infoQuery) {
        deletem = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableAttribute.tableName];
        executeResult = [db executeUpdate:[NSString stringWithString:deletem]];
    }
    else {
        NSArray *infoDeleteKeys = infoQuery.allKeys;
        NSArray *infoDeleteValues = infoQuery.allValues;
        //只支持一个条件的简单query语句.
        deletem = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", tableAttribute.tableName, infoDeleteKeys[0]];
        NSInteger count = infoDeleteKeys.count;
        for(NSInteger index = 1; index < count; index ++) {
            [deletem appendFormat:@" and %@ = ?", infoDeleteKeys[index]];
        }
        executeResult = [db executeUpdate:[NSString stringWithString:deletem] withArgumentsInArray:infoDeleteValues];
        
        NSLog(@"%@", deletem);
        NSLog(@"%@", infoDeleteValues);
    }
#endif
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    NSString *queryString = [self DBDataGenerateQueryString:infoQuery andArgumentsInArray:arguments];
    executeResult = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ %@", tableAttribute.tableName, queryString] withArgumentsInArray:arguments];
    
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableAttribute.tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED (executeUpdate [%@] error).", tableAttribute.tableName, deletem);
        return DB_EXECUTE_ERROR_SQL;
    }
    
    return DB_EXECUTE_OK;
}


//删
- (NSInteger)DBDataDeleteDBName:(NSString*)databaseName toTable:(NSString*)tableName withQuery:(NSDictionary*)infoQuery
{
    if(![NSThread isMainThread]) {NSLog(@"#error - should excute db in MainThread.");}
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@>", databaseName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find database <%@>", databaseName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    return [self DBDataDelete:db toTable:tableAttribute withQuery:infoQuery];
}


- (NSString*)DBDataGenerateQueryString:(NSDictionary*)infoQuery andArgumentsInArray:(NSMutableArray*)argumentsM
{
    NSMutableString *strm ;
    
    if(0 == infoQuery.count) {
        strm = [NSMutableString stringWithString:@" "];
    }
    else {
        NSArray *infoQueryKeys = infoQuery.allKeys;
        NSArray *infoQueryValues = infoQuery.allValues;
        
        strm = [NSMutableString stringWithString:@" WHERE"];

        for(NSInteger index = 0; index < infoQueryKeys.count; index++) {
            if(index > 0) {
                [strm appendString:@" and"];
            }
            
            if([infoQueryValues[index] isKindOfClass:[NSArray class]]) {
                NSArray *columnValues = infoQueryValues[index];
                [strm appendFormat:@" %@ IN (%@)",
                 infoQueryKeys[index],
                 [NSString stringPaste:@"?" onTimes:columnValues.count withConnector:@","]];
                [argumentsM addObjectsFromArray:columnValues];
            }
            else {
                //
                [strm appendFormat:@" %@ = ?", infoQueryKeys[index]];
                [argumentsM addObject:infoQueryValues[index]];
            }
        }
    }
    
    return [NSString stringWithString:strm];
}






//查

/*
 columnNames : 获取的column名字. 为nil时则查询时使用SELECT *.
 infoQuery : 格式为.
            {@"column1string":"value1string", @"column2number":@10086}
        或者 {@"column1string":"value1string", @"column2number":@10086, @"column3string":["value1string","value1string"]}
        可为nil
 infoLimit : 支持 DBDATA_STRING_ORDER:"ORDER BY ... DESC"
 */
- (NSDictionary*)DBDataQuery:(FMDatabase*)db
                toTable:(DBTableAttribute*)tableAttribute
            columnNames:(NSArray*)columnNames
              withQuery:(NSDictionary*)infoQuery1
              withLimit:(NSDictionary*)infoLimit1
{
    if(![NSThread isMainThread]) {NSLog(@"#error - should excute db in MainThread.");}
    //获取表信息.
    NSLog(@"table :%@ , name:%@, %zd.", tableAttribute, tableAttribute.tableName, tableAttribute.primaryKeys.count);
    NSMutableString *querym ;
    NSMutableDictionary *queryResultm = [[NSMutableDictionary alloc] init];
    NSMutableArray *queryColumnsNamesM = [[NSMutableArray alloc] init];
    
    if(!columnNames) {
        [queryColumnsNamesM addObjectsFromArray:[self getColumnNamesFromTableAttribute:tableAttribute]];
        //tableAttribute.primaryKey.count==0?@",row":@""用于在主键缺省的时候使用隐藏主键rowid.
        if(tableAttribute.primaryKeys.count==0) {
            columnNames = @[@"*, rowid"];
            [queryColumnsNamesM addObject:@"rowid"];
        }
        else {
            columnNames = @[@"*"];
        }
    }
    else {
        [queryColumnsNamesM addObjectsFromArray:columnNames];
    }
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    NSString *queryString = [self DBDataGenerateQueryString:infoQuery1 andArgumentsInArray:arguments];
    
    querym = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@ %@",
              [NSString combineArray:columnNames withInterval:@", " andPrefix:@"" andSuffix:@""],
              tableAttribute.tableName,
              queryString];
    
    if([infoLimit1 objectForKey:DBDATA_STRING_ORDER]) {
        [querym appendFormat:@" %@", [infoLimit1 objectForKey:DBDATA_STRING_ORDER]];
    }
    
    NSLog(@"query string : [%@]", querym);
    NSLog(@"query parameterm : [%@]", arguments);
    FMResultSet *rs = [db executeQuery:[NSString stringWithString:querym] withArgumentsInArray:arguments];
    
    for(NSString *columnName in queryColumnsNamesM) {
        [queryResultm setObject:[[NSMutableArray alloc] init] forKey:columnName];
    }
    
    NSInteger rsRows = 0;
    BOOL parseOK = YES;
    while ([rs next]) {
        BOOL parseOK = YES;
        
        for(NSString *columnName in queryColumnsNamesM) {
            if(!parseOK) {
                break;
            }
            
            NSMutableArray *columnValues = [queryResultm objectForKey:columnName];
            if([columnName isEqualToString:@"rowid"]) {
                [columnValues addObject:[NSNumber numberWithInteger:[rs intForColumn:@"rowid"]]];
            }
            else {
                DBColumnAttribute *columnAttribute = [self getDBColumnAttributeFromTableAttribute:tableAttribute withColumnName:columnName];
                if(!columnAttribute) {
                    NSLog(@"#error - [table : %@] can not find column (%@).",  tableAttribute.tableName, columnName);
                    return nil;
                }
                
                switch (columnAttribute.dataType) {
                    case DBDataColumnTypeNumberInteger:
                        [columnValues addObject:[NSNumber numberWithInteger:[rs intForColumn:columnAttribute.columnName]]];
                        break;
                        
                    case DBDataColumnTypeNumberLongLong:
                        [columnValues addObject:[NSNumber numberWithLongLong:[rs longLongIntForColumn:columnAttribute.columnName]]];
                        break;
                        
                    case DBDataColumnTypeString:
                        [columnValues addObject:[rs stringForColumn:columnAttribute.columnName]];
                        break;
                        
                    default:
                        NSLog(@"#error - not expected default value(%zd)", columnAttribute.dataType);
                        parseOK = NO;
                        break;
                }
            }
            
        }
        
        if(!parseOK) {
            break;
        }
        
        rsRows ++;
    }
    
    [rs close];
    
    if(!parseOK) {
        NSLog(@"#error - column value parse FAILED.");
        return nil;
    }
    else if(rsRows == 0) {
        NSLog(@"query result NONE.");
        return nil;
    }
    
    NSInteger countValues = 0;
    
    for(NSString *columnName in queryColumnsNamesM) {
        NSMutableArray *columnValues = [queryResultm objectForKey:columnName];
        [queryResultm setObject:[NSArray arrayWithArray:columnValues] forKey:columnName];
        
        if(countValues == 0) {
            countValues = columnValues.count;
        }
        else {
            if(countValues != columnValues.count) {
                NSLog(@"#error - count of values not fit.");
                return nil;
            }
        }
    }
    
    //查询结果为0时, 返回nil.
    NSLog(@"query result count : %zd", countValues);
    if(countValues == 0) {
        NSLog(@"query result count 0, return nil");
        return nil;
    }
    
    return [NSDictionary dictionaryWithDictionary:queryResultm];
}


//查
- (NSDictionary*)DBDataQueryDBName:(NSString*)databaseName
                           toTable:(NSString*)tableName
                       columnNames:(NSArray*)columnNames
                         withQuery:(NSDictionary*)infoQuery
                         withLimit:(NSDictionary*)infoLimit
{
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@ : %@>", databaseName, tableName);
        return nil;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find table <%@ : %@>", databaseName, tableName);
        return nil;
    }
    
    return [self DBDataQuery:db toTable:tableAttribute columnNames:columnNames withQuery:infoQuery withLimit:infoLimit];
}


//改. 暂时不实现.
- (NSInteger)DBDataUpdate:(FMDatabase*)db toTable:(DBTableAttribute*)tableAttribute withInfoUpdate:(NSDictionary*)infoUpdate withInfoQuery:(NSDictionary*)infoQuery
{
    NSMutableString *updatem = nil;
    BOOL retFMDB;

    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSArray *infoUpdateKeys = infoUpdate.allKeys;
    NSArray *infoUpdateValues = infoUpdate.allValues;
    
    updatem = [NSMutableString stringWithFormat:@"UPDATE %@ set ", tableAttribute.tableName];
    
    for(NSInteger index = 0; index < infoUpdateKeys.count; index++) {
        if(index > 0) {
            [updatem appendString:@", "];
        }
        
        [updatem appendFormat:@"%@ = ? ", infoUpdateKeys[index]];
        [arguments addObject:infoUpdateValues[index]];
    }
    
    NSString *queryString = [self DBDataGenerateQueryString:infoQuery andArgumentsInArray:arguments];
    [updatem appendString:queryString];
    
    NSLog(@"query string : [%@]", updatem);
    NSLog(@"query parameterm : [%@]", arguments);
    
    retFMDB = [db executeUpdate:updatem withArgumentsInArray:arguments];
    if(retFMDB) {
        
    }
    else {
        NSLog(@"#error - DBDataUpdate failed.");
        return DB_EXECUTE_ERROR_DATA;
    }
    
    return DB_EXECUTE_OK;
}


- (NSInteger)DBDataUpdateDBName:(NSString*)databaseName toTable:(NSString*)tableName withInfoUpdate:(NSDictionary*)infoUpdate withInfoQuery:(NSDictionary*)infoQuery
{
    if(![NSThread isMainThread]) {NSLog(@"#error - should excute db in MainThread.");}
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@ : %@>", databaseName, tableName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find table <%@ : %@>", databaseName, tableName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    return [self DBDataUpdate:db toTable:tableAttribute withInfoUpdate:infoUpdate withInfoQuery:infoQuery];
}






- (NSInteger)DBDataUpdateAdd1:(FMDatabase*)db toTable:(DBTableAttribute*)tableAttribute withColumnName:(NSString*)columnName withInfoQuery:(NSDictionary*)infoQuery
{
    NSMutableString *updatem = nil;
    BOOL retFMDB;
    
    updatem = [NSMutableString stringWithFormat:@"UPDATE %@ SET %@ = %@+1 ", tableAttribute.tableName, columnName, columnName];
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    NSString *queryString = [self DBDataGenerateQueryString:infoQuery andArgumentsInArray:arguments];
    [updatem appendString:queryString];
    
    NSLog(@"query string : [%@]", updatem);
    NSLog(@"query parameterm : [%@]", arguments);
    retFMDB = [db executeUpdate:updatem withArgumentsInArray:arguments];
    if(retFMDB) {
        
    }
    else {
        NSLog(@"#error - DBDataUpdateAdd1 failed.");
        return DB_EXECUTE_ERROR_DATA;
    }
    
    return DB_EXECUTE_OK;
}


- (NSInteger)DBDataUpdateAdd1DBName:(NSString*)databaseName toTable:(NSString*)tableName withColumnName:(NSString*)columnName withInfoQuery:(NSDictionary*)infoQuery
{
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@ : %@>", databaseName, tableName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find table <%@ : %@>", databaseName, tableName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    return [self DBDataUpdateAdd1:db toTable:tableAttribute withColumnName:columnName withInfoQuery:infoQuery];
}




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


- (DBDataColumnType)columnTypeFromString:(NSString*)typeString
{
    DBDataColumnType type = NSNotFound;
    
    if([typeString isEqualToString:@"integer"]) {
        type = DBDataColumnTypeNumberInteger;
    }
    else if([typeString isEqualToString:@"longlong"]) {
        type = DBDataColumnTypeNumberLongLong;
    }
    else if([typeString isEqualToString:@"var"]) {
        type = DBDataColumnTypeString;
    }
    
    return type;
}





- (NSString*)generateCreateSQLWithTableValue:(DBTableAttribute*)tableAttribute
{
    NSMutableString *strm = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", tableAttribute.tableName];
    NSInteger count = tableAttribute.columnAttributes.count;
    for(NSInteger index = 0; index < count ; index ++) {
        if(index > 0) {
            [strm appendFormat:@", "];
        }
        
        DBColumnAttribute *columnAttribute = tableAttribute.columnAttributes[index];
        [strm appendFormat:@"%@ %@", columnAttribute.columnName, [self columnTypeToString:columnAttribute.dataType]];
        
        if(index == (count - 1)) {
            [strm appendFormat:@")"];
        }
    }
    
    return [NSString stringWithString:strm];
}







- (void)buildByJsonData:(NSData*)data
{
    NSDictionary *dict;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"obj : %@", obj);
    
    if(!obj || ![obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"#error :");sleep(100);
        return;
    }
    
    NSLog(@"version : %@", [obj objectForKey:@"version"]);
    
    obj = [obj objectForKey:@"tables"];
    if(!obj || ![obj isKindOfClass:[NSArray class]]) {
        NSLog(@"#error :");sleep(100);
        return;
    }
    
    NSArray *arrayTable = obj;
    for(obj in arrayTable) {
        if(!obj || ![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"#error :");sleep(100);
            return;
        }
        
        dict = obj;
        
        DBTableAttribute *tableAttribute = [self DBTableAttributeFromDict:dict];
        if(!tableAttribute) {
            NSLog(@"#error :");sleep(100);
        }
        
        NS0Log(@"table : %@, tableName : %@, databaseNames : %@",table, tableAttribute.tableName, tableAttribute.databaseNames);
        [self.tableAttributes addObject:tableAttribute];
        
        //detect , checked / add / update .
        [self buildTable:tableAttribute];
    }
}


- (DBTableAttribute*)DBTableAttributeFromDict:(NSDictionary*)dict
{
    DBTableAttribute *tableAttribute = [[DBTableAttribute alloc] init];
    
    NSString *tableName         = [dict objectForKey:@"tableName"];
    NSArray *databaseNames      = [dict objectForKey:@"databaseNames"];
    NSArray *columnAttributes   = [dict objectForKey:@"columnAttributes"];
    NSArray *primaryKeys        = [dict objectForKey:@"primaryKeys"];
    NSArray *preset             = [dict objectForKey:@"preset"];
    NSString *comment           = [dict objectForKey:@"comment"];
    
    if([tableName           isKindOfClass:[NSString class]] &&
       [databaseNames       isKindOfClass:[NSArray class]]  &&
       [columnAttributes    isKindOfClass:[NSArray class]]  &&
       [primaryKeys         isKindOfClass:[NSArray class]]  &&
       [preset              isKindOfClass:[NSArray class]]  &&
       [comment             isKindOfClass:[NSString class]]) {
        NS0Log(@"checked");
        
        NSMutableArray *columnAttributesM = [[NSMutableArray alloc] init];
        for (NSDictionary *dictColumnAttribute in columnAttributes) {
            if(![dictColumnAttribute isKindOfClass:[NSDictionary class]]) {
                NSLog(@"#error-");sleep(100);
                return nil;
            }
            
            DBColumnAttribute *columnAttribute = [self DBColumnAttributeFromDict:dictColumnAttribute];
            if(!columnAttribute) {
                NSLog(@"#error-");sleep(100);
                return nil;
            }
            
            [columnAttributesM addObject:columnAttribute];
        }
        
        tableAttribute.tableName         = tableName;
        tableAttribute.databaseNames     = databaseNames;
        tableAttribute.columnAttributes  = [NSArray arrayWithArray:columnAttributesM];
        tableAttribute.primaryKeys       = primaryKeys;
        tableAttribute.preset            = preset;// [NSArray arrayWithArray:presetm];
        tableAttribute.comment           = comment;
    }
    else {
        NSLog(@"#error- %@[%d %d %d %d %d %d]",
              dict,
              [tableName           isKindOfClass:[NSString class]],
              [databaseNames       isKindOfClass:[NSArray class]],
              [columnAttributes    isKindOfClass:[NSArray class]],
              [primaryKeys         isKindOfClass:[NSArray class]],
              [preset              isKindOfClass:[NSArray class]],
              [comment             isKindOfClass:[NSString class]]
              
              
              
              );
        sleep(100);
        return nil;
    }
    
    return tableAttribute;
}


- (DBColumnAttribute*)DBColumnAttributeFromDict:(NSDictionary*)dict
{
    DBColumnAttribute *columnAttribute = [[DBColumnAttribute alloc] init];
    
    NSString    *columnName             = [dict objectForKey:@"columnName"];
    NSString    *dataTypeString         = [dict objectForKey:@"dataType"];
    NSNumber    *isNeedForInsertNumber  = [dict objectForKey:@"isNeedForInsert"];
    NSNumber    *isAutoIncrementNumber  = [dict objectForKey:@"isAutoIncrement"];
    id          defaultValue            = [dict objectForKey:@"defaultValue"];
    
    //NSLog(@"%@", dict);
    
    //if([columnName isKindOfClass:[NSString class]]){NSLog(@"checked");}else {NSLog(@"#error-");}
    //if(  [dataTypeString isKindOfClass:[NSString class]]){NSLog(@"checked");}else {NSLog(@"#error-");}
    //if(  [isNeedForInsertNumber isKindOfClass:[NSNumber class]]){NSLog(@"checked");}else {NSLog(@"#error-");}
    //if(  [isAutoIncrementNumber isKindOfClass:[NSNumber class]]){NSLog(@"checked");}else {NSLog(@"#error-");}
    //if(   ([defaultValue isKindOfClass:[NSString class]] || [defaultValue isKindOfClass:[NSNumber class]])){NSLog(@"checked");}else {NSLog(@"#error-");}

    if([columnName isKindOfClass:[NSString class]] &&
       [dataTypeString isKindOfClass:[NSString class]] &&
       [isNeedForInsertNumber isKindOfClass:[NSNumber class]] &&
       [isAutoIncrementNumber isKindOfClass:[NSNumber class]] &&
       ([defaultValue isKindOfClass:[NSString class]] || [defaultValue isKindOfClass:[NSNumber class]])){
        
        columnAttribute.columnName          = columnName;
        columnAttribute.dataType            = [self columnTypeFromString:dataTypeString];
        columnAttribute.isNeedForInsert     = [isNeedForInsertNumber boolValue];
        columnAttribute.isAutoIncrement     = [isAutoIncrementNumber boolValue];
        columnAttribute.defaultValue        = defaultValue;
    }
    else {
        NSLog(@"#error-");
        sleep(100);
        return nil;
    }
    
    return columnAttribute;
}


- (id)getDataBaseByName:(NSString*)databaseName
{
    NSString *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", documentPath, @"sqlite"];
    
    NS0Log(@"[%@] getDataBaseByName. dict = %@", databaseName, self.dataBases);
    
    FMDatabase *db = [self.dataBases objectForKey:databaseName];
    if(!db) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *dbName = [NSString stringWithFormat:@"%@.db", databaseName];
        
        NSString *pathConfigDB = [NSString stringWithFormat:@"%@/%@", folder, dbName];
        NSLog(@"[%@] create %@ ", databaseName, pathConfigDB);
        db = [FMDatabase databaseWithPath:pathConfigDB];
        
        if(db) {
            [db open];
            NSLog(@"[%@] add to global FMDatabase dict.", databaseName);
            [self.dataBases setObject:db forKey:databaseName];
        }
    }
    
    return db;
}


- (void)buildTable:(DBTableAttribute*)tableAttribute
{
    NSString *databaseName;
    for(databaseName in tableAttribute.databaseNames) {
        NSLog(@"[%@ : %@] build tableAttribute.", databaseName, tableAttribute.tableName);
        
        FMDatabase *db = [self getDataBaseByName:databaseName];
        if(!db) {
            NSLog(@"#error - ");
            sleep(100);
            continue;
        }
        
        //判断表是否存在.
        if([self DBDataDetectTableExist:db withTableName:tableAttribute.tableName]) {
            NSLog(@"[%@ : %@] table exist.", databaseName, tableAttribute.tableName);
            continue;
        }
        
//        NSMutableString *createStringm = [NSMutableString stringWithFormat:@"create table if not exists %@(", tableAttribute.tableName];
        NSMutableString *createStringm = [NSMutableString stringWithFormat:@"create table %@(", tableAttribute.tableName];
        NSInteger index = 0;
        for(DBColumnAttribute *columnAttribute in tableAttribute.columnAttributes) {
            if(index > 0) {
                [createStringm appendString:@", "];
            }
            
//            [createStringm appendFormat:@"%@ %@ %@", columnAttribute.columnName, [self columnTypeToString:columnAttribute.dataType], columnAttribute.isAutoIncrement?@"autoincrement":@""];
            [createStringm appendFormat:@"%@ %@ %@", columnAttribute.columnName, [self columnTypeToString:columnAttribute.dataType], columnAttribute.isAutoIncrement?@"":@""];
            
            index ++;
        }
        
        if(tableAttribute.primaryKeys.count > 0) {
            [createStringm appendFormat:@", PRIMARY KEY(%@)", [NSString combineArray:tableAttribute.primaryKeys withInterval:@"\", " andPrefix:@"\"" andSuffix:@"\""]];
        }
        
        [createStringm appendString:@")"];
        
        //NSString *createHostsTable = @"create table if not exists hosts(id integer primary key autoincrement, hostname varchar, host varchar, imageHost varchar)";
        BOOL executeResult = [db executeUpdate:[NSString stringWithString:createStringm]];
        if(executeResult) {
            NSLog(@"[%@ : %@] create table OK.", databaseName, tableAttribute.tableName);
        }
        else {
            NSLog(@"#error- [%@ : %@] create table FAILED. <%@>",databaseName, tableAttribute.tableName, createStringm);
            sleep(100);
            continue;
        }
        
        //添加预置数据.
        for(NSDictionary *dict in tableAttribute.preset) {
            NSString *databaseNamePreset = [dict objectForKey:@"databaseName"];
            if(!([databaseNamePreset isEqualToString:databaseName] || [databaseNamePreset isEqualToString:@"*"])) {
                continue;
            }
            
            //检测. values 的类型为NSArray, array中的成员为NSDictionary.
            BOOL dataChecked = YES;
            NSDictionary *contents = [dict objectForKey:@"content"];
            if([contents isKindOfClass:[NSDictionary class]]) {
                
            }
            else {
                dataChecked = NO;
            }
            
            if(!dataChecked) {
                NSLog(@"#error- [%@ : %@] create table preset FAILED.",databaseNamePreset, tableAttribute.tableName);
                sleep(100);
                continue;
            }

            NSLog(@"[%@ : %@] insert presets.", databaseName, tableAttribute.tableName);
            
            NSInteger retInsert = [self DBDataInsert:db toTable:tableAttribute withInfo:contents countReplace:NO];
            if(DB_EXECUTE_OK != retInsert) {
                NSLog(@"#error- [%@ : %@] insert preset FAILED. <%@>", databaseName, tableAttribute.tableName, contents);
                sleep(100);
                continue;
            }
            else {
                NSLog(@"[%@ : %@] insert presets OK.", databaseName, tableAttribute.tableName);
            }
            
        }
    }
}


//对Insert, Update的输入数据, Query的输出数据进行检测. 返回行数. 执行时检测所有key对应的value array的个数相同.
//错误时返回 NSNotFound.
- (NSInteger)DBDataCheckRowsInDictionary:(NSDictionary*)dict
{
    NSInteger rows = 0;
    
    NSArray *columnNames = dict.allKeys;
    for(NSString *columnName in columnNames) {
        if(![columnName isKindOfClass:[NSString class]]) {
            NSLog(@"#error - columns should be NSString.");
            rows = NSNotFound;
            break;
        }
        
        NSArray *values = [dict objectForKey:columnName];
        if(values && [values isKindOfClass:[NSArray class]] && (0 == rows || values.count == rows )) {
            rows = values.count;
        }
        else {
            NSLog(@"#error - rows not fit.");
            rows = NSNotFound;
            break;
        }
    }
    
    return rows;
}



- (BOOL)DBDataCheckCountOfArray:(NSArray*)arrays withCount:(NSInteger)count
{
    BOOL result = YES;
    
    for(NSArray *array in arrays) {
        if([array isKindOfClass:[NSArray class]] && array.count == count) {
            
        }
        else {
            result = NO;
            break;
        }
    }
    
    return result;
}





- (NSDictionary*)DBDataQuery:(FMDatabase*)db
                     toTable:(DBTableAttribute*)tableAttribute
               withSqlString:(NSString*)sqlString
         andArgumentsInArray:(NSArray*)arguments
{
    if(![NSThread isMainThread]) {NSLog(@"#error - should excute db in MainThread.");}
    
    NSLog(@"sqlString : %@", sqlString);
    if(arguments.count > 0) {
        NSLog(@"arguments : %@", arguments);
    }
    
    NSLog(@"executeQuery");
    FMResultSet *rs = [db executeQuery:sqlString withArgumentsInArray:arguments];
    
    //怎么取?
    
    [rs close];
    
    return nil;
}


//直接的sql语句执行表查询. 暂时只用于测试.
- (NSDictionary*)DBDataQueryDBName:(NSString*)databaseName
                           toTable:(NSString*)tableName
                     withSqlString:(NSString*)sqlString
               andArgumentsInArray:(NSArray*)arguments
{
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@ : %@>", databaseName, tableName);
        return nil;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find table <%@ : %@>", databaseName, tableName);
        return nil;
    }
    
    return [self DBDataQuery:db toTable:tableAttribute withSqlString:sqlString andArgumentsInArray:arguments];
}


- (NSInteger)DBDataUpdate:(FMDatabase*)db
                      toTable:(DBTableAttribute*)tableAttribute
                withSqlString:(NSString*)sqlString
          andArgumentsInArray:(NSArray*)arguments
{
    if(![NSThread isMainThread]) {NSLog(@"#error - should excute db in MainThread.");}
    
    NSInteger retDBData = DB_EXECUTE_OK;
    
    NSLog(@"DBDataUpdate sqlString : %@", sqlString);
    if(arguments.count > 0) {
        NSLog(@"arguments : %@", arguments);
    }
    
    NSLog(@"executeUpdate");
    BOOL fmdbResult = [db executeUpdate:sqlString withArgumentsInArray:arguments];
    if(fmdbResult) {
        retDBData = DB_EXECUTE_OK;
    }
    else {
        NSLog(@"#error - executeUpdate failed.")
        retDBData = DB_EXECUTE_ERROR_SQL;
    }
    
    return retDBData;
}


//直接的sql语句执行表增删改. 暂时只用于测试.
- (NSInteger)DBDataUpdateDBName:(NSString*)databaseName
                            toTable:(NSString*)tableName
                      withSqlString:(NSString*)sqlString
                andArgumentsInArray:(NSArray*)arguments
{
    FMDatabase *db = [self getDataBaseByName:databaseName];
    if(!db) {
        NSLog(@"#error - not find database <%@ : %@>", databaseName, tableName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    DBTableAttribute *tableAttribute = [self getDBTableAttribute:databaseName withTableName:tableName];
    if(!tableAttribute) {
        NSLog(@"#error - not find table <%@ : %@>", databaseName, tableName);
        return DB_EXECUTE_ERROR_NOT_FOUND;
    }
    
    return [self DBDataUpdate:db toTable:tableAttribute withSqlString:sqlString andArgumentsInArray:arguments];
}














@end




