//
//  EmoticonCharacterView.h
//  hacfun
//
//  Created by Ben on 15/12/3.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputAction)(NSString *EmoticonString);


@interface EmoticonCharacterView : UIView

@property (nonatomic,copy)inputAction action;
@property (nonatomic,assign)BOOL isShow;

- (void)setInputAction:(inputAction)action;
- (void)emoticonsShow;
- (void)emoticonsHidden;

@end
