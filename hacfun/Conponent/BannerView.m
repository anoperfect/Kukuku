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
//    [self.buttonTopic setBackgroundImage:[self createImageWithColor:[UIColor orangeColor]] forState:UIControlStateSelected];
//    [self.buttonTopic setBackgroundImage:[self createImageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
    
    UIImageView *imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backn"]];
    [self.buttonTopic addSubview:imageBack];
    [imageBack setTag:TAG_IMAGEBACK];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIconBanner"]];
    [self.buttonTopic addSubview:image];
    [image setTag:TAG_IMAGEICON];
//    [image setFrame:CGRectMake(imageBack.frame.origin.x+imageBack.frame.size.width, 0, height, height)];
    [self.buttonTopic setTitleEdgeInsets:UIEdgeInsetsMake(0, image.frame.origin.x + image.frame.size.width + 2, 0, 0)];
    [self.buttonTopic setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}


- (void)setTextTopic:(NSString *)text {
    [self.buttonTopic setTitle:text forState:UIControlStateNormal];
}


- (void)setButtonData:(NSArray*)buttonDataAry {
    
    self.buttonDataAry = [NSArray arrayWithArray:buttonDataAry];
    self.buttons = [[NSMutableArray alloc]init];
    
    NSInteger numFirstLevelButton = 0;
    NSMutableArray *firstLevelButtons = [[NSMutableArray alloc]init];
    NSMutableArray *firstLevelButtonsData = [[NSMutableArray alloc]init];
    
    for(id obj in buttonDataAry) {
        ButtonData *data = (ButtonData*)obj;
        PushButton *button = [[PushButton alloc] init];
        [button.titleLabel setFont:[UIFont fontWithName:@"BannerButtonMenu"]];
        [button setTitleColor:[UIColor colorWithName:@"BannerButtonMenuText"] forState:UIControlStateNormal];
        [button addTarget:data.target action:data.sel forControlEvents:UIControlEventTouchDown];
        [self.buttons addObject:button];
        
        if(data.superId == 0) {
            numFirstLevelButton ++;
            [firstLevelButtons addObject:button];
            [firstLevelButtonsData addObject:data];
        }
    }
    
    CGFloat yBorder = 10;
    CGFloat height = self.frame.size.height - 2*yBorder;
    CGRect rect;
    NSInteger indexBtn = 0;
    CGFloat widthBtn = height * 1.0;
    CGFloat x,mx;
    CGFloat borderRight = 3;
    CGFloat padding = 10;
    ButtonData *data ;
    PushButton *button ;
    mx = borderRight;
    
//    for(NSInteger i = 0; i<numFirstLevelButton ; i++) {
    for(NSInteger i = numFirstLevelButton-1; i>=0 ; i--) {
        
        data = (ButtonData*)[firstLevelButtonsData objectAtIndex:i];
        button = (PushButton*)[firstLevelButtons objectAtIndex:i];
        
        if(data.method == 1) {
            widthBtn = height * 1.0;
            [button setImage:[UIImage imageNamed:data.imageName] forState:UIControlStateNormal];
        }
        else {
            widthBtn = 45;
            [button setTitle:data.title forState:UIControlStateNormal];
        }
        
        if(i == numFirstLevelButton -1) {
            x = self.frame.size.width - borderRight - widthBtn;
        }
        else {
            PushButton *buttonRight = (PushButton*)[firstLevelButtons objectAtIndex:i+1];
            x = buttonRight.frame.origin.x - widthBtn - padding;
        }
        
        rect = CGRectMake(x, yBorder, widthBtn, height);
        [button setFrame:rect];
        
        [self addSubview:button];
        
        indexBtn ++;
    }
}


- (PushButton*) getButtonByKeyword: (NSString*)keyword {
    
    BOOL isFound = NO;
    NSInteger index = 0;
    for(ButtonData *data in self.buttonDataAry) {
        
        if([keyword isEqualToString:data.keyword]) {
            isFound = YES;
            break;
        }
        
        index ++;
    }
    
    return isFound?[self.buttons objectAtIndex:index]:nil;
}


- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)dealloc {
    kcountObjBannerView --;
    NSLog(@"BannerView1[%zd] dealloc %@", kcountObjBannerView, self);
}

@end




























//CGSize itemSize = CGSizeMake(self.buttonTopic.frame.size.height, self.buttonTopic.frame.size.height);
//UIGraphicsBeginImageContext(itemSize);
//CGRect imageRect = CGRectMake(0, 0, 20, 20);
//[image drawInRect:imageRect];
//UIGraphicsEndImageContext();

//UIImage *image = [UIImage imageNamed:@"appicon"];
//NS0Log(@"%lf %lf", image.size.width,image.size.height);
//
//CGSize size = CGSizeMake(height, height);
//UIImage *scaledImage = [self imageScale:image toSize:size];
//NS0Log(@"%lf %lf", scaledImage.size.width,scaledImage.size.height);
//
//[self.buttonTopic setImage:scaledImage forState:UIControlStateNormal];
//[self.buttonTopic setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//[self.buttonTopic setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];