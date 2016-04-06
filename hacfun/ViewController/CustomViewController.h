//
//  CustomViewController.h
//  hacfun
//
//  Created by Ben on 15/8/17.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerView.h"
#import "ButtonData.h"
@interface CustomViewController : UIViewController




@property (nonatomic, copy)   NSString *textTopic;
@property (nonatomic, copy)   NSString *titleString;
@property (nonatomic, copy)   NSString *infoString;

@property (nonatomic, assign) CGFloat   yBolowView;
@property (nonatomic, assign) CGFloat   heightWastageByNavigationBar;
@property (nonatomic, assign) CGRect    frameSoftKeyboard;
@property (nonatomic, assign) BOOL      isShowingSoftKeyboard;





- (void)setTopic:(NSString*)str ;


//显示一个提示信息.
- (void)showIndicationText:(NSString*)text;


//重载按钮行为(默认openLeftMenu).
- (void)clickButtonTopic ;


- (void)actionAddData:(ButtonData*)actionData;
- (void)actionRemoveDataByKeyString:(NSString*)string;


//重载以定义按钮时间.
- (void)actionViaString:(NSString*)string;


- (void)dismiss;


- (void)showPopupView:(UIView*)view;
- (void)dismissPopupView;
@end
