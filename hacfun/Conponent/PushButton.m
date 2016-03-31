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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
