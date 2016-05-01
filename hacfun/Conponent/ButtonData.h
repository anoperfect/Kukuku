//
//  ButtonData.h
//  hacfun
//
//  Created by Ben on 15/7/30.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface ButtonData : NSObject

@property (strong,nonatomic) NSString *keyword;
@property (assign,nonatomic) NSInteger id;
@property (assign,nonatomic) NSInteger superId;
@property (strong,nonatomic) NSString *imageName;
@property (strong,nonatomic) NSString *title;
@property (assign,nonatomic) NSInteger method;//只显示图片,只显示文字,图片＋文字

@property (assign,nonatomic) id target;
@property (assign,nonatomic) SEL sel;
@end
