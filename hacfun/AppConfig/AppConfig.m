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

@property (strong,nonatomic) NSArray *hosts;
@property (assign,nonatomic) NSInteger hostIndex ;


@property (nonatomic, strong)   NSMutableArray *emoticons;
@property (nonatomic, strong)   NSMutableArray *drafts;
@property (nonatomic, strong)   NSMutableArray *colors;
@property (nonatomic, strong)   NSMutableArray *fonts;

@property (nonatomic, strong)   NSMutableArray *settingkvs;
@property (nonatomic, strong)   NSMutableArray *categories;



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
        self.hostIndex = hostIndex;
        
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
    
    NSDictionary *infoUpdate = @{
                                 @"tid":[NSNumber numberWithInteger:detailHistory.tid],
                                 @"createdAtForDisplay":[NSNumber numberWithLongLong:detailHistory.createdAtForDisplay],
                                 @"createdAtForLoaded":[NSNumber numberWithLongLong:detailHistory.createdAtForLoaded]
                                 };
    
    NSDictionary *infoQuery = @{
                                 @"tid":[NSNumber numberWithInteger:detailHistory.tid]
                                 };
    
    NSInteger retDBData = [self.dbData DBDataUpdateDBName:DBNAME_HOST toTable:TABLENAME_DETAILHISTORY withInfoUpdate:infoUpdate withInfoQuery:infoQuery];
    if(retDBData != DB_EXECUTE_OK) {
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
        
        arrayReturn = [self configDBRecordGets:tidArray];
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
                            NSLog(@"---RECORD : [%zd] found xxx not equal. \n%@\n%@", postData.tid, postData.jsonstring, jsonstring);
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
            
            for(NSInteger indexCount = 0; indexCount < count; indexCount ++) {
                if([tidNumber isEqual:tidArray[indexCount]]) {
                    NSLog(@"configDBRecordGets tid [%zd] got", tidNumber);
                    
                    PostData *postData = [PostData fromString:jsonstringArray[indexCount] atPage:0];
                    if(postData) {
                        postData.type = PostDataTypeLocal;
                    }
                    else {
                        postData = [PostData fromOnlyTid:[tidNumber integerValue]];
                    }
                    
                    [arrayPostDataM addObject:postData];
                    
                    break;
                }
            }
            
        }
        
        arrayReturn = [NSArray arrayWithArray:arrayPostDataM];
    }
    
    return arrayReturn;
}














#if 0

//===========================================================================================================
//id, collectedAt
- (NSInteger)configDBCollectionInsert:(NSDictionary*)infoInsert {
    [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withInfo:infoInsert countReplace:NO];
    
    return CONFIGDB_EXECUTE_OK;
}


- (BOOL)configDBCollectionDelete:(NSDictionary*)infoDelete {
    
    LOG_POSTION

    [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withQuery:infoDelete];
    
    return YES;
}




/*
  1.  连表查询. 
      联表查询语句.
      @"SELECT collection.id, collection.collectedAt, record.jsonstring FROM collection,record WHERE collection.id = record.id ORDER BY collection.collectedAt DESC"
      @"SELECT collection.id, record.jsonstring FROM collection,record WHERE collection.id = %@ AND collection.id = record.id"
  2.  分表查询, record单条查询.
  3.  分表查询, record多条查询. 查询后直接比对匹配.
  4.  分表查询, record多条查询. 查询后优化算法比对匹配.
  方法1破坏暂定的结构.
  使用方法3.
*/

- (NSDictionary*)configDBCollectionQuery:(NSDictionary*)infoQuery {
    NSLog(@"#error - not implement.");
    return nil;
    
#if 0
    if(!infoQuery) {
        infoQuery = @{@"orderString":@"ORDER BY collection.collectedAt DESC"};
    }
    NSArray *arrayCollections = [self.dbData DBDataQueryDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION columnNames:nil withQuery:infoQuery withLimit:@{}];NSMutableArray *idArrayM = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in arrayCollections) {
        [idArrayM addObject:[dict objectForKey:@"tid"]];
    }
    NSLog(@"qwerty : arrayCollections %@", arrayCollections);
    
    if(idArrayM.count <= 0) {
        return nil;
    }
    
    //正常情况下, record中有此记录. 但是post, reply可能因为网络原因未访问下thread信息然后存储到record. 因此需重新构建数组.
    NSArray *arrayRecords = [self.dbData DBDataQueryDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfo:@{@"tid":[NSArray arrayWithArray:idArrayM]}];
    
    NSMutableArray *arraymReturn = [[NSMutableArray alloc] init];
    
    NSInteger numberFound = 0;
    for(NSInteger index = 0; index < arrayCollections.count; index++) {
        BOOL foundInRecord = NO;
        NSDictionary *dict = arrayCollections[index];
        NSMutableDictionary* dictm = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        NSNumber *tid = [dict objectForKey:@"tid"];
        
        for(NSDictionary *dictRecord in arrayRecords) {
            if([[dictRecord objectForKey:@"tid"] isEqualToNumber:tid]) {
                numberFound ++;
                [dictm addEntriesFromDictionary:dictRecord];
                foundInRecord = YES;
                break;
            }
        }
        
        if(!foundInRecord) {
            NSLog(@"#error tid %@ not find record.", tid);
        }
        
        [arraymReturn addObject:[NSDictionary dictionaryWithDictionary:dictm]];
    }
    
    NSLog(@"qwerty[%zd] : %@\n%@\n%@", numberFound, arrayCollections, arrayRecords, arraymReturn);
    
    return [NSArray arrayWithArray:arraymReturn];
#endif
}



//===========================================================================================================
//id, postedAt
- (NSInteger)configDBPostInsert:(NSDictionary*)infoInsert {
    
    BOOL couldBeReplaced = NO;
    [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_POST withInfo:infoInsert countReplace:couldBeReplaced];
    
    
    return CONFIGDB_EXECUTE_OK;
}


- (BOOL)configDBPostDelete:(NSDictionary*)infoDelete {
    
    LOG_POSTION

    [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_COLLECTION withQuery:infoDelete];
    
    return YES;
}



- (NSArray*)configDBPostQuery:(NSDictionary*)infoQuery {

    return nil;
}


//===========================================================================================================
//id, repliedAt
- (NSInteger)configDBReplyInsert:(NSDictionary*)infoInsert {
    
    
    
    return CONFIGDB_EXECUTE_OK;
}


- (BOOL)configDBReplyDelete:(NSDictionary*)infoDelete {
    
    
    return YES;
}



- (NSArray*)configDBReplyQuery:(NSDictionary*)infoQuery {
    
    return nil;
}






//===========================================================================================================
//id, collectedAt
- (NSInteger)configDBDetailHistoryInsert:(NSDictionary*)infoInsert countBeReplaced:(BOOL)couldBeReplaced{
    
    LOG_POSTION
    
    [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_DETAILHISTORY withInfo:infoInsert countReplace:couldBeReplaced];
    
    return CONFIGDB_EXECUTE_OK;
}


- (BOOL)configDBDetailHistoryDelete:(NSDictionary*)infoDelete {
    
    LOG_POSTION

    [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_DETAILHISTORY withQuery:infoDelete];
    
    return YES;
}


- (NSDictionary*)configDBDetailHistoryQuery:(NSDictionary*)infoQuery {

    NSDictionary *valueDetailHistory = [self.dbData DBDataQueryDBName:DBNAME_HOST toTable:TABLENAME_DETAILHISTORY columnNames:nil withQuery:infoQuery withLimit:nil];
    
    NSLog(@"Result : %@", valueDetailHistory);
    
    return valueDetailHistory;
}










- (BOOL)configDBRecordInsert:(NSDictionary*)infoInsert {
    
    [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfo:infoInsert countReplace:YES];
    
    return YES;
}


- (BOOL)configDBRecordDelete:(NSDictionary*)infoDelete {
    
    [self.dbData DBDataDeleteDBName:DBNAME_HOST toTable:TABLENAME_RECORD withQuery:infoDelete];
    return YES;
}


- (NSDictionary*)configDBRecordQuery:(NSDictionary*)infoQuery {
    
    return [self.dbData DBDataQueryDBName:DBNAME_HOST toTable:TABLENAME_RECORD columnNames:nil withQuery:infoQuery withLimit:nil];
}


- (BOOL)configDBRecordUpdate:(NSDictionary*)infoUpdate withInfoQuery:(NSDictionary*)infoQuery
{
    
    [self.dbData DBDataUpdateDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfoUpdate:infoUpdate withInfoQuery:infoQuery];
    
    return YES;
}


- (BOOL)configDBRecordInsertOrReplace:(NSDictionary*)infoInsert {
    
    BOOL result = YES;
    NSLog(@"#error - not implement.");
    
    //使用优化方式. 先读出已经存储的. 对比后确认是否需更新.
    NSArray *columnNamesInsert  = [infoInsert objectForKey:DBDATA_STRING_COLUMNS];
    NSArray *valuesInsert       = [infoInsert objectForKey:DBDATA_STRING_VALUES];
    NSInteger indextid          = [columnNamesInsert indexOfObject:@"tid"];
    NSInteger indexjsonstring   = [columnNamesInsert indexOfObject:@"jsonstring"];
    NSInteger countInfoInsert   = [self.dbData DBDataCheckRowsInDictionary:infoInsert];
    
    NSMutableArray *tidsQueryM = [[NSMutableArray alloc] init];
    for(NSArray *array in valuesInsert) {
        [tidsQueryM addObject:array[indextid]];
    }
    
    NSArray *tidsQuery = [NSArray arrayWithArray:tidsQueryM];
    NSDictionary *queryResult = [self.dbData DBDataQueryDBName:DBNAME_HOST
                                                       toTable:TABLENAME_RECORD
                                                   columnNames:@[@"tid", @"jsonstring"]
                                                     withQuery:@{@"tid":tidsQuery} withLimit:nil];
    
    NSInteger countQueryResult  = [self.dbData DBDataCheckRowsInDictionary:queryResult];
    NSArray *columnNamesQuery   = [queryResult objectForKey:DBDATA_STRING_COLUMNS];
    NSArray *valuesQuery        = [queryResult objectForKey:DBDATA_STRING_VALUES];
    NSInteger indextidQuery         = [columnNamesQuery indexOfObject:@"tid"];
    NSInteger indexjsonstringQuery  = [columnNamesQuery indexOfObject:@"jsonstring"];
    

    
    
#if 0
    NSArray *tids               = [infoInsert objectForKey:@"tid"];
    NSArray *tidBelongTos       = [infoInsert objectForKey:@"tidBelongTo"];
    NSArray *createdAts         = [infoInsert objectForKey:@"createdAt"];
    NSArray *updatedAts         = [infoInsert objectForKey:@"updatedAt"];
    NSArray *jsonstrings        = [infoInsert objectForKey:@"jsonstring"];
    
    NSInteger countInfoInsert = [self.dbData DBDataCheckRowsInDictionary:infoInsert];
    

    
    NSArray *columnNames = [infoInsert objectForKey:DBDATA_STRING_COLUMNS];
    NSArray *values = [infoInsert objectForKey:DBDATA_STRING_VALUES];
    
    NSInteger indextid = [columnNames indexOfObject:@"tid"];
    NSInteger indexjsonstring = [columnNames indexOfObject:@"jsonstring"];
#endif
    
    NSMutableIndexSet *indexSetRemove = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *indexSetKeep = [[NSMutableIndexSet alloc] init];
    
    NSInteger index = 0;
    for(NSArray *valueInsert in valuesInsert) {
        BOOL keep = YES;
        BOOL found = NO;
        
        NSNumber *tidNumberInsert       = valueInsert[indextid];
        NSString *jsonstringInsert      = valueInsert[indexjsonstring];
        
        for(NSArray *valueQuery in valuesQuery) {
            
            NSNumber *tidNumberQuery    = valueQuery[indextidQuery];
            NSString *jsonstringQuery   = valueQuery[indexjsonstringQuery];
            
            if([tidNumberInsert isEqual:tidNumberQuery]) {
                found = YES;
                NSLog(@"%@ find in query.", tidNumberInsert);
                if([jsonstringInsert isEqual:jsonstringQuery]) {
                    NSLog(@"%@ jsonstring equal", tidNumberInsert);
                    [indexSetRemove addIndex:index];
                    keep = NO;
                }
                else {
                    NSLog(@"%@ jsonstring not equal \n%@\n%@", tidNumberInsert, jsonstringInsert, jsonstringQuery);
                }
 
                break;
            }
        }
        
        if(!found) {
            NSLog(@"%@ not in query.", tidNumberInsert);
        }
        
        if(keep) {
            NSLog(@"%@ would be insert/update .", tidNumberInsert);
            [indexSetKeep addIndex:index];
        }
        else {
            NSLog(@"%@ not update .", tidNumberInsert);
        }
        
        index ++;
    }
    
    
    
    if((indexSetKeep.count + indexSetRemove.count) != countInfoInsert) {
        NSLog(@"#error - ");
        sleep(100);
    }
    
    if(indexSetKeep.count == countInfoInsert) {
        NSLog(@"ALL equal. do not need to update.");
        return nil;
    }
    else if(indexSetKeep.count == countInfoInsert) {
        NSLog(@"ALL update.");
        return DB_EXECUTE_OK == [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfo:infoInsert countReplace:YES];
    }
    else {
        NSLog(@"update %zd / total %zd", indexSetKeep.count, countInfoInsert);
        
        infoInsert = @{
                       DBDATA_STRING_COLUMNS:columnNamesInsert,
                       DBDATA_STRING_VALUES:[valuesInsert objectsAtIndexes:indexSetKeep]
                       };
        
        return DB_EXECUTE_OK == [self.dbData DBDataInsertDBName:DBNAME_HOST toTable:TABLENAME_RECORD withInfo:infoInsert countReplace:YES];
    }
    
    
    
    
#if 0
    NSString *jsonstring = infoInsert[@"jsonstring"];
    NSNumber *tidNumber = infoInsert[@"tid"];
    if([jsonstring isKindOfClass:[NSString class]] && [tidNumber isKindOfClass:[NSNumber class]]) {
        NSLog(@"PostRecord[%@] insert or update", tidNumber);
    }
    else {
        NSLog(@"PostRecord[%@] insert or update infoInsert error.", tidNumber);
        return NO;
    }
    
    
    NSDictionary* dictQuery = @{@"tid":tidNumber};
    NSArray *arrayQuery = [self configDBRecordQuery:dictQuery];
    if(arrayQuery && [arrayQuery count] > 0) {
        NSLog(@"PostRecord[%@] insert or update. already added.", tidNumber);
        NSDictionary *dictQueryResult = (NSDictionary*)[arrayQuery objectAtIndex:0];
        if([dictQueryResult[@"jsonstring"] isEqual:jsonstring]) {
            NSLog(@"PostRecord[%@] not need update.", tidNumber);
        }
        /*新建主题或者回复后, 选择是否占位. 占位的话则需取消此判断. 
          关于是否占位, 是指在新建主题或者回复后, 只能获取到id信息. 此id信息需保存到post表活着reply表中. 
          但是如果之后的对该主题/回复的访问有网络故障的情况. 则导致未获取到详细信息不能添加到record表. 
          如果执行联表查询, 则此id不会出现在查询结果中.
          如果占位的话, 则可以解决此问题, 只是查询处的jsonstring为空. 
          暂时决定使用占位.
         */
        else if([jsonstring length] == 0){
            NSLog(@"#error- PostRecord[%@]. json string null.", tidNumber);
            result = NO;
        }
        else {
            NSLog(@"PostRecord[%@] need update", tidNumber);
            NSLog(@"db stored :\n%@", dictQueryResult[@"jsonstring"]);
            NSLog(@"update to :\n%@", jsonstring);
 
            result = [self configDBRecordUpdate:infoInsert withInfoQuery:@{@"tid":tidNumber}];
        }
    }
    else {
        NSLog(@"PostRecord[%@] insert.", tidNumber);
        result = [self configDBRecordInsert:infoInsert];
    }
#endif
    return result;
}









- (void)configDBTestClearForRebuild
{
    LOG_POSTION

}



- (NSString*)configDBSettingKVGet:(NSString*)key {
    NSString *value = nil; //@"NANSETTINGKV";
    
    NSDictionary *valueQeury = [self.dbData DBDataQueryDBName:DBNAME_HOST toTable:@"settingkv" columnNames:@[@"value"] withQuery:@{@"key":key} withLimit:nil];
    NSArray *values = [valueQeury objectForKey:@"value"];
    if([values isKindOfClass:[NSArray class]] && values.count > 0 && [values[0] isKindOfClass:[NSString class]]) {
        value = values[0];
        NSLog(@"key [%@] return value : [%@]", key, value);
    }
    else {
        NSLog(@"#error - configDBSettingKVGet read (%@) FAILED.", key);
    }
    
    return value;
}


- (BOOL)configDBSettingKVSet:(NSString*)key withValue:(NSString*)value{
    return (DB_EXECUTE_OK == [self.dbData DBDataUpdateDBName:DBNAME_HOST toTable:@"settingkv" withInfoUpdate:@{@"value":value} withInfoQuery:@{@"key":key}]);
}










- (NSDictionary*)configDBGetCategory
{
    NSDictionary *valueQuery = [self.dbData DBDataQueryDBName:DBNAME_HOST toTable:TABLENAME_CATEGORY columnNames:nil withQuery:nil withLimit:@{DBDATA_STRING_ORDER:@"ORDER BY click DESC"}];
    
    return valueQuery;
}



- (void)configDBSetAddCategoryClick:(NSString*)cateogry {
    [self.dbData DBDataUpdateAdd1DBName:DBNAME_HOST toTable:TABLENAME_CATEGORY withColumnName:@"click" withInfoQuery:@{@"name":cateogry}];
}






- (NSArray*)getEmoticonStrings
{
    NSArray *emoticonArray = @[@"NAN"];
    NSDictionary *valuesQuery = [self.dbData DBDataQueryDBName:@"config" toTable:@"emoticon" columnNames:@[@"emoticon"] withQuery:nil withLimit:nil];
    if(valuesQuery && [[valuesQuery objectForKey:@"emoticon"] isKindOfClass:[NSArray class]]) {
        emoticonArray = [NSArray arrayWithArray:[valuesQuery objectForKey:@"emoticon"]];
    }
    
    return emoticonArray;
}







- (NSArray*)configDBGetColors
{
    NSArray *keywords = [self.colors objectForKey:@"keyword"];
    NSArray *colorstrings = [self.colors objectForKey:@"colorstring"];
    
    NSMutableArray *colorsM = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < keywords.count; index ++) {
//    for(NSString *keyword in keywords) {
        if(index < colorstrings.count) {
            [colorsM addObject:@{@"keyword":keywords[index], @"colorstring":colorstrings[index]}];
        }
        else {
            break;
        }
    }

    return [NSArray arrayWithArray:colorsM];
}


- (NSArray*)configDBGetFonts
{
    NSArray *keywords = [self.fonts objectForKey:@"keyword"];
    NSArray *fontstrings = [self.fonts objectForKey:@"fontstring"];
    
    NSMutableArray *fontsM = [[NSMutableArray alloc] init];
    for(NSInteger index = 0; index < keywords.count; index ++) {
        //    for(NSString *keyword in keywords) {
        if(index < fontstrings.count) {
            [fontsM addObject:@{@"keyword":keywords[index], @"fontstring":fontstrings[index]}];
        }
        else {
            break;
        }
    }
    
    return [NSArray arrayWithArray:fontsM];
}

#endif
@end








#if 0
- (id)configDBGet:(id)key {
    NS0Log(@"configDBGet key : %@", key);
    
    id object = nil;
    
    if([key isEqual:@"hostnames"]) {
        object = [NSArray arrayWithArray:self.hostnames];
    }
    
    if([key isEqual:@"hosts"]) {
        object = [NSArray arrayWithArray:self.hosts];
    }
    
    if([key isEqual:@"imageHosts"]) {
        object = [NSArray arrayWithArray:self.imageHosts];
    }
    
    if([key isEqual:@"hostIndex"]) {
        object = [NSNumber numberWithInteger:self.hostIndex];
    }
    
    if([key isEqual:@"hostname"]) {
        object = [self.hostnames objectAtIndex:self.hostIndex];
    }
    
    if([key isEqual:@"host"]) {
        object = [self.hosts objectAtIndex:self.hostIndex];
    }
    
    if([key isEqual:@"imageHost"]) {
        object = [self.imageHosts objectAtIndex:self.hostIndex];
    }
    
    if([key isEqualToString:@"numberInCategoryPage"]) {
        if([[self configDBGet:@"hostname"] isEqualToString:@"hacfun"]) {
            object = [NSNumber numberWithInteger:20];
        }
        else if([[self configDBGet:@"hostname"] isEqualToString:@"kukuku"]) {
            object = [NSNumber numberWithInteger:10];
        }
        else {
            object = [NSNumber numberWithInteger:10];
        }
    }
    
    return object;
}
#endif





