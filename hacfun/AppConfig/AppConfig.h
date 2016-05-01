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

#define CONFIGDB_EXECUTE_OK 0
#define CONFIGDB_EXECUTE_ERROR_SQL      -1
#define CONFIGDB_EXECUTE_ERROR_EXIST    -2
#define CONFIGDB_EXECUTE_ERROR_DATA     -3


+ (AppConfig*)sharedConfigDB;



//host.
- (NSArray*)configDBHostsGet;
- (Host*)configDBHostsGetCurrent;
- (NSArray*)configDBHostsGetHostnames;

//hostindex.
- (NSInteger)configDBHostIndexGet;
- (BOOL)configDBHostIndexSet:(NSInteger)hostIndex;

//emoticon
- (NSArray*)configDBEmoticonGet;
- (BOOL)configDBAddClickOnString:(NSString*)emoticonString;
- (BOOL)configDBEmoticonAdd:(NSArray*)emoticonStrings;


//draft.
- (NSArray*)configDBDraftGet;
- (BOOL    )configDBDraftAdd:(NSString*)index;
- (BOOL    )configDBDraftRemoveAtIndex:(NSInteger)index;
- (BOOL    )configDBDraftRemoveAtIndexSet:(NSIndexSet*)indexSet;


//color.
- (NSArray*)configDBColorGet;

//font.
- (NSArray*)configDBFontGet;

//settingkv.
- (NSString*)configDBSettingKVGet:(NSString*)key ;
-      (BOOL)configDBSettingKVSet:(NSString*)key withValue:(NSString*)value ;


//category.
- (NSArray*)configDBCategoryGet;
-     (BOOL)configDBCategoryAddClick:(NSString*)cateogry;


//DetailHistory
- (DetailHistory*)configDBDetailHistoryGetByTid:(NSInteger)tid;
- (BOOL)configDBDetailHistoryUpdate:(DetailHistory*)history;


//Collection.
- (NSArray*)configDBCollectionGet;
- (Collection*)configDBCollectionGetByTid:(NSInteger)tid;
- (BOOL)configDBCollectionAdd:(Collection*)collection;


//Post.
- (NSArray*)configDBPostGet;
- (Post*)configDBPostGetByTid:(NSInteger)tid;
- (BOOL)configDBPostAdd:(Post*)post;


//Reply.
- (NSArray*)configDBReplyGet;
- (Reply*)configDBPReplyGetByTid:(NSInteger)tid;
- (BOOL)configDBReplyAdd:(Reply*)reply;


- (BOOL)configDBRecordAdds:(NSArray*)postDatas;



@end























