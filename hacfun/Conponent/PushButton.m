//
//  PushButton.m
//  hacfun
//
//  Created by Ben on 16/3/31.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "PushButton.h"

@implementation PushButton




- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}


- (void)setActionData:(ButtonData*)data
{
    _actionData = data;
    
    
    [self setTitle:@"收藏" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    
#if 0
    //[self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, widthButton - heightButton)];
    //[self setTitleEdgeInsets:UIEdgeInsetsMake(0, heightButton, 0, 0)];
    
    CGRect frame = button.imageView.frame;
    LOG_RECT(frame, @"button-image");
    frame = button.titleLabel.frame;
    LOG_RECT(frame, @"button-title");
#endif
    
    
}


#if 0
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat btnCornerRedius = 1;
    CGFloat titleW = contentRect.size.width - btnCornerRedius;
    CGFloat titleH = self.frame.size.height;
    CGFloat titleX = self.frame.size.height + btnCornerRedius;
    CGFloat titleY = 0;
    contentRect = (CGRect){{titleX,titleY},{titleW,titleH}};
    return contentRect;
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    CGFloat btnCornerRedius = 1;
    CGFloat imageW = self.frame.size.height -10;
    CGFloat imageH = self.frame.size.height -10;
    CGFloat imageX = 5;
    CGFloat imageY = 5;
    contentRect = (CGRect){{imageX,imageY},{imageW,imageH}};
    return contentRect;
    
}
#endif





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
