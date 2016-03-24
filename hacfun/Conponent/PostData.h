//
//  PostData.h
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostData : NSObject <NSCoding>





@property (strong, nonatomic) NSString * content;
@property (nonatomic) long long createdAt ; //=1436622610000;
@property (strong, nonatomic) NSString * email ;//= "";
@property (nonatomic) NSInteger forum ; //= 4;
@property (nonatomic) NSInteger id ;//= 6297913;
@property (strong, nonatomic) NSString *image ;
@property (nonatomic) BOOL lock ;//= 0;
@property (strong, nonatomic) NSString *name ; //= "";
@property (nonatomic) BOOL sage ;//= 0;
@property (strong, nonatomic) NSString *thumb ;//= "";
@property (strong, nonatomic) NSString *title ;//= "";
@property (nonatomic) NSString *uid ;//= TYXC4L2E;
@property (nonatomic) long long updatedAt ;//= 1436668641000;

@property (nonatomic) BOOL bTopic; //是否是主题. 否则为回复.
@property (strong,nonatomic) NSMutableArray *replys;
@property (strong, nonatomic) NSArray *recentReply ;//=     ( 6299638, 6299598, 6299451, 6299426, 6299069);
@property (nonatomic) NSInteger replyCount ;//= 24;

@property (nonatomic) NSInteger mode; //数据是属于 1. 栏目模式; 2. Post模式.

@property (nonatomic) NSInteger height;




typedef enum {
    PostDataTypeNone = 0,       //基础
    PostDataTypeReal,           //实时解析出来的.
    PostDataTypeLocal,          //本地缓存数据.
    PostDataTypeOnlyThreadId    //只有threadid的.
}PostDataType;


@property (nonatomic,assign) PostDataType type;


+ (PostData*)fromDictData: (NSDictionary *)dict ;
- (BOOL)isIdInArray:(NSArray*)array;


+ (NSString*) postDataContentRetreat:(NSString*)content ;


typedef NS_ENUM(NSInteger, ThreadDataToViewType) {
    ThreadDataToViewTypeInfoUseNumber,      //info栏显示No. 用于DetailViewControler.
    ThreadDataToViewTypeInfoUseReplyCount,  //info栏显示
    ThreadDataToViewTypeAdditionalInfoUseReplyCount,
};


//PostData显示在View上的时候, 先转为一个ui元素显示内容的dictionary. 使用mutable时因为方便具体ui显示时的微调.
- (NSMutableDictionary*)toViewDisplayData:(ThreadDataToViewType)type;


+ (NSMutableArray*)parseFromCategoryJsonData:(NSData*)data ;
+ (NSMutableArray*)parseFromDetailedJsonData:(NSData*)data ;
+ (NSMutableArray*)sendSynchronousRequestByThreadId:(long long)tid andPage:(NSInteger)page;
+ (PostData*)parseFromThreadJsonData:(NSData*)data ;


#if 0
+ (void)postDataAsyncRequestByTid:(NSInteger)tid
                          andPage:(NSInteger)page
                completionHandler:(void (^)(PostData*))handle;

#endif


@end



