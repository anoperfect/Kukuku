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







@interface AppConfig ()

@property (strong,nonatomic) FMDatabase *configDataBase ;
@property (strong,nonatomic) FMDatabase *hostDataBase ;
@property (assign,nonatomic) NSInteger hostIndex ;

@property (strong,nonatomic) NSArray *hostnames;
@property (strong,nonatomic) NSArray *hosts;
@property (strong,nonatomic) NSArray *imageHosts;

//@property (strong,nonatomic) NSString *hostname;
//@property (strong,nonatomic) NSString *host;
//@property (strong,nonatomic) NSString *imageHost;


@end


@implementation AppConfig



+ (UIColor*)backgroundColorFor:(NSString*)name {
    
    static NSMutableArray *aryName = nil;
    static NSMutableArray *aryColor = nil;
    static BOOL isInited = NO;
    
    if(!isInited) {
        isInited = YES;
        
        aryName = [[NSMutableArray alloc] init];
        aryColor = [[NSMutableArray alloc] init];
        
        [aryName addObject:@""];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"PostViewCell"];
        [aryColor addObject:HexRGB(0xd0d0d0)];
        
        [aryName addObject:@"ThreadsViewController"];
        [aryColor addObject:[UIColor purpleColor]];
        
        [aryName addObject:@"ViewController"];
//        [aryColor addObject:[UIColor purpleColor]];
        [aryColor addObject:HexRGBAlpha(0x808080, 0.6)];
        
        [aryName addObject:@"BannerView"];
        [aryColor addObject:HexRGBAlpha(0xa0a0a0,0.0)];
        
        [aryName addObject:@"PostView"];
        [aryColor addObject:[UIColor lightGrayColor]];
        
        [aryName addObject:@"PostTableView"];
        [aryColor addObject:HexRGBAlpha(0xffffff, 0.6)];
        
        [aryName addObject:@"MenuAction"];
        [aryColor addObject:[UIColor blueColor]];
        
        [aryName addObject:@"CreateViewController"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"ImageViewController"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"PostDataCellView"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"ReplyCellBorderMain"];
        [aryColor addObject:[UIColor redColor]];
        
        [aryName addObject:@"ReplyCellBorderReply"];
        //[aryColor addObject:[UIColor blueColor]];
        [aryColor addObject:HexRGB(0xcccccc)];
        
        [aryName addObject:@"LoadingView"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"whiteColor"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"blackColor"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"clearColor"];
        [aryColor addObject:[UIColor clearColor]];
    }
    
    NSInteger index = [aryName indexOfObject:name];
    if(index != NSNotFound) {
        return [aryColor objectAtIndex:index];
    }
    else {
        NSLog(@"error- %s not found", __FUNCTION__);
    }
    
    return [UIColor orangeColor];
}


+ (UIColor*)textColorFor:(NSString*)name {
    
    static NSMutableArray *aryName = nil;
    static NSMutableArray *aryColor = nil;
    static BOOL isInited = NO;
    
    if(!isInited) {
        isInited = YES;
        
        aryName = [[NSMutableArray alloc] init];
        aryColor = [[NSMutableArray alloc] init];
        
        [aryName addObject:@"Black"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"CellTitle"];
        [aryColor addObject:HexRGBAlpha(0x0, 0.66)];
        
        [aryName addObject:@"CellInfo"];
        [aryColor addObject:HexRGBAlpha(0x0, 0.66)];
        
        [aryName addObject:@"CellInfoAdditional"];
        [aryColor addObject:HexRGBAlpha(0x0, 0.66)];
        
        [aryName addObject:@"RefreshTint"];
        [aryColor addObject:[UIColor redColor]];
        
        [aryName addObject:@"BannerButtonMenu"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"manageInfo"];
        [aryColor addObject:[UIColor redColor]];
        
        [aryName addObject:@"otherInfo"];
        [aryColor addObject:HexRGBAlpha(0x0, 0.66)];
    }
    
    NSInteger index = [aryName indexOfObject:name];
    if(index != NSNotFound) {
        return [aryColor objectAtIndex:index];
    }
    else {
        NSLog(@"#error- %s not found <%@>.", __FUNCTION__, name);
    }
    
    return [UIColor blueColor];
}


+ (UIFont*)fontFor:(NSString*)name {
    
    static NSMutableArray *aryName = nil;
    static NSMutableArray *aryFont = nil;
    static BOOL isInited = NO;
    
    if(!isInited) {
        isInited = YES;
        
        aryName = [[NSMutableArray alloc] init];
        aryFont = [[NSMutableArray alloc] init];
        
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        LOG_RECT(applicationFrame, @"applicationFrame")
        
        CGRect bounds = [[UIScreen mainScreen] bounds];
        LOG_RECT(bounds, @"bounds")
        
        [aryName addObject:@""];
        [aryFont addObject:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        
        [aryName addObject:@"PostTitle"];
        [aryFont addObject:[UIFont systemFontOfSize:applicationFrame.size.width*0.036]];
        
        [aryName addObject:@"PostContent"];
        [aryFont addObject:[UIFont systemFontOfSize:applicationFrame.size.width*0.045]];
        
        [aryName addObject:@"ButtonTopic"];
        [aryFont addObject:[UIFont systemFontOfSize:16.0]];
        
        [aryName addObject:@"BannerButtonMenu"];
        [aryFont addObject:[UIFont systemFontOfSize:applicationFrame.size.width*0.0400]];
        
        [aryName addObject:@"PopupView"];
        [aryFont addObject:[UIFont systemFontOfSize:16.0]];
    }
    
    NSInteger index = [aryName indexOfObject:name];
    if(index != NSNotFound) {
        return [aryFont objectAtIndex:index];
    }
    else {
        NSLog(@"error- %s <%@> not found", __FUNCTION__, name);
    }
    
    return [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];

}










//===========================================================================================================
//id, collectedAt
- (NSInteger)configDBCollectionInsert:(NSDictionary*)infoInsert {
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"collection"];
    NSInteger id;
    //NSInteger threadId;
    long long collectedAt;
    
    NSObject* obj;
    
    obj = [infoInsert objectForKey:@"id"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"id");
        return CONFIGDB_EXECUTE_ERROR_DATA;
    }
    id = [(NSNumber*)obj integerValue];
    
    obj = [infoInsert objectForKey:@"collectedAt"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"collectedAt");
        return CONFIGDB_EXECUTE_ERROR_DATA;
    }
    collectedAt = [(NSNumber*)obj longLongValue];
    
    BOOL couldBeReplaced = NO;
    
    if(couldBeReplaced) {
        NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(id, collectedAt) VALUES(%zi,%llu)", tableName, id, collectedAt];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return CONFIGDB_EXECUTE_ERROR_SQL;
        }
    }
    else {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(id, collectedAt) VALUES(%zi,%llu)", tableName, id, collectedAt];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return CONFIGDB_EXECUTE_ERROR_SQL;
        }
    }
    
    //insert record.
    //[self configDBRecordInsertOrReplace:infoInsert];
    
    return CONFIGDB_EXECUTE_OK;
}


- (BOOL)configDBCollectionDelete:(NSDictionary*)infoDelete {
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"collection"];
    
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@", tableName, [infoDelete objectForKey:@"id"]];
    if(![infoDelete objectForKey:@"id"]) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        NSLog(@"error- delete table %@ FAILED (need info %@).", tableName, @"id");
        return NO;
    }
    
    BOOL executeResult = [self.hostDataBase executeUpdate:delete];
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED (executeUpdate [%@] error).", tableName, delete);
        return NO;
    }
    
    return YES;
}


- (NSArray*)configDBCollectionQuery:(NSDictionary*)infoQuery {
    //默认按照最新收藏的放最前面.
    NSString *query = [NSString stringWithFormat:@"SELECT collection.id, collection.collectedAt, record.jsonstring FROM collection,record WHERE collection.id = record.id ORDER BY collection.collectedAt DESC"]; //ASC
    
    NSObject *obj = [infoQuery objectForKey:@"id"];
    if(obj && [obj isKindOfClass:[NSNumber class]]) {
        query = [NSString stringWithFormat:@"SELECT collection.id, record.jsonstring FROM collection,record WHERE collection.id = %@ AND collection.id = record.id", obj];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSInteger id = [rs intForColumn:@"id"];
        long long collectedAt = [rs longLongIntForColumn:@"collectedAt"];
        NSDictionary *dict = @{
                               @"id":[NSNumber numberWithInteger:id],
                               @"collectedAt":[NSNumber numberWithLongLong:collectedAt],
                               @"jsonstring":[rs stringForColumn:@"jsonstring"]
                               };
        [array addObject:dict];
    }
    NSLog(@"%s count : %zi", __FUNCTION__, [array count]);
    
    return [NSArray arrayWithArray:array];
}


//- (BOOL)configDBCollectionUpdate:(NSDictionary*)infoUpdate {
//    
//    NSString *tableName = [NSString stringWithFormat:@"collection"];
//    NSString *update = [NSString stringWithFormat:@"UPDATE %@ set collectedAt = %@ WHERE id = %@", tableName, [infoUpdate objectForKey:@"collectedAt"], [infoUpdate objectForKey:@"id"]];
//    
//    BOOL executeResult = [self.hostDataBase executeUpdate:update];
//    if(executeResult) {
//        NSLog(@"update table %@ OK.", tableName);
//    }
//    else {
//        NSLog(@"error --- update table %@ FAILED.", tableName);
//        return NO;
//    }
//    
//    [self configDBRecordInsert:(NSDictionary*)infoUpdate orReplace:YES];
//    
//    return YES;
//}













//===========================================================================================================
//id, collectedAt
- (NSInteger)configDBDetailHistoryInsert:(NSDictionary*)infoInsert countBeReplaced:(BOOL)couldBeReplaced{
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"detailhistory"];
    NSInteger id;
    //NSInteger threadId;
    long long createdAtForDisplay = 0;
    long long createdAtForLoaded = 0;
    
    NSObject* obj;
    
    obj = [infoInsert objectForKey:@"id"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"id");
        return CONFIGDB_EXECUTE_ERROR_DATA;
    }
    id = [(NSNumber*)obj integerValue];
    
    obj = [infoInsert objectForKey:@"createdAtForDisplay"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"createdAtForDisplay");
//        return CONFIGDB_EXECUTE_ERROR_DATA;
    }
    createdAtForDisplay = [(NSNumber*)obj longLongValue];
    
    
    obj = [infoInsert objectForKey:@"createdAtForLoaded"];
    if(!(obj && [obj isKindOfClass:[NSNumber class]])) {
        NSLog(@"error- insert table %@ FAILED (need info %@).", tableName, @"createdAtForLoaded");
//        return CONFIGDB_EXECUTE_ERROR_DATA;
    }
    createdAtForLoaded = [(NSNumber*)obj longLongValue];
    
    if(couldBeReplaced) {
        NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(id,createdAtForDisplay,createdAtForLoaded) VALUES(%zi,%llu,%llu)", tableName, id, createdAtForDisplay,createdAtForLoaded];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return CONFIGDB_EXECUTE_ERROR_SQL;
        }
    }
    else {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(id,createdAtForDisplay,createdAtForLoaded) VALUES(%zi,%llu,%llu)", tableName, id, createdAtForDisplay,createdAtForLoaded];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return CONFIGDB_EXECUTE_ERROR_SQL;
        }
    }
    
    return CONFIGDB_EXECUTE_OK;
}


- (BOOL)configDBDetailHistoryDelete:(NSDictionary*)infoDelete {
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"detailhistory"];
    
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@", tableName, [infoDelete objectForKey:@"id"]];
    if(![infoDelete objectForKey:@"id"]) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        NSLog(@"error- delete table %@ FAILED (need info %@).", tableName, @"id");
        return NO;
    }
    
    BOOL executeResult = [self.hostDataBase executeUpdate:delete];
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED (executeUpdate [%@] error).", tableName, delete);
        return NO;
    }
    
    return YES;
}


- (NSDictionary*)configDBDetailHistoryQuery:(NSDictionary*)infoQuery {
    NSDictionary *dict = @{};
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"detailhistory"];
    NSString *query = [NSString stringWithFormat:@"SELECT * from %@ where id = %@", tableName, [infoQuery objectForKey:@"id"]];
    
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        dict = @{
                 @"id":[NSNumber numberWithInteger:[rs intForColumn:@"id"]],
                 @"createdAtForDisplay":[rs stringForColumn:@"createdAtForDisplay"],
                 @"createdAtForLoaded":[rs stringForColumn:@"createdAtForLoaded"]
                 };
        break;
    }
    LOG_POSTION
    NSLog(@"detailhistory [%@] : %@", [infoQuery objectForKey:@"id"], dict);
    LOG_POSTION
    
    return dict;
}







- (NSInteger)configDBPostInsert:(NSDictionary*)infoInsert orReplace:(BOOL)couldBeReplaced{
    
    LOG_POSTION
    NSString *tableName = [NSString stringWithFormat:@"post"];
    
    id obj = [infoInsert objectForKey:@"id"];
    if(obj && [obj isKindOfClass:[NSNumber class]]) {
        
    }
    else {
        NSLog(@"error- insert table %@ FAILED (%@).", tableName, @"info error");
        return CONFIGDB_EXECUTE_ERROR_DATA;
    }
    
    if(couldBeReplaced) {
        NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(id) VALUES(%@)", tableName, obj];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return CONFIGDB_EXECUTE_ERROR_SQL;
        }
    }
    else {
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(id) VALUES(%@)", tableName, obj];
        BOOL executeResult = [self.hostDataBase executeUpdate:insert];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED (executeUpdate [%@] error).", tableName, insert);
            return CONFIGDB_EXECUTE_ERROR_SQL;
        }
    }
    
    return CONFIGDB_EXECUTE_OK;
}



- (BOOL)configDBPostDelete:(NSDictionary*)infoDelete {
    
    NSLog(@"3. delete : %@", infoDelete);
    
    NSString *tableName = [NSString stringWithFormat:@"post"];
    
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@", tableName, [infoDelete objectForKey:@"id"]];
    if(![infoDelete objectForKey:@"id"]) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        NSLog(@"error --- delete table %@ FAILED.", tableName);
        return NO;
    }
    
    BOOL executeResult = [self.hostDataBase executeUpdate:delete];
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


- (NSArray*)configDBPostQuery1:(NSDictionary*)infoQuery {
    
    NSString *tableName = [NSString stringWithFormat:@"post"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT threadId FROM %@ WHERE id = %@",tableName, [infoQuery objectForKey:@"id"]];
    if(![infoQuery objectForKey:@"id"]) {
        query = [NSString stringWithFormat:@"SELECT id FROM %@", tableName];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSInteger id = [rs intForColumn:@"id"];
        [array addObject:[NSNumber numberWithInteger:id]];
    }
    
    return [NSArray arrayWithArray:array];
}

- (NSArray*)configDBPostQuery:(NSDictionary*)infoQuery {
    
//    NSString *tableName = [NSString stringWithFormat:@"post"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT id FROM post,record WHERE post.id = %@ AND post.id = record.id",
                       [infoQuery objectForKey:@"id"]];
    if(![infoQuery objectForKey:@"id"]) {
        query = [NSString stringWithFormat:@"SELECT id, record.jsonstring FROM post,record WHERE post.id = record.id"];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSInteger id = [rs intForColumn:@"id"];
        NSLog(@"%@", [rs stringForColumn:@"jsonstring"]);
        NSDictionary *dict = @{
                               @"id":[NSNumber numberWithInteger:id],
                               @"jsonstring":[rs stringForColumn:@"jsonstring"]
                               };
        [array addObject:dict];
    }
    NSLog(@"%s count : %zi", __FUNCTION__, [array count]);
    
    return [NSArray arrayWithArray:array];
}


//- (BOOL)configDBPostUpdate:(NSDictionary*)infoUpdate {
//    
//    NSString *tableName = [NSString stringWithFormat:@"post"];
//    NSString *update = [NSString stringWithFormat:@"UPDATE %@ set jsonstring = %@ WHERE id = %@", tableName,
//                        [infoUpdate objectForKey:@"jsonstring"],
//                        [infoUpdate objectForKey:@"id"]];
//    
//    BOOL executeResult = [self.hostDataBase executeUpdate:update];
//    if(executeResult) {
//        NSLog(@"update table %@ OK.", tableName);
//    }
//    else {
//        NSLog(@"error --- update table %@ FAILED.", tableName);
//        return NO;
//    }
//    
//    return YES;
//}


- (BOOL)configDBRecordInsert:(NSDictionary*)infoInsert {
    
    LOG_POSTION
    
    NSString *tableName = [NSString stringWithFormat:@"record"];
    
//    NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(id, threadId, createdAt, updatedAt, jsonstring) VALUES(%zi, %zi, %lld, %lld, '%@')", tableName,
//                        [(NSNumber*)[infoInsert objectForKey:@"id"] integerValue],
//                        [(NSNumber*)[infoInsert objectForKey:@"threadId"] integerValue],
//                        [(NSNumber*)[infoInsert objectForKey:@"createdAt"] longLongValue],
//                        [(NSNumber*)[infoInsert objectForKey:@"updatedAt"] longLongValue],
//                        [infoInsert objectForKey:@"jsonstring"]];
//    BOOL executeResult = [self.hostDataBase executeUpdate:insert];
//    if(executeResult) {
//        NSLog(@"insert table %@ OK.", tableName);
//    }
//    else {
//        NSLog(@"error- insert table %@ FAILED.", tableName);
//        return NO;
//    }
    
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(id, threadId, createdAt, updatedAt, jsonstring) VALUES(?,?,?,?,?)", tableName];
    BOOL executeResult = [self.hostDataBase executeUpdate:insert,
                        [infoInsert objectForKey:@"id"],
                        [infoInsert objectForKey:@"threadId"],
                        [infoInsert objectForKey:@"createdAt"],
                        [infoInsert objectForKey:@"updatedAt"],
                        [infoInsert objectForKey:@"jsonstring"]];
    if(executeResult) {
        NSLog(@"insert table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- insert table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


- (BOOL)configDBRecordDelete:(NSDictionary*)infoDelete {
    
    NSLog(@"3. delete : %@", infoDelete);
    
    NSString *tableName = [NSString stringWithFormat:@"record"];
    
    NSString *delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE threadId = %@", tableName, [infoDelete objectForKey:@"id"]];
    if(![infoDelete objectForKey:@"id"]) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    }
    
    BOOL executeResult = [self.hostDataBase executeUpdate:delete];
    if(executeResult) {
        NSLog(@"delete table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- delete table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


- (NSArray*)configDBRecordQuery:(NSDictionary*)infoQuery {
    
    NSString *tableName = [NSString stringWithFormat:@"record"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = %@",tableName, [infoQuery objectForKey:@"id"]];
    if(![infoQuery objectForKey:@"id"]) {
        query = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSInteger id = [rs intForColumn:@"id"];
        NSInteger threadId = [rs intForColumn:@"threadId"];
        long long createdAt = [rs longLongIntForColumn:@"createdAt"];
        long long updatedAt = [rs longLongIntForColumn:@"updatedAt"];
        NSString *jsonstring = [rs stringForColumn:@"jsonstring"];
        NSDictionary *dict = @{
                               @"id":[NSNumber numberWithInteger:id],
                               @"threadId":[NSNumber numberWithInteger:threadId],
                               @"createdAt":[NSNumber numberWithLongLong:createdAt],
                               @"updatedAt":[NSNumber numberWithLongLong:updatedAt],
                               @"jsonstring":jsonstring};
        [array addObject:dict];
    }
    
    return [NSArray arrayWithArray:array];
}


- (BOOL)configDBRecordUpdate:(NSDictionary*)infoUpdate {
    
    NSString *tableName = [NSString stringWithFormat:@"record"];
    
    NSString *update = [NSString stringWithFormat:@"UPDATE %@ set threadId = %@, createdAt = %@, updatedAt = %@, jsonstring = ? WHERE id = %@", tableName,
                        [infoUpdate objectForKey:@"threadId"],
                        [infoUpdate objectForKey:@"createdAt"],
                        [infoUpdate objectForKey:@"updatedAt"],
                        [infoUpdate objectForKey:@"id"]];
    
    BOOL executeResult = [self.hostDataBase executeUpdate:update,
                          [infoUpdate objectForKey:@"jsonstring"]];
    if(executeResult) {
        NSLog(@"update table %@ OK.", tableName);
    }
    else {
        NSLog(@"error --- update table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


- (BOOL)configDBRecordInsertOrReplace:(NSDictionary*)infoInsert {
    
    BOOL result = YES;
    NSString *jsonstring = infoInsert[@"jsonstring"];
    
    NSDictionary* dictQuery = @{@"id":[infoInsert objectForKey:@"id"]};
    NSArray *arrayQuery = [self configDBRecordQuery:dictQuery];
    if(arrayQuery && [arrayQuery count] > 0) {
        NSLog(@"id = %@. already added.", [infoInsert objectForKey:@"id"]);
        
        NSDictionary *dictQueryResult = (NSDictionary*)[arrayQuery objectAtIndex:0];
        if([dictQueryResult isEqual:infoInsert]) {
            NSLog(@"id = %@. not need update.", [infoInsert objectForKey:@"id"]);
        }
        else if([jsonstring length] == 0){
            NSLog(@"error- id = %@. no json string.", [infoInsert objectForKey:@"id"]);
            result = NO;
        }
        else {
            NS0Log(@"1:\n%@", dictQueryResult);
            NS0Log(@"2:\n%@", infoInsert);
            
            NSLog(@"id = %@. update.", [infoInsert objectForKey:@"id"]);
            result = [self configDBRecordUpdate:infoInsert];
        }
    }
    else {
        result = [self configDBRecordInsert:infoInsert];
    }
    
    return result;
}


+ (AppConfig*)sharedConfigDB {
    
    static AppConfig* sharedAppConfig = nil;
    if(nil == sharedAppConfig) {
        sharedAppConfig = [[AppConfig alloc] init];
    }
    
    return sharedAppConfig;
}


-(id) init {
    if (self = [super init]) {
#if 0
        //创建各文件夹.
        //创建总 config.db.
        NSString *documentPath =
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbName = @"config.db";
        //NSString *pathConfigDB = [NSString stringWithFormat:@"%@/%@", documentPath, dbName];
        
        if(![fileManager fileExistsAtPath:pathConfigDB]) {
            NSLog(@"create %@ ", dbName);
            [self configDBRebuild];
        }
        else {
        }
#endif
        
        [self configDBBuildWithForceRebuild:NO];
        
        [self configDBOpen];
    }
    
    return self;
}


- (void)configDBBuildWithForceRebuild:(BOOL)forceRebuild{
    
    LOG_POSTION
    

    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建各文件夹.
    //创建总 config.db.
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbName = @"config.db";
    NSString *pathConfigDB = [NSString stringWithFormat:@"%@/%@", documentPath, dbName];
    if(forceRebuild) {
        [fileManager removeItemAtPath:pathConfigDB error:nil];
    }
    
    NSLog(@"create %@ ", pathConfigDB);
    FMDatabase *configDataBase = [FMDatabase databaseWithPath:pathConfigDB];
    [configDataBase open];
    [AppConfig configDBInitCreateTableHost:configDataBase];
    [AppConfig configDBInitCreateTableHostIndex:configDataBase];
    [AppConfig configDBInitCreateTableEmoticon:configDataBase];
    
    NSString *query = nil;
    FMResultSet *rs = nil;
    query = [NSString stringWithFormat:@"SELECT id, hostname FROM %@", @"hosts"];
    rs = [configDataBase executeQuery:query];
    while ([rs next]) {
        
        NSString *hostName = [rs stringForColumn:@"hostname"];
        NSInteger hostIndex = [rs intForColumn:@"id"];
        NSLog(@"vvv : id %zi, hostName : %@", hostIndex, hostName);
        
        FMDatabase *hostDataBase = nil;
        //创建数据库.
        NSString *folderHost = [NSString stringWithFormat:@"%@/%@", documentPath, hostName];
        if(![fileManager fileExistsAtPath:folderHost]) {
            NSLog(@"create %@ ", folderHost);
            
            [[NSFileManager defaultManager] createDirectoryAtPath:folderHost withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *pathHostConfigDB = [NSString stringWithFormat:@"%@/%@.db", folderHost, hostName];
        if(forceRebuild) {
            [fileManager removeItemAtPath:pathHostConfigDB error:nil];
        }

        NSLog(@"create %@ ", pathHostConfigDB);
        
        hostDataBase = [FMDatabase databaseWithPath:pathHostConfigDB];
        [hostDataBase open];
        [AppConfig configDBInitHostCreateTableSettingKV     :hostDataBase onHostName:hostName];
        [AppConfig configDBInitHostCreateTableCategory      :hostDataBase onHostName:hostName];
        [AppConfig configDBInitHostCreateTableCollection    :hostDataBase onHostName:hostName];
        [AppConfig configDBInitHostCreateTableDetailHistory :hostDataBase onHostName:hostName];
        [AppConfig configDBInitHostCreateTablePost          :hostDataBase onHostName:hostName];
        [AppConfig configDBInitHostCreateTableReply         :hostDataBase onHostName:hostName];
        [AppConfig configDBInitHostCreateTableRecord        :hostDataBase onHostName:hostName];
        
        [hostDataBase close];
        hostDataBase = nil;
    }
    
    [configDataBase close];
    configDataBase = nil;
}


- (void)configDBOpen {
    
    //清除数据.
    if(self.configDataBase) {
        [self.configDataBase close];
        self.configDataBase = nil;
    }
    
    if(self.hostDataBase) {
        [self.hostDataBase close];
        self.hostDataBase = nil;
    }
    
    self.hostIndex = 0;
    self.hostnames = nil;
    self.hosts = nil;
    
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbName = @"config.db";
    NSString *pathConfigDB = [NSString stringWithFormat:@"%@/%@", documentPath, dbName];
    self.configDataBase = [FMDatabase databaseWithPath:pathConfigDB];
    [self.configDataBase open];
    
    NSString *query = nil;
    FMResultSet *rs = nil;
    query = [NSString stringWithFormat:@"SELECT selectedIndex FROM %@", @"hostIndex"];
    rs = [self.configDataBase executeQuery:query];
    while ([rs next]) {
        self.hostIndex = [rs intForColumn:@"selectedIndex"];
        NSLog(@"vvv : %zi", self.hostIndex);
    }
    
    NSMutableArray *hostnames = [[NSMutableArray alloc] init];
    NSMutableArray *hosts = [[NSMutableArray alloc] init];
    NSMutableArray *imageHosts = [[NSMutableArray alloc] init];
    
    query = [NSString stringWithFormat:@"SELECT id, hostname, host, imageHost FROM %@", @"hosts"];
    rs = [self.configDataBase executeQuery:query];
    while ([rs next]) {
        
        NSInteger hostIndex = [rs intForColumn:@"id"];
        NSString *hostname = [rs stringForColumn:@"hostname"];
        NSString *host = [rs stringForColumn:@"host"];
        NSString *imageHost = [rs stringForColumn:@"imageHost"];
        
        [hostnames addObject:hostname];
        [hosts addObject:host];
        [imageHosts addObject:imageHost];
        
        NSLog(@"vvv : [%zi,%@,%@,%@]", hostIndex, hostname, host, imageHost);
        
        if(self.hostIndex == hostIndex) {
            NSString *folderHost = [NSString stringWithFormat:@"%@/%@", documentPath, hostname];
            NSString *pathHostConfigDB = [NSString stringWithFormat:@"%@/%@.db", folderHost, hostname];
            self.hostDataBase = [FMDatabase databaseWithPath:pathHostConfigDB];
            [self.hostDataBase open];
        }
    }
    
    self.hostnames = [NSArray arrayWithArray:hostnames];
    self.hosts = [NSArray arrayWithArray:hosts];
    self.imageHosts = [NSArray arrayWithArray:imageHosts];
}








- (NSString*)configDBSettingKVGet:(NSString*)key {
    NSString *value = @"";
    
    NSString *query = [NSString stringWithFormat:@"select value from %@ where key = \"%@\"", @"settingkv", key];
    FMResultSet *rs = [self.hostDataBase executeQuery:query];
    while ([rs next]) {
        NSString *strValue = [rs stringForColumn:@"value"];
        value = [NSString stringWithString:strValue];
        break;
    }
    
    NS0Log(@"key [%@] return value : [%@]", key, value);
    return value;
}


- (BOOL)configDBSettingKVSet:(NSString*)key withValue:(NSString*)value{
    
    NSString *update = [NSString stringWithFormat:@"update %@ set value = %@ where key = \"%@\"", @"settingkv", [NSString stringWithFormat:@"%@", value], key];
    [self.hostDataBase executeUpdate:update];
    
    return YES;
}








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
    
    if([key isEqual:@"categories"]) {
        NSMutableArray *arrayCategories = [[NSMutableArray alloc] init];
//        NSMutableDictionary *dic = nil;
        
        NSString *categoryTableName = [NSString stringWithFormat:@"category"];
        NSString *query = [NSString stringWithFormat:@"select name,link,click from %@ order by click DESC", categoryTableName];
        FMResultSet *rs = [self.hostDataBase executeQuery:query];
        while ([rs next]) {
            NSString *name = [rs stringForColumn:@"name"];
            NSString *link = [rs stringForColumn:@"link"];
            NSInteger click = [rs intForColumn:@"click"];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", link, @"link", [NSNumber numberWithInteger:click], @"click", nil];
            [arrayCategories addObject:dic];
        }
        
        NS0Log(@"--- cateogries : %@", arrayCategories);
        object = arrayCategories;
    }
    
    return object;
}


- (void)configDBSet:(id)key withObject:(id)object {
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
//    [self configDBInit];
    
    if([key isEqual:@"hostIndex"]) {
        
        if([(NSNumber*)object integerValue] != self.hostIndex) {
            NSString *tableName = @"hostIndex";
            NSString *update = [NSString stringWithFormat:@"update %@ set selectedIndex = %@", tableName, [NSString stringWithFormat:@"%@", object]];
            [self.configDataBase executeUpdate:update];
            
            self.hostIndex = [(NSNumber*)object integerValue];
            if(self.hostDataBase) {
                [self.hostDataBase close];
                self.hostDataBase = nil;
            }
            
            NSString *hostname = [self.hostnames objectAtIndex:self.hostIndex];
            NSString *documentPath =
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *folderHost = [NSString stringWithFormat:@"%@/%@", documentPath, hostname];
            NSString *pathHostConfigDB = [NSString stringWithFormat:@"%@/%@.db", folderHost, hostname];
            self.hostDataBase = [FMDatabase databaseWithPath:pathHostConfigDB];
            [self.hostDataBase open];
        }
    }
}


- (void)configDBSetAddCategoryClick:(NSString*)cateogry {
    LOG_POSTION
    
//    AppConfig *sharedConfigDB = [self sharedConfigDB];
//    [self configDBInit];
    
    NSString *tableName = [NSString stringWithFormat:@"category"];
    
    NSString *update =
        [NSString stringWithFormat:@"update %@ set click = click+1 where name = \"%@\"", tableName,  cateogry];
    [self.hostDataBase executeUpdate:update];
    LOG_POSTION
}







+ (BOOL)configDBInitDetectTableExist:(FMDatabase *)dataBase withTableName:(NSString*)tableName
{
    BOOL isExist = NO;
    FMResultSet *rs = [dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        if(count > 0) {
            isExist = YES;
            break;
        }
    }

    return isExist;
}


+ (BOOL)configDBInitCreateTableHost:(FMDatabase *)dataBase {
    NSString *tableName = @"hosts";
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostsTable = @"create table if not exists hosts(id integer primary key autoincrement, hostname varchar, host varchar, imageHost varchar)";
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", @"hosts");
    }
    else {
        NSLog(@"error- create table FAILED.");
        return NO;
    }
    
    NSString *insert1 = @"insert into hosts(id, hostname, host, imageHost) values(?,?,?,?)";
    executeResult = [dataBase executeUpdate:insert1,
                     [NSNumber numberWithInteger:0],
                     @"hacfun",
                     @"http://hacfun.tv/api",
                     @"http://cdn.ovear.info:8999"
                     ];
    if(executeResult) {
        NSLog(@"insert table %@ OK.", @"hosts");
    }
    else {
        NSLog(@"error- insert table FAILED.");
        return NO;
    }
    
    NSString *insert2 = @"insert into hosts(id, hostname, host, imageHost) values(?,?,?,?)";
    executeResult = [dataBase executeUpdate:insert2,
                     [NSNumber numberWithInteger:1],
                     @"kukuku",
                     @"http://kukuku.cc/api",
                     @"http://static.koukuko.com/h"
                     ];
    if(executeResult) {
        NSLog(@"insert table %@ OK.", @"hosts");
    }
    else {
        NSLog(@"error- insert table FAILED.");
        return NO;
    }
    
    return YES;
}


+ (BOOL)configDBInitCreateTableHostIndex:(FMDatabase *)dataBase {
    NSString *tableName = @"hostIndex";
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostIndexTable = @"create table if not exists hostIndex(selectedIndex integer)";
    BOOL executeResult = [dataBase executeUpdate:createHostIndexTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    NSString *insert1 = @"insert into hostIndex(selectedIndex) values(?)";
    NSInteger initedHostIndex = 1;
    executeResult = [dataBase executeUpdate:insert1,
                     [NSNumber numberWithInteger:initedHostIndex]
                     ];
    if(executeResult) {
        NSLog(@"insert table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- insert table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


+ (BOOL)configDBInitCreateTableEmoticon:(FMDatabase *)dataBase {
    NSString *tableName = @"emoticon";
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createTableEmoticon = @"create table if not exists emoticon(emoticon var, selectedtimes integer)";
    BOOL executeResult = [dataBase executeUpdate:createTableEmoticon];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    NSString *insert = @"insert into emoticon(emoticon,selectedtimes) values(?,?)";
    
    NSArray *arrayEmoticon = @[
        @"|∀ﾟ",
        @"(´ﾟДﾟ`)",
        @"(;´Д`)",
        @"(｀･ω･)",
        @"(=ﾟωﾟ)=",
        @"| ω・´)",
        @"|-` )",
        @"|д` )",
        @"|ー` )",
        @"|∀` )",
        @"(つд⊂)",
        @"(ﾟДﾟ≡ﾟДﾟ)",
        @"(＾o＾)ﾉ",
        @"(|||ﾟДﾟ)",
        @"( ﾟ∀ﾟ)",
        @"( ´∀`)",
        @"(*´∀`)",
        @"(*ﾟ∇ﾟ)",
        @"(*ﾟーﾟ)",
        @"(　ﾟ 3ﾟ)",
        @"( ´ー`)",
        @"( ・_ゝ・)",
        @"( ´_ゝ`)",
        @"(*´д`)",
        @"(・ー・)",
        @"(・∀・)",
        @"(ゝ∀･)",
        @"(〃∀〃)",
        @"(*ﾟ∀ﾟ*)",
        @"( ﾟ∀。)",
        @"( `д´)",
        @"(`ε´ )",
        @"(`ヮ´ )",
        @"σ`∀´)",
        @" ﾟ∀ﾟ)σ",
        @"ﾟ ∀ﾟ)ノ",
        @"(╬ﾟдﾟ)",
        @"(|||ﾟдﾟ)",
        @"( ﾟдﾟ)",
        @"Σ( ﾟдﾟ)",
        @"( ;ﾟдﾟ)",
        @"( ;´д`)",
        @"(　д ) ﾟ ﾟ",
        @"( ☉д⊙)",
        @"(((　ﾟдﾟ)))",
        @"( ` ・´)",
        @"( ´д`)",
        @"( -д-)",
        @"(, д<)",
        @"･ﾟ( ﾉд`ﾟ)",
        @"( TдT)",
        @"(￣∇￣)",
        @"(￣3￣)",
        @"(￣ｰ￣)",
        @"(￣ . ￣)", 
        @"(￣皿￣)", 
        @"(￣艸￣)", 
        @"(￣︿￣)", 
        @"(￣︶￣)", 
        @"ヾ(´ωﾟ｀)", 
        @"(*´ω`*)", 
        @"(・ω・)", 
        @"( ´・ω)", 
        @"(｀・ω)", 
        @"(´・ω・`)", 
        @"(`・ω・´)", 
        @"( `_っ´)", 
        @"( `ー´)", 
        @"( ´_っ`)", 
        @"( ´ρ`)", 
        @"( ﾟωﾟ)", 
        @"(oﾟωﾟo)", 
        @"(　^ω^)", 
        @"(｡◕∀◕｡)", 
        @"/( ◕‿‿◕ )\\",
        @"ヾ(´ε`ヾ)", 
        @"(ノﾟ∀ﾟ)ノ", 
        @"(σﾟдﾟ)σ", 
        @"(σﾟ∀ﾟ)σ", 
        @"|дﾟ )", 
        @"┃電柱┃", 
        @"ﾟ(つд`ﾟ)", 
        @"ﾟÅﾟ )　", 
        @"⊂彡☆))д`)", 
        @"⊂彡☆))д´)", 
        @"⊂彡☆))∀`)", 
        @"(´∀((☆ミつ",
    ];
    
    for(NSString *string in arrayEmoticon) {
        executeResult = [dataBase executeUpdate:insert,
                         string,
                         [NSNumber numberWithInteger:0]
                        ];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED.", tableName);
        }
    }
    
    return YES;
}


- (id)configDBEmocticonGet:(id)dict {
    
    NSString *tableName = @"emoticon";
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [self.configDataBase executeQuery:query];
    while ([rs next]) {
        NSString *string = [rs stringForColumn:@"emoticon"];
        [array addObject:string];
    }
    
    return [NSArray arrayWithArray:array];
}


- (NSArray*)getEmoticonStrings {
    return [NSArray arrayWithArray:[self configDBEmocticonGet:nil]];
}


+ (BOOL)configDBInitHostCreateTableSettingKV:(FMDatabase*)dataBase onHostName:(NSString*)hostName{
    NSString *tableName = @"settingkv";
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSDictionary *dictKVKeys = @{
                                 /*@"hostIndex":@"1",*/
                                 @"disableimageshow":@"0",
                                 @"autosaveimagetoalbum":@"0",
                                 @"nil":@"nil"
                                 };
    
    NSString *createHostsTable = @"create table if not exists settingkv(key varchar, value varchar)";
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table FAILED.");
        return NO;
    }
    
    for(NSString *key in dictKVKeys) {
        
        NSString *insert = @"insert into settingkv(key, value) values(?,?)";
        executeResult = [dataBase executeUpdate:insert,
                         key,
                         (NSString*)[dictKVKeys objectForKey:key]
                         ];
        if(executeResult) {
            NSLog(@"insert table %@ OK.", hostName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED.", hostName);
            return NO;
        }
    }
    
    return YES;
}


+ (BOOL)configDBInitHostCreateTableCategory:(FMDatabase*)dataBase onHostName:(NSString*)hostName {
    NSString *tableName = @"category";
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostsTable = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement, name varchar, link varchar, click integer)", tableName];
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    NSString *insert1 = [NSString stringWithFormat:@"insert into %@ values(NULL,?,?,0)", tableName];
    
    NSMutableArray *arrayLink = [[NSMutableArray alloc] init];
    NSMutableArray *arrayName = [[NSMutableArray alloc] init];
    
    if([hostName isEqualToString:@"hacfun"]) {
        
        [arrayLink addObject:@"%E7%BB%BC%E5%90%88%E7%89%881"];
        [arrayName addObject:@"综合版1"];
        
        [arrayLink addObject:@"%E6%AC%A2%E4%B9%90%E6%81%B6%E6%90%9E"];
        [arrayName addObject:@"欢乐恶搞"];
        
        [arrayLink addObject:@"%E6%8E%A8%E7%90%86"];
        [arrayName addObject:@"推理"];
        
        [arrayLink addObject:@"%E6%8A%80%E6%9C%AF%E5%AE%85"];
        [arrayName addObject:@"技术讨论"];
        
        [arrayLink addObject:@"%E6%96%99%E7%90%86"];
        //    [arrayName addObject:@"美食<fontstyle='color:#fff'>(汪版)</font>"];
        [arrayName addObject:@"美食(汪版)"];
        
        [arrayLink addObject:@"%E8%B2%93%E7%89%88"];
        [arrayName addObject:@"喵版"];
        
        [arrayLink addObject:@"%E9%9F%B3%E4%B9%90"];
        [arrayName addObject:@"音乐"];
        
        [arrayLink addObject:@"%E8%80%83%E8%AF%95"];
        [arrayName addObject:@"校园(考试)"];
        
        [arrayLink addObject:@"%E4%BA%8C%E6%AC%A1%E5%88%9B%E4%BD%9C"];
        [arrayName addObject:@"绘画涂鸦(二创)"];
        
        [arrayLink addObject:@"%E5%A7%90%E5%A6%B91"];
        [arrayName addObject:@"姐妹(淑女)"];
        
        [arrayLink addObject:@"%E5%A5%B3%E6%80%A7%E5%90%91"];
        [arrayName addObject:@"女性向"];
        
        [arrayLink addObject:@"%E5%A5%B3%E8%A3%85"];
        [arrayName addObject:@"女装(时尚)"];
        
        [arrayLink addObject:@"%E6%97%A5%E8%AE%B0"];
        [arrayName addObject:@"日记(树洞)"];
        
        [arrayLink addObject:@"WIKI"];
        [arrayName addObject:@"WIKI"];
        
        [arrayLink addObject:@"%E9%83%BD%E5%B8%82%E6%80%AA%E8%B0%88"];
        [arrayName addObject:@"都市怪谈"];
        
        
        [arrayLink addObject:@"%E5%8A%A8%E7%94%BB"];
        [arrayName addObject:@"动画"];
        
        [arrayLink addObject:@"%E6%BC%AB%E7%94%BB"];
        [arrayName addObject:@"漫画"];
        
        [arrayLink addObject:@"%E5%9B%BD%E6%BC%AB"];
        [arrayName addObject:@"国漫"];
        
        [arrayLink addObject:@"%E7%BE%8E%E6%BC%AB"];
        [arrayName addObject:@"美漫"];
        
        [arrayLink addObject:@"%E8%BD%BB%E5%B0%8F%E8%AF%B4"];
        [arrayName addObject:@"轻小说"];
        
        [arrayLink addObject:@"%E5%B0%8F%E8%AF%B4"];
        [arrayName addObject:@"小说(连载)"];
        
        [arrayLink addObject:@"GALGAME"];
        [arrayName addObject:@"GALGAME"];
        
        [arrayLink addObject:@"VOCALOID"];
        [arrayName addObject:@"VOCALOID"];
        
        [arrayLink addObject:@"%E4%B8%9C%E6%96%B9Project"];
        [arrayName addObject:@"东方Project"];
        
        [arrayLink addObject:@"%E8%88%B0%E5%A8%98"];
        [arrayName addObject:@"舰娘"];
        
        [arrayLink addObject:@"LoveLive"];
        [arrayName addObject:@"LoveLive"];
        
        
        [arrayLink addObject:@"%E6%B8%B8%E6%88%8F"];
        [arrayName addObject:@"游戏综合版"];
        
        [arrayLink addObject:@"EVE"];
        [arrayName addObject:@"EVE"];
        
        [arrayLink addObject:@"DNF"];
        [arrayName addObject:@"DNF"];
        
        [arrayLink addObject:@"%E6%88%98%E4%BA%89%E9%9B%B7%E9%9C%86"];
        [arrayName addObject:@"战争雷霆"];
        
        [arrayLink addObject:@"LOL"];
        [arrayName addObject:@"LOL"];
        
        [arrayLink addObject:@"DOTA"];
        [arrayName addObject:@"DOTA"];
        
        [arrayLink addObject:@"GTA5"];
        [arrayName addObject:@"GTA5"];
        
        [arrayLink addObject:@"Minecraft"];
        [arrayName addObject:@"Minecraft"];
        
        [arrayLink addObject:@"MUG"];
        [arrayName addObject:@"音乐游戏"];
        
        [arrayLink addObject:@"WOT"];
        [arrayName addObject:@"WOT坦克世界"];
        
        [arrayLink addObject:@"WOW"];
        [arrayName addObject:@"WOW"];
        
        [arrayLink addObject:@"D3"];
        [arrayName addObject:@"D3"];
        
        [arrayLink addObject:@"%E5%8D%A1%E7%89%8C%E6%A1%8C%E6%B8%B8"];
        [arrayName addObject:@"卡牌桌游"];
        
        [arrayLink addObject:@"%E7%82%89%E7%9F%B3%E4%BC%A0%E8%AF%B4"];
        [arrayName addObject:@"炉石传说"];
        
        [arrayLink addObject:@"%E6%80%AA%E7%89%A9%E7%8C%8E%E4%BA%BA"];
        [arrayName addObject:@"怪物猎人"];
        
        [arrayLink addObject:@"%E5%8F%A3%E8%A2%8B%E5%A6%96%E6%80%AA"];
        [arrayName addObject:@"口袋妖怪"];
        
        [arrayLink addObject:@"AC%E5%A4%A7%E9%80%83%E6%9D%80"];
        [arrayName addObject:@"AC大逃杀"];
        
        [arrayLink addObject:@"%E7%B4%A2%E5%B0%BC"];
        [arrayName addObject:@"索尼"];
        
        [arrayLink addObject:@"%E4%BB%BB%E5%A4%A9%E5%A0%82"];
        [arrayName addObject:@"任天堂"];
        
        [arrayLink addObject:@"%E6%97%A5%E9%BA%BB"];
        [arrayName addObject:@"日麻"];
        
        
        [arrayLink addObject:@"AKB"];
        [arrayName addObject:@"AKB48"];
        
        [arrayLink addObject:@"SNH48"];
        [arrayName addObject:@"SNH48"];
        
        [arrayLink addObject:@"COSPLAY"];
        [arrayName addObject:@"眼科(Cosplay)"];
        
        [arrayLink addObject:@"%E5%A3%B0%E4%BC%98"];
        [arrayName addObject:@"声优"];
        
        [arrayLink addObject:@"%E6%A8%A1%E5%9E%8B"];
        [arrayName addObject:@"模型(手办)"];
        
        
        [arrayLink addObject:@"%E5%BD%B1%E8%A7%86"];
        [arrayName addObject:@"电影/电视"];
        
        [arrayLink addObject:@"%E6%91%84%E5%BD%B1"];
        [arrayName addObject:@"摄影"];
        
        [arrayLink addObject:@"%E4%BD%93%E8%82%B2"];
        [arrayName addObject:@"体育"];
        
        [arrayLink addObject:@"%E5%86%9B%E6%AD%A6"];
        [arrayName addObject:@"军武"];
        
        [arrayLink addObject:@"%E6%95%B0%E7%A0%81"];
        [arrayName addObject:@"数码"];
        
        [arrayLink addObject:@"%E5%A4%A9%E5%8F%B0"];
        [arrayName addObject:@"天台(股票)"];
        
        [arrayLink addObject:@"%E5%80%BC%E7%8F%AD%E5%AE%A4"];
        [arrayName addObject:@"值班室"];
    }
    else if([hostName isEqualToString:@"kukuku"]) {
        //        <a href="/%E6%96%99%E7%90%86">美食<font style="color:#fff">（汪版）</font></a>
        //        <a href="/%E9%80%9F%E6%8A%A5">速报<font style="color:#f00"> new</font></a>
        //        <a href="/LoveLive">LoveLive <font style="color:#f00"> new</font></a>
        
        [arrayLink addObject:@"%E7%BB%BC%E5%90%88%E7%89%881"];
        [arrayName addObject:@"综合版1"];
        
        [arrayLink addObject:@"%E6%AC%A2%E4%B9%90%E6%81%B6%E6%90%9E"];
        [arrayName addObject:@"欢乐恶搞"];
        
        [arrayLink addObject:@"%E6%8E%A8%E7%90%86"];
        [arrayName addObject:@"推理"];
        
        [arrayLink addObject:@"%E6%8A%80%E6%9C%AF%E5%AE%85"];
        [arrayName addObject:@"技术讨论"];
        
        [arrayLink addObject:@"%E6%96%99%E7%90%86"];
        [arrayName addObject:@"美食（汪版）"];
        
        [arrayLink addObject:@"%E8%B2%93%E7%89%88"];
        [arrayName addObject:@"喵版"];
        
        [arrayLink addObject:@"%E9%9F%B3%E4%B9%90"];
        [arrayName addObject:@"音乐"];
        
        [arrayLink addObject:@"%E4%BD%93%E8%82%B2"];
        [arrayName addObject:@"体育"];
        
        [arrayLink addObject:@"%E5%86%9B%E6%AD%A6"];
        [arrayName addObject:@"军武"];
        
        [arrayLink addObject:@"%E6%A8%A1%E5%9E%8B"];
        [arrayName addObject:@"模型"];
        
        [arrayLink addObject:@"%E8%80%83%E8%AF%95"];
        [arrayName addObject:@"考试"];
        
        [arrayLink addObject:@"%E6%95%B0%E7%A0%81"];
        [arrayName addObject:@"数码"];
        
        [arrayLink addObject:@"%E6%97%A5%E8%AE%B0"];
        [arrayName addObject:@"日记"];
        
        [arrayLink addObject:@"%E9%80%9F%E6%8A%A5"];
        [arrayName addObject:@"速报 new"];
        
        [arrayLink addObject:@"%E5%8A%A8%E7%94%BB"];
        [arrayName addObject:@"动画"];
        
        [arrayLink addObject:@"%E6%BC%AB%E7%94%BB"];
        [arrayName addObject:@"漫画"];
        
        [arrayLink addObject:@"%E7%BE%8E%E6%BC%AB"];
        [arrayName addObject:@"美漫（小马）"];
        
        [arrayLink addObject:@"%E8%BD%BB%E5%B0%8F%E8%AF%B4"];
        [arrayName addObject:@"轻小说"];
        
        [arrayLink addObject:@"%E5%B0%8F%E8%AF%B4"];
        [arrayName addObject:@"小说（连载）"];
        
        [arrayLink addObject:@"%E4%BA%8C%E6%AC%A1%E5%88%9B%E4%BD%9C"];
        [arrayName addObject:@"二次创作（同人）"];
        
        [arrayLink addObject:@"VOCALOID"];
        [arrayName addObject:@"VOCALOID"];
        
        [arrayLink addObject:@"%E4%B8%9C%E6%96%B9Project"];
        [arrayName addObject:@"东方Project"];
        
        [arrayLink addObject:@"%E5%BC%B9%E5%B9%95%E7%BD%91%E7%AB%99ABC"];
        [arrayName addObject:@"弹幕网站ABC"];
        
        [arrayLink addObject:@"%E6%B8%B8%E6%88%8F"];
        [arrayName addObject:@"游戏综合版"];
        
        [arrayLink addObject:@"EVE"];
        [arrayName addObject:@"EVE"];
        
        [arrayLink addObject:@"DNF"];
        [arrayName addObject:@"DNF"];
        
        [arrayLink addObject:@"%E6%88%98%E4%BA%89%E9%9B%B7%E9%9C%86"];
        [arrayName addObject:@"战争雷霆"];
        
        [arrayLink addObject:@"%E6%89%A9%E6%95%A3%E6%80%A7%E7%99%BE%E4%B8%87%E4%BA%9A%E7%91%9F%E7%8E%8B"];
        [arrayName addObject:@"扩散性百万亚瑟王"];
        
        [arrayLink addObject:@"LOL"];
        [arrayName addObject:@"LOL"];
        
        [arrayLink addObject:@"DOTA"];
        [arrayName addObject:@"DOTA"];
        
        [arrayLink addObject:@"Minecraft"];
        [arrayName addObject:@"Minecraft"];
        
        [arrayLink addObject:@"MUG"];
        [arrayName addObject:@"MUSIC GAME"];
        
        [arrayLink addObject:@"MUGEN"];
        [arrayName addObject:@"MUGEN"];
        
        [arrayLink addObject:@"WOT"];
        [arrayName addObject:@"WOT坦克世界"];
        
        [arrayLink addObject:@"WOW"];
        [arrayName addObject:@"WOW"];
        
        [arrayLink addObject:@"D3"];
        [arrayName addObject:@"D3"];
        
        [arrayLink addObject:@"%E5%8D%A1%E7%89%8C%E6%A1%8C%E6%B8%B8"];
        [arrayName addObject:@"卡牌桌游"];
        
        [arrayLink addObject:@"%E7%82%89%E7%9F%B3%E4%BC%A0%E8%AF%B4"];
        [arrayName addObject:@"炉石传说"];
        
        [arrayLink addObject:@"%E6%80%AA%E7%89%A9%E7%8C%8E%E4%BA%BA"];
        [arrayName addObject:@"怪物猎人"];
        
        [arrayLink addObject:@"%E5%8F%A3%E8%A2%8B%E5%A6%96%E6%80%AA"];
        [arrayName addObject:@"口袋妖怪"];
        
        [arrayLink addObject:@"%E7%B4%A2%E5%B0%BC"];
        [arrayName addObject:@"索尼"];
        
        [arrayLink addObject:@"%E4%BB%BB%E5%A4%A9%E5%A0%82"];
        [arrayName addObject:@"任天堂"];
        
        [arrayLink addObject:@"%E6%97%A5%E9%BA%BB"];
        [arrayName addObject:@"日麻"];
        
        [arrayLink addObject:@"%E8%88%B0%E5%A8%98"];
        [arrayName addObject:@"舰娘"];
        
        [arrayLink addObject:@"LoveLive"];
        [arrayName addObject:@"LoveLive  new"];
        
        [arrayLink addObject:@"AKB"];
        [arrayName addObject:@"AKB"];
        
        [arrayLink addObject:@"COSPLAY"];
        [arrayName addObject:@"眼科(Cosplay)"];
        
        [arrayLink addObject:@"%E5%BD%B1%E8%A7%86"];
        [arrayName addObject:@"电影/电视"];
        
        [arrayLink addObject:@"%E6%91%84%E5%BD%B1"];
        [arrayName addObject:@"摄影"];
        
        [arrayLink addObject:@"%E5%A3%B0%E4%BC%98"];
        [arrayName addObject:@"声优"];
        
        [arrayLink addObject:@"%E5%80%BC%E7%8F%AD%E5%AE%A4"];
        [arrayName addObject:@"值班室"];
    }
    else {
        [arrayLink addObject:@"%E7%BB%BC%E5%90%88%E7%89%881"];
        [arrayName addObject:@"综合版1"];
    }
    
    NSInteger count = [arrayName count];
    for(NSInteger i=0; i<count; i++) {
        executeResult = [dataBase executeUpdate:insert1,
                         (NSString*)[arrayName objectAtIndex:i],
                         (NSString*)[arrayLink objectAtIndex:i]
                         ];
        if(executeResult) {
            NS0Log(@"insert table %@ OK.", tableName);
        }
        else {
            NSLog(@"error- insert table %@ FAILED.", tableName);
            return NO;
        }
    }
    
    return YES;
}


+ (BOOL)configDBInitHostCreateTableCollection:(FMDatabase*)dataBase onHostName:(NSString*)hostName {
    //用stringWithFormat是因为之前表名有host后缀.
    NSString *tableName = [NSString stringWithFormat:@"collection"];
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostsTable = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key, collectedAt integer)", tableName];
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


#define SQLITE_STRING_TYPE_INTEGER  @"integer"

+ (BOOL)configDBInitHostCreateTableDetailHistory:(FMDatabase*)dataBase onHostName:(NSString*)hostName {
    
    NSString *tableName = [NSString stringWithFormat:@"detailhistory"];
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSMutableString *createHostsTable = [NSMutableString stringWithFormat:@"create table if not exists %@(id integer primary key", tableName];
    [createHostsTable appendFormat:@", %@ %@", @"createdAtForDisplay", SQLITE_STRING_TYPE_INTEGER];
    [createHostsTable appendFormat:@", %@ %@", @"createdAtForLoaded", SQLITE_STRING_TYPE_INTEGER];
    [createHostsTable appendString:@")"];
    
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


+ (BOOL)configDBInitHostCreateTablePost:(FMDatabase*)dataBase onHostName:(NSString*)hostName {
    
    NSString *tableName = [NSString stringWithFormat:@"post"];
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostsTable = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key)", tableName];
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


+ (BOOL)configDBInitHostCreateTableReply:(FMDatabase*)dataBase onHostName:(NSString*)hostName {
    
    NSString *tableName = [NSString stringWithFormat:@"reply"];
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostsTable = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key, threadId integer)", tableName];
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}


+ (BOOL)configDBInitHostCreateTableRecord:(FMDatabase*)dataBase onHostName:(NSString*)hostName {
    
    NSString *tableName = [NSString stringWithFormat:@"record"];
    if([self configDBInitDetectTableExist:dataBase withTableName:tableName]) {
        NSLog(@"table exist : %@", tableName);
        return YES;
    }
    
    NSString *createHostsTable = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key, threadId integer, createdAt integer, updatedAt integer, jsonstring varchar, belongto integer)", tableName];
    BOOL executeResult = [dataBase executeUpdate:createHostsTable];
    if(executeResult) {
        NSLog(@"create table %@ OK.", tableName);
    }
    else {
        NSLog(@"error- create table %@ FAILED.", tableName);
        return NO;
    }
    
    return YES;
}
















































































@end


