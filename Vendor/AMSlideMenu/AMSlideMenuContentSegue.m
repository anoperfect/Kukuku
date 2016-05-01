//
//  AMSlideMenuContentSegue.m
//  AMSlideMenu
//
// The MIT License (MIT)
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import "AMSlideMenuContentSegue.h"

#import "AMSlideMenuMainViewController.h"

@implementation AMSlideMenuContentSegue

/*----------------------------------------------------*/
#pragma mark - Actions -
/*----------------------------------------------------*/

- (void)perform
{
    UITableViewController *sourceVC = [self sourceViewController];
    UINavigationController *destinationNVC = [self destinationViewController];
    
    AMSlideMenuMainViewController *mainVC = (AMSlideMenuMainViewController *)sourceVC.parentViewController;    
    
    UINavigationItem *navItem = mainVC.currentActiveNVC.navigationBar.topItem;
    
    if (!navItem)
        navItem = destinationNVC.navigationBar.topItem;
    
    if (!mainVC.isInitialStart)
    {
        CGRect openedFrame = mainVC.currentActiveNVC.view.frame;
        [mainVC.currentActiveNVC.view removeFromSuperview];
        //这句有警告. 去掉警告则有内存泄漏. 导致nac中的vc不能释放.
        //to-do.未解决此问题.
        //尝试不重复创建UINavigationController的方式, 但是左右menu使用同一UINavigationController的方式未完成合适方式. 另外内存泄漏的原因未找到, 不确定是使用原因或者是原库原因.

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnonnull"
        //这里是会报警告的代码
        mainVC.currentActiveNVC.viewControllers = nil;
        mainVC.currentActiveNVC = nil;
#pragma clang diagnostic pop
        
        mainVC.currentActiveNVC = destinationNVC;
        mainVC.currentActiveNVC.view.frame = openedFrame;
        navItem = destinationNVC.navigationBar.topItem;
        
    }
    
    if (mainVC.leftMenu)
    {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mainVC configureLeftMenuButton:leftBtn];
        [leftBtn addTarget:mainVC action:@selector(openLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        
//        navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    }
    
    if (mainVC.rightMenu)
    {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mainVC configureRightMenuButton:rightBtn];
        [rightBtn addTarget:mainVC action:@selector(openRightMenu) forControlEvents:UIControlEventTouchUpInside];
        
//        navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }


    //Waiting for calling viewWillApear in nvc
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [mainVC configureSlideLayer:destinationNVC.view.layer];
    });

    
    [mainVC switchCurrentActiveControllerToController:destinationNVC fromMenu:sourceVC];
}

@end