//
//  PostImageView.m
//  hacfun
//
//  Created by Ben on 15/7/29.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostImageView.h"
#import "FuncDefine.h"
#import "ImageViewCache.h"
#import "NSString+Category.h"



@interface PostImageView ()
@property (nonatomic, strong) UIImageView *embedImageView;
@end


@implementation PostImageView


- (id)embedImageView
{
    if(!_embedImageView) {
        _embedImageView = [[UIImageView alloc] init];
        [self addSubview:_embedImageView];
    }
    
    return _embedImageView;
}


- (void)setDownloadString : (NSString*)downloadString {
    if(!downloadString) {
        _downloadString = nil;
        //NSLog(@"#error - downloadString nil.");
        return ;
    }
    
    NSLog(@"downloadString %@", downloadString);
    
    _downloadString = downloadString;
    
    NSData *dataRead = [ImageViewCache getImageViewCache:self.downloadString];
    NS0Log(@"%zi", [dataRead length]);
    if([dataRead length] > 0) {
        NSLog(@"------ use cached image.");
        [self updateImageByCachedData:dataRead];
    }
    else {
        [self updateImage:[UIImage imageNamed:@"zheshiluweipng"]];
        NSLog(@"------ start download.");
        //[self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];

        __weak typeof(self) weakSelf = self;
        [[PostImageView HTTPSessionManager] GET:downloadString
                                     parameters:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                            if([responseObject isKindOfClass:[NSData class]]) {
                                                [ImageViewCache setImageViewCache:downloadString withData:responseObject];
                                                
                                                //因为cell重用的原因, 可能对同一个PostImageView设置多个download URL.因此显示的时候需判断一下.
                                                if([downloadString isEqualToString:_downloadString]) {
                                                    NSLog(@"PostImageView updateImageByDownloadedData. %@", downloadString);
                                                    [weakSelf updateImageByDownloadedData:responseObject];
                                                }
                                                else {
                                                    NSLog(@"...fossil PostImageView updateImageByDownloadedData.");
                                                }
                                            }
                                        }
                                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            NSLog(@"#error - PostImageView download error<%@>.", downloadString);
                                        }
         ];
    }
}


+ (AFHTTPSessionManager *)HTTPSessionManager
{

    static dispatch_once_t once;
    static AFHTTPSessionManager *kHTTPSessionManager = nil;
    
    dispatch_once(&once, ^{
        kHTTPSessionManager = [AFHTTPSessionManager manager];
        [kHTTPSessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        kHTTPSessionManager.requestSerializer.timeoutInterval = 10;
    });
    
    return kHTTPSessionManager;
}


- (void)setBackgroundDownload {
    
//    NSURL *urlstr=[[NSURL alloc] initWithString:[self.downloadString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURL *urlstr = [NSString stringToNSURL:self.downloadString];
    NS0Log(@"url:%@", urlstr);
    
    //把图片转换为二进制的数据
    NSData *data = [NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
    if(data) {
        NSLog(@"thumb image length : %zd <%@>", data.length, urlstr);
        [self performSelectorOnMainThread:@selector(updateImageByDownloadedData:) withObject:data waitUntilDone:NO];
    }
    else {
        NSLog(@"error : url[%@] content return nil ", urlstr);
    }
}


- (void)layoutSubviews
{
    CGRect frameEmbedImageView = CGRectZero;
    UIImage *image = self.embedImageView.image;
    if(image.size.height > 0) {
        CGFloat width = self.frame.size.height * image.size.width / image.size.height;
        frameEmbedImageView = CGRectMake(0, 0, width, self.frame.size.height);
        
        if(width > self.frame.size.width) {
            CGFloat height = self.frame.size.width* image.size.height / image.size.width;
            frameEmbedImageView = CGRectMake(0, 0, self.frame.size.width, height);
        }
    }
    
    self.embedImageView.frame = frameEmbedImageView;
    
}


- (void)updateImageByDownloadedData:(NSData*)data
{
    
    
    UIImage *image = [UIImage imageWithData:data];
    [self updateImage:image];
}


- (void)updateImageByCachedData:(NSData*)data
{
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"data length : %zd, image : %@", data.length, image);
    [self updateImage:image];
}


- (void)updateImage:(UIImage*)image
{
    if(image) {
        self.embedImageView.image = image;
        [self layoutSubviews];
    }
    
}


- (UIImage*)getDisplayingImage
{
    return [self.embedImageView.image copy];
}





//- (void)setDidSelectedResponseTarget : (id) target
//                             selector:(SEL)selector {
//    
//    self.target = target;
//    self.selector = selector;
//}
//
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    NSLog(@"PostImage touchesBegan.");
//}


//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.userInteractionEnabled = YES;
////        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPostViewImage)];
////        [self addGestureRecognizer:labelTapGestureRecognizer];
//        
//    }
//    return self;
//}


//- (void)clickPostViewImage {
//    NSLog(@"click post view image.");
//    
//    if(nil != self.selector) {
////        [self.target performSelector:self.selector withObject:nil];
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end