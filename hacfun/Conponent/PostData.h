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
@property (nonatomic) NSInteger tid ;//= 6297913;
@property (nonatomic) NSInteger tidBelongTo ;//= 6297913;
@property (strong, nonatomic) NSString *image ;
@property (nonatomic) BOOL lock ;//= 0;
@property (strong, nonatomic) NSString *name ; //= "";
@property (nonatomic) BOOL sage ;//= 0;
@property (strong, nonatomic) NSString *thumb ;//= "";
@property (strong, nonatomic) NSString *title ;//= "";
@property (nonatomic) NSString *uid ;//= TYXC4L2E;
@property (nonatomic) long long updatedAt ;//= 1436668641000;

@property (strong,nonatomic) NSMutableArray *replies;
@property (strong, nonatomic) NSArray *recentReply ;//=     ( 6299638, 6299598, 6299451, 6299426, 6299069);
@property (nonatomic) NSInteger replyCount ;//= 24;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic) BOOL bTopic; //是否是主题. 否则为回复.
@property (nonatomic) NSInteger mode; //数据是属于 1. 栏目模式; 2. Post模式.
@property (nonatomic) CGFloat optimumSizeHeight;

@property (nonatomic, strong) NSString *jsonstring;

typedef enum {
    PostDataTypeNone = 0,       //基础
    PostDataTypeReal,           //实时解析出来的.
    PostDataTypeLocal,          //本地缓存数据.
    PostDataTypeOnlyTid         //只有tid的.
}PostDataType;


@property (nonatomic,assign) PostDataType type;


- (void)copyFrom:(PostData*)postDataFrom;
- (BOOL)isIdInArray:(NSArray*)array;


+ (NSString*) postDataContentRetreat:(NSString*)content ;


typedef NS_ENUM(NSInteger, ThreadDataToViewType) {
    ThreadDataToViewTypeInfoUseNumber = 0,      //info栏显示No. 用于DetailViewControler.
    ThreadDataToViewTypeInfoUseReplyCount,  //info栏显示
    ThreadDataToViewTypeAdditionalInfoUseReplyCount
};


//PostData显示在View上的时候, 先转为一个ui元素显示内容的dictionary. 使用mutable时因为方便具体ui显示时的微调.
- (NSMutableDictionary*)toViewDisplayData:(ThreadDataToViewType)type;


//从栏目请求响应api中获取的内容中解出PostData数组. forum的信息以key=forum, obj=dict的形式存入additional.
+ (NSMutableArray*)parseFromCategoryJsonData:(NSData*)data atPage:(NSInteger)page storeAdditional:(NSMutableDictionary*)additonal;

//返回解析出的主题. 具体回复内容放置到replies中. additional可存储一些其他信息.
+ (PostData*)parseFromDetailedJsonData:(NSData*)data atPage:(NSInteger)page repliesTo:(NSMutableArray*)replies  storeAdditional:(NSMutableDictionary*)additonal;


//从json格式的 string中解析.
+ (PostData*)fromString:(NSString*)jsonstring atPage:(NSInteger)page;
+ (PostData*)fromOnlyTid:(NSInteger)tid;



//page=-1时取最后一页.
//下载内容为空或者解析出错时返回nil.
//在主线程中执行时返回nil.
+ (PostData*)sendSynchronousRequestByTid:(long long)tid atPage:(NSInteger)page repliesTo:(NSMutableArray*)replies storeAdditional:(NSMutableDictionary*)additonal;



@end







@interface PostDataPage : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray *postDatas;

@end


@interface PostViewDataPage : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray *postViewDatas;

@end




