//
//  CustomViewController.h
//  hacfun
//
//  Created by Ben on 15/8/17.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import <UIKit/UIKit.h>





@class ButtonData;

@interface CustomViewController : UIViewController




@property (nonatomic, copy)   NSString *textTopic;


@property (nonatomic, assign) CGFloat   yBolowView;

@property (nonatomic, assign) CGFloat   heightWastageByNavigationBar;

@property (nonatomic, assign) CGRect    frameSoftKeyboard;
@property (nonatomic, assign) BOOL      isShowingSoftKeyboard;



//设置导航栏右上的内容.
- (void)actionAddData:(ButtonData*)actionData;
- (void)actionRemoveDataByKeyString:(NSString*)string;
- (void)actionClear;
- (void)actionRefresh;

//Override.
- (NSArray*)toolData;
- (void)showToolBar;
- (void)hiddenToolBar;


//显示一个提示信息.
- (void)showIndicationText:(NSString*)text inTime:(NSTimeInterval)secs;
- (void)dismissIndicationText;

- (void)showProgressText:(NSString*)text inTime:(NSTimeInterval)secs;
- (void)dismissProgressText;


//用于某些响应selector.
- (void)dismiss;

//显示一个弹出view. 取消弹出view.
- (void)showPopupView:(UIView*)view;
- (void)dismissPopupView;

- (void)showPopupView:(UIView *)view inTime:(NSTimeInterval)secs;


//重载按钮行为(默认openLeftMenu).
- (void)clickButtonTopic ;


//重载以定义按钮事件.
- (void)actionViaString:(NSString*)string;


@end
