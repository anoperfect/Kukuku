//
//  AppConfig.h
//  hacfun
//
//  Created by Ben on 15/8/6.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuncDefine.h"
#import "DBData.h"
@interface AppConfig : NSObject




+ (AppConfig*)sharedConfigDB;


//接口给测试用.
- (void)configDBBuildWithForceRebuild:(BOOL)forceRebuild;


+ (UIColor*)backgroundColorFor:(NSString*)name;
+ (UIColor*)textColorFor:(NSString*)name;
+ (UIFont*)fontFor:(NSString*)name;

- (id)configDBGet:(id)key ;
- (void)configDBSet:(id)key withObject:(id)object ;

- (NSString*)configDBSettingKVGet:(NSString*)key ;
- (BOOL)configDBSettingKVSet:(NSString*)key withValue:(NSString*)value ;

- (void)configDBSetAddCategoryClick:(NSString*)cateogry ;





#define CONFIGDB_EXECUTE_OK 0
#define CONFIGDB_EXECUTE_ERROR_SQL      -1
#define CONFIGDB_EXECUTE_ERROR_EXIST    -2
#define CONFIGDB_EXECUTE_ERROR_DATA     -3





- (NSInteger)configDBCollectionInsert:(NSDictionary*)infoInsert;
- (BOOL)configDBCollectionDelete:(NSDictionary*)infoDelete ;
- (NSArray*)configDBCollectionQuery:(NSDictionary*)infoQuery ;


- (NSInteger)configDBDetailHistoryInsert:(NSDictionary*)infoInsert countBeReplaced:(BOOL)couldBeReplaced;
- (BOOL)configDBDetailHistoryDelete:(NSDictionary*)infoDelete;
- (NSDictionary*)configDBDetailHistoryQuery:(NSDictionary*)infoQuery;




//- (BOOL)configDBCollectionUpdate:(NSDictionary*)infoUpdate ;


//- (BOOL)configDBCollectionInsert:(NSInteger)collectionId andUid:(NSString*)uid;
//- (BOOL)configDBCollectionDelete:(NSInteger)collectionId;
//- (NSArray*)configDBCollectionGet;
//- (BOOL)configDBCollectionUpdate:(NSDictionary*)info ;



//- (NSInteger)configDBPostInsert:(NSDictionary*)infoInsert orReplace:(BOOL)couldBeReplaced;
//- (BOOL)configDBPostDelete:(NSDictionary*)infoDelete ;
//- (NSArray*)configDBPostQuery:(NSDictionary*)infoQuery ;
//
//
//- (BOOL)configDBRecordInsert:(NSDictionary*)infoInsert ;
//- (BOOL)configDBRecordDelete:(NSDictionary*)infoDelete ;
//- (NSArray*)configDBRecordQuery:(NSDictionary*)infoQuery ;
//- (BOOL)configDBRecordUpdate:(NSDictionary*)infoUpdate ;
//
//
//
//- (BOOL)addRecord:(NSDictionary*)dict withThreadId:(NSInteger)threadId from:(NSString*)string ;

- (BOOL)configDBRecordInsertOrReplace:(NSDictionary*)infoInsert ;


- (NSArray*)getEmoticonStrings;











- (NSInteger)configDBInitCreateTableDraft:(FMDatabase *)dataBase;
- (NSInteger)configDBDraftInsert:(NSDictionary *)infoInsert;
- (NSInteger)configDBDraftDelete:(NSDictionary *)infoDelete;
- (NSArray*)configDBDraftQuery:(NSDictionary*)infoQuery;



- (void)configDBTestClearForRebuild;
- (void)configDBTestOnConfig:(NSString*)sqlString;
@end




#define CONFIG_NSInteger_To_Object(integer) [NSNumber numberWithInteger:integer]
#define CONFIG_Object_To_NSInteger(number)  [number integerValue]



#define CONFIG_NSSTRING_TO_BOOL(s)
#define CONFIG_NSSTRING_TO_INTEGER(s)






