//
//  DBData.h
//  hacfun
//
//  Created by Ben on 16/1/16.
//  Copyright (c) 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DB_EXECUTE_OK 0
#define DB_EXECUTE_ERROR_SQL      -1
#define DB_EXECUTE_ERROR_EXIST    -2
#define DB_EXECUTE_ERROR_DATA     -3



@interface DBData : NSObject
- (NSInteger)DBCollectionInsert:(NSDictionary*)infoInsert;
- (BOOL)DBCollectionDelete:(NSDictionary*)infoDelete ;
- (NSArray*)DBCollectionQuery:(NSDictionary*)infoQuery ;
@end
