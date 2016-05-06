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




#define DBNAME_CONFIG           @"config"
#define DBNAME_HOST             ((Host*)[self.hosts objectAtIndex:self.hostIndex]).hostname



#define TABLENAME_HOSTS         @"hosts"
#define TABLENAME_HOSTINDEX     @"hostindex"
#define TABLENAME_EMOTICON      @"emoticon"
#define TABLENAME_DRAFT         @"draft"
#define TABLENAME_COLOR         @"color"
#define TABLENAME_FONT          @"font"

#define TABLENAME_SETTINGKV     @"settingkv"
#define TABLENAME_CATEGORY      @"category"
#define TABLENAME_DETAILHISTORY @"detailhistory"
#define TABLENAME_RECORD        @"record"
#define TABLENAME_COLLECTION    @"collection"
#define TABLENAME_POST          @"post"
#define TABLENAME_REPLY         @"reply"
#define TABLENAME_NOTSHOWUID    @"notshowuid"
#define TABLENAME_NOTSHOWTID    @"notshowtid"
#define TABLENAME_ATTENT        @"attent"





@interface AppConfig ()


//具体的数据库操作尽量通过DBData.
@property (nonatomic, strong) DBData *dbData;

//host配置缓存.
@property (strong,nonatomic) NSArray *hosts;
@property (assign,nonatomic) NSInteger hostIndex ;

//config缓存.
@property (nonatomic, strong)   NSMutableArray *emoticons;
@property (nonatomic, strong)   NSMutableArray *drafts;
@property (nonatomic, strong)   NSMutableArray *colors;
@property (nonatomic, strong)   NSMutableArray *fonts;



//host相关缓存.
@property (nonatomic, strong) NSMutableDictionary *dictSettingKV;

//@property (nonatomic, strong)   NSMutableArray *categories;



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
        
        self.dictSettingKV = [[NSMutableDictionary alloc] init];
        
        self.dbData = [[DBData alloc] init];
        //建立或者升级数据库.
        [self configdbBuildTable];
        
        //数据库输入初始数据.
        [self configDBInitData];
        
        //测试.
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

    //增加或更新预置值.
    //color 加入一些预置.
    NSDictionary *infoInsertColors = @{
                                       DBDATA_STRING_COLUMNS:@[@"keyword", @"colorstring"],
                                       DBDATA_STRING_VALUES :@[
                                                                @[@"PostViewCellBackground",                @"#d0d0d0"],
                                                                @[@"PostViewCellBackground",                @"#d0d0d0"],
                                                                @[@"ThreadsViewControllerBackground",       @"purple"],
                                                                @[@"ViewControllerBackground",              @"#808080@60"],
                                                                @[@"BannerViewBackground",                  @"#a0a0a0@00"],
                                                                @[@"PostViewBackground",                    @"lightGray"],
                                                                @[@"PostTableViewBackground",               @"#ffffff@60"],
                                                                @[@"MenuActionBackground",                  @"blue"],
                                                                @[@"CreateViewControllerBackground",        @"white"],
                                                                @[@"ImageViewControllerBackground",         @"white"],
                                                                @[@"PostDataCellViewBackground",            @"white"],
                                                                @[@"ReplyCellBorderMainBackground",         @"red"],
                                                                @[@"ReplyCellBorder",                       @"#cccccc"],
                                                                @[@"LoadingViewBackground",                 @"black"],
                                                                @[@"draftTableViewBackground",              @"#eeeeee@80"],
                                                                @[@"CellTitleText",                         @"#000000@66"],
                                                                @[@"CellInfoText",                          @"#000000@66"],
                                                                @[@"CellInfoAdditionalText",                @"#000000@66"],
                                                                @[@"ThreadContentText",                     @"black"],
                                                                @[@"manageInfoText",                        @"red"],
                                                                @[@"otherInfoText",                         @"#000000@66"],
                                                                @[@"RefreshTint",                           @"red"],
                                                                @[@"BannerTopicText",                       @"black"],
                                                                @[@"BannerButtonMenuText",                  @"black"],
                                                                @[@"FootViewText",                          @"#000000@80"],
                                                                @[@"SettingTableViewBackground",            @"white"],
                                                                @[@"draftCellText",                         @"#000000@80"],
                                                                @[@"messageIndicationBackground",           @"#aaaaaa@60"],
                                                                @[@"messageIndicationText",                 @"#000000@60"],
                                                                @[@"CategoryCellBorder",                    @"#dddddd@56"],
                                                                @[@"DetailCellTopicBorder",                 @"red"],
                                                                @[@"DetailCellReplyBorder",                 @"#000011@20"],
                                                                @[@"EmoticonButtonBorder",                  @"#0000ff@10"],
                                                                @[@"AttachPictureBackground",               @"blue"],
                                                                @[@"default",                               @"orange"],
                                                                @[@"orange",                                @"orange"]
                                           
                                           ]
                                       };
  
    NSInteger retInsert = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_COLOR withInfo:infoInsertColors countReplace:YES];
    if(retInsert != DB_EXECUTE_OK) {
        NSLog(@"#error - insert %@ values FAILED.", TABLENAME_COLOR);
    }
    
    //font 加入一些预置.
    //wp : width percentage.
    //pt : pt
    NSDictionary *infoInsertFont = @{
                                       DBDATA_STRING_COLUMNS:@[@"keyword", @"fontstring"],
                                       DBDATA_STRING_VALUES:@[
                                                                @[@"PostTitle",                             @"wp0.036"],
                                                                @[@"PostContent",                           @"wp0.045"],
                                                                @[@"ButtonTopic",                           @"pt16.0"],
                                                                @[@"BannerButtonMenu",                      @"wp0.040"],
                                                                @[@"PopupView",                             @"pt16.0"],
                                                                @[@"draftCellText",                         @"small"],
                                                                @[@"ImageDownloadStatusLabel",              @"system"],
                                                                @[@"copy",                                  @"system"],
                                                                @[@"default",                               @"system"]
                                                             ]
                                       };
    
    retInsert = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_FONT withInfo:infoInsertFont countReplace:YES];
    if(retInsert != DB_EXECUTE_OK) {
        NSLog(@"#error - insert %@ values FAILED.", TABLENAME_FONT);
    }
    
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
    //current not used.
    
    
}


- (void)test
{
    //current not used.
    
    
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

#define ASSIGN_LONGLONG_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSNumber class]]) {varqwe = [arrayasd[indexzxc] longLongValue];}\
else {NSLog(@"#error - obj (%@) is not NSNumber class.", arrayasd[indexzxc]);varqwe = defaultqaz;}

#define ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(varqwe, arrayasd, indexzxc, defaultqaz) \
if([arrayasd[indexzxc] isKindOfClass:[NSString class]]) {varqwe = [arrayasd[indexzxc] copy];}\
else {NSLog(@"#error - obj (%@) is not NSString class.", arrayasd[indexzxc]);varqwe = defaultqaz;}



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
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_EMOTICON withInfo:infoInsert countReplace:YES];
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
        NSArray *contentArray      = queryResult[@"content"];
        NSArray *clickArray = queryResult[@"click"];
        
        if([self.dbData DBDataCheckCountOfArray:@[contentArray, clickArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                Draft *draft = [[Draft alloc] init];
                
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
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_CONFIG toTable:TABLENAME_DRAFT withInfo:infoInsert countReplace:YES];
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
        
        NSArray *keywordArray       = queryResult[@"keyword"];
        NSArray *colorstringArray   = queryResult[@"colorstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[keywordArray, colorstringArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                ColorItem *colorItem = [[ColorItem alloc] init];
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(colorItem.name, keywordArray, index, @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(colorItem.colorstring, colorstringArray, index, @"NAN")
                
                [arrayReturnM addObject:colorItem];
            }
            
            self.colors = arrayReturnM;
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
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
        
        NSArray *keywordArray       = queryResult[@"keyword"];
        NSArray *fontstringArray    = queryResult[@"fontstring"];
        
        if([self.dbData DBDataCheckCountOfArray:@[keywordArray, fontstringArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                FontItem *fontItem = [[FontItem alloc] init];
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(fontItem.name, keywordArray, index, @"NAN")
                ASSIGN_STRING_VALUE_FROM_ARRAYMEMBER(fontItem.fontstring, fontstringArray, index, @"NAN")
                
                [arrayReturnM addObject:fontItem];
            }
            
            self.fonts = arrayReturnM;
            arrayReturn = [NSArray arrayWithArray:arrayReturnM];
        }
    }
    
    return arrayReturn;
}

//settingkv.
- (NSString*)configDBSettingKVGet:(NSString*)key
{
    if([self.dictSettingKV objectForKey:key]) {
        return [self.dictSettingKV objectForKey:key];
    }
    
    NSString *valueString = @"NAN";
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
        NSLog(@"#error - ");
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
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_SETTINGKV withInfo:infoInsert countReplace:YES];
    if(DB_EXECUTE_OK != retDBData) {
        NSLog(@"#error - ");
        result = NO;
    }
    
    [self.dictSettingKV setObject:value forKey:key];
    
    return result;
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
    
    NSArray *arrayReturn = nil ;
    if(count > 0) {
        NSArray *nameArray      = queryResult[@"name"];
        NSArray *linkArray      = queryResult[@"link"];
        NSArray *forumArray     = queryResult[@"forum"];
        NSArray *clickArray     = queryResult[@"click"];
        
        if([self.dbData DBDataCheckCountOfArray:@[nameArray, linkArray, forumArray, clickArray] withCount:count]) {
            NSMutableArray *arrayReturnM = [NSMutableArray arrayWithCapacity:count];
            
            for(NSInteger index = 0; index < count ;  index ++) {
                Category *category = [[Category alloc] init];
                category.name           = nameArray[index];
                category.link           = linkArray[index];
                category.forum          = [forumArray[index] integerValue];
                category.click          = [clickArray[index] integerValue];
                
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
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_DETAILHISTORY withInfo:infoInsert countReplace:YES];
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
    
    NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withInfo:infoInsert countReplace:NO];
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
- (NSArray*)configDBPostGet
{
    NSLog(@"#error - not implement");
    return nil;
}


- (Post*)configDBPostGetByTid:(NSInteger)tid
{
    NSLog(@"#error - not implement");
    return nil;
}


- (BOOL)configDBPostAdd:(Post*)post
{
    BOOL result = YES;
    NSLog(@"#error - not implement");
    return result;
}





//Reply.
- (NSArray*)configDBReplyGet
{
    NSLog(@"#error - not implement");
    return nil;
}


- (Reply*)configDBPReplyGetByTid:(NSInteger)tid
{
    NSLog(@"#error - not implement");
    return nil;
}


- (BOOL)configDBReplyAdd:(Reply*)reply
{
    BOOL result = YES;
    NSLog(@"#error - not implement");
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
                        NSLog(@"---RECORD : [%zd] found.", postData.tid);
                        if([postData.jsonstring isEqualToString:jsonstring]) {
                            NSLog(@"---RECORD : [%zd] found and equal.", postData.tid);
                            [indexSetKeep removeIndex:indexPostData];
                        }
                        else {
                            NSLog(@"---RECORD : [%zd] found xxx not equal. \n[%zd]%@\n[%zd]%@", postData.tid, postData.jsonstring.length, postData.jsonstring, jsonstring.length, jsonstring);
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
        NSInteger retDBData = [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfo:infoInsert countReplace:YES];
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
    }
    
    return arrayReturn;
}


@end
