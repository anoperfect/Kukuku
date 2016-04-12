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
    
    pdCopy.content = [self.content copy];
    pdCopy.createdAt = self.createdAt; //=1436622610000;
    pdCopy.email = [self.email copy];//= "";
    pdCopy.forum = self.forum; //= 4;
    pdCopy.id = self.id;//= 6297913;
    pdCopy.image = [self.image copy];
    pdCopy.lock = self.lock ;//= 0;
    pdCopy.name = [self.name copy]; //= "";
    pdCopy.sage = self.sage ;//= 0;
    pdCopy.thumb = [self.thumb copy];//= "";
    pdCopy.title = [self.title copy];//= "";
    pdCopy.uid = [self.uid copy];//= TYXC4L2E;
    pdCopy.updatedAt = self.updatedAt;//= 1436668641000;
    
    pdCopy.bTopic = NO; //是否是主题. 否则为回复.
    pdCopy.replys = NULL;
    pdCopy.recentReply = [self.recentReply copy];
    pdCopy.replyCount = self.replyCount ;
    
    pdCopy.optimumSizeHeight = self.optimumSizeHeight;
    pdCopy.type = self.type;
    pdCopy.actionStrings = self.actionStrings;
    
    return pdCopy;
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
        if(pd.id == self.id) {
            return YES;
        }
    }
    
    return NO;
}


+ (PostData*)fromDictData:(NSDictionary *)dict {
    
    PostData *pd = [[PostData alloc] init];
    pd.jsonString = [NSString stringWithFormat:@"%@", dict];
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
        DICT_PARSE_GET_NSINTEGER(@"id", pd.id)
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
    
    return finished?pd:nil;
}


+ (NSString*)addLinkForReferenceNumber:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@">>No.[0-9]+" options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound) {
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
        if (rangeResult.location == NSNotFound) {
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
    
#if 0
    //这个特殊字符,编辑或者是NSString的操作接口都有问题. 因此采用临时替换的方式.
    NSString *specialChars = @";ﾟ";
    NSString *specialChar = [specialChars substringWithRange:NSMakeRange(1, 1)];
    NSString *tmpReplace = @"##special char##";
    content = [content stringByReplacingOccurrencesOfString:specialChar withString:tmpReplace];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@];
    content = [content stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:tmpReplace withString:specialChar];
#endif
    
    //一些www的关键字符信息需转义.
    content = [FuncDefine decodeWWWEscape:content];
    
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
    [encode encodeObject:[NSNumber numberWithInteger:self.id] forKey:@"id"];
    [encode encodeObject:self.image forKey:@"image"];
    [encode encodeObject:[NSNumber numberWithBool:self.lock] forKey:@"lock"];
    [encode encodeObject:self.name forKey:@"name"];
    [encode encodeObject:[NSNumber numberWithBool:self.sage] forKey:@"sage"];
    [encode encodeObject:self.thumb forKey:@"thumb"];
    [encode encodeObject:self.title forKey:@"title"];
    [encode encodeObject:self.uid forKey:@"uid"];
    [encode encodeObject:[NSNumber numberWithLongLong:self.updatedAt] forKey:@"updatedAt"];
    
    [encode encodeObject:[NSNumber numberWithBool:self.bTopic] forKey:@"bTopic"];
//    @property (strong,nonatomic) NSMutableArray *replys;
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
        self.id = [((NSNumber*)[decoder decodeObjectForKey:@"id"]) integerValue];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.lock = [((NSNumber*)[decoder decodeObjectForKey:@"lock"]) boolValue];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.sage = [((NSNumber*)[decoder decodeObjectForKey:@"sage"]) boolValue];
        self.thumb = [decoder decodeObjectForKey:@"thumb"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.updatedAt = [((NSNumber*)[decoder decodeObjectForKey:@"updatedAt"]) longLongValue];
        
        self.bTopic = [((NSNumber*)[decoder decodeObjectForKey:@"bTopic"]) boolValue];
//    @property (strong,nonatomic) NSMutableArray *replys;
//    @property (strong, nonatomic) NSArray *recentReply ;//=     ( 6299638, 6299598, 6299451, 6299426, 6299069);
        self.replyCount = [((NSNumber*)[decoder decodeObjectForKey:@"replyCount"]) integerValue];
        self.mode = [((NSNumber*)[decoder decodeObjectForKey:@"mode"]) integerValue];
    }
    
    return self;
}


- (NSString*)description {
    return [NSString stringWithFormat:@"%@", self.jsonString];
}


/*
PostDataView 接收的字段字段
 @"title"           - 第一行左边的. 显示日期 uid.
 @"info"            - 第一行右边的. 显示tid, 或者replycount. 可重写.
 @"manageInfo"      - 第二行左边的. 显示sage.
 @"otherInfo"     - 第二行右边的. 显示一些其他信息. 暂时是显示更新回复信息. 用在CollectionViewController显示新回复状态.
 @"content"         - 正文.  根据需要已作内容调整.
 @"colorUid"        － 标记uid颜色. 暂时使用uid颜色标记特定thread. 比如Po, //self post , self reply, follow, other cookie.
 @"postdata"        - copy的PostData.
                      id, thumb replycount直接从raw postdata中读取.
*/


- (NSMutableDictionary*)toVIewDisplayDataUseCustom {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSInteger intervalTimeZoneAdjust = 0;
    //计算时区差值.
    //从实际测试情况看是没有添加时区影响的.
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    intervalTimeZoneAdjust = 0;
    NSString *stringCreatedAt = [FuncDefine stringFromMSecondInterval:self.createdAt andTimeZoneAdjustSecondInterval:0];
    
    NSMutableString *titleText = [NSMutableString stringWithFormat:@"%@  %@ ", stringCreatedAt, self.uid];
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
    
    content = [PostData postDataContentRetreat:self.content];
    [dict setObject:content forKey:@"content"];
    
    [dict setObject:[self copy] forKey:@"postdata"];
    
    return dict;
}


- (NSMutableDictionary*)toViewDisplayData:(ThreadDataToViewType)type
{
    NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
    
    switch (type) {
        case ThreadDataToViewTypeInfoUseNumber:
            dictm = [self toVIewDisplayDataUseCustom];
            [dictm setObject:[NSString stringWithFormat:@"No.%zi", self.id] forKey:@"info"];
            break;
            
        case ThreadDataToViewTypeInfoUseReplyCount:
            dictm = [self toVIewDisplayDataUseCustom];
            [dictm setObject:[NSString stringWithFormat:@"回应: %zi", self.replyCount] forKey:@"info"];
            break;
            
        case ThreadDataToViewTypeAdditionalInfoUseReplyCount:
            dictm = [self toVIewDisplayDataUseCustom];
            [dictm setObject:[NSString stringWithFormat:@"No.%zi", self.id] forKey:@"info"];
            [dictm setObject:[NSString stringWithFormat:@"回应: %zi", self.replyCount] forKey:@"infoAdditional"];
            break;
            
        default:
            break;
    }
    
    return dictm;
    
}








+ (void)gotParsedThread:(NSDictionary*)dict belongTo:(NSInteger)threadId {
    
    LOG_POSTION
    NSLog(@"%@ --- %zi" , [dict objectForKey:@"id"], threadId);
    NS0Log(@"%@", dict);
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    //    if(!([jsonData length] > 0 && error == nil)){
    //        NSLog(@"error : ------");
    //        return NO;
    //    }
    
    NSString *jsonstring = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    
    id obj;
    obj = [dict objectForKey:@"id"];
    if([obj isKindOfClass:[NSNumber class]]) {
        [info setObject:obj forKey:@"id"];
    }
    else {
        NSLog(@"error- %@ not in dictionay.", @"id");
        return;
    }
    
    if(0 == threadId) {
        [info setObject:obj forKey:@"threadId"];
    }
    else {
        [info setObject:[NSNumber numberWithInteger:threadId] forKey:@"threadId"];
    }
    
    obj = [dict objectForKey:@"createdAt"];
    if([obj isKindOfClass:[NSNumber class]]) {
        [info setObject:obj forKey:@"createdAt"];
    }
    else {
        NSLog(@"error- %@ not in dictionay.", @"createdAt");
        return;
    }
    
    obj = [dict objectForKey:@"updatedAt"];
    if([obj isKindOfClass:[NSNumber class]]) {
        [info setObject:obj forKey:@"updatedAt"];
    }
    else {
        NSLog(@"error- %@ not in dictionay.", @"updatedAt");
        //return;
        [info setObject:[NSNumber numberWithLongLong:0] forKey:@"updatedAt"];
    }
    
    [info setObject:jsonstring forKey:@"jsonstring"];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[AppConfig sharedConfigDB] configDBRecordInsertOrReplace:info];
    });
}


+ (NSMutableArray*)parseFromCategoryJsonData:(NSData*)data storeAdditional:(NSMutableDictionary*)additonal
{
    id obj;
    NSDictionary *dict;
    NSMutableArray *arr;

    if(nil == data) {
        NSLog(@"data nil");
        return nil;
    }
    
    //NSData转 NSString.
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json data string : \n%@", jsonString);
    
    //NSString转NSData.
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
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
        
        pd = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == pd) {
            break;
        }
        
        //将解析的数据加载到record表中.
        [self gotParsedThread:(NSDictionary*)obj belongTo:0];
        
        //PostData各数据获取完成.
        pd.bTopic = YES;
        pd.mode = 1;
        pd.actionStrings = @[@"复制", @"举报", @"加入草稿"];
        [postDatasArray addObject:pd];
    }
    
    return postDatasArray;
}


+ (NSMutableArray*)parseFromDetailedJsonData:(NSData*)data storeAdditional:(NSMutableDictionary*)additonal
{
    if(nil == data) {
        NSLog(@"data null");
        return nil;
    }
    
    //NSData转 NSString.
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json data string : \n%@", jsonString);
    
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
    
    NSMutableArray *postDatasArray = [[NSMutableArray alloc] init];
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
        
        topic = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == topic) {
            NSLog(@"error- : PostData formDictData with content %@", obj);
            return nil;
        }
        
        [self gotParsedThread:(NSDictionary*)obj belongTo:0];
        topic.actionStrings = @[@"复制", @"举报", @"只看Po", @"加入草稿"];
        [postDatasArray addObject:topic];
    }
    else {
        NSLog(@"key threads nil.");
        return nil;
    }
    
    PostData *pd = nil;
    obj = [dict objectForKey:@"replys"];
    if(obj && [obj isKindOfClass:[NSMutableArray class]]) {
        
    }
    else {
        NSLog(@"key replys nil.");
        return postDatasArray;
    }
    
    arr = (NSMutableArray*)obj;
    for(obj in arr) {
        
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing obj");
            continue;
        }
        
        dict = (NSDictionary*)obj;
        NS0Log(@"%@", dict);
        
        pd = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == pd) {
            break;
        }
        
        [self gotParsedThread:(NSDictionary*)obj belongTo:topic.id];
        
        pd.bTopic = NO;
        pd.mode = 2;
        pd.actionStrings = @[@"复制", @"举报", @"关注", @"加入草稿"];
        [postDatasArray addObject:pd];
    }
    
    NS0Log(@"<%p> count : %zd", postDatasArray, [postDatasArray count]);
    return postDatasArray;
}


//page=-1时取最后一页.
+ (NSMutableArray*)sendSynchronousRequestByThreadId:(long long)tid andPage:(NSInteger)page
{
    NSString *urlString = nil;
    urlString = [NSString stringWithFormat:@"%@/t/%lld?page=%@",
                 [[AppConfig sharedConfigDB] configDBGet:@"host"],
                 tid,
                 page!=-1?[NSNumber numberWithLongLong:tid]:@"last"];
    
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
        return [PostData parseFromDetailedJsonData:responseData storeAdditional:nil];
    }
    else {
        return nil;
    }
}


+ (PostData*)parseFromThreadJsonData:(NSData*)data {
    LOG_POSTION
    
    PostData *postData = nil;
    if(data) {
        //NSLog(@"%s", [data bytes]);
    }
    else {
        NSLog(@"data null");
        return nil;
    }
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NS0Log(@"obj nil %d", __LINE__);
        return nil;
    }
    
    dict = (NSDictionary*)obj;
    
    NS0Log(@"%@", dict);
    
    obj = [dict objectForKey:@"threads"];
    if(obj) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing threads obj");
            return nil;
        }
        
        postData = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == postData) {
            NSLog(@"error : PostData formDictData with content %@", obj);
            return nil;
        }
        
        postData.jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        postData.bTopic = YES;
        postData.mode = 1;
    }
    else {
        NSLog(@"obj nil %d", __LINE__);
        return nil;
    }
    
    return postData;
}





@end


//        obj = [dict objectForKey:@"content"];
//        if([obj isKindOfClass:[NSString class]]){
//            pd.content = [(NSString*)obj copy];
//            pd.content = [pd.content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//            pd.content = [pd.content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//            pd.content = [pd.content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//            pd.content = [pd.content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//            pd.content = [pd.content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@];
//            pd.content = [pd.content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
//        }
//        else {
//            NSLog(@"----------------------------------------------%@ not get", @"content");
//            break;
//        }
//
//        obj = [dict objectForKey:@"createdAt"];
//        if([obj isKindOfClass:[NSNumber class]]){
//            pd.createdAt = [(NSNumber*)obj longLongValue];
//            NS0Log(@"nsnumber : %@", (NSNumber*)obj);
//            NS0Log(@"pd.createdAt : %lld", pd.createdAt);
//
//        }
//        else {
//            NSLog(@"----------------------------------------------%@ not get", @"createdAt");
//            break;
//        }
//
//        obj = [dict objectForKey:@"uid"];
//        if([obj isKindOfClass:[NSString class]]){
//            pd.uid = [(NSString*)obj copy];
//        }
//        else {
//            NSLog(@"----------------------------------------------%@ not get", @"uid");
//            break;
//        }
//
//        obj = [dict objectForKey:@"replyCount"];
//        if([obj isKindOfClass:[NSNumber class]]){
//            pd.replyCount = [(NSNumber*)obj integerValue];
//        }
//        else {
//            NSLog(@"----------------------------------------------%@ not get", @"replyCount");
//            break;
//        }
//
//
//        obj = [dict objectForKey:@"id"];
//        if([obj isKindOfClass:[NSNumber class]]){
//            pd.id = [(NSNumber*)obj integerValue];
//        }
//        else {
//            NSLog(@"----------------------------------------------%@ not get", @"id");
//            break;
//        }


//
//    //跟 。时, nbsp; 可能监测不出. 增加此方法额外监测.
//    NSRange range;
//    while(0) {
//    range = [content rangeOfString:@"&nbsp"];
//    if(range.length > 0) {
//        NSLog(@"111");
//       if( content.length > (range.location+range.length)
//       && [[content substringWithRange:NSMakeRange(range.location+range.length, 1)] isEqualToString:@";"]
//       ) {
//           NSLog(@"///found");
//           range.length += 1;
//           content = [content stringByReplacingCharactersInRange:range withString:@];
//       }
//       else {
//           NSLog(@"///not found");
//           break;
//       }
//    }
//    else {
//        break;
//    }
//    }
//
//    range = [content rangeOfString:@"&nbsp"];
//    if(range.length > 0) {
//        NSLog(@"111111 : %@", content);
//
//        NSString *str = @"你们的下一句话会是(&nbsp;ﾟ∀ﾟ)";
//        NSString *str1 = [str substringWithRange:NSMakeRange(16, 1)];
//        NSLog(@"%@", str1);
//        printf("%s\n", [str1 cStringUsingEncoding:NSUTF8StringEncoding]);
//
//        NSString *specialChars = @";ﾟ";
//        NSString *specialChar = [specialChars substringWithRange:NSMakeRange(1, 1)];
//        NSString *tmpReplace = @"##special char##";
//        NSLog(@"%@",specialChars);
//
//    }
