//
//  DBData.h
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define DB_EXECUTE_OK 0
#define DB_EXECUTE_ERROR_SQL      -1
#define DB_EXECUTE_ERROR_EXIST    -2
#define DB_EXECUTE_ERROR_DATA     -3



typedef NS_ENUM(NSInteger, DBDataColumnType) {
    DBDataColumnTypeNumberInteger,
    DBDataColumnTypeNumberLongLong,
    DBDataColumnTypeString,
};



@interface DBColumnValue : NSObject
@property (nonatomic, strong) NSString          *columnName;
@property (nonatomic, assign) DBDataColumnType  dataType;
@property (nonatomic, assign) BOOL              isNeedForInsert;
@property (nonatomic, assign) BOOL              isAutoIncrement;
@property (nonatomic, strong) id                defaultValue;
@end


@interface DBTableValue : NSObject
@property (nonatomic, strong) NSString          *tableName;
@property (nonatomic, strong) NSArray           *columns;       //成员为DBColumnValue.
@property (nonatomic, assign) BOOL              forHost;        //是属于全局的, 或者是属于host的.
@property (nonatomic, strong) NSArray           *primaryKey;    //字符串数组.
@end





@interface DBData : NSObject

@property (nonatomic, strong) NSArray           *tables;




- (NSInteger)DBCollectionInsert:(NSDictionary*)infoInsert;
- (BOOL)DBCollectionDelete:(NSDictionary*)infoDelete ;
- (NSArray*)DBCollectionQuery:(NSDictionary*)infoQuery ;












//创建.
- (NSInteger)DBDataCreateTable:(FMDatabase*)db tableName:(NSString*)tableName;

//增
- (NSInteger)DBDataInsert:(FMDatabase*)db toTable:(NSString*)tableName withInfo:(NSDictionary*)infoInsert countReplace:(BOOL)couldReplace;

//删
- (NSInteger)DBDataDelete:(FMDatabase*)db toTable:(NSString*)tableName withInfo:(NSDictionary*)infoDelete;

//查
- (NSArray*)DBDataQuery:(FMDatabase*)db toTable:(NSString*)tableName withInfo:(NSDictionary*)infoQuery;

//改. 暂时不实现.
//删. 暂时不实现.





@end
