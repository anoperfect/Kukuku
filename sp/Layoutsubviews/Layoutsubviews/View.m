//
//  View.m
//  Layoutsubviews
//
//  Created by Ben on 15/9/3.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "View.h"
#define LOG NSLog(@"%d", __LINE__);
@implementation View




- (id)initWithFrame:(CGRect)frame {
    LOG
    
    self = [super initWithFrame:frame];
    LOG
    NSLog(@"self : %@", self);
    LOG
    
    [self setBackgroundColor:[UIColor blueColor]];
    LOG
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    LOG
    [subView setFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    LOG
    [subView setBackgroundColor:[UIColor yellowColor]];
    LOG
    [subView setTag:2];
    LOG
    NSLog(@"subView1 : %@", subView);
    LOG
    [self addSubview:subView];
    LOG
    
    return self;
}


- (void)layoutSubviews {
    
    NSLog(@"layoutSubviews");
    
    UIView *subView = [self viewWithTag:2];
    NSLog(@"subView2 : %@", subView);
    [subView setFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    
    CGRect frame = self.frame;
    frame.size.height += 20;
    [self setFrame:frame];
}


@end
