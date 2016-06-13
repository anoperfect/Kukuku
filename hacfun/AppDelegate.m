//
//  AppDelegate.m
//  hacfun
//
//  Created by Ben on 15/7/12.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "AppDelegate.h"
#import "MainVC.h"
#import "CategoryViewController.h"
#import "AppConfig.h"
#import "BonJoYiViewController.h"








@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AppConfig sharedConfigDB];
    
    //MainVC *mainVC = [[MainVC alloc] init];
    BonJoYiViewController *vc = [[BonJoYiViewController alloc] init];
    UINavigationController *startNVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = startNVC;
    
    [self.window makeKeyAndVisible];
    
    [self test];
    
    return YES;
}


- (void)test
{
    CGSize viewSize = self.window.bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    NSLog(@"imagesDict :%@", imagesDict);
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    NSLog(@"launchImage :%@", launchImage);
    
    launchImage = @"LaunchImage1";
    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSLog(@"%@", launchView);
    
    [self.window addSubview:launchView];
    
    [UIView animateWithDuration:3.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                         
                     }];
    
}



- (BOOL)application1:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AppConfig sharedConfigDB];
    
    [[AppConfig sharedConfigDB] authAsync:nil];
    
    NSInteger waitTimes = 0;
    while(![AppConfig sharedConfigDB].authResult && waitTimes < 20) {
        [NSThread sleepForTimeInterval:0.1];
        waitTimes ++;
        NSLog(@"wait for auth : %zd", waitTimes);
    }
    
    UINavigationController *startNVC = nil;
    if(![AppConfig sharedConfigDB].authResult) {
        NSLog(@"#error - auth failed.");
        BonJoYiViewController *vc = [[BonJoYiViewController alloc] init];
        startNVC = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    else {
        MainVC *mainVC = [[MainVC alloc] init];
        startNVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = startNVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
