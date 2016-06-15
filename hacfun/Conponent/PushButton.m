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





- (void)horizonLayoutViews:(NSArray<UIView *> *)subviews
                  withEdge:(UIEdgeInsets)edge
            andSubViewEdge:(UIEdgeInsets)subviewEdge
{
    
    
    
    
}



- (void)verticalLayoutViews:(NSArray<UIView*>*) subviews
                   withEdge:(UIEdgeInsets)edge
             andSubViewEdge:(UIEdgeInsets)subviewEdge
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    height += edge.top;
    
    CGFloat xSubview = 0.0;
    CGFloat ySubview = 0.0;
    CGFloat ySubviewSum = edge.top;
    
    for(UIView *view in subviews) {
        width = MAX(view.bounds.size.width + subviewEdge.left + subviewEdge.right + edge.left + edge.right, width);
        height += subviewEdge.top + subviewEdge.bottom + view.bounds.size.height;
        
        xSubview = edge.left + subviewEdge.left;
        ySubview = ySubviewSum + subviewEdge.top;
        ySubviewSum += subviewEdge.top + subviewEdge.bottom + view.bounds.size.height;
        
        view.frame = CGRectMake(xSubview, ySubview, view.bounds.size.width, view.bounds.size.height);
        [self addSubview:view];
    }
    
    height += edge.bottom;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
}


#if 0
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
#endif




@end




@interface TextButtonLine ()

@property (nonatomic, strong) void (^action)(NSString* text);

@end

@implementation TextButtonLine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _buttonBackgroundColor = [UIColor whiteColor];
        _buttonBorderColor = [UIColor blackColor];
        _buttonTextColor = [UIColor blackColor];
        _buttonBorderWidth = 1.7;
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonBackgroundColor = [UIColor whiteColor];
        _buttonBorderColor = [UIColor blackColor];
        _buttonTextColor = [UIColor blackColor];
        _buttonBorderWidth = 1.7;
    }
    return self;
}


- (void)setTexts:(NSArray<NSString*>*)texts
{
    _buttonTexts = texts;
    [self startDisplay];
}


- (void)startDisplay
{
    NSInteger index = 0;
    NSInteger count = _buttonTexts.count;
    CGFloat buttonWidth = self.frame.size.width;
    CGFloat buttonHeight = self.frame.size.width;
    CGFloat widthInterval = (self.frame.size.width - buttonWidth) / (count - 1);
    
    CGFloat heightInterval = buttonHeight * 1.27;
    for(NSString *text in _buttonTexts) {
        
        PushButton *button = [[PushButton alloc] init];
        button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        [button setTitle:text forState:UIControlStateNormal];
        button.center = CGPointMake(buttonWidth/2, buttonHeight/2);
#define TEXTBUTTONLINE_BUTTON_TAG      6000
        button.tag = index + TEXTBUTTONLINE_BUTTON_TAG;
        //button.backgroundColor = [UIColor blueColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        button.layer.borderColor = self.buttonBorderColor.CGColor;
        button.layer.borderWidth = self.buttonBorderWidth;
        button.layer.cornerRadius = button.frame.size.width / 2;
        [button setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        button.backgroundColor = self.buttonBackgroundColor;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        //button.edgeTitleLabel = UIEdgeInsetsMake(12, 12, 12, 12);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        
        [self addSubview:button];
        
        index ++;
    }
    
    widthInterval = 0;
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         for(NSInteger index = 0; index < count ; index ++) {
                             UIView *view = [self viewWithTag:index+TEXTBUTTONLINE_BUTTON_TAG];
                             view.center = CGPointMake(buttonWidth/2, buttonHeight/2 + index * (heightInterval+6));
                         }
                     }
     
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              for(NSInteger index = 0; index < count ; index ++) {
                                                  UIView *view = [self viewWithTag:index+TEXTBUTTONLINE_BUTTON_TAG];
                                                  view.center = CGPointMake(buttonWidth/2, buttonHeight/2 + index * heightInterval);
                                              }
                                          }
                          
                                          completion:^(BOOL finished) {
                                              
                                              
                                              
                                          }
                          ];

                         
                         
                     }
     ];
}


- (void)setButtonActionByText:(void (^)(NSString* text))action
{
    self.action = [action copy];
}


- (void)buttonClick:(UIButton*)button
{
    NSInteger index = button.tag - TEXTBUTTONLINE_BUTTON_TAG;
    if(index >= 0 && index < _buttonTexts.count && self.action) {
        self.action(_buttonTexts[index]);
    }
}

@end
