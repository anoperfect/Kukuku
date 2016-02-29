//
//  BannerView.h
//  hacfun
//
//  Created by Ben on 15/7/24.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonData.h"
@interface BannerView : UIView




@property (strong,nonatomic)UIButton *buttonTopic;

- (void)setTextTopic:(NSString*)text;

- (void)setButtonData:(NSArray*)buttonDataAry;

- (UIButton*) getButtonByKeyword: (NSString*)keyword;

@end






