//
//  CreateViewController.h
//  hacfun
//
//  Created by Ben on 15/7/28.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface CreateViewController : CustomViewController




- (void)setCreateCategory:(NSString*)nameCategory withOriginalContent:(NSString*)originalContent;
- (void)setReplyId:(NSInteger)id;
- (void)setReplyId:(NSInteger)id withReference:(NSInteger)idReference;
    
    

@end
