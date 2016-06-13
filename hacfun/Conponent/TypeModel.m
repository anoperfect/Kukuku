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