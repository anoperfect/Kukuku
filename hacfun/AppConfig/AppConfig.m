//
//  AppConfig.m
//  hacfun
//
//  Created by Ben on 15/8/6.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "AppConfig.h"
#import "FMDB.h"
#import "FuncDefine.h"





//这是Ku岛管理分配的appkey.
#define APPKEY          @"ee2a5472-065b-41c2-8b8c-d4cd56abcdef"

//这不是正式的appSecret. appSecret需保密. 正式的appSecret存本地用于test&build.
#define APPSECRET       @"s6Q1w62100abcdef"

#import "koukukoisland.appkey"


#define DBNAME_CONFIG           @"config"
#define DBNAME_HOST             ((Host*)[self.hosts objectAtIndex:self.hostIndex]).hostname



#define TABLENAME_HOSTS                     @"hosts"
#define TABLENAME_HOSTINDEX                 @"hostindex"
#define TABLENAME_EMOTICON                  @"emoticon"
#define TABLENAME_DRAFT                     @"draft"
#define TABLENAME_COLOR                     @"color"
#define TABLENAME_FONT                      @"font"
#define TABLENAME_BACKGROUNDVIEW            @"backgroundview"

#define TABLENAME_SETTINGKV                 @"settingkv"
#define TABLENAME_CATEGORY                  @"category"
#define TABLENAME_DETAILHISTORY             @"detailhistory"
#define TABLENAME_DETAILRECORD              @"detailrecord"
#define TABLENAME_RECORD                    @"record"
#define TABLENAME_COLLECTION                @"collection"
#define TABLENAME_POST                      @"post"
#define TABLENAME_REPLY                     @"reply"
#define TABLENAME_NOTSHOWUID                @"notshowuid"
#define TABLENAME_NOTSHOWTID                @"notshowtid"
#define TABLENAME_ATTENT                    @"attent"


@interface AppConfig ()


//具体的数据库操作尽量通过DBData.
@property (nonatomic, strong) DBData *dbData;

//host配置缓存.
@property (strong,nonatomic) NSArray *hosts;
@property (assign,nonatomic) NSInteger hostIndex ;

//category缓存.
@property (nonatomic, strong, readwrite) NSArray<Category*> *categories;

//config缓存.
@property (nonatomic, strong)   NSMutableArray *emoticons;
@property (nonatomic, strong)   NSMutableArray *drafts;
@property (nonatomic, strong)   NSMutableArray *colors;
@property (nonatomic, strong)   NSMutableArray *fonts;
@property (nonatomic, strong)   NSMutableArray *backgroundviews;





@property (nonatomic, strong)   NSMutableArray *notShowUids;
@property (nonatomic, strong)   NSMutableArray *notShowTids;
@property (nonatomic, strong)   NSMutableArray *attents;



@property (nonatomic, strong)   NSString *appkey;
@property (nonatomic, strong)   NSString *hwid;
@property (nonatomic, strong)   NSString *appSecret;
@property (nonatomic, strong)   NSString *token;

@property (nonatomic, assign, readwrite)    BOOL    authResult;
@property (nonatomic, strong, readwrite)    NSDate  *updateCategoryDate;



//host相关缓存.
@property (nonatomic, strong) NSMutableDictionary *dictSettingKV;

//@property (nonatomic, strong)   NSMutableArray *categories;


@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) dispatch_queue_t postDataRetreatQueueInstance;
@end


@implementation AppConfig


+ (AppConfig*)sharedConfigDB {
    
    static AppConfig* sharedAppConfig = nil;
    if(nil == sharedAppConfig) {
        sharedAppConfig = [[AppConfig alloc] init];
    }
    
    return sharedAppConfig;
}


- (id)init {
    if (self = [super init]) {
        
        self.appkey = APPKEY;
        self.appSecret = APPSECRET;
        
        self.dictSettingKV = [[NSMutableDictionary alloc] init];
        
        self.dbData = [[DBData alloc] init];
        
        //测试.
        [self testBeforeBuild];
        
        //建立或者升级数据库.
        [self configdbBuildTable];
        
        //数据库输入初始数据.
        [self configDBInitData];
        
        //测试.
        [self testAfterBuild];
        
        //开始鉴权.
        //[self authAsync:nil];
        
        [self HTTPSessionManager];
        
        //设备基础信息读取.
        //当前未开启sign校验. 随意写一个. token校验同样未开启.
#if ENABLE_IDFA
        NSString *hwidraw = [NSString deviceIdfa];
#else
        NSString *hwidraw = [NSString deviceUuid];
#endif
        self.hwid = [hwidraw calculateMD5];
        
        self.token = [self configDBSettingKVGet:@"token"];
        
        if([self.token isEqualToString:@"NAN"]) {
            self.token = nil;
        }
        
        self.authResult = NO;
        
        [self test];
        
    }
    
    return self;
}


- (void)configdbBuildTable
{
    NSString *resPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.json"];
    
    NSData *data = [NSData dataWithContentsOfFile:resPath];
    //NSLog(@"------\n%@\n-------", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    if(data) {
        [self.dbData buildByJsonData:data];
    }
    else {
        NSLog(@"#error - resPath content NULL.");
    }
}


//输入预定数据. 一些数据(数据量小,修改可能性小的)直接加入内存, 读的时候不操作数据库.
- (void)configDBInitData
{
    //升级数据库.
    
    //数据更新.
    
    //读取一些配置. 之后read的时候不用操作数据库.
    [self configDBInitReadConfig];
    [self configDBInitReadHost];
}


- (void)configDBInitReadConfig
{
    self.hosts      = nil;
    self.hosts      = [self configDBHostsGet];
    
    self.hostIndex  = NSNotFound;
    self.hostIndex  = [self configDBHostIndexGet];
}


- (void)configDBInitReadHost
{
    self.categories = [self configDBCategoryGet];
    
    self.notShowUids    = [NSMutableArray arrayWithArray:[self configDBNotShowUidGets]];
    self.notShowTids    = [NSMutableArray arrayWithArray:[self configDBNotShowTidGets]];
    self.attents        = [NSMutableArray arrayWithArray:[self configDBAttentGets]];
}


- (void)testBeforeBuild
{

}


- (void)testAfterBuild
{
//    NSString *tablename = @"color";
//    NSString *strDropTable = [NSString stringWithFormat:@"DROP TABLE %@", tablename];
//    [self.dbData DBDataUpdateDBName:DBNAME_CONFIG withSqlString:strDropTable andArgumentsInArray:nil];
    
    //Post测试数据.
    //NSString *strAddPostTest = @"INSERT OR IGNORE INTO Post(tid,postedAt) VALUES(6624990,0)";
    //[self.dbData DBDataUpdateDBName:DBNAME_HOST withSqlString:strAddPostTest andArgumentsInArray:nil];
}









//host.
- (NSArray*)configDBHostsGet
{
    if(self.hosts) {
        return self.hosts;
    }
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_HOSTS
                                                   columnNames:nil withQuery:nil withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {

        NSArray *snArray                    = queryResult[@"sn"];
        NSArray *hostnameArray              = queryResult[@"hostname"];
        NSArray *hostArray                  = queryResult[@"host"];
        NSArray *imageHostArray             = queryResult[@"imageHost"];
        NSArray *urlStringArray             = queryResult[@"urlString"];
        NSArray *numberInCategoryPageArray  = queryResult[@"numberInCategoryPage"];
        NSArray *numberInDetailPageArray    = queryResult[@"numberInDetailPage"];
        
        if([self.dbData DBDataCheckCountOfArray:@[snArray, hostnameArray, hostArray, imageHostArray, urlStringArray, numberInCategoryPageArray, numberInDetailPageArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                Host *host = [[Host alloc] init];
                host.id                     = [snArray[index] integerValue];
                host.hostname               = hostnameArray[index];
                host.host                   = hostArray[index];
                host.imageHost              = imageHostArray[index];
                host.urlString              = urlStringArray[index];
                host.numberInCategoryPage   = [numberInCategoryPageArray[index] integerValue];
                host.numberInDetailPage     = [numberInDetailPageArray[index] integerValue];
                
                [arrayReturnM addObject:host];
            }
            
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    self.hosts = arrayReturn;
    
    return arrayReturn;
}


- (Host*)configDBHostsGetCurrent
{
    return self.hosts[self.hostIndex];
}


- (NSArray*)configDBHostsGetHostnames
{
    NSMutableArray *hostnamesM = [[NSMutableArray alloc] init];
    for(Host *host in self.hosts) {
        [hostnamesM addObject:host.hostname];
    }
    
    return [NSArray arrayWithArray:hostnamesM];
}


#define ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSNumber class]]) {varqwe = [arrayasd[indexzxc] integerValue];}\
else {NSLog(@"#error - obj (%@) is not NSNumber class.", arrayasd[indexzxc]);varqwe = defaultqaz;}

#define ASSIGN_BOOL_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSNumber class]]) {varqwe = ([arrayasd[indexzxc] integerValue] > 0);}\
else {NSLog(@"#error - obj (%@) is not NSNumber class.", arrayasd[indexzxc]);varqwe = defaultqaz;}

#define ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSNumber class]]) {varqwe = [arrayasd[indexzxc] longLongValue];}\
else {NSLog(@"#error - obj (%@) is not NSNumber class.", arrayasd[indexzxc]);varqwe = defaultqaz;}

#define ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSString class]]) {varqwe = [arrayasd[indexzxc] copy];}\
else {NSLog(@"#error - obj (%@) is not NSString class.", arrayasd[indexzxc]);varqwe = defaultqaz;}

#define ASSIGN_BLOB_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSData class]]) {varqwe = [arrayasd[indexzxc] copy];}\
else if([arrayasd[indexzxc] isKindOfClass:[NSNull class]]) {varqwe = nil;}\
else {NSLog(@"#error - obj (%@) is not NSData class.", arrayasd[indexzxc]);varqwe = defaultqaz;}




//hostindex.
- (NSInteger)configDBHostIndexGet
{
    if(self.hostIndex != NSNotFound) {
        return self.hostIndex;
    }
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_HOSTINDEX
                                                   columnNames:nil withQuery:nil withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSInteger hostIndex = 1 ;
    if(count > 0) {
        NSArray *selectedIndexArray = queryResult[@"selectedIndex"];

        if([self.dbData DBDataCheckCountOfArray:@[selectedIndexArray] withCount:count]) {
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(hostIndex, selectedIndexArray, 0, hostIndex)
        }
    }
    else {
        NSLog(@"#error - query from db error.");
    }
    
    self.hostIndex = hostIndex;
    
    return hostIndex;
}


- (BOOL)configDBHostIndexSet:(NSInteger)hostIndex
{
    BOOL result = YES;
    
    if(hostIndex < self.hosts.count) {
        //设置sel.hostIndex缓存.
        self.hostIndex = hostIndex;
        
        //清除所有host相关缓存.
        self.dictSettingKV = [[NSMutableDictionary alloc] init];
        
        
        //查询数据库.
        NSInteger dbResult = [self.dbData DBDataUpdateDBName:DBNAME_CONFIG
                                                     toTable:TABLENAME_HOSTINDEX
                                              withInfoUpdate:@{@"":[NSNumber numberWithInteger:hostIndex]}
                                               withInfoQuery:nil];
        if(DB_EXECUTE_OK != dbResult) {
            NSLog(@"#error - db exec error.");
            result = NO;
        }
    }
    else {
        NSLog(@"#error - hostIndex (%zd) invalid.", hostIndex);
        result = NO;
    }
    
    return result;
}


//emoticon
- (NSArray*)configDBEmoticonGet
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_EMOTICON
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY click DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *emoticonArray      = queryResult[@"emoticon"];
        NSArray *clickArray = queryResult[@"click"];
        
        if([self.dbData DBDataCheckCountOfArray:@[emoticonArray, clickArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                Emoticon *emoticon = [[Emoticon alloc] init];
                
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(emoticon.emoticon, emoticonArray, index, @"NAN")
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(emoticon.click, clickArray, index, 0)
  
                [arrayReturnM addObject:emoticon];
            }
            
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
}


- (BOOL)configDBAddClickOnString:(NSString*)emoticonString
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataUpdateAdd1DBName:DBNAME_CONFIG toTable:TABLENAME_EMOTICON withColumnName:@"click" withInfoQuery:@{@"emoticon":emoticonString}];
    
    if(retDBData != DB_EXECUTE_OK) {
        NSLog(@"#error - configDBAddClickOnString");
        result = NO;
    }

    return result;
}



- (BOOL)configDBEmoticonAdd:(NSArray*)emoticonStrings
{
    BOOL result = YES;
    
    NSMutableArray *valuesM = [[NSMutableArray alloc] init];
    for(NSString *emoticonString in emoticonStrings) {
        [valuesM addObject:@[emoticonString, @0]];
    }
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"emoticon", @"click"],
                                 DBDATA_STRING_VALUES:[NSArray arrayWithArray:valuesM]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_EMOTICON withInfo:infoInsert orReplace:YES];
    if(retDBData != DB_EXECUTE_OK) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}



//draft.
- (NSArray*)configDBDraftGet
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_DRAFT
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY click DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *snArray            = queryResult[@"sn"];
        NSArray *contentArray       = queryResult[@"content"];
        NSArray *clickArray         = queryResult[@"click"];
        
        if([self.dbData DBDataCheckCountOfArray:@[snArray, contentArray, clickArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                Draft *draft = [[Draft alloc] init];
                
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(draft.sn, snArray, index, 0)
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(draft.content, contentArray, index, @"NAN")
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(draft.click, clickArray, index, 0)
                
                [arrayReturnM addObject:draft];
            }
            
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
}


- (BOOL    )configDBDraftAdd:(NSString*)content
{
    BOOL result = YES;

    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"content", @"click"],
                                 DBDATA_STRING_VALUES:@[@[content, @0]]
                                 };
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_DRAFT withInfo:infoInsert orReplace:YES];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL    )configDBDraftRemoveBySn:(NSInteger)sn
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_CONFIG toTable:TABLENAME_DRAFT withQuery:@{@"sn":[NSNumber numberWithInteger:sn]}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL    )configDBDraftRemoveBySns:(NSArray*)sns
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_CONFIG toTable:TABLENAME_DRAFT withQuery:@{@"sn":sns}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}




//color.
- (NSArray*)configDBColorGet
{
    if(self.colors) {
        return [NSArray arrayWithArray:self.colors];
    }
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_COLOR
                                                   columnNames:nil withQuery:nil withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *titleArray             = queryResult[@"title"];
        NSArray *enableCustmizeArray    = queryResult[@"enableCustmize"];
        NSArray *colorstringArray       = queryResult[@"colorstring"];
        NSArray *colornightstringArray  = queryResult[@"colornightstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, titleArray, enableCustmizeArray, colorstringArray, colornightstringArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                ColorItem *colorItem = [[ColorItem alloc] init];
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.name,               nameArray,              index, @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.title,              titleArray,             index, @"NAN")
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(colorItem.enableCustmize,     enableCustmizeArray,    index, 0)
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.colorstring,        colorstringArray,       index, @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.colornightstring,   colornightstringArray,  index, @"NAN")
                
                [arrayReturnM addObject:colorItem];
            }
            
            self.colors = arrayReturnM;
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
}


- (ColorItem *)configDBColorGetByName:(NSString*)name
{
    ColorItem *colorItem = nil;
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_COLOR
                                                   columnNames:nil
                                                     withQuery:@{@"name":name}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    if(count > 0) {
        
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *titleArray             = queryResult[@"title"];
        NSArray *enableCustmizeArray    = queryResult[@"enableCustmize"];
        NSArray *colorstringArray       = queryResult[@"colorstring"];
        NSArray *colorsnighttringArray  = queryResult[@"colornightstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, titleArray, enableCustmizeArray, colorstringArray, colorsnighttringArray] withCount:count]) {
            
            colorItem = [[ColorItem alloc] init];
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.name,               nameArray,              0, @"NAN")
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.title,              titleArray,             0, @"NAN")
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(colorItem.enableCustmize,     enableCustmizeArray,    0, 0)
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.colorstring,        colorstringArray,       0, @"NAN")
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (colorItem.colornightstring,   colorsnighttringArray,  0, @"NAN")
        }
    }
    else {
        NSLog(@"#error - configDBColorGetByName : %@ not found.", name);
    }
    
    return colorItem;
}


- (BOOL)configDBColorUpdate:(ColorItem*)color
{
    BOOL result = YES;
    
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"name", @"colorstring", @"colornightstring"],
                                 DBDATA_STRING_VALUES:@[@[color.name, color.colorstring, color.colornightstring]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_COLOR withInfo:infoInsert orReplace:YES];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


//font.
- (NSArray*)configDBFontGet
{
    if(self.fonts) {
        return [NSArray arrayWithArray:self.fonts];
    }
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_FONT
                                                   columnNames:nil withQuery:nil withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *titleArray             = queryResult[@"title"];
        NSArray *enableCustmizeArray    = queryResult[@"enableCustmize"];
        NSArray *fontstringArray        = queryResult[@"fontstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, titleArray, enableCustmizeArray, fontstringArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                FontItem *fontItem = [[FontItem alloc] init];
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (fontItem.name,            nameArray,           index, @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (fontItem.title,           titleArray,          index, @"NAN")
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(fontItem.enableCustmize,  enableCustmizeArray, index, 0)
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(fontItem.fontstring,       fontstringArray,     index, @"NAN")
                
                [arrayReturnM addObject:fontItem];
            }
            
            self.fonts = arrayReturnM;
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
}



- (FontItem *)configDBFontGetByName:(NSString*)name
{
    FontItem *fontItem = nil;
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_FONT
                                                   columnNames:nil
                                                     withQuery:@{@"name":name}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    if(count > 0) {
        
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *titleArray             = queryResult[@"title"];
        NSArray *enableCustmizeArray    = queryResult[@"enableCustmize"];
        NSArray *fontstringArray       = queryResult[@"fontstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, titleArray, enableCustmizeArray, fontstringArray] withCount:count]) {
            
            fontItem = [[FontItem alloc] init];
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (fontItem.name,           nameArray,           0, @"NAN")
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (fontItem.title,          titleArray,          0, @"NAN")
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(fontItem.enableCustmize, enableCustmizeArray, 0, 0)
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (fontItem.fontstring,     fontstringArray,     0, @"NAN")
        }
    }
    else {
        NSLog(@"#error - configDBFontGetByName : %@ not found.", name);
    }
    
    return fontItem;
}


- (BOOL)configDBFontUpdate:(FontItem*)font
{
    BOOL result = YES;
    
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"name", @"fontstring"],
                                 DBDATA_STRING_VALUES:@[@[font.name, font.fontstring]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_FONT withInfo:infoInsert orReplace:YES];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}



//backgroundview.
- (NSArray*)configDBBackgroundViewGet
{
    if(self.backgroundviews) {
        return [NSArray arrayWithArray:self.backgroundviews];
    }
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_BACKGROUNDVIEW
                                                   columnNames:nil withQuery:nil withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *titleArray             = queryResult[@"title"];
        NSArray *enableCustmizeArray    = queryResult[@"enableCustmize"];
        NSArray *enableArray            = queryResult[@"onUse"];
        NSArray *imageNameArray         = queryResult[@"imageName"];
        NSArray *imageDataArray         = queryResult[@"imageData"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, titleArray, enableCustmizeArray, enableArray, imageNameArray, imageDataArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                BackgroundViewItem *backgroundViewItem = [[BackgroundViewItem alloc] init];
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (backgroundViewItem.name,           nameArray,           index, @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (backgroundViewItem.title,          titleArray,          index, @"NAN")
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(backgroundViewItem.enableCustmize, enableCustmizeArray, index, 0)
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(backgroundViewItem.onUse,          enableArray,         index, 0)
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (backgroundViewItem.imageName,      imageNameArray,      index, @"NAN")
                ASSIGN_BLOB_VALUE_FROM_ARRAYMEMBER   (backgroundViewItem.imageData,      imageDataArray,      index, nil)
                
                [arrayReturnM addObject:backgroundViewItem];
            }
            
            self.backgroundviews = arrayReturnM;
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
}


- (BackgroundViewItem *)configDBBackgroundViewGetByName:(NSString*)name
{
    BackgroundViewItem *backgroundViewItem = nil;
    
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_CONFIG
                                                       toTable:TABLENAME_BACKGROUNDVIEW
                                                   columnNames:nil
                                                     withQuery:@{@"name":name}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];

    if(count > 0) {
        
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *titleArray             = queryResult[@"title"];
        NSArray *enableCustmizeArray    = queryResult[@"enableCustmize"];
        NSArray *enableArray            = queryResult[@"onUse"];
        NSArray *imageNameArray         = queryResult[@"imageName"];
        NSArray *imageDataArray         = queryResult[@"imageData"];
                
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, titleArray, enableCustmizeArray, enableArray, imageNameArray, imageDataArray] withCount:count]) {

            backgroundViewItem = [[BackgroundViewItem alloc] init];
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (backgroundViewItem.name,           nameArray,           0, @"NAN")
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (backgroundViewItem.title,          titleArray,          0, @"NAN")
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(backgroundViewItem.enableCustmize, enableCustmizeArray, 0, 0)
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(backgroundViewItem.onUse,          enableArray,         0, 0)
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (backgroundViewItem.imageName,      imageNameArray,      0, @"NAN")
            ASSIGN_BLOB_VALUE_FROM_ARRAYMEMBER   (backgroundViewItem.imageData,      imageDataArray,      0, nil)
            
        }
    }
    
    return backgroundViewItem;
}


- (BOOL)configDBBackgroundViewUpdate:(BackgroundViewItem *)backgroundview
{
    BOOL result = YES;
    
    NSMutableDictionary *infoUpdateM = [[NSMutableDictionary alloc] init];
    BackgroundViewItem *backgroundviewOriginal = [self configDBBackgroundViewGetByName:backgroundview.name];
    if(backgroundview.onUse != backgroundviewOriginal.onUse) {
        [infoUpdateM setObject:[NSNumber numberWithInteger:backgroundview.onUse] forKey:@"onUse"];
    }
    
    if(![backgroundview.imageData isEqual:backgroundviewOriginal.imageData]) {
        [infoUpdateM setObject:backgroundview.imageData forKey:@"imageData"];
    }
    
    if(infoUpdateM.count > 0) {
        NSInteger retDBData = [self.dbData DBDataUpdateDBName:DBNAME_CONFIG
                                                      toTable:TABLENAME_BACKGROUNDVIEW
                                               withInfoUpdate:infoUpdateM
                                                withInfoQuery:@{@"name":backgroundview.name}];
    
        if(DB_EXECUTE_OK != retDBData) {
            NSLog(@"#error - ");
            result = NO;
        }
    }
    else {
        NSLog(@"#error - not data updated.");
        result = NO;
    }
    
    return result;
}


//settingkv.
- (NSString*)configDBSettingKVGet:(NSString*)key
{
    if([self.dictSettingKV objectForKey:key]) {
        return [self.dictSettingKV objectForKey:key];
    }
    
    NSString *valueString = nil;
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_SETTINGKV
                                                   columnNames:@[@"value"]
                                                     withQuery:@{@"key":key}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    if(count == 1) {
        
        NSArray *values    = queryResult[@"value"];
        
        if([self.dbData DBDataCheckCountOfArray:@[values] withCount:count]) {
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(valueString, values, 0, @"NAN")
            if(![valueString isEqualToString:@"NAN"]) {
                [self.dictSettingKV setObject:valueString forKey:key];
            }
        }
    }
    else {
        NSLog(@"#error - <%@> not found.", key);
    }
    
    return valueString;
}


-      (BOOL)configDBSettingKVSet:(NSString*)key withValue:(NSString*)value
{
    BOOL result = YES;
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"key", @"value"],
                                 DBDATA_STRING_VALUES:@[@[key, value]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_SETTINGKV withInfo:infoInsert orReplace:YES];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    [self.dictSettingKV setObject:value forKey:key];
    
    return result;
}


- (void)setTitleWithString:(NSString *)title,...
{
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    if (title)
    {
        //将第一个参数添加到array
        [argsArray addObject:title];
        
        va_list params; //定义一个指向个数可变的参数列表指针；
        va_start(params,title);//va_start  得到第一个可变参数地址,
        
        NSString *arg;
        while( (arg = va_arg(params,NSString *)) )         //va_arg 指向下一个参数地址
        {
            if ( arg )
            {
                [argsArray addObject:arg];
            }
        }
        va_end(params);         //置空
    }
//    for (NSString *str in argsArray)
//    {
//        NSLog(@"%@",str);
//    }
}


-(NSArray *)actionUsePic:(id)actionNum, ... {
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params; //定义一个指向个数可变的参数列表指针;
    va_start(params,actionNum);//va_start 得到第一个可变参数地址,
    id arg;
    if (actionNum) {
        //将第一个参数添加到array
        id prev = actionNum;
        [argsArray addObject:prev];
        //va_arg 指向下一个参数地址
        //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
        while( (arg = va_arg(params,id)) )
        {
            if ( arg ){
                [argsArray addObject:arg];
            }
        }
        //置空
        va_end(params);
        //这里循环 将看到所有参数
//        for (NSNumber *num in argsArray) {
//            NSLog(@"%d", [num intValue]);
//        }
    }
    return argsArray;
}



//category.
- (NSArray*)configDBCategoryGet
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_CATEGORY
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY click DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NS0Log(@"zzz:%@", queryResult);
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *linkArray              = queryResult[@"link"];
        NSArray *forumArray             = queryResult[@"forum"];
        NSArray *headerIconUrlArray     = queryResult[@"headerIconUrl"];
        NSArray *contentArray           = queryResult[@"content"];
        NSArray *passwordRequiredArray  = queryResult[@"passwordRequired"];
        NSArray *clickArray             = queryResult[@"click"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, linkArray, forumArray, headerIconUrlArray, contentArray, passwordRequiredArray, clickArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                Category *category = [[Category alloc] init];
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.name ,               nameArray ,             index,  @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.link ,               linkArray ,             index,  @"NAN")
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(category.forum,               forumArray,             index,  0)
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.headerIconUrl ,      headerIconUrlArray ,    index,  @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.content,             contentArray,           index,  @"NAN")
                ASSIGN_BOOL_VALUE_FROM_ARRAYMEMBER   (category.passwordRequired,    passwordRequiredArray,  index,  NO)
                ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(category.click,               clickArray,             index,  0)
                
                [arrayReturnM addObject:category];
            }
            
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }

    if(!arrayReturn) {
        NSLog(@"#error - configDBCategoryGet");
        Category *category = [[Category alloc] init];
        category.name           = @"获取栏目错误";
        category.link           = @"获取栏目错误";
        category.forum          = 0;
        category.click          = 0;
        
        arrayReturn = @[category];
    }
    
    return arrayReturn;
}


- (Category*)configDBCategoryGetByName:(NSString*)name
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_CATEGORY
                                                   columnNames:nil
                                                     withQuery:@{@"name":name}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    Category *category = nil;

    if(count > 0) {
        NSArray *nameArray              = queryResult[@"name"];
        NSArray *linkArray              = queryResult[@"link"];
        NSArray *forumArray             = queryResult[@"forum"];
        NSArray *headerIconUrlArray     = queryResult[@"headerIconUrl"];
        NSArray *contentArray           = queryResult[@"content"];
        NSArray *passwordRequiredArray  = queryResult[@"passwordRequired"];
        NSArray *clickArray             = queryResult[@"click"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, linkArray, forumArray, headerIconUrlArray, contentArray, passwordRequiredArray, clickArray] withCount:count]) {
            category = [[Category alloc] init];
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.name ,               nameArray ,             0,  @"NAN")
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.link ,               linkArray ,             0,  @"NAN")
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(category.forum,               forumArray,             0,  0)
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.headerIconUrl ,      headerIconUrlArray ,    0,  @"NAN")
            ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER (category.content,             contentArray,           0,  @"NAN")
            ASSIGN_BOOL_VALUE_FROM_ARRAYMEMBER   (category.passwordRequired,    passwordRequiredArray,  0,  NO)
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(category.click,               clickArray,             0,  0)
        }
    }
    
    return category;
}


- (Category*)configDBCategoryParseFromDict:(NSDictionary*)dict onHostName:(NSString*)hostname
{
    Category* category = [[Category alloc] init];
    BOOL parsed = YES;
    
    NSString *name = [dict objectForKey:@"name"];
    NSString *keywords = [dict objectForKey:@"keywords"];
    NSString *displayName = [dict objectForKey:@"displayName"];
    NSString *description = [dict objectForKey:@"description"];
    
    if(name.length > 0) {
        category.name = [name copy];
        category.link = [NSString URLEncodedString:category.name];
        
        if([name isEqualToString:keywords]
           && [name isEqualToString:displayName]
           && [name isEqualToString:description])
        {
            
        }
        else {
            NSLog(@"#error - <%@ %@ %@ %@>", name, keywords, displayName, description);
        }
        
    }
    else {
        NSLog(@"#error - Category %@ not parsed.", @"name");
        parsed = NO;
    }
    
    NSNumber *forumNumber = [dict objectForKey:@"id"];
    if([forumNumber isKindOfClass:[NSNumber class]]) {
        category.forum = [forumNumber integerValue];
    }
    else {
        NSLog(@"#error - id set to forum failed.");
        parsed = NO;
    }
    
    NSString *headerIconUrl = [FuncDefine objectParseFromDict:dict WithXPath:@[
                                                     @{@"headerIcon":[NSDictionary class]},
                                                     @{@"url":[NSDictionary class]}
                                                     ]
     ];
    if([headerIconUrl isKindOfClass:[NSString class]]) {
        category.headerIconUrl = headerIconUrl;
    }
    else {
        category.headerIconUrl = @"";
        NSLog(@"#error - Category %@ <%@> not parsed.", category.name,  @"headerIconUrl");
    }
    
    NSString *content = [dict objectForKey:@"content"];
    if([content isKindOfClass:[NSString class]]) {
        category.content = content;
    }
    else {
        category.content = @"";
        NSLog(@"#error - Category %@ <%@> not parsed.", category.name, @"content");
    }
    
    NSNumber *passwordRequiredNumber = [dict objectForKey:@"passwordRequired"];
    if([passwordRequiredNumber isKindOfClass:[NSNumber class]]) {
        category.passwordRequired = [passwordRequiredNumber boolValue];
    }
    else {
        category.passwordRequired = NO;
        NSLog(@"#error - Category %@ <%@> not parsed.", category.name, @"passwordRequired");
    }
    
    if(!parsed) {
        NSLog(@"#error - configDBCategoryParseFromDict failed <%@>.", [NSString stringFromNSDictionary:dict]);
        category = nil;
    }
    
    return category;
}


- (BOOL)configDBCategoryInserts:(NSArray*)categories
{
    BOOL result = YES;
    NSArray *columnNames = @[@"name", @"link", @"forum", @"headerIconUrl", @"content", @"passwordRequired", @"click"];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for(Category *category in categories) {
        NSMutableArray *value = [NSMutableArray arrayWithCapacity:columnNames.count];
        
        #define ASSIGN_STRING_IF_NULL(s, v) if(!(s)) { (s) = (v);}
        ASSIGN_STRING_IF_NULL(category.name, @"")
        ASSIGN_STRING_IF_NULL(category.link, @"")
        ASSIGN_STRING_IF_NULL(category.headerIconUrl, @"")
        ASSIGN_STRING_IF_NULL(category.content, @"")

        [value addObject:[category.name copy]];
        [value addObject:[category.link copy]];
        [value addObject:[NSNumber numberWithInteger:category.forum]];
        [value addObject:[category.headerIconUrl copy]];
        [value addObject:[category.content copy]];
        [value addObject:[NSNumber numberWithInteger:category.passwordRequired]];
        [value addObject:[NSNumber numberWithInteger:category.click]];
        
        [values addObject:[NSArray arrayWithArray:value]];
    }
    
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:columnNames,
                                 DBDATA_STRING_VALUES:[NSArray arrayWithArray:values]
                                 };
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_CATEGORY withInfo:infoInsert];
    if(retDBData == DB_EXECUTE_OK) {
        NSLog(@"---Category : insert/update OK");
    }
    else {
        NSLog(@"#error ---Category : insert/update FAILED");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBCategoryUpdates:(NSArray*)categories
{
    BOOL result = YES;
    
    NSMutableArray<NSDictionary*> *infosUpdate = [[NSMutableArray alloc] init];
    NSMutableArray<NSDictionary*> *infosQuery = [[NSMutableArray alloc] init];
    
    for(Category *category in categories) {
        [infosUpdate addObject:@{
                                 @"link":category.link,
                                 @"forum":[NSNumber numberWithInteger:category.forum],
                                 @"headerIconUrl":category.headerIconUrl,
                                 @"content":category.content,
                                 @"passwordRequired":[NSNumber numberWithBool:category.passwordRequired]
                                 }
         ];
        [infosQuery addObject:@{@"name":category.name}];
    }
    
    NSInteger retDBData = [self.dbData DBDataUpdatesDBName:DBNAME_HOST toTable:TABLENAME_CATEGORY withInfosUpdate:infosUpdate withInfosQuery:infosQuery];
    if(retDBData != DB_EXECUTE_OK) {
        NSLog(@"#error - DBDataUpdateAdd1DBName");
        result = NO;
    }
    
    return result;
}


-     (BOOL)configDBCategoryAddClick:(NSString*)cateogry
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataUpdateAdd1DBName:DBNAME_HOST toTable:TABLENAME_CATEGORY withColumnName:@"click" withInfoQuery:@{@"name":cateogry}];
    if(retDBData != DB_EXECUTE_OK) {
        NSLog(@"#error - DBDataUpdateAdd1DBName");
        result = NO;
    }
    
    return result;
}










//DetailHistory
- (DetailHistory*)configDBDetailHistoryGetByTid:(NSInteger)tid
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_DETAILHISTORY
                                                   columnNames:nil
                                                     withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    DetailHistory *detailHistory = nil ;
    if(count <= 0) {
        NSLog(@"configDBDetailHistoryGetByTid none.")
    }
    else if(count > 1) {
        NSLog(@"#error - ")
    }
    else {
        NSArray *tidArray                   = queryResult[@"tid"];
        NSArray *createdAtForDisplayArray   = queryResult[@"createdAtForDisplay"];
        NSArray *createdAtForLoadedArray    = queryResult[@"createdAtForLoaded"];
        
        if([self.dbData DBDataCheckCountOfArray:@[tidArray, createdAtForDisplayArray, createdAtForLoadedArray] withCount:count]) {
            detailHistory = [[DetailHistory alloc] init];
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(detailHistory.tid, tidArray, 0, 0)
            ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(detailHistory.createdAtForDisplay, createdAtForDisplayArray, 0, 0)
            ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(detailHistory.createdAtForLoaded, createdAtForLoadedArray, 0, 0)
        }
    }
    
    return detailHistory;
}


- (BOOL)configDBDetailHistoryUpdate:(DetailHistory*)detailHistory;
{
    BOOL result = YES;
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"tid", @"createdAtForDisplay", @"createdAtForLoaded"],
                                 DBDATA_STRING_VALUES:@[@[[NSNumber numberWithInteger:detailHistory.tid], [NSNumber numberWithLongLong:detailHistory.createdAtForDisplay], [NSNumber numberWithLongLong:detailHistory.createdAtForLoaded]]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_DETAILHISTORY withInfo:infoInsert orReplace:YES];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


//DetailHistory
- (NSArray<DetailRecord*> *)configDBDetailRecordGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_DETAILRECORD
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY browseredAt DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *browseredAtArray   = queryResult[@"browseredAt"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, browseredAtArray] withCount:count]) {
            return nil;
        }
        
        NSMutableArray *arrayReturnM = [[NSMutableArray alloc] init];
        
        for(NSInteger index = 0; index < count; index++) {
            
            DetailRecord *detailrecord = [[DetailRecord alloc] init];
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(detailrecord.tid, tidArray, index, 0)
            ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(detailrecord.browseredAt, browseredAtArray, index, 0)
            
            [arrayReturnM addObject:detailrecord];
        }
        
        arrayReturn = [NSArray arrayWithArray:arrayReturnM];
    }
    
    return arrayReturn;
}


- (BOOL)configDBDetailRecordAdd:(DetailRecord*)detailrecord
{
    BOOL result = YES;
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"tid", @"browseredAt"],
                                 DBDATA_STRING_VALUES:@[@[[NSNumber numberWithInteger:detailrecord.tid], [NSNumber numberWithLongLong:detailrecord.browseredAt]]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_DETAILRECORD withInfo:infoInsert orReplace:NO];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBDetailRecordDelete:(DetailRecord*)detailrecord
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST
                                                  toTable:TABLENAME_DETAILRECORD
                                                withQuery:@{@"tid":[NSNumber numberWithInteger:detailrecord.tid],
                                                            @"browseredAt":[NSNumber numberWithLongLong:detailrecord.browseredAt]
                                                            }];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBDetailRecordDeleteByTid:(NSInteger)tid
{
    BOOL result = YES;
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST
                                                  toTable:TABLENAME_DETAILRECORD
                                                withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBDetailRecordDeleteByLastDay:(NSInteger)days
{
    BOOL result = YES;

    long long msec = MSEC_NOW;
    msec = msec / MSEC_1DAY * MSEC_1DAY;
    msec -= days * MSEC_1DAY;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE browseredAt<%lld", TABLENAME_DETAILRECORD, msec];
    NSInteger retDBData = [self.dbData DBDataUpdateDBName:DBNAME_HOST withSqlString:sql andArgumentsInArray:nil];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


//Collection.
- (NSArray*)configDBCollectionGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_COLLECTION
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY collectedAt DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *collectedAtArray   = queryResult[@"collectedAt"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, collectedAtArray] withCount:count]) {
            return nil;
        }
        
        NSMutableArray *arrayReturnM = [[NSMutableArray alloc] init];
        
        for(NSInteger index = 0; index < count; index++) {
            
            Collection *collection = [[Collection alloc] init];
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(collection.tid, tidArray, index, 0)
            ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(collection.collectedAt, collectedAtArray, index, 0)
            
            [arrayReturnM addObject:collection];
        }
        
        arrayReturn = [NSArray arrayWithArray:arrayReturnM];
    }
    
    return arrayReturn;
}


- (Collection*)configDBCollectionGetByTid:(NSInteger)tid
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_COLLECTION
                                                   columnNames:nil
                                                     withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    Collection *collection = nil;
    
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *collectedAtArray   = queryResult[@"collectedAt"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, collectedAtArray] withCount:count]) {
            return nil;
        }
        
        collection = [[Collection alloc] init];
        
        ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(collection.tid, tidArray, 0, 0)
        ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(collection.collectedAt, collectedAtArray, 0, 0)
    }
    
    return collection;
}


//不能添加已存在的tid.
- (BOOL)configDBCollectionAdd:(Collection*)collection
{
    BOOL result = YES;
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"tid", @"collectedAt"],
                                 DBDATA_STRING_VALUES:@[@[[NSNumber numberWithInteger:collection.tid], [NSNumber numberWithLongLong:collection.collectedAt]]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withInfo:infoInsert];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBCollectionRemove:(NSInteger)tid
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBCollectionRemoveByTidArray:(NSArray*)tidArray
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withQuery:@{@"tid":tidArray}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


//Post.
- (NSArray*)configDBPostGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_POST
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY tid DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *postedAtArray   = queryResult[@"postedAt"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, postedAtArray] withCount:count]) {
            return nil;
        }
        
        NSMutableArray *arrayReturnM = [[NSMutableArray alloc] init];
        for(NSInteger index = 0; index < count; index++) {
            
            Post *post = [[Post alloc] init];
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(post.tid, tidArray, index, 0)
            ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(post.postedAt, postedAtArray, index, 0)
            
            [arrayReturnM addObject:post];
        }
        
        arrayReturn = [NSArray arrayWithArray:arrayReturnM];
    }
    
    return arrayReturn;
}


- (Post*)configDBPostGetByTid:(NSInteger)tid
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_POST
                                                   columnNames:nil
                                                     withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    Post *post = nil;
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *postedAtArray   = queryResult[@"postedAt"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, postedAtArray] withCount:count]) {
            return nil;
        }
        
        post = [[Post alloc] init];
        
        ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(post.tid, tidArray, 0, 0)
        ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(post.postedAt, postedAtArray, 0, 0)
    }
    
    return post;
}


//不能添加已存在的tid.
- (BOOL)configDBPostAdd:(Post*)post
{
    BOOL result = YES;
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"tid", @"postedAt"],
                                 DBDATA_STRING_VALUES:@[@[[NSNumber numberWithInteger:post.tid], [NSNumber numberWithLongLong:post.postedAt]]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_POST withInfo:infoInsert];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBPostRemove:(NSInteger)tid
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_POST withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBPostRemoveByTidArray:(NSArray*)tidArray
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_POST withQuery:@{@"tid":tidArray}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}




//Reply.
- (NSArray*)configDBReplyGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_REPLY
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY tid DESC"}];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *repliedAtArray     = queryResult[@"repliedAt"];
        NSArray *tidBelongToArray   = queryResult[@"tidBelongTo"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, repliedAtArray, tidBelongToArray] withCount:count]) {
            return nil;
        }
        
        NSMutableArray *arrayReturnM = [[NSMutableArray alloc] init];
        
        for(NSInteger index = 0; index < count; index++) {
            
            Reply *reply = [[Reply alloc] init];
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(reply.tid, tidArray, index, 0)
            ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(reply.repliedAt, repliedAtArray, index, 0)
            ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(reply.tidBelongTo, tidBelongToArray, index, 0)
            
            [arrayReturnM addObject:reply];
        }
        
        arrayReturn = [NSArray arrayWithArray:arrayReturnM];
    }
    
    return arrayReturn;
}


- (Reply*)configDBReplyGetByTid:(NSInteger)tid
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_REPLY
                                                   columnNames:nil
                                                     withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    Reply *reply = nil;
    
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *repliedAtArray     = queryResult[@"repliedAt"];
        NSArray *tidBelongToArray   = queryResult[@"tidBelongTo"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, repliedAtArray] withCount:count]) {
            return nil;
        }
        
        reply = [[Reply alloc] init];
        
        ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(reply.tid, tidArray, 0, 0)
        ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(reply.repliedAt, repliedAtArray, 0, 0)
        ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(reply.tidBelongTo, tidBelongToArray, 0, 0)
    }
    
    return reply;
}


//不能添加已存在的tid.
- (BOOL)configDBReplyAdd:(Reply*)reply
{
    BOOL result = YES;
    
    NSLog(@"vbn %@", reply);
    
    //#如果更新的话, 则click会刷新到0.
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"tid", @"repliedAt", @"tidBelongTo"],
                                 DBDATA_STRING_VALUES:@[@[[NSNumber numberWithInteger:reply.tid], [NSNumber numberWithLongLong:reply.repliedAt], [NSNumber numberWithInteger:reply.tidBelongTo]]]
                                 };
    
    
    NSLog(@"vbn %@", infoInsert);
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_REPLY withInfo:infoInsert];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBReplyRemove:(NSInteger)tid
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_REPLY withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBReplyRemoveByTidArray:(NSArray*)tidArray
{
    BOOL result = YES;
    
    NSLog(@"tidArray:%@", tidArray);
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_REPLY withQuery:@{@"tid":tidArray}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBReplyRemoveByTopicTidArray:(NSArray*)tidArray
{
    BOOL result = YES;
    
    NSLog(@"tidArray:%@", tidArray);
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_REPLY withQuery:@{@"tidBelongTo":tidArray}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    return result;
}


- (BOOL)configDBRecordAdds:(NSArray*)postDatas
{
    BOOL result = YES;
    
    NSMutableArray *tidAll = [NSMutableArray arrayWithCapacity:postDatas.count];
    for(PostData *postData in postDatas) {
        [tidAll addObject:[NSNumber numberWithInteger:postData.tid]];
    }

    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_RECORD
                                                   columnNames:@[@"tid", @"jsonstring"]
                                                     withQuery:@{@"tid":tidAll}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSMutableIndexSet *indexSetKeep = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, postDatas.count)];
    
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *jsonstringkArray   = queryResult[@"jsonstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[tidArray, jsonstringkArray] withCount:count]) {
            NSInteger indexPostData = 0;
            for(PostData *postData in postDatas) {
                for(NSInteger index = 0; index < count; index ++) {
                    NSInteger tid = 0;
                    NSString *jsonstring = nil;
                    ASSIGN_INTEGER_VALUE_FROM_ARRAYMEMBER(tid, tidArray, index, tid);
                    ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(jsonstring, jsonstringkArray, index, @"NAN");
                    
                    if(postData.tid == tid) {
                        //NSLog(@"---RECORD : [%zd] found.", postData.tid);
                        if([postData.jsonstring isEqualToString:jsonstring]) {
                            NSLog(@"---RECORD : [%zd] found and equal.", postData.tid);
                            [indexSetKeep removeIndex:indexPostData];
                        }
                        else {
                            NSLog(@"---RECORD : [%zd] found xxx not equal.", postData.tid);
                            NSLog(@"--- diff info : %@", [NSString diffFromString:postData.jsonstring toString:jsonstring referentceLineNumber:3]);
                        }
                        
                        break;
                    }
                }
                
                indexPostData ++;
            }
        }
    }
    
    if(indexSetKeep.count == postDatas.count) {
        NSLog(@"---RECORD : insert/update ALL");
    }
    else if(indexSetKeep.count == 0) {
        NSLog(@"---RECORD : insert/update NONE");
        postDatas = nil;
    }
    else {
        NSLog(@"---RECORD : insert/update partical %zd/%zd", indexSetKeep.count, postDatas.count);
        postDatas = [postDatas objectsAtIndexes:indexSetKeep];
    }
    
    if(postDatas) {
        //构建insert的NSDictionary参数.
        NSArray *columnNames = @[@"tid", @"tidBelongTo", @"createdAt", @"updatedAt", @"jsonstring"];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for(PostData *postData in postDatas) {
            NSMutableArray *value = [NSMutableArray arrayWithCapacity:columnNames.count];
            [value addObject:[NSNumber numberWithInteger:postData.tid]];
            [value addObject:[NSNumber numberWithInteger:postData.tidBelongTo]];
            [value addObject:[NSNumber numberWithLongLong:postData.createdAt]];
            [value addObject:[NSNumber numberWithLongLong:postData.updatedAt]];
            [value addObject:[postData.jsonstring copy]];
            
            [values addObject:[NSArray arrayWithArray:value]];
        }
        
        NSDictionary *infoInsert = @{
                                     DBDATA_STRING_COLUMNS:columnNames,
                                     DBDATA_STRING_VALUES:[NSArray arrayWithArray:values]
                                     };
        NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfo:infoInsert orReplace:YES];
        if(retDBData == DB_EXECUTE_OK) {
            NSLog(@"---RECORD : insert/update OK");
        }
        else {
            NSLog(@"---RECORD : insert/update FAILED");
            result = NO;
        }
    }

    return result;
}


- (NSArray*)configDBRecordGets:(NSArray*)tidGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_RECORD
                                                   columnNames:nil
                                                     withQuery:@{@"tid":tidGets}
                                                     withLimit:nil];
    NSInteger count = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *tidArray           = queryResult[@"tid"];
        NSArray *jsonstringArray    = queryResult[@"jsonstring"];
        
        if(![self.dbData DBDataCheckCountOfArray:@[tidArray, jsonstringArray] withCount:count]) {
            return nil;
        }
    }
    
    NSArray *tidArray           = queryResult[@"tid"];
    NSArray *jsonstringArray    = queryResult[@"jsonstring"];
    
    NSMutableArray *arrayPostDataM = [[NSMutableArray alloc] init];
    for(NSNumber *tidNumber in tidGets) {
        PostData *postData = nil;
        
        for(NSInteger indexCount = 0; indexCount < count; indexCount ++) {
            if([tidNumber isEqual:tidArray[indexCount]]) {
                NSLog(@"configDBRecordGets tid [%@] got", tidNumber);
                
                postData = [PostData fromString:jsonstringArray[indexCount] atPage:0];
                if(postData) {
                    postData.type = PostDataTypeLocal;
                }
                else {
                    postData = [PostData fromOnlyTid:[tidNumber integerValue]];
                    NSLog(@"jsonstring parsed failed. (%@)", jsonstringArray[indexCount]);
                }
                
                break;
            }
        }
        
        if(!postData) {
            NSLog(@"not find the record.");
            postData = [PostData fromOnlyTid:[tidNumber integerValue]];
        }
        
        [arrayPostDataM addObject:postData];
    }
    
    arrayReturn = [NSArray arrayWithArray:arrayPostDataM];
    
    return arrayReturn;
}


- (NSArray<NotShowUid*> *)configDBNotShowUidGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_NOTSHOWUID
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:nil];
    NSArray<NSDictionary*> *queryResultArray = [self.dbData queryResultDictionaryToArray:queryResult];
    
    NSMutableArray<NotShowUid*> *notShowUidsM = [[NSMutableArray alloc] init];
    
    if(queryResultArray.count > 0) {
        NotShowUid *notShowUid = nil;
        notShowUid = [[NotShowUid alloc] initWithDictionary:queryResultArray[0]];
        [notShowUidsM addObject:notShowUid];
    }
    
    return [NSArray arrayWithArray:notShowUidsM];
}


- (NotShowUid*)configDBNotShowUidGet:(NSString*)uid
{
    if(!uid) {
        return nil;
    }
    
    if(self.notShowUids) {
        for(NotShowUid *obj in self.notShowUids) {
            if([obj.uid isEqualToString:uid]) {
                return obj;
            }
        }
        
        return nil;
    }
    
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_NOTSHOWUID
                                                   columnNames:nil
                                                     withQuery:@{@"uid":uid}
                                                     withLimit:nil];
    NSArray<NSDictionary*> *queryResultArray = [self.dbData queryResultDictionaryToArray:queryResult];
    
    NotShowUid *notShowUid = nil;
    if(queryResultArray.count == 1) {
        notShowUid = [[NotShowUid alloc] initWithDictionary:queryResultArray[0]];
    }
    
    return notShowUid;
}


- (BOOL)configDBNotShowUidAdd:(NotShowUid*)notShowUid
{
    BOOL result = YES;
    
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"uid", @"commitedAt", @"comment"],
                                 DBDATA_STRING_VALUES:@[@[notShowUid.uid, [NSNumber numberWithLongLong:notShowUid.commitedAt], notShowUid.comment]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_NOTSHOWUID withInfo:infoInsert];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    [self.notShowUids addObject:notShowUid];
    
    return result;
}


- (BOOL)configDBNotShowUidRemove:(NSString*)uid
{
    if(!uid) {
        return NO;
    }
    
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_NOTSHOWUID withQuery:@{@"uid":uid}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    for(NotShowUid *obj in self.notShowUids) {
        if([obj.uid isEqualToString:uid]) {
            [self.notShowUids removeObject:obj];
            break;
        }
    }
    
    return result;
}


- (NSArray<NotShowTid*> *)configDBNotShowTidGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_NOTSHOWTID
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:nil];
    NSArray<NSDictionary*> *queryResultArray = [self.dbData queryResultDictionaryToArray:queryResult];
    
    NSMutableArray<NotShowTid*> *notShowTidsM = [[NSMutableArray alloc] init];
    
    if(queryResultArray.count > 0) {
        NotShowTid *notShowTid = nil;
        notShowTid = [[NotShowTid alloc] initWithDictionary:queryResultArray[0]];
        [notShowTidsM addObject:notShowTid];
    }
    
    return [NSArray arrayWithArray:notShowTidsM];
}



- (NotShowTid*)configDBNotShowTidGet:(NSInteger)tid
{
    if(self.notShowTids) {
        for(NotShowTid *obj in self.notShowTids) {
            if(obj.tid == tid) {
                return obj;
            }
        }
        
        return nil;
    }
    
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_NOTSHOWTID
                                                   columnNames:nil
                                                     withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}
                                                     withLimit:nil];
    NSArray<NSDictionary*> *queryResultArray = [self.dbData queryResultDictionaryToArray:queryResult];
    
    NotShowTid *notShowTid = nil;
    if(queryResultArray.count == 1) {
        notShowTid = [[NotShowTid alloc] initWithDictionary:queryResultArray[0]];
    }
    
    return notShowTid;
}


- (BOOL)configDBNotShowTidAdd:(NotShowTid*)notShowTid
{
    BOOL result = YES;
    
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"tid", @"commitedAt", @"comment"],
                                 DBDATA_STRING_VALUES:@[@[[NSNumber numberWithInteger:notShowTid.tid], [NSNumber numberWithLongLong:notShowTid.commitedAt], notShowTid.comment]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_NOTSHOWTID withInfo:infoInsert];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    [self.notShowTids addObject:notShowTid];
    
    return result;
}


- (BOOL)configDBNotShowTidRemove:(NSInteger)tid
{
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_NOTSHOWTID withQuery:@{@"tid":[NSNumber numberWithInteger:tid]}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    for(NotShowTid *obj in self.notShowTids) {
        if(obj.tid == tid) {
            [self.notShowTids removeObject:obj];
            break;
        }
    }

    
    return result;
}


- (NSArray<Attent*> *)configDBAttentGets
{
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_ATTENT
                                                   columnNames:nil
                                                     withQuery:nil
                                                     withLimit:nil];
    NSArray<NSDictionary*> *queryResultArray = [self.dbData queryResultDictionaryToArray:queryResult];
    
    NSMutableArray<Attent*> *attentsM = [[NSMutableArray alloc] init];
    
    if(queryResultArray.count > 0) {
        Attent *attent = nil;
        attent = [[Attent alloc] initWithDictionary:queryResultArray[0]];
        [attentsM addObject:attent];
    }
    
    return [NSArray arrayWithArray:attentsM];
}



- (Attent*)configDBAttentGet:(NSString*)uid
{
    if(!uid) {
        return nil;
    }
    
    if(self.attents) {
        for(Attent *obj in self.attents) {
            if([obj.uid isEqualToString:uid]) {
                return obj;
            }
        }
        
        return nil;
    }
    
    //从数据库查询.
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_ATTENT
                                                   columnNames:nil
                                                     withQuery:@{@"uid":uid}
                                                     withLimit:nil];
    NSArray<NSDictionary*> *queryResultArray = [self.dbData queryResultDictionaryToArray:queryResult];
    
    Attent *attent = nil;
    if(queryResultArray.count == 1) {
        attent = [[Attent alloc] initWithDictionary:queryResultArray[0]];
    }
    
    return attent;
}


- (BOOL)configDBAttentAdd:(Attent*)attent
{
    BOOL result = YES;
    
    NSDictionary *infoInsert = @{
                                 DBDATA_STRING_COLUMNS:@[@"uid", @"commitedAt", @"comment"],
                                 DBDATA_STRING_VALUES:@[@[attent.uid, [NSNumber numberWithLongLong:attent.commitedAt], attent.comment]]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_ATTENT withInfo:infoInsert];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    [self.attents addObject:attent];

    return result;
}


- (BOOL)configDBAttentRemove:(NSString*)uid
{
    if(!uid) {
        return NO;
    }
    
    BOOL result = YES;
    
    NSInteger retDBData = [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_ATTENT withQuery:@{@"uid":uid}];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    for(Attent *obj in self.attents) {
        if([obj.uid isEqualToString:uid]) {
            [self.attents removeObject:obj];
            break;
        }
    }
    
    return result;
}









//清除数据库. 需仅适用于开发者环境.
- (void)removeAll
{
    [self.dbData removeAll];
}
































































































































- (NSString*)generateSign:(NSDictionary*)argument
{
    NSArray *allkeys = argument.allKeys;
    allkeys = [allkeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *signRAW = [NSMutableString stringWithString:self.appSecret];
    for(NSString *key in allkeys) {
        [signRAW appendFormat:@"%@%@", key, argument[key]];
    }
    [signRAW appendString:self.appSecret];
    NSString *sign = [signRAW calculateMD5];
    
    NS0Log(@"sign : [%@] -> [%@]", signRAW, sign);
    
    return sign;
}


- (NSString*)generateArgumentWithAuthInfoAndQueryArgument:(NSDictionary*)argument1
{
    NSMutableDictionary *argumentWithAppendAuth = [NSMutableDictionary dictionaryWithDictionary:argument1];
    [argumentWithAppendAuth setObject:self.appkey forKey:@"appkey"];
    [argumentWithAppendAuth setObject:self.hwid   forKey:@"hwid"];
    if(self.token) {
        [argumentWithAppendAuth setObject:self.token   forKey:@"token"];
    }
    
    NSString *sign = [self generateSign:argumentWithAppendAuth];
    [argumentWithAppendAuth setObject:sign forKey:@"sign"];
    
    
    NSArray *allkeys = argumentWithAppendAuth.allKeys;
    allkeys = [allkeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *argumentString = [NSMutableString stringWithString:@""];
    for(NSString *key in allkeys) {
        [argumentString appendFormat:@"%@=%@", key, argumentWithAppendAuth[key]];
        if([key isEqual:[allkeys lastObject]]) {
            
        }
        else {
            [argumentString appendString:@"&"];
        }
    }
    
    return [NSString stringWithString:argumentString];
}


- (NSString*)generateRequestURL:(NSString*)query andArgument:(NSDictionary*)argument
{
    NSString *urlHostString = @"http://api.kukuku.cc";
    NSString *urlStringm = [NSString stringWithFormat:@"%@/%@?%@",
                            urlHostString,
                            query,
                           [self generateArgumentWithAuthInfoAndQueryArgument:argument]
                           ];
    
    NSString *urlString = [NSString stringWithString:urlStringm];
    
    NSLog(@"generateRequestURL : [%@]", urlString);
    return urlString;
}


- (NSData*)sendSynchronousRequestTo:(NSString*)query andArgument:(NSDictionary*)argument
{
    NSString *urlString = [self generateRequestURL:query andArgument:argument];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"request URL : %@", urlString);
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    mutableRequest.HTTPMethod = @"GET";
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:&response error:&error];
    
    if(error || data.length == 0) {
        NSLog(@"%@", error);
        data = nil;
    }
    else {
        NSLog(@"%@ : \n%@", query, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    
    return data;
}


- (NSDictionary*)sendSynchronousRequestAndJsonParseTo:(NSString*)query andArgument:(NSDictionary*)argument;
{
    NSDictionary *dict = nil;
    NSData *data = [self sendSynchronousRequestTo:query andArgument:argument];
    if(data) {
        
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if([dict isKindOfClass:[NSDictionary class]]) {
            
        }
        else {
            NSLog(@"#error - sendSynchronousRequestTo return data json parse to NSDictionary failed.");
            dict = nil;
        }
    }
    else {
        NSLog(@"#error - sendSynchronousRequestTo return nil.");
    }
 
    return dict;
}


- (BOOL)checkResponseDict:(NSDictionary*)dict
{
    if([[dict objectForKey:@"code"] isEqual:[NSNumber numberWithInteger:200]]) {
        return YES;
    }
    else {
        return NO;
    }
}


#if 0
+ (NSString*)deviceUuid
{
    NSString *deviceUuid = @"Uuidnotdefine";
    
    NSString *uuidkeychain = [SSKeychain passwordForService:@"app.Ku岛Fun" account:@"uuid"];
    if(uuidkeychain) {
        NSLog(@"deviceUuid use keychain <%@>.", uuidkeychain);
        deviceUuid = uuidkeychain;
    }
    else {
        NSString * result = [NSString deviceUuid];

        [SSKeychain setPassword:result forService:@"app.Ku岛Fun" account:@"uuid"];
        NSLog(@"deviceUuid generate and set keychain <%@>", result);
        
        deviceUuid = result;
    }
    
    return deviceUuid;
}
#endif





- (void)authAsync:(void(^)(BOOL result))handle
{
    NSLog(@"authAsync");
    
    __block NSString *query = nil;
    //CreateNewIfNotExist
    if(!self.token) {
        query = @"v2/token/createNewIfNotExist";
        [self GET:query
      andArgument:nil
         progress:nil
          success:^(NSURLSessionDataTask *task, NSData *responseData, NSDictionary *dictionary) {
              self.token = [NSString stringWithString:dictionary[@"token"]];
              [self configDBSettingKVSet:@"token" withValue:self.token];
              NSLog(@"auth <%@> token got : %@", query, self.token);
              
              query = @"v2/system/healthy";
              [self GET:query
            andArgument:nil
               progress:nil
                success:^(NSURLSessionDataTask *task, NSData *responseData, NSDictionary *dictionary) {
                    if([self checkResponseDict:dictionary]) {
                        self.authResult = YES;
                        if(handle) {
                            handle(YES);
                        }
                    }
                    else {
                        NSLog(@"#error - auth <%@> response failed.", query);
                        if(handle) {
                            handle(NO);
                        }
                    }
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"#error - GET <%@> error : %@", query, error);
                    if(handle) {
                        handle(NO);
                    }
                }
               ];
          }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"#error - GET <%@> error : %@", query, error);
             if(handle) {
                 handle(NO);
             }
         }
         ];
    }
    else {
        query = @"v2/system/healthy";
        [self GET:query
      andArgument:nil
         progress:nil
          success:^(NSURLSessionDataTask *task, NSData *responseData, NSDictionary *dictionary) {
              if([self checkResponseDict:dictionary]) {
                  self.authResult = YES;
                  if(handle) {
                      handle(YES);
                  }
              }
              else {
                  NSLog(@"#error - auth <%@> response failed.", query);
                  if(handle) {
                      handle(NO);
                  }
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"#error - GET <%@> error : %@", query, error);
              if(handle) {
                  handle(NO);
              }
          }
         ];
    }
}





- (void)updateCategoryAsync:(void(^)(BOOL result, NSInteger total, NSInteger updateNumber))handle
{
    __weak typeof(self) weakSelf = self;
    
    NSString *query = @"v2/group/list";
    NSDictionary *argument = nil;
    
    [self GET:query
  andArgument:argument
     progress:nil
      success:^(NSURLSessionDataTask *task, NSData *responseData, NSDictionary *dictionary) {
          
          NSInteger total         = self.categories.count;
          NSInteger updateNumber  = 0;
          BOOL result             = YES;
          NSMutableArray *categoriesUpdate = [[NSMutableArray alloc] init];
          NSMutableArray *categoriesInsert = [[NSMutableArray alloc] init];

          if([[dictionary objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
              NSArray *result = [dictionary objectForKey:@"result"];
              for(NSDictionary *dict in result) {
                  if(![dict isKindOfClass:[NSDictionary class]]) {
                      NSLog(@"#error - format.");
                      continue;
                  }
                  
                  Category *category = [weakSelf configDBCategoryParseFromDict:dict onHostName:[weakSelf configDBHostsGetCurrent].hostname];
                  if(!category) {
                      NSLog(@"#error - configDBCategoryParseFromDict <%@>.", [NSString stringFromNSDictionary:dict]);
                      continue;
                  }
                  
                  Category *categoryDB = nil;
                  for(Category *c in self.categories) {
                      if([c.name isEqualToString:category.name]) {
                          categoryDB = c;
                          break;
                      }
                  }
                  
                  if(!categoryDB) {
                      [categoriesInsert addObject:category];
                      total ++;
                      updateNumber ++;
                  }
                  else {
                      if([category isEqual:categoryDB]) {
                          
                      }
                      else {
                          NSLog(@"parsed : %@", category);
                          NSLog(@"stored : %@", categoryDB);
                          [categoriesUpdate addObject:category];
                          updateNumber ++;
                      }
                  }
                  
              }
              
              BOOL refresh = NO;
              
              if(categoriesInsert.count > 0) {
                  [weakSelf configDBCategoryInserts:categoriesInsert];
                  refresh = YES;
              }
              
              if(categoriesUpdate.count > 0) {
                  [weakSelf configDBCategoryUpdates:categoriesUpdate];
                  refresh = YES;
              }
          }
          else {
              NSLog(@"#error - <%@> response nil.", query);
              result = NO;
          }

          if(handle) {
              handle(result, total, updateNumber);
          }
     }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          if(handle) {
              handle(NO, self.categories.count, 0);
          }
    }];
}
































































































































































































































































































































- (AFHTTPSessionManager *)HTTPSessionManager
{
    if(!self.session) {
        self.session = [AFHTTPSessionManager manager];
        [self.session setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    }
    
    
    
    return self.session;
}
   

- (dispatch_queue_t)postDataRetreatQueue
{
    if(!self.postDataRetreatQueueInstance) {
        self.postDataRetreatQueueInstance = dispatch_queue_create("my.postdataretreat.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self.postDataRetreatQueueInstance;
}


- (void)GET:(NSString*)query
andArgument:(NSDictionary*)argument
   progress:(void (^)(NSProgress *downloadProgress))downloadProgressHandle
    success:(void (^)(NSURLSessionDataTask *task, NSData * responseData, NSDictionary * dictionary))successHandle
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureHandle
{
    NSString *urlString = [self generateRequestURL:query andArgument:argument];
    [HTTPMANAGE GET:urlString
         parameters:nil
           progress:^(NSProgress * _Nonnull downloadProgress) {
               if(downloadProgress) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       downloadProgressHandle(downloadProgress);
                   });
               }
           }
     
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"Networking GET : success");
                if([responseObject isKindOfClass:[NSData class]]) {
                    LOG_POSTION
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    if([dictionary isKindOfClass:[NSDictionary class]]) {
                        LOG_POSTION
                        if(successHandle) {
                            LOG_POSTION
                            successHandle(task, responseObject, dictionary);
                        }
                    }
                    else {
                        LOG_POSTION
                        if(failureHandle) {
                            NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"Data parse to NSDictionary error (%@)", responseObject] code:400 userInfo:nil];
                            failureHandle(task, error);
                        }
                        
                    }
                }
                else {
                    LOG_POSTION
                    if(failureHandle) {
                        NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"#error - responseObject not NSData.(%@)", [responseObject class]] code:400 userInfo:nil];
                        failureHandle(task, error);
                    }
                }
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Networking GET : failure");
                if(failureHandle) {
                    failureHandle(task, error);
                }
            }
     ];
}


- (void)test
{

    
}




@end



