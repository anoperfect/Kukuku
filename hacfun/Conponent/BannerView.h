//
//  BannerView.h
//  hacfun
//
//  Created by Ben on 15/7/24.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonData.h"
#import "PushButton.h"
@interface BannerView : UIView




@property (strong,nonatomic)PushButton *buttonTopic;

- (void)setTextTopic:(NSString*)text;

- (void)setButtonData:(NSArray*)buttonDataAry;





//依照关键字获取按钮.
- (PushButton*)getButtonByKeyword:(NSString*)keyword;

@end






