//
//  BannerView.m
//  hacfun
//
//  Created by Ben on 15/7/24.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "BannerView.h"
#import "FuncDefine.h"
#import "AppConfig.h"
@interface BannerView ()




@property (strong,nonatomic) NSArray *buttonDataAry;
@property (strong,nonatomic) NSMutableArray *buttons;



@end

static NSInteger kcountObjBannerView = 0;
@implementation BannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)alloc
{
    id obj = [super alloc];
    NSLog(@"%@ alloc-", [obj class]);
    return obj;
}


- (instancetype)init {
    self = [super init];
    
    if(self) {
        kcountObjBannerView ++;
        NSLog(@"BannerView1[%zd] init %@", kcountObjBannerView, self);
        [self setTopicButton];
    }
    
    return self;
}

#define TAG_IMAGEBACK   1001
#define TAG_IMAGEICON   1002

- (void)layoutSubviews {

    LOG_POSTION
    CGFloat width = 160;
    CGFloat yBorder = 3;
    CGFloat height = self.frame.size.height - 2*yBorder;
    [self.buttonTopic setFrame:CGRectMake(0, yBorder, width, height)];
    
    UIImageView *imageBack = (UIImageView*)[self viewWithTag:TAG_IMAGEBACK];
    [imageBack setFrame:CGRectMake(0, 0, 10, 0)];
    #define Y_CENTER(v, my) { CGRect frameOriginal = v.frame; CGFloat height = v.superview.frame.size.height - 2.0 * my ; height = height > 0 ? height : 0; [v setFrame: CGRectMake(frameOriginal.origin.x, my, frameOriginal.size.width, height)]; }
    Y_CENTER(imageBack, 6);
    
    UIImageView *image =(UIImageView*)[self viewWithTag:TAG_IMAGEICON];
    [image setFrame:CGRectMake(imageBack.frame.origin.x+imageBack.frame.size.width, 0, height, height)];
    [self.buttonTopic setTitleEdgeInsets:UIEdgeInsetsMake(0, image.frame.origin.x + image.frame.size.width + 2, 0, 0)];
    [self.buttonTopic setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    LOG_REC0(imageBack.frame, @"imageBack");
    LOG_REC0(self.buttonTopic.frame, @"buttonTopic");
}


- (void)setTopicButton {
    
    LOG_POSTION
    self.backgroundColor = [UIColor colorWithName:@"BannerViewBackground"];
    
    self.buttonTopic = [[PushButton alloc] init];
    self.buttonTopic.showsTouchWhenHighlighted = YES;
    [self addSubview:self.buttonTopic];
    [self.buttonTopic setTitleColor:[UIColor colorWithName:@"BannerTopicText"] forState:UIControlStateNormal];
    [self.buttonTopic.titleLabel setFont:[UIFont fontWithName:@"ButtonTopic"]];
    
    UIImageView *imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backn"]];
    [self.buttonTopic addSubview:imageBack];
    [imageBack setTag:TAG_IMAGEBACK];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIconBanner"]];
    [self.buttonTopic addSubview:image];
    [image setTag:TAG_IMAGEICON];
    [self.buttonTopic setTitleEdgeInsets:UIEdgeInsetsMake(0, image.frame.origin.x + image.frame.size.width + 2, 0, 0)];
    [self.buttonTopic setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}


- (void)setTextTopic:(NSString *)text {
    [self.buttonTopic setTitle:text forState:UIControlStateNormal];
}






- (void)dealloc {
    kcountObjBannerView --;
    NSLog(@"BannerView1[%zd] dealloc %@", kcountObjBannerView, self);
}

@end