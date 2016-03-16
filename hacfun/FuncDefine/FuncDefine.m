//
//  FuncDefine.m
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "FuncDefine.h"

@implementation FuncDefine




+ (NSTimeInterval)timeIntervalCountWithRecount:(BOOL)recount
{
    static NSDate *kdate0 = nil;
    if(nil == kdate0 || recount) {
        kdate0 = [NSDate date];
        return 0.0;
    }
    
    NSDate *date = [NSDate date];
    return [date timeIntervalSinceDate:kdate0];
}


+ (NSString*)stringFromCGRect:(CGRect)rect
{
    return [NSString stringWithFormat:@
            "%3zd.%zd, "
            "%3zd.%zd, "
            "%3zd.%zd, "
            "%3zd.%zd"
            ,
            (NSInteger)rect.origin.x,       (NSInteger)(rect.origin.x       * 10.0) % 10,
            (NSInteger)rect.origin.y,       (NSInteger)(rect.origin.y       * 10.0) % 10,
            (NSInteger)rect.size.width,     (NSInteger)(rect.size.width     * 10.0) % 10,
            (NSInteger)rect.size.height,    (NSInteger)(rect.size.height    * 10.0) % 10
            ];
}


+ (NSString*)stringFromViewFrame:(UIView*)view
{
    CGRect frame = view.frame;
    return [self stringFromCGRect:frame];
}












@end





#if SHOW_TASK
此处更新一些任务及记录.
颜文字 (完成,需更改为输出代理和collection.)
图片发送
图片picker
拍照
发送时的Loading
图片保存  YES
收藏使用数据库
我的发帖
cookie确认 (暂不实现)
cookie管理 (暂不实现)
postdata到cell的转换 YES
引用图标
画图板 (暂不实现)
下拉刷新取消
栏目 YES
栏目更新 YES
数据库更新指令
kukuku.cc的图片地址  YES
kukuku.cc字体太小 YES
使用navigation切换页面 YES
BannerView的button 的文字宽度
设置 60%

//------add--category(综合版1,%%)--
//------set--imageHost(http://)--

#endif






















//------add--category(综合版1,%%)--
//------set--imageHost(http://)--

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


//    UIViewController *rv = [[UIViewController alloc]init];

//    [self setModalPresentationStyle:UIModalPresentationPopover];
//    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentViewController:rv animated:YES completion:^(void){ }];
//    [self performSelector:@selector(dontSleep) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.5;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"pageCurl";
//    animation.subtype = kCATransitionFromRight;
//    animation.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:animation forKey:nil];



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


//    [self presentViewController:vc animated:NO completion:^(void){ }];
//    [self performSelector:@selector(dontSleep) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];

[self.navigationController pushViewController:vc animated:YES];
}


- (void)dontSleep {
    
}


+ (id)configGetForKey:(id)key;
+ (void)configSetForKey:(id)object forKey:(id)key;


+ (NSMutableDictionary*) sharedConfigDictionary {
    
    static NSMutableDictionary *configDictionary = nil;
    if(nil == configDictionary) {
        configDictionary = [[NSMutableDictionary alloc] init];
        
        [configDictionary setObject:@"hacfun.tv" forKey:@"Dao"];
        //        [configDictionary setObject:@"kukuku.cc" forKey:@"Dao"];
        
        if([[configDictionary objectForKey:@"Dao"] isEqual:@"hacfun.tv"]) {
            [configDictionary setObject:@"V0.01@hacfun.tv" forKey:@"version"];
            [configDictionary setObject:@"http://hacfun.tv/api" forKey:@"host"];
            [configDictionary setObject:@"http://cdn.ovear.info:8999" forKey:@"imageHost"];
        }
        else {
            [configDictionary setObject:@"V0.01@kukuku.cc" forKey:@"version"];
            [configDictionary setObject:@"http://kukuku.cc/api" forKey:@"host"];
            [configDictionary setObject:@"http://static.koukuko.com/h" forKey:@"imageHost"];
        }
    }
    
    return configDictionary;
}


+ (id)configGetForKey:(id)key {
    NSMutableDictionary *configDictionary = [AppConfig sharedConfigDictionary];
    return [configDictionary objectForKey:key];
}


+ (void)configSetForKey:(id)object forKey:(id)key {
    NSMutableDictionary *configDictionary = [AppConfig sharedConfigDictionary];
    [configDictionary setObject:object forKey:key];
    
    //#KVO.
    if([key isEqual:@"Dao"]) {
        if([[configDictionary objectForKey:@"Dao"] isEqual:@"hacfun.tv"]) {
            [configDictionary setObject:@"V0.01@hacfun.tv" forKey:@"version"];
            [configDictionary setObject:@"http://hacfun.tv/api" forKey:@"host"];
            [configDictionary setObject:@"http://cdn.ovear.info:8999" forKey:@"imageHost"];
        }
        else {
            [configDictionary setObject:@"V0.01@kukuku.cc" forKey:@"version"];
            [configDictionary setObject:@"http://kukuku.cc/api" forKey:@"host"];
            [configDictionary setObject:@"http://static.koukuko.com/h" forKey:@"imageHost"];
        }
    }
}



#endif


#if 0
- (void)setPost1Data: (PostData*) postData inRow:(NSInteger)row{
    
    NS0Log(@"******setPostData");
    long long secondsCreateAt = postData.createdAt / 1000 ;
    NSDate *dateWithNoZone = [NSDate dateWithTimeIntervalSince1970:secondsCreateAt];
    //NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //NSInteger interval = [zone secondsFromGMTForDate:dateWithNoZone];
    NSDate *date = [dateWithNoZone dateByAddingTimeInterval:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringCreatedAt = [dateFormatter stringFromDate:date];
    
    NS0Log(@"createdAt: %lld %@", postData.createdAt, stringCreatedAt);
    
    NSMutableString *titleText = [NSMutableString stringWithFormat:@"%@  %@ ", stringCreatedAt, postData.uid];
    if(postData.sage) {
        [titleText appendString:@" SAGE "];
    }
    if(postData.lock) {
        [titleText appendString:@" LOCK "];
    }
    
    [self.titleLabel setText:titleText];
    
    //infoLabel.
    if(postData.mode == 1) {
        self.infoLabel.text = [NSString stringWithFormat:@"回应: %zi", postData.replyCount];
    }
    else {
        self.infoLabel.text = [NSString stringWithFormat:@"NO. %zi", postData.id];
    }
    self.contentLabel.text = postData.content;
    
    //RTLabel相关.
    CGSize size = [self.contentLabel optimumSize];
    FRAME_SET_HEIGHT(self.contentLabel, size.height)
    
    
#define Y_BLOW(view, border) (view.frame.origin.y + view.frame.size.height + border)
    CGFloat viewHeight = Y_BLOW(self.contentLabel, 3);
    
    //UIViewImage
    if([postData.thumb isEqualToString:@""]) {
        
    }
    else {
        [self.imageView setFrame:CGRectMake(10, Y_BLOW(self.contentLabel, 3), 100, 68)];
        NSString *imageHost = [[AppConfig sharedConfigDB] configDBGet:@"imageHost"];
        [self.imageView setDownloadUrlString:[NSString stringWithFormat:@"%@/%@", imageHost, postData.thumb]];
        
        viewHeight = Y_BLOW(self.imageView, 3);
        
        NS0Log(@"//////set image");
    }
    
    FRAME_SET_HEIGHT(self, viewHeight)
    CGFloat yBorder = 3;
    postData.height = self.frame.size.height + 2 * yBorder;
    NS0Log(@"postData.height : %zi", postData.height);
}
#endif



#if 0

- (void)showMoreMenu {
    LOG_POSTION
    
    //    NSMutableArray *ary = [[NSMutableArray alloc] init];
    //    ButtonData *data ;
    //
    //    data = [[ButtonData alloc] init];
    //    data.keyword = @"refresh";
    //    data.id = 'f';
    //    data.superId = 'm';
    //    data.image = @"";
    //    data.title = @"刷新";
    //    data.method = 2;
    //    [ary addObject:data];
    //
    //    data = [[ButtonData alloc] init];
    //    data.keyword = @"reload";
    //    data.id = 'l';
    //    data.superId = 'm';
    //    data.image = @"";
    //    data.title = @"加载";
    //    data.method = 2;
    //    [ary addObject:data];
    //
    //    CGFloat width = 100;
    //    self.actionMenu = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - width, 0, width, 0)];
    //    //[self.view addSubview:self.actionMenu];
    //    [self.actionMenu setBackgroundColor:[AppConfig backgroundColorFor:@"MenuAction"]];
    //    FRAME_BELOW_TO(self.actionMenu, self.bannerView, 1.0)
    //
    //    NSInteger index = 0;
    //    CGFloat height = 36;
    //    for(ButtonData *d in ary) {
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [self.actionMenu addSubview:button];
    //        [button setFrame:CGRectMake(0, index*height , self.actionMenu.frame.size.width, height)];
    //        [button setTitle:d.title forState:UIControlStateNormal];
    //        [button setTitleColor:[AppConfig textColorFor:@"Black"] forState:UIControlStateNormal];
    //        [button setTag:d.id];
    //        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    //        
    //        index ++;
    //        FRAME_ADD_HEIGHT(self.actionMenu, height)
    //    }
}







#endif



#if DELEDE_JSON_CACHE
NSInteger PostId = [(NSNumber*)[self.arrayAllRecord objectAtIndex:row] integerValue];

NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentPath = [array firstObject];

NSString *jsonCacheFolder =
[NSString stringWithFormat:@"%@/%@/JsonCache", documentPath, [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
[[NSFileManager defaultManager] createDirectoryAtPath:jsonCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
NSString *pathJsonCache = [NSString stringWithFormat:@"%@/Post_%08zi.json", jsonCacheFolder, PostId];

[[NSFileManager defaultManager] removeItemAtPath:pathJsonCache error:nil];



#endif



#if 0
- (void)pageNumberCount {
    
    NSLog(@"------ %zi , pageNum %zi", [self.postDatas count], self.pageNum);
    
    NSInteger numPostDatas = [self.postDatas count];
    if(numPostDatas == 0 || numPostDatas == 1) {
        self.pageNum = 1;
    }
    else if(((numPostDatas - 1) % 20) == 0) {
        self.pageNum ++;
    }
    else {
        //        NSInteger tmp = (numPostDatas-1) / 20 * 20 ;
        //
        //        NSRange range = NSMakeRange(tmp+1, numPostDatas - tmp - 1);
        //        [self.postDatas removeObjectsInRange:range];
        //        NSLog(@"remove %zi , length %zi", range.location, range.length);
    }
    
    if(self.pageNum == 1) {
        //        [self.postDatas removeAllObjects];
    }
}


- (NSString*)getDownloadUrlString {
    
    NSInteger pageNumReload = 0;
    
    NSLog(@"------ %zi , pageNum %zi", [self.postDatas count], self.pageNum);
    
    NSInteger numPostDatas = [self.postDatas count];
    if(numPostDatas == 0 || numPostDatas == 1) {
        pageNumReload = 1;
    }
    else if(((numPostDatas - 1) % 20) == 0) {
        pageNumReload = self.pageNum + 1;
    }
    else {
        pageNumReload = self.pageNum;
    }
    
    return [NSString stringWithFormat:@"%@/t/%zi?page=%zi", self.host, self.threadId, pageNumReload];
}
#endif


#if USING_USER_DEFAULT
- (void)collectionWithUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.topic];
    NSString *key = [NSString stringWithFormat:@"Collection@%@", [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    
    NSArray *getArr = [userDefault objectForKey:key];
    
    NSInteger index = [getArr indexOfObject:data];
    if(NSNotFound == index || [getArr count] == 0) {
        NSMutableArray *newArr = [[NSMutableArray alloc] initWithObjects:data, nil];
        [newArr addObjectsFromArray:getArr];
        [userDefault setObject:newArr forKey:key];
        [userDefault synchronize];
        
        for(NSData* d in newArr) {
            PostData *pd = [NSKeyedUnarchiver unarchiveObjectWithData:d];
            NSLog(@"%@", pd);
        }
        
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"收藏成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
    else {
        NSLog(@"duplicate");
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"该主题已收藏";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
    
    
    //[userDefault setObject:data forKey:@"PostData"];
    
    //    NSData *getdata = [userDefault objectForKey:@"PostData"];
    //    PostData *postData = [NSKeyedUnarchiver unarchiveObjectWithData:getdata];
    
    //    NSLog(@"%@", postData);
    
}
#endif



#if JSON_CACHE

- (void)collection {
    
    if(!self.topic) {
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"主题未加载成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
        return;
    }
    
    /* 保存json文件. */
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array firstObject];
    
    NSString *jsonCacheFolder =
    [NSString stringWithFormat:@"%@/%@/JsonCache", documentPath, [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    [[NSFileManager defaultManager] createDirectoryAtPath:jsonCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *pathJsonCache = [NSString stringWithFormat:@"%@/collection_%08zi.json", jsonCacheFolder, self.topic.id];
    
    [self.jsonData writeToFile:pathJsonCache atomically:YES];
    
    /* collection 写数据库. */
    NSArray *arrayCollection = [[AppConfig sharedConfigDB] configDBCollectionGet];
    NSInteger index = [arrayCollection indexOfObject:[NSNumber numberWithInteger:self.topic.id]];
    if(NSNotFound == index || [arrayCollection count] == 0) {
        [[AppConfig sharedConfigDB] configDBCollectionInsert:self.topic.id andUid:@""];
        
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"收藏成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
    else {
        NSLog(@"duplicate");
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"该主题已收藏";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
}


- (void)deleteCollection:(NSInteger)row {
    NSLog(@"---\n%@", self.arrayCollection);
    
    NSInteger collectionId = [(NSNumber*)[self.arrayCollection objectAtIndex:row] integerValue];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array firstObject];
    
    NSString *jsonCacheFolder =
    [NSString stringWithFormat:@"%@/%@/JsonCache", documentPath, [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    [[NSFileManager defaultManager] createDirectoryAtPath:jsonCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *pathJsonCache = [NSString stringWithFormat:@"%@/collection_%08zi.json", jsonCacheFolder, collectionId];
    
    [[NSFileManager defaultManager] removeItemAtPath:pathJsonCache error:nil];
    
}


- (PostData*)getThreadPostDataFromJsonCache:(NSInteger)id {
    
    PostData *postData = nil;
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array firstObject];
    
    NSString *jsonCacheFolder =
    [NSString stringWithFormat:@"%@/%@/JsonCache", documentPath, [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    [[NSFileManager defaultManager] createDirectoryAtPath:jsonCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *pathJsonCache = [NSString stringWithFormat:@"%@/collection_%08zi.json", jsonCacheFolder, id];
    
    NSData *data = [NSData dataWithContentsOfFile:pathJsonCache];
    if(data) {
        //NSLog(@"%s", [data bytes]);
    }
    else {
        NSLog(@"data null");
        return nil;
    }
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj) {
        NS0Log(@"obj class NSArray     : %d", [obj isKindOfClass:[NSArray class]]);
        NS0Log(@"obj class NSDictionary: %d", [obj isKindOfClass:[NSDictionary class]]);
    }
    else {
        NS0Log(@"obj nil %d", __LINE__);
        return nil;
    }
    
    dict = (NSDictionary*)obj;
    
    NS0Log(@"%@", dict);
    
    obj = [dict objectForKey:@"threads"];
    if(obj) {
        if(![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@ not dictionary", @"parsing threads obj");
            return nil;
        }
        
        postData = [PostData fromDictData:(NSDictionary*)obj];
        if(nil == postData) {
            NSLog(@"error : PostData formDictData with content %@", obj);
            return nil;
        }
        
        postData.bTopic = YES;
        postData.mode = 1;
    }
    else {
        NSLog(@"obj nil %d", __LINE__);
        return nil;
    }
    
    return postData;
}








#endif




#if USING_USER_DEFAULT //CollectionViewController

- (void)refreshPostDataWithUserDefault {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Collection@%@", [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    NSArray *getArr = [userDefault objectForKey:key];
    if(0 == [getArr count]) {
        
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"无收藏信息";
        [popupView popupInSuperView:self.view];
        
        return ;
    }
    
    self.postDatas = [[NSMutableArray alloc] init];
    for(NSData *data in getArr) {
        
        PostData *postData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.postDatas addObject:postData];
    }
    
    [self postDatasToCellDataSource];
    [self.postView reloadData];
}


- (void)deleteCollectionWithUserDefault:(NSInteger)row {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Collection@%@", [[AppConfig sharedConfigDB] configDBGet:@"hostname"]];
    NSArray *getArr = [userDefault objectForKey:key];
    NSMutableArray *modifiedArr = [[NSMutableArray alloc] initWithArray:getArr];
    [modifiedArr removeObjectAtIndex:row];
    
    [userDefault setObject:modifiedArr forKey:key];
    [userDefault synchronize];
}









#endif



#if 0 //layout for DetailedViewController postdatacell layout.


- (void)layoutCell0: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData *)postData{
    //    CALayer *TopBorder = [CALayer layer];
    //    TopBorder.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, 0.0f);
    //    TopBorder.backgroundColor = [AppConfig backgroundColorFor:@"ReplyCellBorderMain"].CGColor;
    [cell.layer removeAllAnimations];
    
    
    if(row == 0) {
        
    }
    else if(row == 1) {
        CALayer *TopBorder = [CALayer layer];
        TopBorder.frame = CGRectMake(0.0f, 0.0f, cell.layer.frame.size.width, 1.0f);
        TopBorder.backgroundColor = [AppConfig backgroundColorFor:@"ReplyCellBorderMain"].CGColor;
        [cell.layer addSublayer:TopBorder];
    }
    else {
        CALayer *TopBorder = [CALayer layer];
        TopBorder.frame = CGRectMake(0.0f, 0.0f, cell.layer.frame.size.width, 1.0f);
        TopBorder.backgroundColor = [AppConfig backgroundColorFor:@"ReplyCellBorderReply"].CGColor;
        [cell.layer addSublayer:TopBorder];
    }
    
    //    [cell.layer addSublayer:TopBorder];
    
    cell.backgroundColor = [cell viewWithTag:100].backgroundColor;
    
}


- (void)layoutCell1: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData *)postData{
    [cell.layer removeAllAnimations];
    
    NSLog(@"%s : %zi", __FUNCTION__, row);
    cell.backgroundColor = [cell viewWithTag:100].backgroundColor;
    
    PostDataCellView *v = (PostDataCellView*)[cell viewWithTag:100];
    if(v) {
        
        v.layout = ^(PostDataCellView* cellView, NSInteger row) {
            
            NSLog(@"xxxxxx");
            
            [cellView.layer removeAllAnimations];
            
            CALayer *border = [CALayer layer];
            border.frame = CGRectMake(0.0f, cellView.frame.size.height, cellView.frame.size.width, 2.0f);
            border.backgroundColor = [[UIColor blueColor] CGColor];
            
            [cellView.layer addSublayer:border];
        };
    }
    else {
        
        NSLog(@"-----");
        
    }
    
    
    
    
    
    return;
    
    
    
    //    CGFloat height = 100;
    //    PostData* pd = (PostData*)([self.postDatas objectAtIndex:row]);
    //    height = pd.height;
    //
    //    CALayer *TopBorder = [CALayer layer];
    //    TopBorder.frame = CGRectMake(0.0f, height, cell.frame.size.width, 1.0f);
    //
    //    if(row == 0) {
    //        TopBorder.backgroundColor = [AppConfig backgroundColorFor:@"ReplyCellBorderMain"].CGColor;
    //    }
    //    else {
    //        TopBorder.backgroundColor = [AppConfig backgroundColorFor:@"ReplyCellBorderReply"].CGColor;
    //    }
    //
    ////    else {
    ////        CALayer *TopBorder = [CALayer layer];
    ////        TopBorder.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, 1.0f);
    ////        TopBorder.backgroundColor = [AppConfig backgroundColorFor:@"ReplyCellBorderReply"].CGColor;
    ////        [cell.layer addSublayer:TopBorder];
    ////    }
    //
    //    [cell.layer addSublayer:TopBorder];
    //    LOG_VIEW_RECT(cell.layer, @"111");
    
    
    //UIView *tmp = [[UIView alloc] init];
    //[cell setBackgroundView:tmp];
    //    [tmp.layer setBorderColor:[[UIColor blackColor] CGColor]];
    //    [tmp.layer setBorderWidth:1];
    //[tmp.layer addSublayer:TopBorder];
    //LOG_VIEW_RECT(tmp.layer, @"111")
    //    [cell.layer addSublayer:TopBorder];
    
    //    cell.backgroundColor = [cell viewWithTag:100].backgroundColor;
}


- (void)layoutCell: (UITableViewCell *)cell withRow:(NSInteger)row withPostData:(PostData *)postData{
    [cell.layer removeAllAnimations];
    
    NSLog(@"row at : %zi", row);
    PostDataCellView *cellView = (PostDataCellView*)[cell viewWithTag:100];
    //    cell.backgroundColor = cellView.backgroundColor;
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    [cellView.layer removeAllAnimations];
    
    float borderHeight = 0.3;
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0.0f, cellView.frame.size.height-borderHeight, cellView.frame.size.width, borderHeight);
    border.backgroundColor = [[UIColor blueColor] CGColor];
    if(0 == row) {
        border.backgroundColor = [[UIColor redColor] CGColor];
    }
    
    [cellView.layer addSublayer:border];
    //
    //
    //    [cell.layer removeAllAnimations];
    //
    //    border = [CALayer layer];
    //    border.frame = CGRectMake(0.0f, cell.frame.size.height, cell.frame.size.width, 2.0f);
    //    border.backgroundColor = [[UIColor redColor] CGColor];
    //
    //    [cell.layer addSublayer:border];
}


#if 0
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    PostDataCellView *cellView = object;
    
    [cellView.layer removeAllAnimations];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0.0f, cellView.frame.size.height, cellView.frame.size.width, 2.0f);
    border.backgroundColor = [[UIColor blueColor] CGColor];
    
    [cellView.layer addSublayer:border];
}
#endif




//- (void)addToPost {
//
//    //保存到record.
//    NSString *jsonstring = [[NSString alloc] initWithData:self.jsonData encoding:NSUTF8StringEncoding];
//    NSDictionary *infoInsertRecord = @{
//                                 @"id"          : [NSNumber numberWithInteger:self.threadId],
//                                 @"threadId"    : [NSNumber numberWithInteger:self.threadId],
//                                 @"createdAt"   : [NSNumber numberWithLongLong:0],
//                                 @"updatedAt"   : [NSNumber numberWithLongLong:0],
//                                 @"jsonstring"  : jsonstring };
////    [[AppConfig sharedConfigDB] configDBRecordInsert:infoInsertRecord];
//
//    //保存到post.
//    NSDictionary *infoInsertPost = @{
//                                     @"id"          : [NSNumber numberWithInteger:self.threadId] };
////    [[AppConfig sharedConfigDB] configDBPostInsert:infoInsertPost orReplace:YES];
//
//
////    NSArray *array = [[AppConfig sharedConfigDB] configDBPostQuery:nil];
////    NSLog(@"------\n%@\n", array);
//}





- (void)clearDataAdditional {
    self.topic = nil;
    self.topicDictObj = nil;
}


////重写观察方
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"idCollection"]) {
//
//        LOG_POSTION
//
//    }
//    else if ([keyPath isEqualToString:@"idPo"]) {
//
//        LOG_POSTION
//
//        NSDictionary *info = @{
//                               @"postId":[NSNumber numberWithInteger:self.threadId],
//                               @"threadId":[NSNumber numberWithInteger:self.idPo],
//                               @"postTime":[NSNumber numberWithLongLong:0],
//                               @"updateTime":[NSNumber numberWithLongLong:0],
//                               @"threadTime":[NSNumber numberWithLongLong:0],
//                               };
//
////        [[AppConfig sharedConfigDB] configDBPostInsert:info orReplace:YES];
//    }
//    else if ([keyPath isEqualToString:@"idReply"]) {
//
//        LOG_POSTION
//        NSLog(@"idReply:%zi.", self.idReply);
//
//        NSDictionary *info = @{
//                               @"postId":[NSNumber numberWithInteger:self.threadId],
//                               @"threadId":[NSNumber numberWithInteger:self.idReply],
//                               @"postTime":[NSNumber numberWithLongLong:0],
//                               @"updateTime":[NSNumber numberWithLongLong:0],
//                               @"threadTime":[NSNumber numberWithLongLong:0],
//                               };
//
////        [[AppConfig sharedConfigDB] configDBPostInsert:info orReplace:YES];
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}


//在init注册观察者
-(instancetype) init
{
    if (self = [super init]) {
        
        //        [self addObserver:self
        //               forKeyPath:@"idCollection"
        //                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
        //                  context:nil];
        //
        //        [self addObserver:self
        //               forKeyPath:@"idPo"
        //                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
        //                  context:nil];
        //
        //        [self addObserver:self
        //               forKeyPath:@"idReply"
        //                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
        //                  context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFromCreateReplyFinish:) name:@"CreateReplyFinish" object:nil];
    }
    
    return self;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //    [self removeObserver:self forKeyPath:@"idCollection"];
    //    [self removeObserver:self forKeyPath:@"idPo"];
    //    [self removeObserver:self forKeyPath:@"idReply"];
}

#endif


#if 0 //DetailedViewController - collection
- (void)collection {
    
    if(!self.topic) {
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"主题未加载成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
        return;
    }
    
    //查看是否已经收藏过.
    NSDictionary* infoQuery = @{@"id":[NSNumber numberWithInteger:self.threadId],
                                @"threadId":[NSNumber numberWithInteger:self.threadId]};
    NSArray* queryArray = [[AppConfig sharedConfigDB] configDBCollectionQuery:infoQuery];
    if([queryArray count] > 0) {
        
        NSLog(@"duplicate");
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"该主题已收藏";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
        
        return;
    }
    
    //帖子的信息已经在解析的时候自动存储到record表.
    
    NSInteger result ;
    NSDictionary *infoInsertCollection = @{
                                           @"id":[NSNumber numberWithInteger:self.threadId],
                                           @"collectedAt":[NSNumber numberWithLongLong:111]
                                           };
    result = [[AppConfig sharedConfigDB] configDBCollectionInsert:infoInsertCollection];
    if(CONFIGDB_EXECUTE_OK == result) {
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"收藏成功";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
    else {
        NSLog(@"error- ");
        PopupView *popupView = [[PopupView alloc] init];
        popupView.numofTapToClose = 1;
        popupView.secondsOfAutoClose = 2;
        popupView.titleLabel = @"主题收藏失败";
        popupView.borderLabel = 30;
        popupView.line = 3;
        [popupView popupInSuperView:self.view];
    }
}

#endif


#if 0


- (void)finishTest1 {
    
    //[self actionDismissWithReloadNotification:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    [vc setPostThreadId:6670627];
    
    //[self presentViewController:vc animated:NO completion:^(void){ }];
    [self.navigationController pushViewController:vc animated:YES];
    
    //    [self.navigationController popToViewController:self animated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
}


- (void)finishTestx {
    
    DetailViewController *vc = [[DetailViewController alloc]init];
    [vc setPostThreadId:6670627];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [array removeLastObject];
    [array addObject:vc];
    
    [self.navigationController setViewControllers:array animated:YES];
}
#endif





























































































































































































































































































































































































































#if 0
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"-----------------------------------");
    
    CGRect frame = [((NSValue*)[change objectForKey:@"new"]) CGRectValue];
    LOG_RECT(frame, @"cell")
    
    PostDataCellView *cellView = object;
    UITableViewCell *cell = (UITableViewCell*)cellView.superview;
    
    [self layoutCell:cell withRow:0 withPostData:nil];
    
    /*
     PostDataCellView *cell = object;
     
     [cell.layer removeAllAnimations];
     
     CALayer *border = [CALayer layer];
     border.frame = CGRectMake(0.0f, frame.size.height, cell.frame.size.width, 2.0f);
     border.backgroundColor = [[UIColor blueColor] CGColor];
     
     [self.layer addSublayer:border];
     */
}


- (void)layoutCellView: (id)object {
    
    NSLog(@"%@.", object);
    
    
    
    
}
#endif