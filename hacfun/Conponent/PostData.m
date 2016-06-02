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




@interface PostData () <NSURLConnectionDelegate>



@end


@implementation PostData



- (instancetype)init
{
    self = [super init];
    if (self) {
                [self addObserver:self
                       forKeyPath:@"jsonstring"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:nil];
    }
    return self;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"jsonstring"]){//这里只处理balance属性
        NS0Log(@"keyPath=%@,object=%@,newValue=%@,context=%@",keyPath,object,[change objectForKey:@"new"],context);
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"jsonstring"];
}

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
    self.postViewData       = postDataFrom.postViewData.count>0 ? [NSMutableDictionary dictionaryWithDictionary:postDataFrom.postViewData] : nil;
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


- (NSArray<NSString*> *)contentURLStrings
{
    return nil;
}


+ (PostData*)fromDictData:(NSDictionary *)dict atPage:(NSInteger)page {
    
    PostData *pd = [[PostData alloc] init];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if(jsonData) {
        pd.jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NS0Log(@"form dict to json string : \ndict:\n%@\njsonstring:\n%@\n", dict, pd.jsonstring);
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
        
#define DICT_PARSE_GET_NSSTRING_R(keyr, item) { \
    obj = dict;\
    for(NSString *key in [keyr componentsSeparatedByString:@"/"]) {\
        obj = [obj objectForKey:key];\
        NS0Log(@"obj after %@ : %@", key, obj); \
    }\
    if([obj isKindOfClass:[NSString class]]){ \
        item = [(NSString*)obj copy]; \
    }\
    else { \
        NSLog(@"----------------------------------------------%@ not get", keyr); \
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
        
#define DICT_PARSE_GET_ARRAY(key, item) { \
        obj = [dict objectForKey:key]; \
        if([obj isKindOfClass:[NSArray class]]){ \
            item = [NSArray arrayWithArray:obj]; \
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
        DICT_PARSE_GET_ARRAY(@"recentReply", pd.recentReply)
        DICT_PARSE_GET_NSINTEGER(@"sage", pd.sage)
        DICT_PARSE_GET_NSSTRING(@"thumb", pd.thumb)
        DICT_PARSE_GET_NSSTRING(@"title", pd.title)
        DICT_PARSE_GET_NSSTRING(@"uid", pd.uid)
        DICT_PARSE_GET_LONGLONG(@"updatedAt", pd.updatedAt)
        
//        pd.content = [self postDataContentRetreat:pd.content];
        
        //recentReply进行判断及由小到大排序.
        NSArray *recentReply = pd.recentReply;
        pd.recentReply = nil;
        NSMutableArray *recentReplyCheck = [[NSMutableArray alloc] init];
        for(NSNumber *tidNumber in recentReply) {
            if([tidNumber isKindOfClass:[NSNumber class]]) {
                [recentReplyCheck addObject:tidNumber];
            }
        }
        pd.recentReply = [NSArray arrayWithArray:recentReplyCheck];
        pd.recentReply = [pd.recentReply sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *n1 = obj1;
            NSNumber *n2 = obj2;
            
            return [n1 compare:n2];
        }];
        
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


+ (PostData*)fromDictData:(NSDictionary *)dict atPage:(NSInteger)page onHostName:(NSString*)hostname
{
    
    PostData *pd = [[PostData alloc] init];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if(jsonData) {
        pd.jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NS0Log(@"form dict to json string : \ndict:\n%@\njsonstring:\n%@\n", dict, pd.jsonstring);
    }
    else {
        NSLog(@"#error - dict to jsonstring error. [dict:%@]", dict);
        pd.jsonstring = @"";
    }
    
    BOOL finished = NO;
    id obj;
    NS0Log(@"%@", dict);
    
    do {
        DICT_PARSE_GET_NSSTRING_R(@"ext/content", pd.content)
        DICT_PARSE_GET_LONGLONG(@"createTime", pd.createdAt)
//        DICT_PARSE_GET_NSSTRING(@"email", pd.email)
//        DICT_PARSE_GET_NSINTEGER(@"forum", pd.forum)
        DICT_PARSE_GET_NSINTEGER(@"id", pd.tid)
//        DICT_PARSE_GET_NSSTRING(@"image", pd.image)
        DICT_PARSE_GET_NSINTEGER(@"replyLocked", pd.lock)
//        DICT_PARSE_GET_NSSTRING(@"name", pd.name)
        DICT_PARSE_GET_NSINTEGER(@"replyCount", pd.replyCount)
//        DICT_PARSE_GET_ARRAY(@"recentReply", pd.recentReply)
        DICT_PARSE_GET_NSINTEGER(@"sage", pd.sage)
//        DICT_PARSE_GET_NSSTRING(@"thumb", pd.thumb)
        DICT_PARSE_GET_NSSTRING(@"title", pd.title)
        DICT_PARSE_GET_NSSTRING(@"creator", pd.uid)
        DICT_PARSE_GET_LONGLONG(@"sortTime", pd.updatedAt)
        
        NSNumber *hasImage = [dict objectForKey:@"hasImage"];
        NSDictionary *imageDict = [dict objectForKey:@"image"];
        if([hasImage isKindOfClass:[NSNumber class]] && [hasImage boolValue]) {
           
            if([imageDict isKindOfClass:[NSDictionary class]]) {
                NSNumber *widthNumber   = [imageDict objectForKey:@"width"];
                NSNumber *heightNumber  = [imageDict objectForKey:@"height"];
                NSNumber *sizeNumber    = [imageDict objectForKey:@"size"];
                NSNumber *banned        = [imageDict objectForKey:@"banned"];
                NSString *url           = [imageDict objectForKey:@"url"];
                
                if(
                   [widthNumber isKindOfClass:[NSNumber class]] && [widthNumber integerValue] > 0
                   &&   [heightNumber isKindOfClass:[NSNumber class]] && [heightNumber integerValue] > 0
                   &&   [sizeNumber isKindOfClass:[NSNumber class]] && [sizeNumber integerValue] > 0
                   &&   [banned isKindOfClass:[NSNumber class]] && ![banned boolValue]
                   &&   [url isKindOfClass:[NSString class]]
                   ) {
                    pd.image = [url copy];
                    if([sizeNumber integerValue] > 10*1000) {
                        //缩略图约束比例缩放到 (100, 68)
                        CGFloat width = [widthNumber integerValue];
                        CGFloat height = [heightNumber integerValue];
                        
                        
                        CGFloat widthTo = 100.0;
                        CGFloat heightTo = 68.0;
                        CGFloat scale = 2.0;
                        
                        NS0Log(@"from %d:%d", (int)width, (int)height);
                        
                        
                        if(width / height >= (widthTo / heightTo)) {
                            height = height / width * widthTo;
                            width = widthTo;
                        }
                        else {
                            width = width / height * heightTo;
                            height = heightTo;
                        }
                        
                        NS0Log(@"to   %d:%d", (int)width, (int)height);
                        
                        pd.thumb = [NSString stringWithFormat:@"%@?op=imageView2&mode=1&width=%d&height=%d&quality=60", pd.image, (int)(width*scale), (int)(height*scale)];
                    }
                    else {
                        pd.thumb = [pd.image copy];
                    }
                }
                else {
                    NSLog(@"#error - image parse failed.<%@>", dict);
                }
            }
            else {
                NSLog(@"#error - image parse failed.<%@>", dict);
            }
        }
        else {
            NS0Log(@"no image.")
        }
        
        
        
        //        pd.content = [self postDataContentRetreat:pd.content];
        
        //recentReply进行判断及由小到大排序.
        NSArray *recentReply = pd.recentReply;
        pd.recentReply = nil;
        NSMutableArray *recentReplyCheck = [[NSMutableArray alloc] init];
        for(NSNumber *tidNumber in recentReply) {
            if([tidNumber isKindOfClass:[NSNumber class]]) {
                [recentReplyCheck addObject:tidNumber];
            }
        }
        pd.recentReply = [NSArray arrayWithArray:recentReplyCheck];
        pd.recentReply = [pd.recentReply sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *n1 = obj1;
            NSNumber *n2 = obj2;
            
            return [n1 compare:n2];
        }];
        
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
    
    if(pd.tid > 0 && pd.uid.length > 0) {
        
    }
    else {
        NSLog(@"#error - parse PostData failed. <tid:%zd, uid:%@>", pd.tid, pd.uid);
        pd = nil;
    }
    
    return pd;
}


+ (PostData*)fromString:(NSString*)jsonstring atPage:(NSInteger)page
{
    if(!jsonstring) {
        return nil;
    }
    
    NSLog(@"fromString:%@", jsonstring);
    
    id obj = [NSJSONSerialization JSONObjectWithData:[jsonstring dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        PostData* postData = [self fromDictData:obj atPage:page onHostName:[[AppConfig sharedConfigDB] configDBHostsGetCurrent].hostname];
        if(postData) {
            //重新由fromDictData产生的jsonstring会因为重新排序的原因, 与参数的jsonstring不同. 在之后的LocaleViewController的Datasource PostData判断中, 判断为不同.
            //为避免这种问题, 重新设置一次jsonstring.
            postData.jsonstring = jsonstring;
            return postData;
        }
        else {
            NSLog(@"#error - fromDictData parse error.");
            return nil;
        }
    }
    else {
        NSLog(@"#error - json parse error.");
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


+ (NSString*)addLinkForRefTag:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@"\\[ref tid=\"[0-9]+\"/\\]" options:NSRegularExpressionSearch range:rangeSearch];
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
        
        NSLog(@"%zi %zi",
               [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
               [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *keyString = @"[ref tid=\"";
        NSString *tidString = [searchText substringWithRange:NSMakeRange(range.location+keyString.length, range.length-keyString.length)];
        NSInteger tid = [tidString integerValue];

        NSString *replacement = [NSString stringWithFormat:@"<a href='No.%zd'>>>No.%zd</a>", tid, tid];
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
        
        //已经添加链接的不添加.
        NSLog(@"zxc %zd %zd", rangeResult.location, rangeResult.length);
        NSString *subString = [searchText substringFromIndex:(rangeResult.location+rangeResult.length)];
        if([subString hasPrefix:@"</a>"] || [subString hasPrefix:@"\""]) {
            NSLog(@"ignore link");
        }
        else {
            [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
            [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        }
    
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
    
    //新版本使用NCR显示部分字符. 修改.
    content = [content NCRDecode];
    
    //font属性由RTLabel显示大小不合适. 手动修改成这样.
    content = [content stringByReplacingOccurrencesOfString:@"font size=\"5\"" withString:@"font size=\"16\""];
    
    //对No.xxx加载超链接.
    content = [self addLinkForReferenceNumber:content];
    
    //对[ref tid="123456"/]进行处理.
    content = [self addLinkForRefTag:content];
    
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
PostView 接收的字段字段
按照PostView中的说明.
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
    
    if(self.sage) {
        [dict setObject:@"SAGE" forKey:@"manageInfo"];
    }
    else {
        [dict setObject:@"" forKey:@"manageInfo"];
    }
    
    [dict setObject:@"" forKey:@"otherInfo"];
    
    //正文.
    //htm转换. 更新的接口response中有NCR. 可以用这种方法转换.
    //会导致其他元素丢失. 暂时不适用这种方法.
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.content dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    NS0Log(@"%@", attributedString);
    NS0Log(@"%@", [attributedString string]);
    
    NSString * content = [attributedString string];
    content = self.content;
    
    if(self.name.length > 0) {
        content = [NSString stringWithFormat:@"名称: %@\n%@", self.name, content];
    }
    if(self.email.length > 0 && ![self.email isEqualToString:@"sage"]) { //email的sage表示世嘉. 不用显示.
        content = [NSString stringWithFormat:@"E-mail: %@\n%@", self.email, content];
    }
    if(self.title.length > 0) {
        content = [NSString stringWithFormat:@"标题: %@\n%@", self.title, content];
    }
    
    content = [PostData postDataContentRetreat:content];
    [dict setObject:content?content:@"无正文" forKey:@"content"];
    
    //判断是否设置无图模式.
    NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"disableimageshow"] ;
    BOOL b = [value isEqualToString:@"bool1"];
    if(nil == self.thumb || [self.thumb isEqualToString:@""] || b) {
        
    }
    else {
        Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
        NSString *imageHost = host.imageHost;
        [dict setObject:[NSString stringWithFormat:@"%@%@", imageHost, self.thumb] forKey:@"thumb"];
    }
    
    return dict;
}


- (NSMutableDictionary*)toViewDisplayData:(ThreadDataToViewType)type
{
    if(self.type == PostDataTypeOnlyTid) {
        NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
        [dictm setObject:[NSString stringWithFormat:@"NO.%zd", self.tid]    forKey:@"title"];
        return dictm;
    }
    
    NSMutableDictionary *dictm = [self toVIewDisplayDataUseCustom];
    switch (type) {
        case ThreadDataToViewTypeCustom:
            break;

        case ThreadDataToViewTypeInfoUseNumber:
            [dictm setObject:[NSString stringWithFormat:@"No.%zi", self.tid] forKey:@"info"];
            break;
            
        case ThreadDataToViewTypeInfoUseReplyCount:
            [dictm setObject:[NSString stringWithFormat:@"回应: %zi", self.replyCount] forKey:@"info"];
            break;
            
        case ThreadDataToViewTypeAdditionalInfoUseReplyCount:
            [dictm setObject:[NSString stringWithFormat:@"No.%zi", self.tid] forKey:@"info"];
            [dictm setObject:[NSString stringWithFormat:@"回应: %zi", self.replyCount] forKey:@"otherInfo"];
            break;
            
        case ThreadDataToViewTypeFold:
            [dictm removeObjectsForKeys:@[@"manageInfo", @"otherInfo", @"statusInfo", @"content", @"colorUid", @"colorUidSign", @"thumb", @"replies"]];
            break;
            
        case ThreadDataToViewTypeSimple:
            [dictm removeObjectsForKeys:@[@"manageInfo", @"otherInfo", @"statusInfo", @"colorUid", @"colorUidSign", @"thumb", @"replies"]];
            [dictm setObject:@2 forKey:@"contentLineLimit"];
            break;
            
        default:
            break;
    }
    
    return dictm;
}


- (void)generatePostViewData:(ThreadDataToViewType)type
{
    self.postViewData = [self toViewDisplayData:type];
}


- (void)updatePostViewDataViaAddFoldInfo:(NSString*)info
{
    NSString *foldInfo = [self.postViewData objectForKey:@"fold"];
    if(foldInfo.length > 0) {
        NSArray *foldInfos = [foldInfo componentsSeparatedByString:@","];
        if([foldInfos indexOfObject:info] == NSNotFound) {
            [self.postViewData setObject:[NSString stringWithFormat:@"%@,%@", foldInfo, info] forKey:@"fold"];
        }
        else {
            NSLog(@"add fold info : already added.");
        }
    }
    else {
        [self.postViewData setObject:[NSString stringWithFormat:@"%@", info] forKey:@"fold"];
    }
}


- (void)updatePostViewDataViaRemoveFoldInfo:(NSString*)info
{
    NSString *foldInfo = [self.postViewData objectForKey:@"fold"];
    if(foldInfo.length > 0) {
        NSArray *foldInfos = [foldInfo componentsSeparatedByString:@","];
        NSMutableArray *foldInfosUpdate = [NSMutableArray arrayWithArray:foldInfos];
        [foldInfosUpdate removeObject:info];
        
        if(foldInfosUpdate.count < foldInfos.count) {
            if(foldInfosUpdate.count > 0) {
                [self.postViewData setObject:[foldInfosUpdate componentsJoinedByString:@","] forKey:@"fold"];
                NSLog(@"remove fold info %@, then %@", info, [self.postViewData objectForKey:@"fold"]);
            }
            else {
                [self.postViewData removeObjectForKey:@"fold"];
                NSLog(@"remove fold info %@, then none fold", info);
            }
        }
        else {
            NSLog(@"remove fold info %@ , not found.", info);
        }
        
        [self.postViewData setObject:[NSString stringWithFormat:@"%@,%@", foldInfo, info] forKey:@"fold"];
    }
    else {
        NSLog(@"#remove fold info %@ , not found, fold info empty", info);
    }
}


+ (void)gotParsedPostDatas:(NSArray*)postDatas
{
    //将比对优化部分放到AppConfig的接口实现中.
    if(![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self gotParsedPostDatas:postDatas];
        });
        
        return ;
    }

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
    
    //解析replys.
    key = @"replys";
    obj = [dict objectForKey:key];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tReplyDict = obj;
        
        NSLog(@"^^^^^^%@", tReplyDict.allKeys);
        
        NSMutableArray *replyPostDatas = [[NSMutableArray alloc] init];
        
        for(NSString *t in tReplyDict.allKeys) {
            if([t isKindOfClass:[NSString class]] && [t hasPrefix:@"t"] && [[t substringFromIndex:1] integerValue] > 0 && [[tReplyDict objectForKey:t] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dictPostData = [NSMutableDictionary dictionaryWithDictionary:[tReplyDict objectForKey:t]];
                [dictPostData setObject:[NSNumber numberWithInteger:[[t substringFromIndex:1] integerValue]] forKey:@"id"];
                
                PostData *postDataReply = [PostData fromDictData:[NSDictionary dictionaryWithDictionary:dictPostData] atPage:0];
                if(postDataReply) {
                    [replyPostDatas addObject:postDataReply];
                }
                else {
                    NSLog(@"#error - parse error.");
                }
            }
        }
        
        if(replyPostDatas.count > 0) {
            NSLog(@"add %zd recent replies to record.", replyPostDatas.count);
            [PostData gotParsedPostDatas:replyPostDatas];
        }
    }
    
    return postDatasArray;
}


+ (NSMutableArray*)parseFromCategoryJsonData:(NSData*)data atPage:(NSInteger)page storeAdditional:(NSMutableDictionary*)additonal onHostName:(NSString*)hostname
{
    id obj;
    NSDictionary *dict;

    
    if(nil == data) {
        NSLog(@"#error - data nil");
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
        NSLog(@"#error - obj [%@] nil or not NSDictionary class", @"JSONObjectWithData");
        return nil;
    }
    
    dict = (NSDictionary*)obj;
    
#if 0
    NSMutableArray *arr;
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
#endif
    
    
    PostData *pd = nil;
    NSMutableArray *postDatasArray = [[NSMutableArray alloc] init];
    
    
    
    NSArray *lists = [FuncDefine objectParseFromDict:dict WithXPath:@[
                                                                      @{@"result":[NSDictionary class]},
                                                                      @{@"list":[NSDictionary class]},
                                                                    ]];
    if(![lists isKindOfClass:[NSArray class]]) {
        NSLog(@"#error - %@ not found in dict.", @"list");
        return nil;
    }
    
    for(obj in lists) {
        
        if(![obj isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"#error - %@ not dictionary", @"parsing obj");
            continue;
        }
        
        pd = [PostData fromDictData:(NSDictionary*)obj atPage:page onHostName:hostname];
        if(nil == pd) {
            NSLog(@"#error - PostData fromDictData.")
            continue;
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
    
    //解析replys.
#if 0
    key = @"replys";
    obj = [dict objectForKey:key];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tReplyDict = obj;
        
        NSLog(@"^^^^^^%@", tReplyDict.allKeys);
        
        NSMutableArray *replyPostDatas = [[NSMutableArray alloc] init];
        
        for(NSString *t in tReplyDict.allKeys) {
            if([t isKindOfClass:[NSString class]] && [t hasPrefix:@"t"] && [[t substringFromIndex:1] integerValue] > 0 && [[tReplyDict objectForKey:t] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dictPostData = [NSMutableDictionary dictionaryWithDictionary:[tReplyDict objectForKey:t]];
                [dictPostData setObject:[NSNumber numberWithInteger:[[t substringFromIndex:1] integerValue]] forKey:@"id"];
                
                PostData *postDataReply = [PostData fromDictData:[NSDictionary dictionaryWithDictionary:dictPostData] atPage:0];
                if(postDataReply) {
                    [replyPostDatas addObject:postDataReply];
                }
                else {
                    NSLog(@"#error - parse error.");
                }
            }
        }
        
        if(replyPostDatas.count > 0) {
            NSLog(@"add %zd recent replies to record.", replyPostDatas.count);
            [PostData gotParsedPostDatas:replyPostDatas];
        }
    }
#endif
    
    NSLog(@"parsed PostData number : %zd", postDatasArray.count);
    
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
    
    //NSObject *obj;
    NSDictionary *dict;
    NSDictionary * dom = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if([dom isKindOfClass:[NSDictionary class]]) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NS0Log(@"obj nil %d", __LINE__);
        return nil;
    }
    
    PostData *topic = nil;
    
    dict = dom;
    NS0Log(@"%@", dict);
    
    NSString *key = @"threads";
    NSDictionary *threads = [dict objectForKey:key];
    if(threads) {
        if(![threads isKindOfClass:[NSDictionary class]]) {
            NSLog(@"obj [%@] nil or not NSDictionary class", key);
            return nil;
        }
        
        topic = [PostData fromDictData:threads atPage:page];
        if(nil == topic) {
            NSLog(@"error- : PostData formDictData with content %@", threads);
            return nil;
        }
        
        topic.tidBelongTo = 0;
        [self gotParsedPostDatas:@[topic]];
    }
    else {
        NSLog(@"#error - key threads nil.");
        return nil;
    }
    
    key = @"replys";
    PostData *pd = nil;
    NSArray *replyArray = [dom objectForKey:key];
    if(replyArray && [replyArray isKindOfClass:[NSArray class]]) {
        
    }
    else {
        NSLog(@"key %@ nil.", key);
        return topic;
    }
    
    for(NSDictionary* replyDict in replyArray) {
        
        if(![replyDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing obj");
            continue;
        }
        
        pd = [PostData fromDictData:replyDict atPage:page];
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
    
    key = @"forum";
    if([dom objectForKey:key]) {
        [additonal setObject:[dom objectForKey:key] forKey:key];
    }
    
    key = @"page";
    if([dom objectForKey:key]) {
        [additonal setObject:[dom objectForKey:key] forKey:key];
    }
    
    key = @"code";
    if([dom objectForKey:key]) {
        [additonal setObject:[dom objectForKey:key] forKey:key];
    }
    
    key = @"success";
    if([dom objectForKey:key]) {
        [additonal setObject:[dom objectForKey:key] forKey:key];
    }
    
    return topic;
}


//返回解析出的主题. 具体回复内容放置到replies中. additional可存储一些其他信息.
+ (PostData*)parseFromDetailedJsonData:(NSData*)data atPage:(NSInteger)page repliesTo:(NSMutableArray*)replies storeAdditional:(NSMutableDictionary*)additonal onHostName:(NSString*)hostname
{
    if(nil == data) {
        NSLog(@"data null");
        return nil;
    }
    
    NSString * key;
    
    //NSData转 NSString.
    NSString *jsonstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"json data string : \n%@", jsonstring);
    
    //NSObject *obj;
    NSDictionary *dict;
    NSDictionary * dom = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if([dom isKindOfClass:[NSDictionary class]]) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NS0Log(@"obj nil %d", __LINE__);
        return nil;
    }
    
    PostData *topic = nil;
    
    dict = dom;
    NS0Log(@"%@", dict);
    
    //收集附加信息.
    key = @"totalPage";
    NSNumber *totalPageNumber = [FuncDefine objectParseFromDict:dom WithXPath:@[
                                                                          @{@"result":[NSDictionary class]},
                                                                          @{@"replies":[NSDictionary class]},
                                                                          @{@"totalPage":[NSDictionary class]}
                                                                          ]
                           ];
    if([totalPageNumber isKindOfClass:[NSNumber class]]) {
        [additonal setObject:totalPageNumber forKey:key];
    }
    
    key = @"page";
    NSNumber *pageNumber = [FuncDefine objectParseFromDict:dom WithXPath:@[
                                                                                @{@"result":[NSDictionary class]},
                                                                                @{@"replies":[NSDictionary class]},
                                                                                @{@"page":[NSDictionary class]}
                                                                                ]
                                 ];
    if([pageNumber isKindOfClass:[NSNumber class]]) {
        [additonal setObject:pageNumber forKey:key];
    }

    
    key = @"code";
    NSNumber *codeNumber = [FuncDefine objectParseFromDict:dom WithXPath:@[
                                                                          @{@"code":[NSDictionary class]}
                                                                          ]
                           ];
    if([codeNumber isKindOfClass:[NSNumber class]]) {
        [additonal setObject:codeNumber forKey:key];
    }
    
    //Topic.
    key = @"threads";
    NSDictionary *threads = [FuncDefine objectParseFromDict:dom WithXPath:@[
                                                                            @{@"result":[NSDictionary class]},
                                                                            @{@"topic":[NSDictionary class]}
                                                                            ]
                             ];
    
    if(![threads isKindOfClass:[NSDictionary class]]) {
        NSLog(@"#error - obj [%@] nil or not NSDictionary class", key);
        return nil;
    }
    
    topic = [PostData fromDictData:threads atPage:page onHostName:hostname];
    if(nil == topic) {
        NSLog(@"error- : PostData formDictData with content %@", threads);
        return nil;
    }
        
    topic.tidBelongTo = 0;
    [self gotParsedPostDatas:@[topic]];
    
    NSArray *repliesData = [FuncDefine objectParseFromDict:dom WithXPath:@[
                                                                            @{@"result":[NSDictionary class]},
                                                                            @{@"replies":[NSDictionary class]},
                                                                            @{@"list":[NSDictionary class]}
                                                                            ]
                             ];
    key = @"replies";
    if(![repliesData isKindOfClass:[NSArray class]]) {
        NSLog(@"obj [%@] nil or not NSDictionary class", key);
    }
    else {
        PostData *pd = nil;
        
        for(NSDictionary* replyDict in repliesData) {
            
            if(![replyDict isKindOfClass:[NSDictionary class]]) {
                NSLog(@"%@ not dictionary", @"parsing obj");
                continue;
            }
            
            pd = [PostData fromDictData:replyDict atPage:page onHostName:hostname];
            if(nil == pd) {
                break;
            }
            
            pd.tidBelongTo = topic.tid;
            pd.bTopic = NO;
            pd.mode = 2;
            [replies addObject:pd];
        }
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


- (NSString*)stringByJsonEscape:(NSString*)str
{
    if(!str) {
        return @"";
    }
    else {
        return [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    }
}


#if 0 //前端用的方式.
 回复无图片.
    @"{\"adminPost\":false,\"ext\":{\"content\":\"%@\"},\"title\":\"%@\",\"topicGroup\":{\"id\":\"%zd\"},\"image\":{},\"topic\":{\"id\":\"%zd\"}}"

 回复无图片.
    {"adminPost":false,"ext":{"content":"abcdef(`)"},"title":"tit","topicGroup":{"id":"54"},"image":{},"topic":{"id":"6624990"}}

 主题和图片.
    {"adminPost":false,"ext":{"content":"|. Thanks."},"title":"1","topicGroup":{"id":"4"},"image":{"id":"31f645df-fe3b-4cb1-b721-947381f248ac"},"filename":"folding_79.592727272727px_1149609_easyicon.net.png","type":0}


 主题无图片.
    {"adminPost":false,"ext":{"content":" "},"title":"","topicGroup":{"id":"4"},"image":{},"type":0}


//        NSString *postImageId = @"31f645df-fe3b-4cb1-b721-947381f248ac";
//        self.postImageName = @"folding_79.592727272727px_1149609_easyicon.net.png";

NSMutableDictionary *dictPost = [[NSMutableDictionary alloc] init];
[dictPost setObject:@NO                                                     forKey:@"adminPost"];
[dictPost setObject:@{@"content":[self stringByJsonEscape:self.content]}    forKey:@"ext"];
[dictPost setObject:[self stringByJsonEscape:self.title]                    forKey:@"title"];
[dictPost setObject:@{@"id":[NSNumber numberWithInteger:category.forum]}    forKey:@"topicGroup"];
[dictPost setObject:@{} forKey:@"image"];

[dictPost setObject:@{@"id":[NSNumber numberWithInteger:tid]} forKey:@"topic"];
[dictPost setObject:@0 forKey:@"type"];




    NSMutableData *postBody = [[NSMutableData alloc] init];
    NSString *strBody = [NSString stringWithFormat:@"{\"adminPost\":false,\"ext\":{\"content\":\"%@\"},\"title\":\"%@\",\"topicGroup\":{\"id\":\"%zd\"},\"image\":{},\"topic\":{\"id\":\"%zd\"}}", [self stringByJsonEscape:self.content], [self stringByJsonEscape:self.title], category.forum, tid];
    NSLog(@"send post body : %@", strBody);
    postBody = [NSMutableData dataWithData:[strBody dataUsingEncoding:NSUTF8StringEncoding]];


#endif




- (void)aysncPostToCategory:(Category*)category
                    replyTo:(NSInteger)replyToTid
            responseHandler:(void (^)(NSURLResponse * response))responseHandler
            progrossHandler:(void (^)(NSString *status, BOOL continuous))progrossHandler
        completionHandler:(void (^)(NSURLResponse *response,
                                       NSData *data,
                                       NSError *connectionError))completionHandler
{
    self.responseHandler    = responseHandler;;
    self.progrossHandler    = progrossHandler;
    self.completionHandler  = completionHandler;
    self.responseData = [[NSMutableData alloc] init];
    
#if 0
    {
        "title": "",
        "creator": "",
        "image": {
            "id": "",
            "resourceKey": null,
            "resourceHash": null,
            "width": 0,
            "height": 0,
            "url": null
        },
        "topicGroupId": 0,
        "topicContent": "",
        "topicId": 6807712,
        "replyLocked": false,
        "reportCount": 0,
        "replyCount": 0,
        "ext": {
            "content": "",
            "contentHeight": 0
        },
        "topicGroup": {
            "id": 4,
            "name": null
        },
        "sage": false,
        "resourceType": 0,
        "type": 0,
        "hasVideo": false,
        "id": 6807712,
        "hasImage": false,
        "createTime": 0,
        "groupId": 0,
        "groupName": "",
        "sortTime": 0
    }
#endif
    
    if(!self.postImage) {
        //正文.
        NSString *urlString = nil;

        NSMutableDictionary *dictPost = [[NSMutableDictionary alloc] init];
        if(replyToTid == NSNotFound || replyToTid == 0) {
            NSString *query = @"/v2/topic/post/json";
            NSDictionary *argument = nil;
            urlString = [[AppConfig sharedConfigDB] generateRequestURL:query andArgument:argument];
        }
        else {
            NSString *query = @"/v2/topic/reply/json";
            NSDictionary *argument = nil;
            urlString = [[AppConfig sharedConfigDB] generateRequestURL:query andArgument:argument];
            
            dictPost[@"topicId"] = [NSNumber numberWithInteger:replyToTid];
            dictPost[@"id"] = [NSNumber numberWithInteger:replyToTid];
        }
        
        dictPost[@"title"] = @"";
        dictPost[@"creator"] = @"";
        NSDictionary *imageDict = @{
                                    @"id": @"",
                                    @"resourceKey": @"",
                                    @"resourceHash": @"",
                                    @"width": @0,
                                    @"height": @0,
                                    @"url": @""
                                };
        dictPost[@"image"] = imageDict;
        dictPost[@"topicGroupId"] = @0;
        dictPost[@"topicContent"] = @"";

        dictPost[@"replyLocked"] = @NO;
        dictPost[@"reportCount"] = @0;
        dictPost[@"replyCount"] = @0;
        dictPost[@"ext"] = @{
                             @"content": self.content,
                             @"contentHeight": @0
                             };
        dictPost[@"topicGroup"] = @{
                                    @"id": category?[NSNumber numberWithInteger:category.forum]:@0,
                                    @"name": category?category.name:@""
                                    },
        
        dictPost[@"sage"] = @false;
        dictPost[@"resourceType"] = @0;
        dictPost[@"type"] = @0;
        dictPost[@"hasVideo"] = @false;

        dictPost[@"hasImage"] = @false;
        dictPost[@"createTime"] = @0;
        dictPost[@"groupId"] = @0;
        dictPost[@"groupName"] = @"";
        dictPost[@"sortTime"] = @0;
        
        NSURL *url=[[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        
        NSData *postBody = [NSJSONSerialization dataWithJSONObject:dictPost options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"send post body : %@", [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
        
        [mutableRequest setHTTPMethod:@"POST"];
        [mutableRequest setHTTPBody:postBody];
        NSString *contentType = @"application/json";
        [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
        NSString *contentLength = [NSString stringWithFormat:@"%lu", postBody.length];
        [mutableRequest setValue:contentLength forHTTPHeaderField:@"Content-Length"];
        [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
    }
    else {
        //这段写的太烂.
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my.upload.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^{
            BOOL result = YES;
            //1.获取token.
            
            NSString *imageId = nil;
            NSString *uploadUrl = nil;
            NSString *token = nil;
            
            NSString *query = @"";
            NSDictionary *argument = nil;
            
            query = @"v2/upload/token/callback";
            argument = nil;
            
            NSLog(@"auth : perform <%@>.", query);
            NSDictionary *uploadTokenCallBack = [[AppConfig sharedConfigDB] sendSynchronousRequestAndJsonParseTo:query andArgument:argument];
            if([[uploadTokenCallBack objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *resultDict = [uploadTokenCallBack objectForKey:@"result"];
                imageId     = [resultDict objectForKey:@"imageId"];
                uploadUrl   = [resultDict objectForKey:@"uploadUrl"];
                token       = [resultDict objectForKey:@"token"];
                if([imageId isKindOfClass:[NSString class]]
                   && [uploadUrl isKindOfClass:[NSString class]]
                   && [token isKindOfClass:[NSString class]]
                   ) {
                    NSLog(@"upload <%@> execute OK.", query);
                }
                else {
                    NSLog(@"#error - upload <%@> response nil.", query);
                    result = NO;
                }
            }
            else {
                NSLog(@"#error - upload <%@> response nil.", query);
                result = NO;
            }

            
            //2.图片上传.
            if(result) {
            
                NSURL *url = [[NSURL alloc] initWithString:[uploadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
                
                //分界线的标识符
                //    NSString *TWITTERFON_FORM_BOUNDARY = @"----WebKitFormBoundaryJCYFNcctaaOtDHN2";
                NSString *TWITTERFON_FORM_BOUNDARY = @"Boundary+0xAbCdEfGbOuNdArY";
                NSMutableData *HTTPBody = [[NSMutableData alloc]init];
                
                [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", TWITTERFON_FORM_BOUNDARY, @"desc"] dataUsingEncoding:NSUTF8StringEncoding]];
                [HTTPBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", TWITTERFON_FORM_BOUNDARY, @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
                [HTTPBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", TWITTERFON_FORM_BOUNDARY, @"token"] dataUsingEncoding:NSUTF8StringEncoding]];
                [HTTPBody appendData:[token dataUsingEncoding:NSUTF8StringEncoding]];
                [HTTPBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                [HTTPBody appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"\"\r\n", TWITTERFON_FORM_BOUNDARY, @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
                NSData *imageData = UIImageJPEGRepresentation(self.postImage, 1.0);
                if(nil != (imageData = UIImagePNGRepresentation(self.postImage)) && imageData.length > 0) {
                    [HTTPBody appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [HTTPBody appendData:UIImagePNGRepresentation(self.postImage)];
                }
                else if(nil != (imageData = UIImageJPEGRepresentation(self.postImage, 1.0)) && imageData.length > 0) {
                    [HTTPBody appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [HTTPBody appendData:UIImagePNGRepresentation(self.postImage)];
                }
                else {
                    [HTTPBody appendData:[[NSString stringWithFormat:@"Content-Type: image/*\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                [HTTPBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [HTTPBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", TWITTERFON_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                
                //设置HTTPHeader中Content-Type的值
                NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
                //设置HTTPHeader
                [mutableRequest setValue:content forHTTPHeaderField:@"Content-Type"];
                //设置Content-Length
                [mutableRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[HTTPBody length]] forHTTPHeaderField:@"Content-Length"];
                NSLog(@"content-length : %zi", [HTTPBody length]);
                //设置http body
                [mutableRequest setHTTPBody:HTTPBody];
                //http method
                [mutableRequest setHTTPMethod:@"POST"];
                
                NSURLResponse *response = nil;
                NSData * imageUploadData = [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:&response error:nil];
                
                if(imageUploadData) {
                    NSLog(@"imageUploadData : %@", [[NSString alloc] initWithData:imageUploadData encoding:NSUTF8StringEncoding]);
                    NSDictionary *imageUploadDict = [NSJSONSerialization JSONObjectWithData:imageUploadData options:NSJSONReadingMutableLeaves error:nil];
                    
                    
                    NSString *imageIdResponse = [FuncDefine objectParseFromDict:imageUploadDict
                                                                      WithXPath:@[
                                                                                  @{@"response":[NSDictionary class]},
                                                                                  @{@"result":[NSDictionary class]}
                                                                                  ]
                                                 ];
                    if(!imageIdResponse) {
                        NSString *response = [imageUploadDict objectForKey:@"response"];
                        if([response isKindOfClass:[NSString class]]) {
                            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                            if([dictResponse isKindOfClass:[NSDictionary class]]) {
                                imageIdResponse = [dictResponse objectForKey:@"result"];
                            }
                        }
                    }
                    
                    if([imageIdResponse isKindOfClass:[NSString class]]) {
                        NSLog(@"image id : %@", imageIdResponse);
                        self.postImageId = imageIdResponse;
                        
                        NSString *postImageHash = [imageUploadDict objectForKey:@"hash"];
                        if([postImageHash isKindOfClass:[NSString class]]) {
                            self.postImageResourceHash = postImageHash;
                            //self.postImageResourceKey = [NSString stringWithFormat:@"%@.jpeg", postImageHash];
                        }
                        
                        if([imageIdResponse isEqualToString:imageId]) {
                            NSLog(@"image id : %@ checked", imageIdResponse);
                            
                        }
                        else {
                            NSLog(@"#error - image id : %@ check failed.", imageIdResponse);
                        }
                    }
                    else {
                        NSLog(@"#error - upload <%@> response nil.", @"file/upload");
                        result = NO;
                    }
                    
                }
                else {
                    NSLog(@"#error - upload <%@> response nil.", @"file/upload");
                    result = NO;
                }
            }
            else {
                NSLog(@"#error - ");
                if(self.progrossHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.progrossHandler(@"传送数据出错", NO);
                    });
                }
            }

            //3.正文发送.
            //正文.
            if(result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *urlString = nil;
                    
                    NSMutableDictionary *dictPost = [[NSMutableDictionary alloc] init];
                    if(replyToTid == NSNotFound || replyToTid == 0) {
                        NSString *query = @"/v2/topic/post/json";
                        NSDictionary *argument = nil;
                        urlString = [[AppConfig sharedConfigDB] generateRequestURL:query andArgument:argument];
                    }
                    else {
                        NSString *query = @"/v2/topic/reply/json";
                        NSDictionary *argument = nil;
                        urlString = [[AppConfig sharedConfigDB] generateRequestURL:query andArgument:argument];
                        
                        dictPost[@"topicId"] = [NSNumber numberWithInteger:replyToTid];
                        dictPost[@"id"] = [NSNumber numberWithInteger:replyToTid];
                    }
                    
                    dictPost[@"title"] = @"";
                    dictPost[@"creator"] = @"";
                    NSDictionary *imageDict = @{
                                                @"id": [self stringByJsonEscape:self.postImageId],
                                                @"resourceKey": [self stringByJsonEscape:self.postImageResourceKey],
                                                @"resourceHash": [self stringByJsonEscape:self.postImageResourceHash],
                                                @"width": [NSNumber numberWithInteger:self.postImageWidth],
                                                @"height": [NSNumber numberWithInteger:self.postImageHeight],
                                                @"url": [self stringByJsonEscape:self.postImageUrl]
                                                };
                    dictPost[@"image"] = imageDict;
                    dictPost[@"topicGroupId"] = @0;
                    dictPost[@"topicContent"] = @"";
                    
                    dictPost[@"replyLocked"] = @NO;
                    dictPost[@"reportCount"] = @0;
                    dictPost[@"replyCount"] = @0;
                    dictPost[@"ext"] = @{
                                         @"content": self.content,
                                         @"contentHeight": @0
                                         };
                    dictPost[@"topicGroup"] = @{
                                                @"id": category?[NSNumber numberWithInteger:category.forum]:@0,
                                                @"name": category?category.name:@""
                                                },
                    
                    dictPost[@"sage"] = @false;
                    dictPost[@"resourceType"] = @0;
                    dictPost[@"type"] = @0;
                    dictPost[@"hasVideo"] = @NO;
                    
                    dictPost[@"hasImage"] = @YES;
                    dictPost[@"createTime"] = @0;
                    dictPost[@"groupId"] = @0;
                    dictPost[@"groupName"] = @"";
                    dictPost[@"sortTime"] = @0;
                    
                    NSURL *url=[[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
                    
                    NSData *postBody = [NSJSONSerialization dataWithJSONObject:dictPost options:NSJSONWritingPrettyPrinted error:nil];
                    NSLog(@"send post body : %@", [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
                    
                    [mutableRequest setHTTPMethod:@"POST"];
                    [mutableRequest setHTTPBody:postBody];
                    NSString *contentType = @"application/json";
                    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
                    NSString *contentLength = [NSString stringWithFormat:@"%lu", postBody.length];
                    [mutableRequest setValue:contentLength forHTTPHeaderField:@"Content-Length"];
                    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
                });
            }
            else {
                NSLog(@"#error - ");
                if(self.progrossHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.progrossHandler(@"传送数据出错", NO);
                    });
                }
                
                if(self.completionHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.completionHandler(nil, nil, nil);
                    });
                }
            }
        });
    }
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    
    self.response = [response copy];
    
    if(self.responseHandler) {
        self.responseHandler(self.response);
    }
    
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NSLog(@"%@已经接收到数据", [NSThread currentThread]);
    
    [self.responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成", [NSThread currentThread]);
    
    if(self.progrossHandler) {
        self.progrossHandler(@"发送成功", NO);
    }
    
    if(self.completionHandler) {
        self.completionHandler(self.response, self.responseData, nil);
    }
}


- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"%6zd, %6zd, %6zd", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    
    if(self.progrossHandler) {
        self.progrossHandler([NSString stringWithFormat:@"发送中 - %zd%%", totalBytesWritten * 100 / totalBytesExpectedToWrite], YES);
    }
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
    
    if(self.progrossHandler) {
        self.progrossHandler(@"数据传输失败", NO);
    }
    
    if(self.completionHandler) {
        self.completionHandler(self.response, self.responseData, error);
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
