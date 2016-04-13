//
//  PopupView.m
//  hacfun
//
//  Created by Ben on 15/8/9.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PopupView.h"
#import "FuncDefine.h"
#import "AppConfig.h"




//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//
CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
    //
    // Create the boundary path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
    // Top left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
    // Top right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
    // Close the path at the rounded rect
    CGPathCloseSubpath(path);
    
    return path;
}


@interface PopupView ()

@property (strong,nonatomic) NSTimer *timerAutoClose;
@property (strong,nonatomic) NSTimer *timerIncreaseLabelText;

@end




@implementation PopupView





- (void)popupInSuperView:(UIView *)aSuperview {
    [self setFrame:[aSuperview bounds]];
    
    self.opaque = NO;
    self.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [aSuperview addSubview:self];
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    if([self.titleLabel length] > 0 || self.secondsOfstringIncrease > 0.0) {
        CGFloat width = self.frame.size.width - 2 * self.rectPadding - 2 * self.borderLabel;
        width = width > 0.0 ? width : self.frame.size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.line * 20)];
        [self addSubview:label];
        [label setTag:(NSInteger)@"label"];
        [label setCenter:self.center];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setText:self.titleLabel];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[AppConfig fontFor:@"PopupView"]];
        label.layer.cornerRadius = 2;//设置那个圆角的有多圆
        label.layer.masksToBounds = YES;
        self.labelText = label;
        [self.labelText setTextAlignment:NSTextAlignmentCenter];
    }
}


- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    [self removeView];
}


//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
    LOG_POSTION
    [self.timerAutoClose invalidate];
    [self.timerIncreaseLabelText invalidate];
    
    UIView *aSuperview = [self superview];
    [super removeFromSuperview];
    
    // Set up the animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    if(self.finish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.finish();
        });
    }
    
    [self removeFromSuperview];
}


- (void)autoIncreaseLabelText:(id)userinfo{
    UILabel *label = (UILabel*)[self viewWithTag:(NSInteger)@"label"];
    [label setText:[label.text stringByAppendingString:@"."]];
//    [label setText:[label.text stringByAppendingString:(NSString*)userinfo]];
}



//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
    rect.size.height -= 1;
    rect.size.width -= 1;
    
    const CGFloat RECT_PADDING = self.rectPadding;
    rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
    
    const CGFloat ROUND_RECT_CORNER_RADIUS = self.rectCornerRadius;
    CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat BACKGROUND_OPACITY = 0.86;
    CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextFillPath(context);
    
    const CGFloat STROKE_OPACITY = 0.20;
    CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextStrokePath(context);
    
    CGPathRelease(roundRectPath);
}


//在init注册观察者
-(id) init {
    if (self = [super init]) {
        
        [self addObserver:self
               forKeyPath:@"numofTapToClose"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"secondsOfAutoClose"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"titleLabel"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        
        [self addObserver:self
               forKeyPath:@"secondsOfstringIncrease"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        
        
        self.rectPadding = 0;
        self.rectCornerRadius = 2;
        
        self.numofTapToClose = 1;
        self.secondsOfAutoClose = 2;
        self.titleLabel = @"";
        self.borderLabel = 10;
        self.line = 3;
        self.stringIncrease = @"";
        self.secondsOfstringIncrease = 0;
        
    }
    return self;
}


//重写观察方
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"numofTapToClose"]) {
        NSArray *arrayGes = self.gestureRecognizers;
        for(UITapGestureRecognizer *ges in arrayGes) {
            [self removeGestureRecognizer:ges];
        }
        
        if(self.numofTapToClose > 0) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
            tapGestureRecognizer.numberOfTapsRequired = self.numofTapToClose;
            [self addGestureRecognizer:tapGestureRecognizer];
        }
    }
    else if([keyPath isEqualToString:@"secondsOfAutoClose"]) {
        if(self.timerAutoClose) {
            [self.timerAutoClose invalidate];
            self.timerAutoClose = nil;
        }
        
        if(self.secondsOfAutoClose > 0.0) {
            self.timerAutoClose = [NSTimer scheduledTimerWithTimeInterval:self.secondsOfAutoClose target:self selector:@selector(removeView) userInfo:nil repeats:NO];
        }
    }
    else if([keyPath isEqualToString:@"titleLabel"]) {
        NS0Log(@"titleLabel set to : %@", self.titleLabel);
        
        UILabel *label = (UILabel*)[self viewWithTag:(NSInteger)@"label"];
        [label setText:self.titleLabel];
    }
    else if([keyPath isEqualToString:@"secondsOfstringIncrease"]) {
        NS0Log(@"x-x-x- : %lf", self.secondsOfstringIncrease);
        
        if(self.timerIncreaseLabelText) {
            NS0Log(@"x-x-x- stop timer.");
            [self.timerIncreaseLabelText invalidate];
            self.timerIncreaseLabelText = nil;
        }
        
        if(self.secondsOfstringIncrease > 0.0) {
            NS0Log(@"x-x-x- new timer.");
            self.timerIncreaseLabelText = [NSTimer scheduledTimerWithTimeInterval:self.secondsOfstringIncrease target:self selector:@selector(autoIncreaseLabelText:) userInfo:nil repeats:YES];
        }
        else {
            [self.labelText setTextAlignment:NSTextAlignmentCenter];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


//移除观察者
-(void) dealloc
{
    [self removeObserver:self forKeyPath:@"numofTapToClose"];
    [self removeObserver:self forKeyPath:@"secondsOfAutoClose"];
    [self removeObserver:self forKeyPath:@"titleLabel"];
    [self removeObserver:self forKeyPath:@"secondsOfstringIncrease"];
}

@end












/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//    const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
//    const CGFloat DEFAULT_LABEL_HEIGHT = 60.0;
//    CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
//    UILabel *loadingLabel =
//    [[UILabel alloc]
//     initWithFrame:labelFrame];
//    loadingLabel.text = NSLocalizedString(@"Loading...", nil);
//    loadingLabel.textColor = [UIColor whiteColor];
//    loadingLabel.backgroundColor = [UIColor clearColor];
////    loadingLabel.textAlignment = UITextAlignmentCenter;
//    loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
//    loadingLabel.autoresizingMask =
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin;
//
//    [popupView addSubview:loadingLabel];
//    UIActivityIndicatorView *activityIndicatorView =
//    [[UIActivityIndicatorView alloc]
//     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [popupView addSubview:activityIndicatorView];
//    activityIndicatorView.autoresizingMask =
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleTopMargin |
//    UIViewAutoresizingFlexibleBottomMargin;
//    [activityIndicatorView startAnimating];
//
//    CGFloat totalHeight =
//    loadingLabel.frame.size.height +
//    activityIndicatorView.frame.size.height;
//    labelFrame.origin.x = floor(0.5 * (popupView.frame.size.width - DEFAULT_LABEL_WIDTH));
//    labelFrame.origin.y = floor(0.5 * (popupView.frame.size.height - totalHeight));
//    loadingLabel.frame = labelFrame;
//
//    CGRect activityIndicatorRect = activityIndicatorView.frame;
//    activityIndicatorRect.origin.x =
//    0.5 * (popupView.frame.size.width - activityIndicatorRect.size.width);
//    activityIndicatorRect.origin.y =
//    loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
//    activityIndicatorView.frame = activityIndicatorRect;


#if POPUPVIEW_ORIGINAL
+ (id)PopopInView:(UIView *)aSuperview
{
    PopupView *popupView =
    [[PopupView alloc] initWithFrame:[aSuperview bounds]];
    if (!popupView)
    {
        return nil;
    }
    
    popupView.opaque = NO;
    popupView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [aSuperview addSubview:popupView];
    
    
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:popupView action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [popupView addGestureRecognizer:tapGestureRecognizer];
    
    return popupView;
}
#endif