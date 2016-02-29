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

- (CGFloat)getOriginYBelowView ;
- (BannerView*)getBannerView;

- (void)setTopic:(NSString*)str ;


//重载按钮行为(默认openLeftMenu).
- (void)clickButtonTopic ;

//重载设置按钮参数数据.
- (NSMutableArray*)getButtonDatas ;


@end
