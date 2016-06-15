//
//  TypeModel.m
//  hacfun
//
//  Created by Ben on 16/6/2.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "TypeModel.h"
#import "Extension.pch"
@implementation TypeModel

@end




@implementation Host
@end


@implementation Emoticon
@end


@implementation Draft
@end


@implementation SettingKV
@end



@implementation Category

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
        //    } else if (![super isEqual:other]) {
        //        return NO;
    } else {
        if(![other isKindOfClass:[Category class]]) {
            return NO;
        }
        
        Category *otherCategory = other;
        if([self.name isEqualToString:otherCategory.name]
           && [self.link isEqualToString:otherCategory.link]
           && self.forum == otherCategory.forum
           && [self.headerIconUrl isEqualToString:otherCategory.headerIconUrl]
           && [self.content isEqualToString:otherCategory.content]
           && self.passwordRequired == otherCategory.passwordRequired
            ) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (NSUInteger)hash
{
    return [self.name hash] ^ [self.link hash];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@ , link:%@, forum:%zd, click:%zd, headerIconUrl:%@, content:%@", self.name, self.link, self.forum, self.click, self.headerIconUrl, self.content];
}


@end


@implementation DetailHistory

- (NSString*)description
{
    return [NSString stringWithFormat:@"tid : %zd . LastLoaded : %lld, %@ . LastDisplayed : %lld, %@",
            self.tid,
            self.createdAtForLoaded,
            self.createdAtForLoaded  ==0?@"0":[NSString stringFromMSecondInterval:self.createdAtForLoaded  andTimeZoneAdjustSecondInterval:0],
            self.createdAtForDisplay,
            self.createdAtForDisplay ==0?@"0":[NSString stringFromMSecondInterval:self.createdAtForDisplay andTimeZoneAdjustSecondInterval:0]
            ];
}

@end


@implementation DetailRecord

- (NSString*)description
{
    return [NSString stringWithFormat:@"tid : %zd . browseredAt : %lld, %@ .",
            self.tid,
            self.browseredAt,
            self.browseredAt  ==0?@"0":[NSString stringFromMSecondInterval:self.browseredAt andTimeZoneAdjustSecondInterval:0]
            ];
}

@end


@implementation Collection
@end


@implementation Post
@end


@implementation Reply
- (NSString*)description
{
    return [NSString stringWithFormat:@"%zd : %zd , repliedAt : %@", self.tidBelongTo, self.tid, [NSString stringFromMSecondInterval:self.repliedAt andTimeZoneAdjustSecondInterval:0]];
}
@end



#define ASSIGN_INTEGER_VALUE_FROM_DICTIONARYMEMBER(varqwe, dictasd, keyzxc, defaultqaz) \
//if([dictasd[keyzxc] isKindOfClass:[NSNumber class]]) {varqwe = [dictasd[keyzxc] integerValue];}\
//else {NSLog(@"#error - obj (%@) is not NSNumber class.", [dictasd[keyzxc]);varqwe = defaultqaz;}


#define ASSIGN_LONGLONG_VALUE_FROM_DICTIONARYMEMBER(varqwe, dictasd, keyzxc, defaultqaz) \
if([dictasd[keyzxc] isKindOfClass:[NSNumber class]]) {varqwe = [dictasd[keyzxc] longLongValue];}\
else {NSLog(@"#error - obj (%@) is not NSNumber class.", dictasd[keyzxc]);varqwe = defaultqaz;}

#define ASSIGN_STRING_VALUE_FROM_DICTIONARYMEMBER(varqwe, dictasd, keyzxc, defaultqaz) \
if([dictasd[keyzxc] isKindOfClass:[NSString class]]) {varqwe = [dictasd[keyzxc] copy];}\
else {NSLog(@"#error - obj (%@) is not NSString class.", dictasd[keyzxc]);varqwe = defaultqaz;}






@implementation NotShowUid


- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        ASSIGN_STRING_VALUE_FROM_DICTIONARYMEMBER(self.uid, dict, @"uid", @"");
        ASSIGN_LONGLONG_VALUE_FROM_DICTIONARYMEMBER(self.commitedAt, dict, @"commitedAt", 0);
        ASSIGN_STRING_VALUE_FROM_DICTIONARYMEMBER(self.comment, dict, @"comment", @"");
    }
    return self;
}


+ (instancetype)NotShowUidWithDictionary:(NSDictionary*)dict
{
    NotShowUid *notShowUid = [[NotShowUid alloc] initWithDictionary:dict];
    return notShowUid;
}



@end


@implementation NotShowTid

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        ASSIGN_INTEGER_VALUE_FROM_DICTIONARYMEMBER(self.tid, dict, @"tid", 0);
        ASSIGN_INTEGER_VALUE_FROM_DICTIONARYMEMBER(self.tid, dict, @"tid", 0)
        ASSIGN_LONGLONG_VALUE_FROM_DICTIONARYMEMBER(self.commitedAt, dict, @"commitedAt", 0);
        ASSIGN_STRING_VALUE_FROM_DICTIONARYMEMBER(self.comment, dict, @"comment", @"");
    }
    return self;
}


+ (instancetype)NotShowUidWithDictionary:(NSDictionary*)dict
{
    NotShowTid *notShowTid = [[NotShowTid alloc] initWithDictionary:dict];
    return notShowTid;
}


@end



@implementation Attent





- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        ASSIGN_STRING_VALUE_FROM_DICTIONARYMEMBER(self.uid, dict, @"uid", @"");
        ASSIGN_LONGLONG_VALUE_FROM_DICTIONARYMEMBER(self.commitedAt, dict, @"commitedAt", 0);
        ASSIGN_STRING_VALUE_FROM_DICTIONARYMEMBER(self.comment, dict, @"comment", @"");
    }
    return self;
}


+ (instancetype)NotShowUidWithDictionary:(NSDictionary*)dict
{
    Attent *attent = [[Attent alloc] initWithDictionary:dict];
    return attent;
}


@end