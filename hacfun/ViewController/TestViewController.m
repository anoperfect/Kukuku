//
//  TestViewController.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "TestViewController.h"
#import "ModelAndViewInc.h"
#import "AppConfig.h"




@interface TestViewController ()






@end

@implementation TestViewController





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



#import "TTTAttributedLabel.h"

@interface EULAView ()


@property (nonatomic, strong) void(^userFeedbackHanle)(BOOL isUserAgree, BOOL notShowAgain);
@property (nonatomic, assign) BOOL withAgreement;
@property (nonatomic, strong) UIScrollView *textContainer;
@property (nonatomic, strong) TTTAttributedLabel *EULRText;
@property (nonatomic, strong) PushButton *buttonAgree;
@property (nonatomic, strong) PushButton *buttonDeny;

@end






@implementation EULAView

- (instancetype)initWithFrame:(CGRect)frame withAgreement:(BOOL)withAgreement andUserFeedbackHanle:(void(^)(BOOL isUserAgree, BOOL notShowAgain))userFeedbackHanle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.withAgreement = withAgreement;
        
        self.textContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 36)];
        [self addSubview:self.textContainer];
        self.textContainer.bounces = NO;
        
        self.EULRText = [[TTTAttributedLabel alloc] initWithFrame:self.textContainer.frame];
        [self.textContainer addSubview:self.EULRText];
        
        NSString *resPath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EULA.txt"];
        //NSData *data = [NSData dataWithContentsOfFile:resPath];
        self.EULRText.numberOfLines = 0;
        self.EULRText.backgroundColor = [UIColor colorWithName:@"ContentBackground"];
        self.EULRText.lineBreakMode = NSLineBreakByWordWrapping;
        self.EULRText.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        self.EULRText.text = [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:nil];
        
        self.buttonDeny = [[PushButton alloc] init];
        [self addSubview:self.buttonDeny];
        [self.buttonDeny setTitle:@"不同意此用户协议" forState:UIControlStateNormal];
        self.buttonDeny.titleLabel.font = [UIFont fontWithName:@"CustomLabel"];
        [self.buttonDeny setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
        [self.buttonDeny addTarget:self action:@selector(clickDeny) forControlEvents:UIControlEventTouchDown];
        self.buttonDeny.layer.borderWidth = 1;
        self.buttonDeny.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
        self.buttonDeny.layer.cornerRadius = 2.7;
        
        self.buttonAgree = [[PushButton alloc] init];
        [self addSubview:self.buttonAgree];
        [self.buttonAgree setTitle:@"已阅读且同意此用户协议" forState:UIControlStateNormal];
        self.buttonAgree.titleLabel.font = [UIFont fontWithName:@"CustomLabel"];
        [self.buttonAgree setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
        [self.buttonAgree addTarget:self action:@selector(clickAgree) forControlEvents:UIControlEventTouchDown];
        self.buttonAgree.layer.borderWidth = 1;
        self.buttonAgree.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
        self.buttonAgree.layer.cornerRadius = 2.7;
        
        self.userFeedbackHanle = userFeedbackHanle;
    }
    
    return self;
}


- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    
    if(self.withAgreement) {
        self.textContainer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 36);
        
        CGRect EULRFrame = CGRectMake(10, 0, self.textContainer.frame.size.width - 10*2, self.textContainer.frame.size.height);
        self.EULRText.frame = EULRFrame;
        CGSize size = [self.EULRText sizeThatFits:self.EULRText.frame.size];
        NSLog(@"%lf nnn - %lf", size.height, self.textContainer.bounds.size.height);
        if(size.height > self.EULRText.frame.size.height) {
            EULRFrame = self.EULRText.frame;
            EULRFrame.size.height = size.height;
            self.EULRText.frame = EULRFrame;
            self.textContainer.contentSize = size;
        }
        
        self.buttonDeny.frame = UIEdgeInsetsInsetRect(CGRectMake(0, self.textContainer.frame.size.height, self.frame.size.width/2, 36), UIEdgeInsetsMake(6, 6, 6, 6));
        self.buttonAgree.frame = UIEdgeInsetsInsetRect(CGRectMake(self.frame.size.width/2, self.textContainer.frame.size.height, self.frame.size.width/2, 36), UIEdgeInsetsMake(6, 6, 6, 6));
    }
    else {
        self.textContainer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        CGRect EULRFrame = CGRectMake(10, 0, self.textContainer.frame.size.width - 10*2, self.textContainer.frame.size.height);
        self.EULRText.frame = EULRFrame;
        CGSize size = [self.EULRText sizeThatFits:self.EULRText.frame.size];
        NSLog(@"%lf nnn - %lf", size.height, self.textContainer.bounds.size.height);
        if(size.height > self.EULRText.frame.size.height) {
            EULRFrame = self.EULRText.frame;
            EULRFrame.size.height = size.height;
            self.EULRText.frame = EULRFrame;
            self.textContainer.contentSize = size;
        }

        self.buttonDeny.hidden = YES;
        self.buttonAgree.hidden = YES;
    }
}


- (void)clickAgree
{
    if(self.userFeedbackHanle) {
        self.userFeedbackHanle(YES, YES);
    }
    
}


- (void)clickDeny
{
    if(self.userFeedbackHanle) {
        self.userFeedbackHanle(NO, NO);
    }
    
    
    
}



@end

