//
//  FuncDefine.m
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "FuncDefine.h"
#import "NSLogn.h"
@implementation FuncDefine











+ (UIViewController *)viewControllerOfView:(UIView*)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


+ (id)objectParseFromDict:(NSDictionary*)dict WithXPath:(NSArray*)xpath
{
    id obj = nil;
    
    id objParsing = dict;
    NS0Log(@"objParsing : %@", objParsing);
    for(NSDictionary *detail in xpath) {
        if(!([detail isKindOfClass:[NSDictionary class]] && detail.count == 1)) {
            LOG_POSTION
            obj = nil;
            break;
        }
        
        Class c = detail.allValues[0];
        if(c == [NSDictionary class]) {
            if([objParsing isKindOfClass:[NSDictionary class]]) {
                objParsing = [objParsing objectForKey:detail.allKeys[0]];
            }
            else {
                NSLog(@"#error : %@ -> %@", [objParsing class], objParsing);
                obj = nil;
                break;
            }
        }
        else if(c == [NSArray class]) {
            if([objParsing isKindOfClass:[NSArray class]]
               && [detail.allKeys[0] isKindOfClass:[NSNumber class]]
               && ((NSArray*)objParsing).count > [detail.allKeys[0] integerValue]
               ) {
                objParsing = [objParsing objectAtIndex:[detail.allKeys[0] integerValue]];
            }
            else {
                LOG_POSTION
                obj = nil;
                break;
            }
        }
        else {
            LOG_POSTION
            obj = nil;
            break;
        }
        
        if([xpath lastObject] == detail) {
            obj = objParsing;
        }
        else {
            NS0Log(@"keep parseing.");
        }
    }
    
    return obj;
}




@end







#if 0


//NSData -> NSString.
NSString *str = [[NSString alloc] initWithData:data];


//NSString -> NSData.
NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];









#endif