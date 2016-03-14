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




@property (strong,nonatomic) NSString *textTopic;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *infoString;

@property (nonatomic, assign) CGFloat yBolowView;


- (void)setTopic:(NSString*)str ;


//重载按钮行为(默认openLeftMenu).
- (void)clickButtonTopic ;

//重载设置按钮参数数据.
- (NSMutableArray*)getButtonDatas ;



- (void)actionAddData:(ButtonData*)actionData;


//重载以定义按钮时间.
- (void)actionViaString:(NSString*)string;


@end
