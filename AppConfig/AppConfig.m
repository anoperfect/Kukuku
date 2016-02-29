//
//  AppConfig.m
//  hacfun
//
//  Created by Ben on 15/8/6.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "AppConfig.h"






//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@implementation AppConfig




+ (UIColor*)backgroundColorFor:(NSString*)name {
    
    static NSMutableArray *aryName = nil;
    static NSMutableArray *aryColor = nil;
    static BOOL isInited = NO;
    
    if(!isInited) {
        isInited = YES;
        
        aryName = [[NSMutableArray alloc] init];
        aryColor = [[NSMutableArray alloc] init];
        
        [aryName addObject:@""];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"PostViewCell"];
        [aryColor addObject:HexRGB(0xd0d0d0)];
        
        [aryName addObject:@"ThreadsViewController"];
        [aryColor addObject:[UIColor purpleColor]];
        
        [aryName addObject:@"BannerView"];
        [aryColor addObject:HexRGB(0xa0a0a0)];
        
        [aryName addObject:@"PostView"];
        [aryColor addObject:[UIColor lightGrayColor]];
        
        [aryName addObject:@"MenuAction"];
        [aryColor addObject:[UIColor blueColor]];
        
        [aryName addObject:@"CreateViewController"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"ImageViewController"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"PostDataCellView"];
        [aryColor addObject:[UIColor whiteColor]];
        
        [aryName addObject:@"ReplyCellBorderMain"];
        [aryColor addObject:[UIColor redColor]];
        
        [aryName addObject:@"ReplyCellBorderReply"];
        //[aryColor addObject:[UIColor blueColor]];
        [aryColor addObject:HexRGB(0xcccccc)];
        
        [aryName addObject:@"LoadingView"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"blackColor"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"clearColor"];
        [aryColor addObject:[UIColor clearColor]];
    }
    
    NSInteger index = [aryName indexOfObject:name];
    if(index != NSNotFound) {
        return [aryColor objectAtIndex:index];
    }
    else {
        NSLog(@"error- %s not found", __FUNCTION__);
    }
    
    return [UIColor orangeColor];
}


+ (UIColor*)textColorFor:(NSString*)name {
    
    static NSMutableArray *aryName = nil;
    static NSMutableArray *aryColor = nil;
    static BOOL isInited = NO;
    
    if(!isInited) {
        isInited = YES;
        
        aryName = [[NSMutableArray alloc] init];
        aryColor = [[NSMutableArray alloc] init];
        
        [aryName addObject:@"Black"];
        [aryColor addObject:[UIColor blackColor]];
        
        [aryName addObject:@"CellTitle"];
        [aryColor addObject:HexRGBAlpha(0x0, 0.66)];
        
        [aryName addObject:@"CellInfo"];
        [aryColor addObject:HexRGBAlpha(0x0, 0.66)];
        
        [aryName addObject:@"RefreshTint"];
        [aryColor addObject:[UIColor redColor]];
    }
    
    NSInteger index = [aryName indexOfObject:name];
    if(index != NSNotFound) {
        return [aryColor objectAtIndex:index];
    }
    else {
        NSLog(@"error- %s not found <%@>.", __FUNCTION__, name);
    }
    
    return [UIColor blueColor];
}


+ (UIFont*)fontFor:(NSString*)name {
    
    static NSMutableArray *aryName = nil;
    static NSMutableArray *aryFont = nil;
    static BOOL isInited = NO;
    
    if(!isInited) {
        isInited = YES;
        
        aryName = [[NSMutableArray alloc] init];
        aryFont = [[NSMutableArray alloc] init];
        
        CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
        NSLog(@"%lf %lf %lf %lf", mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.width, mainFrame.size.height);
        
        //[320,375,414]
        
        [aryName addObject:@""];
        [aryFont addObject:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        
        [aryName addObject:@"PostContent"];
//        [aryFont addObject:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        [aryFont addObject:[UIFont systemFontOfSize:mainFrame.size.width*0.0400]];
        
        [aryName addObject:@"ButtonNavigation"];
        [aryFont addObject:[UIFont systemFontOfSize:16.0]];
    }
    
    NSInteger index = [aryName indexOfObject:name];
    if(index != NSNotFound) {
        return [aryFont objectAtIndex:index];
    }
    else {
        NSLog(@"error- %s not found", __FUNCTION__);
    }
    
    return [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];

}


+ (id)configForKey:(id)key {
    static NSMutableDictionary *configDictionary = nil;
    if(nil == configDictionary) {
        configDictionary = [[NSMutableDictionary alloc] init];
        
        [configDictionary setObject:@"V0.01" forKey:@"version"];
        
        [configDictionary setObject:@"http://hacfun.tv/api" forKey:@"host"];
        [configDictionary setObject:@"http://cdn.ovear.info:8999" forKey:@"imageHost"];
        
//        [configDictionary setObject:@"http://kukuku.cc/api" forKey:@"host"];
        
        
    }
    
    return [configDictionary objectForKey:key];
}


@end



#if 0

//    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
//    UIFont *font1 = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];  // 系统小字体
//    //UIFont *font2 = [UIFont systemFontOfSize:[UIFont labelFontSize]];        // 系统标签字体
//    //UIFont *font3 = [UIFont boldSystemFontOfSize:20];       // 加粗字体
//    //UIFont *font4 = [UIFont italicSystemFontOfSize:20];     // 斜体
//    font = font1;





//- (void)setConfigData:(NSString*)text buttonImages:(NSArray*)images buttonTexts:(NSArray*)texts {
//
//    CGFloat width = 160;
//    CGFloat yBorder = 3;
//    CGFloat height = self.frame.size.height - 2*yBorder;
//
//    self.backgroundColor = [UIColor grayColor];
//
//    self.buttonNavigation = [[UIButton alloc] initWithFrame:CGRectMake(0, yBorder, width, height)];
//    [self addSubview:self.buttonNavigation];
////    self.buttonNavigation.backgroundColor = [UIColor blueColor];
//    [self.buttonNavigation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//    UIImageView *imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backn"]];
//    [self.buttonNavigation addSubview:imageBack];
//    [imageBack setFrame:CGRectMake(0, 0, 10, 0)];
//    Y_CENTER(imageBack, 6);
//    LOG_VIEW_RECT(imageBack, @"backicon")
//
//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon"]];
//    [image setFrame:CGRectMake(imageBack.frame.origin.x+imageBack.frame.size.width, 0, height, height)];
//    [self.buttonNavigation addSubview:image];
//
////    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 200, 36)];
////    [self.buttonNavigation addSubview:label];
////    label.text = @"No. 000000";
////    label.textColor = [UIColor blackColor];
//
//    [self.buttonNavigation setTitleEdgeInsets:UIEdgeInsetsMake(0, image.frame.origin.x + image.frame.size.width + 2, 0, 0)];
//    [self.buttonNavigation setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//
//
//
//
//
//
//
//
//
//    NSMutableArray *ary = [[NSMutableArray alloc]init];
//    id obj;
//    NSString *imageName;
//    UIButton *button;
//    CGRect rect;
//    NSInteger numBtn = [images count];
//    NSInteger indexBtn = 0;
//    CGFloat widthBtn = height * 1.0;
//    CGFloat x,mx;
//    CGFloat borderRight = 3;
//    CGFloat padding = 10;
//    NS0Log(@"self width : %lf", self.frame.size.width);
//    if(images) {
//        for(obj in images) {
//            imageName = (NSString*)obj;
//            button = [UIButton buttonWithType:UIButtonTypeCustom];
//
//            mx = (borderRight+widthBtn) + (numBtn-1-indexBtn) * (padding + widthBtn);
//            x = self.frame.size.width - mx;
//            rect = CGRectMake(x, yBorder, widthBtn, height);
//            [button setFrame:rect];
//            LOG_VIEW_REC0(button, @"button");
//            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//            [button.layer setBorderWidth:0];
//            [button.layer setBorderColor:[UIColor blackColor].CGColor];
//            [self addSubview:button];
//            [ary addObject:button];
//
//            indexBtn ++;
//        }
//    }
//
//    self.buttonAry = [NSArray arrayWithArray:ary];
//}



//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - 100, self.frame.size.height, 0, 0)];
//    [view setTag:100];
//    view.backgroundColor = [UIColor yellowColor];
//    [self addSubview:view];




//    UIView *v = [cell viewWithTag:100];
//    LOG_VIEW_RECT(v, @"cell view")
//    LOG_VIEW_RECT(cell, @"cell")




//FRAME_ADD_HEIGHT(cell, 6);
//((PostData*)[self.postDatas objectAtIndex:row]).height += 6;
//    FRAME_ADD_Y(v, 3);
//
//    UIView *view = v;
//    CGFloat add = 3;
//
//    {
//    CGRect frame = view.frame;
//    [view setFrame:CGRectMake(frame.origin.x, frame.origin.y + add, frame.size.width, frame.size.height)];
//    }
//    [cell.layer setBorderWidth:0];
//    [cell.layer setBorderColor:[UIColor blueColor].CGColor];

//    PostData* pd = ((PostData*)[self.postDatas objectAtIndex:row]);
//    pd.height += 6;










//    self.buttonMenu = [[UIButton alloc] initWithFrame:CGRectMake(2, buttonY, 90, 20)];
//    [self.view addSubview:self.buttonMenu];
//    self.buttonMenu.backgroundColor = [UIColor blueColor];
//    [self.buttonMenu setTitle:@"综合版1" forState:UIControlStateNormal];
//    //[self.buttonMenu setImage:[UIImage imageNamed:@"appicon"] forState:UIControlStateNormal];
//
//    UIImage *image = [UIImage imageNamed:@"appicon"];
//    CGSize itemSize = CGSizeMake(self.buttonMenu.frame.size.height, self.buttonMenu.frame.size.height);
//    UIGraphicsBeginImageContext(itemSize);
//    CGRect imageRect = CGRectMake(0, 0, 20, 20);
//    [image drawInRect:imageRect];
//    UIGraphicsEndImageContext();
//    [self.buttonMenu.imageView setFrame:CGRectMake(0, 0, 10, 10)];
//    [self.buttonMenu setImage:image forState:UIControlStateNormal];
//    [self.buttonMenu setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.buttonMenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//
//    NSLog(@"%lf %lf", image.size.width,image.size.height);
//
//
//    CGSize size = CGSizeMake(20.0, 20.0);
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, 20.0, 20.0)];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    NSLog(@"%lf %lf", scaledImage.size.width,scaledImage.size.height);
//    [self.buttonMenu setImage:scaledImage forState:UIControlStateNormal];


//    UIGraphicsBeginImageContext(size);
//    image = [UIImage imageNamed:@"back"];
//    [image drawInRect:CGRectMake(0, 0, 20.0, 20.0)];
//    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    //UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"appicon"]];
//    UIColor *color = [UIColor colorWithPatternImage:scaledImage];
//    [label setBackgroundColor:color];
//    [self.buttonMenu addSubview:label];

//    self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(100, buttonY, 45, 20)];
//    self.buttonCategory.backgroundColor = [UIColor blueColor];
//    [self.buttonCategory setTitle:@"加载" forState:UIControlStateNormal];
//    [self.buttonCategory addTarget:self action:@selector(reloadPostData) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:self.buttonCategory];
//
//    self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(160, buttonY, 45, 20)];
//    self.buttonCategory.backgroundColor = [UIColor blueColor];
//    [self.buttonCategory setTitle:@"刷新" forState:UIControlStateNormal];
//    [self.buttonCategory addTarget:self action:@selector(refreshPostData) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:self.buttonCategory];
//
//    self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(300, buttonY, 45, 20)];
//    self.buttonCategory.backgroundColor = [UIColor blueColor];
//    [self.buttonCategory setTitle:@"栏目" forState:UIControlStateNormal];
//    [self.view addSubview:self.buttonCategory];


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        // 标示是否被隐藏
//        self.isHiddenItem = YES;
//
//        // 获取要隐藏item的位置
//        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
//
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.tableView cellForRowAtIndexPath:tmpPath].alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            // 隐藏的对应item
//            [[self.tableView cellForRowAtIndexPath:tmpPath] setHidden:YES];
//            // 刷新被隐藏的item
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//        NSLog(@"点击了第0行");
//    } else if (indexPath.row == 1){
//
//        self.isHiddenItem = NO;
//
//        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
//
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.tableView cellForRowAtIndexPath:tmpPath].alpha = 1.0f;
//        } completion:^(BOOL finished) {
//            [[self.tableView cellForRowAtIndexPath:tmpPath] setHidden:YES];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmpPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//        NSLog(@"点击了第1行");
//
//    }
//}


//    NSLog(@"reloadPostData");
//
//    PostData *d = nil;
//    d = [[PostData alloc] init];
//    d.uid = @"qwertyui";
//    d.replyCount = 10;
//    d.content = @"福建省\n\n看到房间电视";
//    [self.postDatas addObject:d];
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    [indexPaths addObject:indexPath];
//
//    [self.postView beginUpdates];
//    [self.postView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    [self.postView endUpdates];



//下一次点击同一个cell时,可能不能及时进入跳转的viewcontroller。
//使用dispatch_async的方式,或者随意performSelector一下.
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        [self presentViewController:rv animated:NO completion:^(void){
//
//            }
//        ];
//    });










//点击加载.
//加载中 － 非常努力地加载中.
//加载成功. - [直接加载]
//加载失败. － oops ! 点击重新加载.
//加载无更多数据. - 已经没有了,点击刷新.


//- (void)refreshPostData {
//
//    LOG_POSTION
//
//    // 刷新时清空原所有数据.
//    self.boolRefresh = YES;
//    self.pageNum = 1;
//
//    //[self.postView setHidden:YES];
//
//    // 在子线程中调用download方法下载图片
//    [self showLoadingView];
//    [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
//}
//
//
//- (void)setBackgroundDownload1 {
//
//    NSString *str = [NSString stringWithFormat:@"%@/%@?page=%zi", self.host, self.nameCategory, self.pageNum];
//    NSURL *urlstr=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"str:%@", str);
//    NSLog(@"url:%@", urlstr);
//
//    //把图片转换为二进制的数据
//    NSData *data=[NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
//    [self performSelectorOnMainThread:@selector(parseAndFresh:) withObject:data waitUntilDone:NO];
//}



- (void)clickSendGet {
    
    NSString *host = @"http://hacfun.tv/api";
    NSString *nameCategory = @"综合版1";
    NSInteger pageNum = 1;
    NSString *str = [NSString stringWithFormat:@"%@/%@?page=%zi", host, nameCategory, pageNum];
    //str = @"http://files.cnblogs.com/ilovewindy/AMSlideMenu.zip";
    NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"str:%@", str);
    NSLog(@"url:%@", url);
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    mutableRequest.HTTPMethod = @"GET";
    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
    
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(move) userInfo:nil repeats:YES];
}





#endif


