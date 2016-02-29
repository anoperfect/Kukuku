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


@implementation BannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    LOG_POSTION0
    self = [super init];
    
    if(self) {
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
    Y_CENTER(imageBack, 6);
    
    UIImageView *image =(UIImageView*)[self viewWithTag:TAG_IMAGEICON];
    [image setFrame:CGRectMake(imageBack.frame.origin.x+imageBack.frame.size.width, 0, height, height)];
    [self.buttonTopic setTitleEdgeInsets:UIEdgeInsetsMake(0, image.frame.origin.x + image.frame.size.width + 2, 0, 0)];
    [self.buttonTopic setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    NSInteger numFirstLevelButton = [self.buttons count];
    
    yBorder = 10;
    height = self.frame.size.height - 2*yBorder;
    CGRect rect;
    NSInteger indexBtn = 0;
    CGFloat widthBtn = height * 1.0;
    CGFloat x,mx;
    CGFloat borderRight = 3;
    CGFloat padding = 10;
    ButtonData *data ;
    UIButton *button ;
    mx = borderRight;
    
    //    for(NSInteger i = 0; i<numFirstLevelButton ; i++) {
    for(NSInteger i = numFirstLevelButton-1; i>=0 ; i--) {
        button = (UIButton*)[self.buttons objectAtIndex:i];
        data = (ButtonData*)[self.buttonDataAry objectAtIndex:i];
        
        if(data.method == 1) {
            widthBtn = height * 1.0;
        }
        else {
            widthBtn = 45;
        }
        
        if(i == numFirstLevelButton -1) {
            x = self.frame.size.width - borderRight - widthBtn;
        }
        else {
            UIButton *buttonRight = (UIButton*)[self.buttons objectAtIndex:i+1];
            x = buttonRight.frame.origin.x - widthBtn - padding;
        }
        rect = CGRectMake(x, yBorder, widthBtn, height);
        [button setFrame:rect];
        if(data.method == 1) {
            [button setImage:[UIImage imageNamed:data.image] forState:UIControlStateNormal];
        }
        
        indexBtn ++;
    }
    
}


- (UIImage*) imageScale:(UIImage*)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


- (void)setTopicButton {
    
    LOG_POSTION
    self.backgroundColor = [AppConfig backgroundColorFor:@"BannerView"];
    
    self.buttonTopic = [[UIButton alloc] init];
    [self addSubview:self.buttonTopic];
    [self.buttonTopic setTitleColor:[AppConfig textColorFor:@"Black"] forState:UIControlStateNormal];
    [self.buttonTopic setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.buttonTopic.titleLabel setFont:[AppConfig fontFor:@"ButtonTopic"]];
//    [self.buttonTopic setBackgroundImage:[self createImageWithColor:[UIColor orangeColor]] forState:UIControlStateSelected];
//    [self.buttonTopic setBackgroundImage:[self createImageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
    [self.buttonTopic setTintColor:[UIColor redColor]];
    
    UIImageView *imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backn"]];
    [self.buttonTopic addSubview:imageBack];
    [imageBack setTag:TAG_IMAGEBACK];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon"]];
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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[AppConfig fontFor:@"BannerButtonMenu"]];
        [button setTitleColor:[AppConfig textColorFor:@"BannerButtonMenu"] forState:UIControlStateNormal];
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
    UIButton *button ;
    mx = borderRight;
    
//    for(NSInteger i = 0; i<numFirstLevelButton ; i++) {
    for(NSInteger i = numFirstLevelButton-1; i>=0 ; i--) {
        
        data = (ButtonData*)[firstLevelButtonsData objectAtIndex:i];
        button = (UIButton*)[firstLevelButtons objectAtIndex:i];
        
        if(data.method == 1) {
            widthBtn = height * 1.0;
            [button setImage:[UIImage imageNamed:data.image] forState:UIControlStateNormal];
        }
        else {
            widthBtn = 45;
            [button setTitle:data.title forState:UIControlStateNormal];
        }
        
        if(i == numFirstLevelButton -1) {
            x = self.frame.size.width - borderRight - widthBtn;
        }
        else {
            UIButton *buttonRight = (UIButton*)[firstLevelButtons objectAtIndex:i+1];
            x = buttonRight.frame.origin.x - widthBtn - padding;
        }
        
        rect = CGRectMake(x, yBorder, widthBtn, height);
        [button setFrame:rect];
        
        [self addSubview:button];
        
//        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
        
        indexBtn ++;
    }
}


- (void)clickButton:(UIButton*)button {
    
    NSInteger index = [self.buttons indexOfObject:button];
    NS0Log(@"index : %zi", index);
    
    NSMutableArray *listAry = [[NSMutableArray alloc] init];
    ButtonData *data = [self.buttonDataAry objectAtIndex:index];
    for(ButtonData *obj in self.buttonDataAry) {
        
        if(obj.superId == data.id) {
            [listAry addObject:obj];
        }
    }
    
    NSInteger num = [listAry count];
    NSInteger indexButton;
    UIButton *subButton;
    UIView *view = [self viewWithTag:100];
    LOG_VIEW_RECT(view, @"original")
    FRAME_SET_HEIGHT(view, 0)
    
    if(num > 0) {
        NSInteger indexSubButton = 0;
        for(ButtonData *pdata in listAry) {
            indexButton = [self.buttonDataAry indexOfObject:pdata];
            subButton = [self.buttons objectAtIndex:indexButton];
            [subButton setFrame:CGRectMake(0, 36*indexSubButton, 100, 36)];
            [subButton setBackgroundColor:[AppConfig backgroundColorFor:@"MenuAction"]];
            if(pdata.method == 2) {
                [subButton setTitle:pdata.title forState:UIControlStateNormal];
            }
            
            [view addSubview:subButton];
            FRAME_ADD_HEIGHT(view, 36)
            LOG_VIEW_RECT(view, @"after add");
            [view setHidden:NO];
            
            indexSubButton ++;
        }
        [self.superview bringSubviewToFront:self];
    }
    else {
        FRAME_SET_HEIGHT(view, 0)
        LOG_VIEW_RECT(view, @"after set");
        [view setHidden:YES];
        [self.superview sendSubviewToBack:self];
    }
    
    
}


- (UIButton*) getButtonByKeyword: (NSString*)keyword {
    
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


- (UIImage*)createImageWithColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
//    [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
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