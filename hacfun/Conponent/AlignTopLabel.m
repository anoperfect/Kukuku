//
//  Label.m
//  hacfun
//
//  Created by Ben on 16/5/18.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "AlignTopLabel.h"

@implementation AlignTopLabel




- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets edgeText = UIEdgeInsetsMake(6, 6, 6, 6);
    CGRect frameText = UIEdgeInsetsInsetRect(bounds, edgeText);
    
    CGRect textRect = [super textRectForBounds:frameText limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y + edgeText.top;
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end

