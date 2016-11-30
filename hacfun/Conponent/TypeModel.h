//
//  TypeModel.h
//  hacfun
//
//  Created by Ben on 16/6/2.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeModel : NSObject

@end




//host
@interface Host : NSObject

@property (nonatomic, assign) NSInteger     id;
@property (nonatomic, copy  ) NSString     *hostname;
@property (nonatomic, copy  ) NSString     *host;
@property (nonatomic, copy  ) NSString     *imageHost;
@property (nonatomic, copy  ) NSString     *urlString;
@property (nonatomic, assign) NSInteger     status;

@property (nonatomic, assign) NSInteger     numberInCategoryPage;
@property (nonatomic, assign) NSInteger     numberInDetailPage;
@end


//hostindex NSInteger

//emoticon
@interface Emoticon : NSObject

@property (nonatomic, copy  ) NSString     *emoticon;
@property (nonatomic, assign) NSInteger     click;

@end

//draft.
@interface Draft : NSObject

@property (nonatomic, assign) NSInteger     sn;
@property (nonatomic, copy  ) NSString     *content;
@property (nonatomic, assign) NSInteger     click;

@end





@interface SettingKV : NSObject

@property (nonatomic, copy  ) NSString     *key;
@property (nonatomic, copy  ) NSString     *value;

@end



@interface PCategory : NSObject

@property (nonatomic, assign) NSInteger     sn;
@property (nonatomic, copy  ) NSString     *name;
@property (nonatomic, copy  ) NSString     *link;
@property (nonatomic, assign) NSInteger     forum;
@property (nonatomic, assign) NSInteger     click;
@property (nonatomic, copy  ) NSString     *headerIconUrl;
@property (nonatomic, copy  ) NSString     *content;
@property (nonatomic, assign) BOOL          passwordRequired;




@end


@interface DetailHistory : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     createdAtForDisplay;
@property (nonatomic, assign) long long     createdAtForLoaded;

@end


@interface DetailRecord : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     browseredAt;

@end




//record . PostData.

//collection.
@interface Collection : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     collectedAt;

@end


@interface Post : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     postedAt;

@end


@interface Reply : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     repliedAt;
@property (nonatomic, assign) NSInteger     tidBelongTo;


@end


@interface NotShowUid : NSObject

@property (nonatomic, strong) NSString      *uid;
@property (nonatomic, assign) long long     commitedAt;
@property (nonatomic, strong) NSString      *comment;


- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (instancetype)NotShowUidWithDictionary:(NSDictionary*)dict;

@end

@interface NotShowTid : NSObject

@property (nonatomic, assign) NSInteger     tid;
@property (nonatomic, assign) long long     commitedAt;
@property (nonatomic, strong) NSString      *comment;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (instancetype)NotShowUidWithDictionary:(NSDictionary*)dict;

@end



@interface Attent : NSObject

@property (nonatomic, strong) NSString      *uid;
@property (nonatomic, assign) long long     commitedAt;
@property (nonatomic, strong) NSString      *comment;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (instancetype)NotShowUidWithDictionary:(NSDictionary*)dict;


@end







