//
//  CookieManage.m
//  hacfun
//
//  Created by Ben on 15/8/8.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "CookieManage.h"

@implementation CookieManage


+ (id)sharedCookieManage {
    static CookieManage* sharedCookieManage = nil;
    if(nil == sharedCookieManage) {
        sharedCookieManage = [[CookieManage alloc] init];
    }
    
    return sharedCookieManage;
}


- (void)showCookie:(NSString*)description {
    
    //    NSLog(@"------%@.", description);
    //    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    for(NSHTTPCookie *cookie in [cookieJar cookies]) {
    //        NSLog(@"------cookie");
    //        NSLog(@"%@", cookie);
    //        NSLog(@"------cookie--");
    //        //[cookieJar deleteCookie:cookie];
    //    }
}








@end





#if 0
2015-08-04 12:13:03.938 hacfun[98410:3679972] <NSHTTPCookie version:0 name:"sails.sid" value:"s%3AYTt1YgESy6cC6BhpsDJRyDAK.ry0ibNkwFbXf3KfO8Bxxgw9tCJN3u%2BQlf0aJvkZLGoA" expiresDate:2015-08-04 06:24:43 +0000 created:2015-08-04 03:54:59 +0000 (4.60353e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
2015-08-04 12:13:03.938 hacfun[98410:3679972] <NSHTTPCookie version:0 name:"userId" value:"s%3A68tzXZKX.MFtNZOnQJrYX0ilMI3QNEaQVvCSePACQCxpC2Ap12bA" expiresDate:2015-11-02 03:54:59 +0000 created:2015-08-04 03:54:59 +0000 (4.60353e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
#endif





//    NSHTTPCookie *cookie = [[NSHTTPCookie alloc]init];
//    [cookie setValue:0 forKey:@"version"];
//    [cookie setValue:0 forKey:@"version"];
//
//
//    version:0
//name:"sails.sid"
//value:"s%3AYTt1YgESy6cC6BhpsDJRyDAK.ry0ibNkwFbXf3KfO8Bxxgw9tCJN3u%2BQlf0aJvkZLGoA"
//expiresDate:2015-08-04 06:24:43 +0000
//created:2015-08-04 03:54:59 +0000 (4.60353e+08)
//sessionOnly:FALSE
//domain:"hacfun.tv"
//path:"/"
//isSecure:FALSE>

//sent by IPhone5.




#if 0

"Set-Cookie" = "userId=s%3A68tzXZKX.MFtNZOnQJrYX0ilMI3QNEaQVvCSePACQCxpC2Ap12bA; Max-Age=7776000; Path=/; Expires=Mon, 02 Nov 2015 03:54:58 GMT, sails.sid=s%3AYTt1YgESy6cC6BhpsDJRyDAK.ry0ibNkwFbXf3KfO8Bxxgw9tCJN3u%2BQlf0aJvkZLGoA; Path=/; Expires=Tue, 04 Aug 2015 06:24:43 GMT; HttpOnly";

2015-08-04 12:13:03.938 hacfun[98410:3679972] <NSHTTPCookie version:0 name:"sails.sid" value:"s%3AYTt1YgESy6cC6BhpsDJRyDAK.ry0ibNkwFbXf3KfO8Bxxgw9tCJN3u%2BQlf0aJvkZLGoA" expiresDate:2015-08-04 06:24:43 +0000 created:2015-08-04 03:54:59 +0000 (4.60353e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
2015-08-04 12:13:03.938 hacfun[98410:3679972] <NSHTTPCookie version:0 name:"userId" value:"s%3A68tzXZKX.MFtNZOnQJrYX0ilMI3QNEaQVvCSePACQCxpC2Ap12bA" expiresDate:2015-11-02 03:54:59 +0000 created:2015-08-04 03:54:59 +0000 (4.60353e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>

//"Set-Cookie" = "userId=s%3AmYY2vU0k.19v7ENHKmsxQDgELdgCYYv23%2BbPAipsUoIqAC8nkO5I; Max-Age=7776000; Path=/; Expires=Wed, 21 Oct 2015 14:49:47 GMT, sails.sid=s%3AieUiZS-n5jpvqwp65opGa7cd.PvIscC2wiBO1OvfIOjO33jkX6P3OYaS8GE9Khl91a1Q; Path=/; Expires=Thu, 23 Jul 2015 17:19:47 GMT; HttpOnly";

#endif



#if IPhone5
2015-08-04 18:16:28.368 hacfun[98826:3708442] ------cookie before POST.
2015-08-04 18:16:28.368 hacfun[98826:3708442] ------cookie
2015-08-04 18:16:28.369 hacfun[98826:3708442] <NSHTTPCookie version:0 name:"sails.sid" value:"s%3AoIxptCAPElNSt4TzPD4GuP_6.%2BED%2BuW2GpEjybGfq9MWZZc36vIzA1PNdrpfuIwar4NE" expiresDate:2015-08-04 12:42:09 +0000 created:2015-08-04 10:12:36 +0000 (4.60376e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
2015-08-04 18:16:28.369 hacfun[98826:3708442] ------cookie--
2015-08-04 18:16:28.370 hacfun[98826:3708442] ------cookie
2015-08-04 18:16:28.370 hacfun[98826:3708442] <NSHTTPCookie version:0 name:"userId" value:"s%3ADbB7qS9c.biYrs0qFri5LlVbiXUUoN8WqBzHLlVsZwv1jm%2ByNCjM" expiresDate:2015-11-02 10:12:36 +0000 created:2015-08-04 10:12:36 +0000 (4.60376e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
2015-08-04 18:16:28.370 hacfun[98826:3708442] ------cookie--
2015-08-04 18:16:28.559 hacfun[98826:3708442] <NSThread: 0x7a73f6f0>{number = 1, name = main}已经接收到响应<NSHTTPURLResponse: 0x7a7132e0> { URL: http://hacfun.tv/api/t/6414910/create } { status code: 200, headers {
    "Access-Control-Allow-Credentials" = "";
    "Access-Control-Allow-Headers" = "";
    "Access-Control-Allow-Methods" = "";
    "Access-Control-Allow-Origin" = "";
    Connection = "keep-alive";
    "Content-Length" = 63;
    "Content-Type" = "application/json; charset=utf-8";
    Date = "Tue, 04 Aug 2015 10:14:55 GMT";
    Server = "gaea/0.1.0.1";
    "Set-Cookie" = "userId=s%3ADbB7qS9c.biYrs0qFri5LlVbiXUUoN8WqBzHLlVsZwv1jm%2ByNCjM; Max-Age=7776000; Path=/; Expires=Mon, 02 Nov 2015 10:16:25 GMT, sails.sid=s%3AoIxptCAPElNSt4TzPD4GuP_6.%2BED%2BuW2GpEjybGfq9MWZZc36vIzA1PNdrpfuIwar4NE; Path=/; Expires=Tue, 04 Aug 2015 12:45:56 GMT; HttpOnly";
    "X-Powered-By" = "Akino Mizuho.Koukuko <koukuko.com>";
} }
    2015-08-04 18:16:28.559 hacfun[98826:3708442] ------
    <NSURLConnection: 0x7ba55bb0> { request: <NSMutableURLRequest: 0x7a6170d0> { URL: http://hacfun.tv/api/t/6414910/create } }------
        2015-08-04 18:16:28.560 hacfun[98826:3708442] <NSThread: 0x7a73f6f0>{number = 1, name = main}已经接收到数据-[CreateViewController connection:didReceiveData:]
        2015-08-04 18:16:28.560 hacfun[98826:3708442] {"data":"成功","success":true,"code":200,"threadsId":6431488}
        2015-08-04 18:16:28.560 hacfun[98826:3708442] <NSThread: 0x7a73f6f0>{number = 1, name = main}数据包传输完成-[CreateViewController connectionDidFinishLoading:]
        2015-08-04 18:16:28.561 hacfun[98826:3708442] ------cookie after POST.
        2015-08-04 18:16:28.561 hacfun[98826:3708442] ------cookie
        2015-08-04 18:16:28.561 hacfun[98826:3708442] <NSHTTPCookie version:0 name:"sails.sid" value:"s%3AoIxptCAPElNSt4TzPD4GuP_6.%2BED%2BuW2GpEjybGfq9MWZZc36vIzA1PNdrpfuIwar4NE" expiresDate:2015-08-04 12:45:56 +0000 created:2015-08-04 10:16:28 +0000 (4.60376e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
        2015-08-04 18:16:28.561 hacfun[98826:3708442] ------cookie--
        2015-08-04 18:16:28.561 hacfun[98826:3708442] ------cookie
        2015-08-04 18:16:28.562 hacfun[98826:3708442] <NSHTTPCookie version:0 name:"userId" value:"s%3ADbB7qS9c.biYrs0qFri5LlVbiXUUoN8WqBzHLlVsZwv1jm%2ByNCjM" expiresDate:2015-11-02 10:16:28 +0000 created:2015-08-04 10:16:28 +0000 (4.60376e+08) sessionOnly:FALSE domain:"hacfun.tv" path:"/" isSecure:FALSE>
        2015-08-04 18:16:28.562 hacfun[98826:3708442] ------cookie--
        2015-08-04 18:16:57.062 hacfun[98826:3708442] ======-[DetailViewController viewDidAppear:] 165
        2015-08-04 18:16:57.062 hacfun[98826:3708442] ======-[BannerView setNavigationText:] 175
        2015-08-04 18:16:57.062 hacfun[98826:3708442] ======-[ThreadsViewController viewDidAppear:] 132
        2015-08-04 18:17:00.322 hacfun[98826:3708442] ======-[ThreadsViewController refreshAction:] 157
        2015-08-04 18:17:00.672 hacfun[98826:3708442] ======-[ThreadsViewController refreshPostData] 202
        2015-08-04 18:17:00.673 hacfun[98826:3708442] str:http://hacfun.tv/api/t/6414910?page=1
        2015-08-04 18:17:00.673 hacfun[98826:3708442] url:http://hacfun.tv/api/t/6414910?page=1
        2015-08-04 18:17:00.673 hacfun[98826:3708442] str:http://hacfun.tv/api/t/6414910?page=1
        2015-08-04 18:17:00.673 hacfun[98826:3708442] url:http://hacfun.tv/api/t/6414910?page=1
        2015-08-04 18:17:00.674 hacfun[98826:3708442] Request :
        
        <NSMutableURLRequest: 0x7a712f30> { URL: http://hacfun.tv/api/t/6414910?page=1 }
            
            2015-08-04 18:17:00.674 hacfun[98826:3708442] cookie field : (null)
            2015-08-04 18:17:00.674 hacfun[98826:3708442] ======-[ThreadsViewController viewWillLayoutSubviews] 141
            2015-08-04 18:17:01.648 hacfun[98826:3708442] <NSThread: 0x7a73f6f0>{number = 1, name = main}已经接收到响应<NSHTTPURLResponse: 0x7b8609f0> { URL: http://hacfun.tv/api/t/6414910?page=1 } { status code: 200, headers {
                "Access-Control-Allow-Credentials" = "";
                "Access-Control-Allow-Headers" = "";
                "Access-Control-Allow-Methods" = "";
                "Access-Control-Allow-Origin" = "";
                Connection = "keep-alive";
                "Content-Length" = 2366;
                "Content-Type" = "application/json; charset=utf-8";
                Date = "Tue, 04 Aug 2015 10:25:27 GMT";
                Etag = "\"-928607680\"";
                Server = "gaea/0.1.0.1";
                "X-Powered-By" = "Akino Mizuho.Koukuko <koukuko.com>";
            } }
        2015-08-04 18:17:01.648 hacfun[98826:3708442] ------
        <NSURLConnection: 0x7a7437d0> { request: <NSMutableURLRequest: 0x7a712f30> { URL: http://hacfun.tv/api/t/6414910?page=1 } }------
            2015-08-04 18:17:01.648 hacfun[98826:3708442] <NSThread: 0x7a73f6f0>{number = 1, name = main}已经接收到数据-[ThreadsViewController connection:didReceiveData:]
            2015-08-04 18:17:01.649 hacfun[98826:3708442] <NSThread: 0x7a73f6f0>{number = 1, name = main}数据包传输完成-[ThreadsViewController connectionDidFinishLoading:]
            2015-08-04 18:17:01.650 hacfun[98826:3708442] numOfReply = 7
            2015-08-04 18:17:01.652 hacfun[98826:3708442] ======-[ThreadsViewController viewWillLayoutSubviews] 141
            2015-08-04 18:17:01.659 hacfun[98826:3708442] last row[6] shown <UITableViewCell: 0x7a611bf0; frame = (0 276; 320 60); autoresize = W; layer = <CALayer: 0x7a6f9b10>>.
            2015-08-04 18:17:01.659 hacfun[98826:3708442] treat
#endif
            
            
            
#if MODIFY_COOKIE
            
            
            NSDictionary *properites = [[NSMutableDictionary alloc] init];
            [properites setValue:@"sails.sid" forKey:NSHTTPCookieName];
            [properites setValue:@"s%3AYTt1YgESy6cC6BhpsDJRyDAK.ry0ibNkwFbXf3KfO8Bxxgw9tCJN3u%2BQlf0aJvkZLGoA" forKey:NSHTTPCookieValue];
            [properites setValue:@"hacfun.tv" forKey:NSHTTPCookieDomain];
            [properites setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
            [properites setValue:@"/" forKey:NSHTTPCookiePath];
            NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properites];
            [cookieJar setCookie:cookie];
            
            properites = [[NSMutableDictionary alloc] init];
            [properites setValue:@"userId" forKey:NSHTTPCookieName];
            [properites setValue:@"s%3A68tzXZKX.MFtNZOnQJrYX0ilMI3QNEaQVvCSePACQCxpC2Ap12bA" forKey:NSHTTPCookieValue];
            [properites setValue:@"hacfun.tv" forKey:NSHTTPCookieDomain];
            [properites setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
            [properites setValue:@"/" forKey:NSHTTPCookiePath];
            cookie = [[NSHTTPCookie alloc] initWithProperties:properites];
            [cookieJar setCookie:cookie];
            
            NSLog(@"------cookie after modify.");
            for(NSHTTPCookie *cookie in [cookieJar cookies]) {
                NSLog(@"------cookie");
                NSLog(@"%@", cookie);
                NSLog(@"------cookie--");
                [cookieJar deleteCookie:cookie];
            }
            
#endif
            
            
            
#if 0
            
            - (void)clickSend1 {
                
                NSString *host = [[AppConfig sharedConfigDB] configDBGet:@"host"];
                //    NSInteger topicNumber = 6364508;//6010990;
                NSString *str = nil;
                //str = @"http://192.168.1.6:8000/index.htm";
                
                if(self.nameCategory) {
                    str =[NSString stringWithFormat:@"%@/%@/create", host, self.nameCategory];
                }
                else {
                    str = [NSString stringWithFormat:@"%@/t/%zi/create", host, self.id];
                    
                }
                
                NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
                
                //分界线的标识符
                //    NSString *TWITTERFON_FORM_BOUNDARY = @"----WebKitFormBoundaryJCYFNcctaaOtDHN2";
                NSString *TWITTERFON_FORM_BOUNDARY = @"----WebKitFormBoundary2UCyBQVe8R5PwpHo";
                
                NSString *firstMPboundary=[[NSString alloc]initWithFormat:@"--%@\r\n", TWITTERFON_FORM_BOUNDARY];
                //分界线 --AaB03x
                NSString *MPboundary=[[NSString alloc]initWithFormat:@"\r\n--%@\r\n", TWITTERFON_FORM_BOUNDARY];
                //结束符 AaB03x--
                NSString *endMPboundary=[[NSString alloc]initWithFormat:@"\r\n--%@--\r\n", TWITTERFON_FORM_BOUNDARY];
                //要上传的图片
                //    UIImage *image=[params objectForKey:@"pic"];
                //    //得到图片的data
                //    NSData* data = UIImagePNGRepresentation(image);
                //    //http body的字符串
                NSMutableString *body = [[NSMutableString alloc]init];
                //参数的集合的所有key的集合
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:30];
                [dic setObject:@"" forKey:@"name"];
                [dic setObject:@"" forKey:@"email"];
                [dic setObject:@"" forKey:@"title"];
                //[dic setObject:@"dev testtt" forKey:@"content"];
                //[dic setObject:@"不错哦,比懒得喷的强。" forKey:@"content"];
                //[dic setObject:textView.text forKey:@"content"];
                NSString *contentInput = [NSString stringWithFormat:@"客户端测试.[%@]沉的快...", self.nameCategory];
                contentInput = textView.text;
                [dic setObject:contentInput forKey:@"content"];
                [dic setObject:@"" forKey:@"image"];
                
                NSMutableArray *ary = [[NSMutableArray alloc]init];
                [ary addObject:@"name"];
                [ary addObject:@"email"];
                [ary addObject:@"title"];
                [ary addObject:@"content"];
                [ary addObject:@"image"];
                
                NSInteger idx = 0;
                
                for(id key in ary) {
                    NS0Log(@"key : %@    , value : %@", key, [dic objectForKey:key]);
                    
                    if(0 == idx) {
                        NS0Log(@"first boundary");
                        [body appendFormat:@"%@", firstMPboundary];
                    }
                    else {
                        [body appendFormat:@"%@", MPboundary];
                    }
                    idx ++;
                    
                    if([(NSString*)key isEqualToString:@"image"]) {
                        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"\"\r\nContent-Type: application/octet-stream\r\n\r\n",key];
                        
                    }
                    else {
                        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                        NSString *strContent = (NSString*)[dic objectForKey:key];
                        [body appendFormat:@"%@", strContent];
                    }
                }
                
                [body appendFormat:@"%@", endMPboundary];
                //    //遍历keys
                //    for(int i=0;i<[keys count];i++)
                //    {
                //        //得到当前key
                //        NSString *key=[keys objectAtIndex:i];
                //        //如果key不是pic，说明value是字符类型，比如name：Boris
                //        if(![key isEqualToString:@"pic"])
                //        {
                //            //添加分界线，换行
                //            [body appendFormat:@"%@\r\n",MPboundary];
                //            //添加字段名称，换2行
                //            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //            //添加字段的值
                //            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
                //        }
                //    }
                
                //    ////添加分界线，换行
                //    [body appendFormat:@"%@\r\n",MPboundary];
                //    //声明pic字段，文件名为boris.png
                //    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
                //    //声明上传文件的格式
                //    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
                
                //声明结束符：--AaB03x--
                //NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
                //声明myRequestData，用来放入http body
                NSMutableData *myRequestData=[NSMutableData data];
                //将body字符串转化为UTF8格式的二进制
                [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
                //将image的data加入
                //    [myRequestData appendData:data];
                //加入结束符--AaB03x--
                //[myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
                
                //设置HTTPHeader中Content-Type的值
                NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
                //设置HTTPHeader
                [mutableRequest setValue:content forHTTPHeaderField:@"Content-Type"];
                //设置Content-Length
                [mutableRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
                //设置http body
                [mutableRequest setHTTPBody:myRequestData];
                //http method
                [mutableRequest setHTTPMethod:@"POST"];
                
                
                NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                NSLog(@"------cookie before POST.");
                for(NSHTTPCookie *cookie in [cookieJar cookies]) {
                    NSLog(@"------cookie");
                    NSLog(@"%@", cookie);
                    NSLog(@"------cookie--");
                    //[cookieJar deleteCookie:cookie];
                }
                
                [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
                
                //NSString *stringRequestData = [[NSString alloc] initWithData:myRequestData encoding:NSUTF8StringEncoding];
                NS0Log(@"%zi\n%@", stringRequestData.length, stringRequestData);
                NS0Log(@"%zi\n%@", stringRequestData.length, myRequestData);
                NS0Log(@"Request : \n\n%@\n\n", stringRequestData);
                
                PopupView *popupView = [[PopupView alloc] init];
                popupView.rectPadding = 10;
                popupView.rectCornerRadius = 2;
                popupView.numofTapToClose = 0;
                popupView.secondsOfAutoClose = 0;
                popupView.titleLabel = @"发送服务器中";
                popupView.borderLabel = 3;
                popupView.line = 3;
                popupView.stringIncrease = @".";
                popupView.secondsOfstringIncrease = 1;
                [popupView setTag:(NSInteger)@"PopupView"];
                [popupView popupInSuperView:self.view];
            }
            

            
            
            
#endif
