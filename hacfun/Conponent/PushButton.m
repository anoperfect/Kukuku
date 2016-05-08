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






























































@implementation ViewContainer

- (void)drawRect:(CGRect)rect
{
    NSLog(@"---drawRect");
    
#if 0
    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path addArcWithCenter:CGPointMake(20, 20) radius:10.0 startAngle:0.0 endAngle:M_PI*1 clockwise:YES];
    [path addArcWithCenter:CGPointMake(20, 20) radius:10.0 startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    [[UIColor blueColor] setStroke];
    [[UIColor whiteColor] setFill];
    [path stroke];
    [path fill];
    
#else
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIEdgeInsets edge = UIEdgeInsetsMake(2, 2, 2, 4);
    CGFloat heightForArrow = 6;
    CGFloat widthToArrow = 0.8;
    CGFloat arrowWidthPercentage = 0.6;
    CGFloat cornerRadius = 6.0;
    
    //创建path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //左圆角
    [path addArcWithCenter:CGPointMake(edge.left + cornerRadius, edge.top + heightForArrow + cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:M_PI*1.5 clockwise:YES];

    //上边左点.
    //[path moveToPoint:   CGPointMake(edge.left+cornerRadius, edge.top + heightForArrow)];
    
    //箭头左点.
    [path addLineToPoint:CGPointMake((width - edge.left - edge.right) * widthToArrow, edge.top + heightForArrow)];
    
    //箭头顶点.
    [path addLineToPoint:CGPointMake((width - edge.left - edge.right) * widthToArrow + arrowWidthPercentage * heightForArrow, edge.top)];
    
    //箭头右点.
    [path addLineToPoint:CGPointMake((width - edge.left - edge.right) * widthToArrow + arrowWidthPercentage * heightForArrow * 2, edge.top + heightForArrow)];
    
    //上边右点.
    [path addLineToPoint:CGPointMake((width - edge.right - cornerRadius), edge.top + heightForArrow)];
    
    //右圆角.
    [path addArcWithCenter:CGPointMake((width - edge.right - cornerRadius), edge.top + heightForArrow + cornerRadius) radius:cornerRadius startAngle:M_PI * 1.5 endAngle:M_PI*2 clockwise:YES];
    
    
    //右边下.
    [path addLineToPoint:CGPointMake((width - edge.right), height - edge.bottom - cornerRadius)];
    
    //右下圆角
    [path addArcWithCenter:CGPointMake((width - edge.right - cornerRadius), height - edge.bottom - cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI*0.5 clockwise:YES];
    
    //下边左.
    [path addLineToPoint:CGPointMake(edge.left+cornerRadius, height - edge.bottom)];
    
    //左下圆角.
    [path addArcWithCenter:CGPointMake(edge.left+cornerRadius, height - edge.bottom - cornerRadius) radius:cornerRadius startAngle:M_PI*0.5 endAngle:M_PI clockwise:YES];
    
    //左边.
    [path addLineToPoint:CGPointMake(edge.left, edge.top + heightForArrow + cornerRadius)];

    
    // 设置描边宽度（为了让描边看上去更清楚）
    [path setLineWidth:1.0];
    //设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
    [[UIColor blueColor] setStroke];
    [[UIColor whiteColor] setFill];
    // 描边和填充
    [path stroke];
    [path fill];
#endif
}





@end
