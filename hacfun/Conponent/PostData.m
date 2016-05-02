//
//  PostData.m
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostData.h"
#import "FuncDefine.h"
#import "AppConfig.h"




@interface PostData ()



@end


@implementation PostData

- (id)copy {
    
    PostData *pdCopy = [[PostData alloc] init];
    NSLog(@"PostData deep copy");
    
    [pdCopy copyFrom:self];
    
    return pdCopy;
}


- (void)copyFrom:(PostData*)postDataFrom
{
    self.content        = [postDataFrom.content copy];
    self.createdAt      = postDataFrom.createdAt; //=1436622610000;
    self.email          = [postDataFrom.email copy];//= "";
    self.forum          = postDataFrom.forum; //= 4;
    self.tid            = postDataFrom.tid;//= 6297913;
    self.tidBelongTo    = postDataFrom.tidBelongTo;//= 6297913;
    self.image          = [postDataFrom.image copy];
    self.lock           = postDataFrom.lock ;//= 0;
    self.name           = [postDataFrom.name copy]; //= "";
    self.sage           = postDataFrom.sage ;//= 0;
    self.thumb          = [postDataFrom.thumb copy];//= "";
    self.title          = [postDataFrom.title copy];//= "";
    self.uid            = [postDataFrom.uid copy];//= TYXC4L2E;
    self.updatedAt      = postDataFrom.updatedAt;//= 1436668641000;
    
    self.bTopic         = NO; //是否是主题. 否则为回复.
    self.replies        = NULL;
    self.recentReply    = [postDataFrom.recentReply copy];
    self.replyCount     = postDataFrom.replyCount ;
    
    self.optimumSizeHeight  = postDataFrom.optimumSizeHeight;
    self.type               = postDataFrom.type;
    self.jsonstring         = [postDataFrom.jsonstring copy];
}


- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    
    if(![other isKindOfClass:[PostData class]]) {
        return NO;
    }
    else {
        return [[self description] isEqualToString:[other description]];
    }
}


- (BOOL)isIdInArray:(NSArray*)array {
    
    for(PostData* pd in array) {
        if(pd.tid == self.tid) {
            return YES;
        }
    }
    
    return NO;
}


+ (PostData*)fromDictData:(NSDictionary *)dict atPage:(NSInteger)page {
    
    PostData *pd = [[PostData alloc] init];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if(jsonData) {
        pd.jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else {
        NSLog(@"#error - dict to jsonstring error. [dict:%@]", dict);
        pd.jsonstring = @"";
    }
    
    BOOL finished = NO;
    id obj;
    NS0Log(@"%@", dict);
    
    do {
#define DICT_PARSE_GET_NSSTRING(key, item) { \
        obj = [dict objectForKey:key]; \
        if([obj isKindOfClass:[NSString class]]){ \
            item = [(NSString*)obj copy]; \
        }\
        else { \
            NSLog(@"----------------------------------------------%@ not get", key); \
            /*break;*/ \
        }\
    }
        
#define DICT_PARSE_GET_NSINTEGER(key, item) { \
        obj = [dict objectForKey:key]; \
        if([obj isKindOfClass:[NSNumber class]]){ \
            item = [(NSNumber*)obj integerValue]; \
        } \
        else if([obj isKindOfClass:[NSString class]]){ \
            item = [(NSString*)obj integerValue]; \
        }\
        else { \
            NSLog(@"----------------------------------------------%@ not get", key); \
            /*break;*/ \
        } \
    }
    
#define DICT_PARSE_GET_LONGLONG(key, item) { \
        obj = [dict objectForKey:key]; \
        if([obj isKindOfClass:[NSNumber class]]){ \
            item = [(NSNumber*)obj longLongValue]; \
        } \
        else { \
            NSLog(@"----------------------------------------------%@ not get", key); \
            /*break;*/ \
        } \
    }
    
        DICT_PARSE_GET_NSSTRING(@"content", pd.content)
        DICT_PARSE_GET_LONGLONG(@"createdAt", pd.createdAt)
        DICT_PARSE_GET_NSSTRING(@"email", pd.email)
        DICT_PARSE_GET_NSINTEGER(@"forum", pd.forum)
        DICT_PARSE_GET_NSINTEGER(@"id", pd.tid)
        DICT_PARSE_GET_NSSTRING(@"image", pd.image)
        DICT_PARSE_GET_NSINTEGER(@"lock", pd.lock)
        DICT_PARSE_GET_NSSTRING(@"name", pd.name)
        DICT_PARSE_GET_NSINTEGER(@"replyCount", pd.replyCount)
        DICT_PARSE_GET_NSINTEGER(@"sage", pd.sage)
        DICT_PARSE_GET_NSSTRING(@"thumb", pd.thumb)
        DICT_PARSE_GET_NSSTRING(@"title", pd.title)
        DICT_PARSE_GET_NSSTRING(@"uid", pd.uid)
        DICT_PARSE_GET_LONGLONG(@"updatedAt", pd.updatedAt)
        
//        pd.content = [self postDataContentRetreat:pd.content];
        
        finished = YES;
        
    }while(0);
    
    if(!finished) {
        
        NSLog(@"%@", obj);
        NSLog(@"obj class NSMutableArray : %d", [obj isKindOfClass:[NSMutableArray class]]);
        NSLog(@"obj class NSArray        : %d", [obj isKindOfClass:[NSArray class]]);
        NSLog(@"obj class NSDictionary   : %d", [obj isKindOfClass:[NSDictionary class]]);
        NSLog(@"obj class NSString       : %d", [obj isKindOfClass:[NSString class]]);
        NSLog(@"obj class NSData         : %d", [obj isKindOfClass:[NSData class]]);
        NSLog(@"obj class NSValue        : %d", [obj isKindOfClass:[NSValue class]]);
        NSLog(@"obj class NSNumber       : %d", [obj isKindOfClass:[NSNumber class]]);
    }
    
    //        @property (strong, nonatomic) NSString * content;
    //        @property (nonatomic) NSInteger  createdAt ; //=1436622610000;
    //        @property (strong, nonatomic) NSString * email ;//= "";
    //        @property (nonatomic) NSInteger forum ; //= 4;
    //        @property (nonatomic) NSInteger id ;//= 6297913;
    //        @property (strong, nonatomic) NSString *image ;
    //        @property (nonatomic) BOOL lock ;//= 0;
    //        @property (strong, nonatomic) NSString *name ; //= "";
    //        @property (strong, nonatomic) NSArray *recentReply ;//=     ( 6299638, 6299598, 6299451, 6299426, 6299069);
    //        @property (nonatomic) NSInteger replyCount ;//= 24;
    //        @property (nonatomic) BOOL sage ;//= 0;
    //        @property (strong, nonatomic) NSString *thumb ;//= "";
    //        @property (strong, nonatomic) NSString *title ;//= "";
    //        @property (nonatomic) NSString *uid ;//= TYXC4L2E;
    //        @property (nonatomic) NSInteger updatedAt ;//= 1436668641000;
    
    pd.page = page;
    return finished?pd:nil;
}


+ (PostData*)fromString:(NSString*)jsonstring atPage:(NSInteger)page
{
    if(!jsonstring) {
        return nil;
    }
    
    id obj = [NSJSONSerialization JSONObjectWithData:[jsonstring dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        return [self fromDictData:obj atPage:page];
    }
    else {
        return nil;
    }
}


+ (PostData*)fromOnlyTid:(NSInteger)tid
{
    PostData *postData = [[PostData alloc] init];
    postData.tid = tid;
    postData.type = PostDataTypeOnlyTid;
    
    return postData;
}


+ (NSString*)addLinkForReferenceNumber:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@">>No.[0-9]+" options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
        [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NS0Log(@"%zi %zi",
              [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
              [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *sub = [searchText substringWithRange:NSMakeRange(range.location+2, range.length-2)];
        NSString *replacement = [NSString stringWithFormat:@"<a href='%@'>>>%@</a>", sub, sub];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return searchText;
}


+ (NSString*)addLinkForWebAddr:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        
        NSString * regexString = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
//        NSString *urlReg = @"^(https?://)?(([0-9a-z_!~*'().&=+$%-]+:)?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}\\.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+\\.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
        
        rangeResult = [searchText rangeOfString:regexString options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        NSLog(@"zxc %zd %zd", rangeResult.location, rangeResult.length);
        
        [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
        [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NS0Log(@"%zi %zi",
               [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
               [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *sub = [searchText substringWithRange:NSMakeRange(range.location, range.length)];
        
        NSString *replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>", sub, sub];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return searchText;
}


//字符转换.
+ (NSString*) postDataContentRetreat:(NSString*)content {
    //一些www的关键字符信息需转义.
    content = [NSString decodeWWWEscape:content];
    
    //font属性由RTLabel显示大小不合适. 手动修改成这样.
    content = [content stringByReplacingOccurrencesOfString:@"font size=\"5\"" withString:@"font size=\"16\""];
    
    //对No.xxx加载超链接.
    content = [self addLinkForReferenceNumber:content];
    
    //对http地址加载超链接.
    content = [self addLinkForWebAddr:content];
    
    return content;
}


- (void)encodeWithCoder:(NSCoder*)encode {
    [encode encodeObject:self.content forKey:@"content"];
    [encode encodeObject:[NSNumber numberWithLongLong:self.createdAt] forKey:@"createdAt"];
    [encode encodeObject:self.email forKey:@"email"];
    [encode encodeObject:[NSNumber numberWithInteger:self.forum] forKey:@"forum"];
    [encode encodeObject:[NSNumber numberWithInteger:self.tid] forKey:@"tid"];
    [encode encodeObject:self.image forKey:@"image"];
    [encode encodeObject:[NSNumber numberWithBool:self.lock] forKey:@"lock"];
    [encode encodeObject:self.name forKey:@"name"];
    [encode encodeObject:[NSNumber numberWithBool:self.sage] forKey:@"sage"];
    [encode encodeObject:self.thumb forKey:@"thumb"];
    [encode encodeObject:self.title forKey:@"title"];
    [encode encodeObject:self.uid forKey:@"uid"];
    [encode encodeObject:[NSNumber numberWithLongLong:self.updatedAt] forKey:@"updatedAt"];
    
    [encode encodeObject:[NSNumber numberWithBool:self.bTopic] forKey:@"bTopic"];
//    @property (strong,nonatomic) NSMutableArray *replies;
//    @property (strong, nonatomic) NSArray *recentReply ;//=     ( 6299638, 6299598, 6299451, 6299426, 6299069);
    [encode encodeObject:[NSNumber numberWithInteger:self.replyCount] forKey:@"replyCount"];
    [encode encodeObject:[NSNumber numberWithInteger:self.mode] forKey:@"mode"];
}


- (id)initWithCoder:(NSCoder*)decoder {
    if((self = [super init])) {
        self.content = [decoder decodeObjectForKey:@"content"];
        self.createdAt = [((NSNumber*)[decoder decodeObjectForKey:@"createdAt"]) longLongValue];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.forum = [((NSNumber*)[decoder decodeObjectForKey:@"forum"]) integerValue];
        self.tid = [((NSNumber*)[decoder decodeObjectForKey:@"tid"]) integerValue];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.lock = [((NSNumber*)[decoder decodeObjectForKey:@"lock"]) boolValue];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.sage = [((NSNumber*)[decoder decodeObjectForKey:@"sage"]) boolValue];
        self.thumb = [decoder decodeObjectForKey:@"thumb"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.updatedAt = [((NSNumber*)[decoder decodeObjectForKey:@"updatedAt"]) longLongValue];
        
        self.bTopic = [((NSNumber*)[decoder decodeObjectForKey:@"bTopic"]) boolValue];
//    @property (strong,nonatomic) NSMutableArray *replies;
//    @property (strong, nonatomic) NSArray *recentReply ;//=     ( 6299638, 6299598, 6299451, 6299426, 6299069);
        self.replyCount = [((NSNumber*)[decoder decodeObjectForKey:@"replyCount"]) integerValue];
        self.mode = [((NSNumber*)[decoder decodeObjectForKey:@"mode"]) integerValue];
    }
    
    return self;
}


- (NSString*)description {
    return [NSString stringWithFormat:@"jsonstring : %@", self.jsonstring];
}


/*
PostDataView 接收的字段字段
按照PostDataCellView中的说明.
*/
- (NSMutableDictionary*)toVIewDisplayDataUseCustom {
    LOG_POSTION
    NSString *uidRetreat = self.uid;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSInteger intervalTimeZoneAdjust = 0;
    //计算时区差值.
    //从实际测试情况看是没有添加时区影响的.
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    intervalTimeZoneAdjust = 0;
    NSString *stringCreatedAt = [NSString stringFromMSecondInterval:self.createdAt andTimeZoneAdjustSecondInterval:0];
    
    if(self.uid.length > 8) {
        NSLog(@"long uid %@", self.uid);
    }
    
//    [self.uid rangeOfString:@"<font color=\"red">管理员1</font>" options:<#(NSStringCompareOptions)#> range:<#(NSRange)#>]
    //uid可能已经有颜色标签.
    NSRange range1 = [self.uid rangeOfString:@"<font color=\"[a-zA-Z]+\">" options:NSRegularExpressionSearch range:NSMakeRange(0, self.uid.length)];
    if(range1.location == NSNotFound || range1.length == 0) {
        
    }
    else {
        NSRange range2 = [self.uid rangeOfString:@"</font>" options:0 range:NSMakeRange(range1.location + range1.length, self.uid.length - (range1.location + range1.length))];
        
        if(range2.location != NSNotFound && range2.length > 0) {
            NSString *uid =  [self.uid substringWithRange:NSMakeRange(range1.location + range1.length,
                                                                      range2.location - (range1.location + range1.length))];
            NSLog(@"uid:%@", uid);
            
            NSString *fontString = [self.uid substringWithRange:range1];
            uidRetreat = uid;
            NSRange rangeFont1 = [fontString rangeOfString:@"<font color=\""];
            if(rangeFont1.location != NSNotFound && rangeFont1.length > 0) {
                NSRange rangeFont2 = [fontString rangeOfString:@"\"" options:0 range:NSMakeRange(rangeFont1.location + rangeFont1.length, fontString.length - (rangeFont1.location + rangeFont1.length))];
                
                if(rangeFont2.location != NSNotFound && rangeFont2.length > 0) {
                    NSString *colorString =  [fontString substringWithRange:NSMakeRange(rangeFont1.location + rangeFont1.length,
                                                                              rangeFont2.location - (rangeFont1.location + rangeFont1.length))];
                    NSLog(@"color:%@", colorString);
                    UIColor *color = [UIColor colorFromString:colorString];
                    if(color) {
                        [dict setObject:color forKey:@"colorUid"];
                    }
                }
            }
        }
    }
    
    NSMutableString *titleText = [NSMutableString stringWithFormat:@"%@  %@ ", stringCreatedAt, uidRetreat];
    [dict setObject:titleText forKey:@"title"];
    [dict setObject:@"" forKey:@"info"];
    
    NSString *content = nil;
    if(self.sage) {
        [dict setObject:@"SAGE" forKey:@"manageInfo"];
    }
    else {
        [dict setObject:@"" forKey:@"manageInfo"];
    }
    
    [dict setObject:@"" forKey:@"otherInfo"];
    
    //正文.
    content = self.content;
    if(self.name.length > 0) {
        content = [NSString stringWithFormat:@"名称: %@\n%@", self.name, content];
    }
    if(self.email.length > 0) {
        content = [NSString stringWithFormat:@"E-mail: %@\n%@", self.email, content];
    }
    if(self.title.length > 0) {
        content = [NSString stringWithFormat:@"标题: %@\n%@", self.title, content];
    }
    
    content = [PostData postDataContentRetreat:content];
    [dict setObject:content?content:@"无正文" forKey:@"content"];
    
    [dict setObject:[self copy] forKey:@"postdata"];
    
    return dict;
}


- (NSMutableDictionary*)toViewDisplayData:(ThreadDataToViewType)type
{
    NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
    
    switch (type) {
        case ThreadDataToViewTypeInfoUseNumber:
            dictm = [self toVIewDisplayDataUseCustom];
            [dictm setObject:[NSString stringWithFormat:@"No.%zi", self.tid] forKey:@"info"];
            break;
            
        case ThreadDataToViewTypeInfoUseReplyCount:
            dictm = [self toVIewDisplayDataUseCustom];
            [dictm setObject:[NSString stringWithFormat:@"回应: %zi", self.replyCount] forKey:@"info"];
            break;
            
        case ThreadDataToViewTypeAdditionalInfoUseReplyCount:
            dictm = [self toVIewDisplayDataUseCustom];
            [dictm setObject:[NSString stringWithFormat:@"No.%zi", self.tid] forKey:@"info"];
            [dictm setObject:[NSString stringWithFormat:@"回应: %zi", self.replyCount] forKey:@"infoAdditional"];
            break;
            
        default:
            break;
    }
    
    return dictm;
    
}


+ (void)gotParsedPostDatas:(NSArray*)postDatas
{
    //将比对优化部分放到AppConfig的接口实现中.
    [[AppConfig sharedConfigDB] configDBRecordAdds:postDatas];
}


+ (NSMutableArray*)parseFromCategoryJsonData:(NSData*)data atPage:(NSInteger)page storeAdditional:(NSMutableDictionary*)additonal
{
    id obj;
    NSDictionary *dict;
    NSMutableArray *arr;

    if(nil == data) {
        NSLog(@"data nil");
        return nil;
    }
    
    //NSData转 NSString.
    NSString *jsonstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json data string : \n%@", jsonstring);
    
    //NSString转NSData.
    NSData *jsonData = [jsonstring dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"compare result : %d", [jsonData isEqual:data]);
    
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(!(obj && [obj isKindOfClass:[NSDictionary class]])){
        NSLog(@"obj [%@] nil or not NSDictionary class", @"JSONObjectWithData");
        return nil;
    }
    
    dict = (NSDictionary*)obj;
    
    NSString *key = @"forum";
    obj = [dict objectForKey:key];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        [additonal setObject:obj forKey:key];
    }
    else {
        NSLog(@"obj [%@] nil or not NSDictionary class", key);
    }
    
    key = @"data";
    obj = [dict objectForKey:key];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        
    }
    else {
        NSLog(@"obj [%@] nil or not NSDictionary class", key);
        return nil;
    }
    
    dict = (NSDictionary*)obj;
    
    key = @"threads";
    obj = [dict objectForKey:key];
    if(obj && [obj isKindOfClass:[NSMutableArray class]]) {
        
    }
    else {
        NSLog(@"obj [%@] nil or not NSMutableArray class", key);
        return nil;
    }
    
    arr = (NSMutableArray*)obj;
    PostData *pd = nil;
    NSMutableArray *postDatasArray = [[NSMutableArray alloc] init];
    
    for(obj in arr) {
        
        if(![obj isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"%@ not dictionary", @"parsing obj");
            continue;
        }
        
        pd = [PostData fromDictData:(NSDictionary*)obj atPage:page];
        if(nil == pd) {
            break;
        }
        
        pd.tidBelongTo = 0;
        
        //PostData各数据获取完成.
        pd.bTopic = YES;
        pd.mode = 1;
        [postDatasArray addObject:pd];
    }
    
    //将解析的数据加载到record表中.
    if(postDatasArray.count > 0) {
        [self gotParsedPostDatas:postDatasArray];
    }
    
    return postDatasArray;
}


//返回解析出的主题. 具体回复内容放置到replies中. additional可存储一些其他信息.
+ (PostData*)parseFromDetailedJsonData:(NSData*)data atPage:(NSInteger)page repliesTo:(NSMutableArray*)replies storeAdditional:(NSMutableDictionary*)additonal
{
    if(nil == data) {
        NSLog(@"data null");
        return nil;
    }
    
    //NSData转 NSString.
    NSString *jsonstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json data string : \n%@", jsonstring);
    
    NSObject *obj;
    NSDictionary *dict;
    NSMutableArray *arr;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NS0Log(@"obj nil %d", __LINE__);
        return nil;
    }
    
    PostData *topic = nil;
    
    dict = (NSDictionary*)obj;
    NS0Log(@"%@", dict);
    
    NSString *key = @"threads";
    obj = [dict objectForKey:key];
    if(obj) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"obj [%@] nil or not NSMutableArray class", key);
            return nil;
        }
        
        [additonal setObject:obj forKey:key];
        
        topic = [PostData fromDictData:(NSDictionary*)obj atPage:page];
        if(nil == topic) {
            NSLog(@"error- : PostData formDictData with content %@", obj);
            return nil;
        }
        
        topic.tidBelongTo = 0;
    }
    else {
        NSLog(@"error - key threads nil.");
        return nil;
    }
    
    key = @"replys";
    PostData *pd = nil;
    obj = [dict objectForKey:key];
    if(obj && [obj isKindOfClass:[NSMutableArray class]]) {
        
    }
    else {
        NSLog(@"key %@ nil.", key);
        return topic;
    }
    
    arr = (NSMutableArray*)obj;
    for(obj in arr) {
        
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing obj");
            continue;
        }
        
        dict = (NSDictionary*)obj;
        NS0Log(@"%@", dict);
        
        pd = [PostData fromDictData:(NSDictionary*)obj atPage:page];
        if(nil == pd) {
            break;
        }
        
        pd.tidBelongTo = topic.tid;
        pd.bTopic = NO;
        pd.mode = 2;
        [replies addObject:pd];
    }
    
    //记录更新到数据库.
    NSMutableArray *parsedPostDatas = [[NSMutableArray alloc] init];
    if(topic) {
        [parsedPostDatas addObject:topic];
    }

    if(replies && replies.count) {
        [parsedPostDatas addObjectsFromArray:replies];
    }
    
    if(parsedPostDatas.count > 0) {
        [self gotParsedPostDatas:parsedPostDatas];
    }
    
    return topic;
}


//page=-1时取最后一页.
//下载内容为空或者解析出错时返回nil.
+ (PostData*)sendSynchronousRequestByTid:(long long)tid atPage:(NSInteger)page repliesTo:(NSMutableArray*)replies storeAdditional:(NSMutableDictionary*)additonal
{
    if([NSThread currentThread] == [NSThread mainThread]) {
        NSLog(@"#error can not running at mainThread");
        return nil;
    }
    
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    
    NSString *urlString = nil;
    urlString = [NSString stringWithFormat:@"%@/t/%lld?page=%@",
                 host.host,
                 tid,
                 page!=-1?[NSNumber numberWithInteger:page]:@"last"];
    NSLog(@"sync thread download url : %@", urlString);
    
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    // send request
    NSError *error = nil;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData && ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)) {
        //        NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        return [PostData parseFromDetailedJsonData:responseData atPage:page repliesTo:replies storeAdditional:additonal];
    }
    else {
        return nil;
    }
}






@end





@implementation PostDataPage
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = NSNotFound;
        self.postDatas = [[NSMutableArray alloc] init];
    }
    return self;
}
@end


@implementation PostViewDataPage
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = NSNotFound;
        self.postViewDatas = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
