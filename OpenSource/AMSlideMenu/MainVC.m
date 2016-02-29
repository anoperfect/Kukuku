//
//  MainVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//

#import "MainVC.h"
#import "LeftMenuTVC.h"
#import "RightMenuTVC.h"
#import "RightMenu.h"



@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   /*******************************
    *     Initializing menus
    *******************************/
//    self.leftMenu = [[LeftMenuTVC alloc] initWithNibName:@"LeftMenuTVC" bundle:nil];
    self.leftMenu = [[LeftMenuTVC alloc] init];
//    self.rightMenu = [[RightMenuTVC alloc] initWithNibName:@"RightMenuTVC" bundle:nil];
    self.rightMenu = [[RightMenuTVC alloc] init];
//    self.rightMenu = [[RightMenu alloc] init];
   /*******************************
    *     End Initializing menus
    *******************************/

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLeftMenu) name:@"openLeftMenu" object:nil];
}

//优先综合版1的列表显示的viewcontroller.
- (AMPrimaryMenu)primaryMenu {
    
    return AMPrimaryMenuRight;
}

#pragma mark - Overriding methods
- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"icon-menu.png"] forState:UIControlStateNormal];
}

- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"icon-menu.png"] forState:UIControlStateNormal];
}

- (BOOL)deepnessForLeftMenu
{
    return YES;
}

- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5f;
}


- (CGFloat)leftMenuWidth
{
    return self.view.bounds.size.width / 2;
}

- (CGFloat)rightMenuWidth
{
    return self.view.bounds.size.width / 2;
}

@end
