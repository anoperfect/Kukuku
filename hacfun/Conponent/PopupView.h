//
//  PopupView.h
//  hacfun
//
//  Created by Ben on 15/8/9.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView




@property (assign,nonatomic) CGFloat rectPadding;
@property (assign,nonatomic) CGFloat rectCornerRadius;

@property (assign,nonatomic) NSInteger numofTapToClose;
@property (assign,nonatomic) CGFloat secondsOfAutoClose;
@property (strong,nonatomic) NSString *titleLabel;
@property (assign,nonatomic) CGFloat borderLabel;
@property (assign,nonatomic) NSInteger line;
@property (strong,nonatomic) NSString* stringIncrease;
@property (assign,nonatomic) CGFloat secondsOfstringIncrease;

@property (assign,nonatomic) UILabel *labelText;
@property (strong,nonatomic) void (^finish)(void);




- (void)popupInSuperView:(UIView *)aSuperview;
- (void)removeView;




@end
