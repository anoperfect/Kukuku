//
//  CreateViewController.h
//  hacfun
//
//  Created by Ben on 15/7/28.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "TypeModel.h"
@interface CreateViewController : CustomViewController




//- (void)setCreateCategory:(NSString*)nameCategory withOriginalContent:(NSString*)originalContent;
//- (void)setReplyId:(NSInteger)id;
//- (void)setReplyId:(NSInteger)id withReference:(NSInteger)idReference;

//新串需填写category, tid为NSNotFound.
//回复tid的话, category需填写.
//originalContent用于举报,引用.
- (void)setCreateCategory:(Category*)category replyTid:(NSInteger)tid withOriginalContent:(NSString*)originalContent;
    

@end
