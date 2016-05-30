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




//host.
- (NSArray*)configDBHostsGet;
- (Host*)configDBHostsGetCurrent;
- (NSArray*)configDBHostsGetHostnames;
#define HOSTNAME ([[AppConfig sharedConfigDB] configDBHostsGetCurrent].hostname)

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
- (BOOL    )configDBDraftRemoveBySn:(NSInteger)sn;
- (BOOL    )configDBDraftRemoveBySns:(NSArray*)sns;


//color.
- (NSArray*)configDBColorGet;
- (ColorItem *)configDBColorGetByName:(NSString*)name;
- (BOOL)configDBColorUpdate:(ColorItem*)color;

//font.
- (NSArray*)configDBFontGet;
- (FontItem *)configDBFontGetByName:(NSString*)name;
- (BOOL)configDBFontUpdate:(FontItem*)font;

//backgroundview.
- (NSArray*)configDBBackgroundViewGet;
- (BackgroundViewItem *)configDBBackgroundViewGetByName:(NSString*)name;
- (BOOL)configDBBackgroundViewUpdate:(BackgroundViewItem*)backgroundview;


//settingkv.
- (NSString*)configDBSettingKVGet:(NSString*)key ;
-      (BOOL)configDBSettingKVSet:(NSString*)key withValue:(NSString*)value ;


//category.
- (NSArray*)configDBCategoryGet;
- (Category*)configDBCategoryGetByName:(NSString*)name;
-     (BOOL)configDBCategoryAddClick:(NSString*)cateogry;



//DetailHistory
- (DetailHistory*)configDBDetailHistoryGetByTid:(NSInteger)tid;
- (BOOL)configDBDetailHistoryUpdate:(DetailHistory*)detailHistory;


//Collection.
- (NSArray*)configDBCollectionGets;
- (Collection*)configDBCollectionGetByTid:(NSInteger)tid;
- (BOOL)configDBCollectionAdd:(Collection*)collection;
- (BOOL)configDBCollectionRemove:(NSInteger)tid;
- (BOOL)configDBCollectionRemoveByTidArray:(NSArray*)tidArray;



//Post.
- (NSArray*)configDBPostGets;
- (Post*)configDBPostGetByTid:(NSInteger)tid;
- (BOOL)configDBPostAdd:(Post*)post;
- (BOOL)configDBPostRemove:(NSInteger)tid;
- (BOOL)configDBPostRemoveByTidArray:(NSArray*)tidArray;


//Reply.
- (NSArray*)configDBReplyGets;
- (Reply*)configDBReplyGetByTid:(NSInteger)tid;
- (BOOL)configDBReplyAdd:(Reply*)reply;
- (BOOL)configDBReplyRemove:(NSInteger)tid;
- (BOOL)configDBReplyRemoveByTidArray:(NSArray*)tidArray;



//Record.
- (BOOL)configDBRecordAdds:(NSArray*)postDatas;
- (NSArray*)configDBRecordGets:(NSArray*)tidArray;

//清除数据库. 需仅适用于开发者环境.
- (void)removeAll;


- (NSString*)generateRequestURL:(NSString*)query andArgument:(NSDictionary*)argument;
- (void)authAsync:(void(^)(BOOL result))handle;
- (void)updateCategoryAsync:(void(^)(BOOL result, NSInteger total, NSInteger updateNumber))handle;
- (NSData*)sendSynchronousRequestTo:(NSString*)query andArgument:(NSDictionary*)argument;
- (NSDictionary*)sendSynchronousRequestAndJsonParseTo:(NSString*)query andArgument:(NSDictionary*)argument;



@end
