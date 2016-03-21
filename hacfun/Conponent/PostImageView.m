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
@interface PostImageView ()




@property (strong,nonatomic) NSString *downloadString ;

@property (nonatomic, strong) UIImageView *embedImageView;

@property (assign,nonatomic) id target;
@property (assign,nonatomic) SEL selector;


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


- (void)setDownloadUrlString : (NSString*)downloadString {
    NSLog(@"downloadString %@", downloadString);
    
    self.downloadString = downloadString;
    
    NSData *dataRead = [ImageViewCache getImageViewCache:self.downloadString];
    NS0Log(@"%zi", [dataRead length]);
    if([dataRead length] > 0) {
        NSLog(@"------ use cached image.%@ - %@", self, self.superview);
        [self updateImageByCachedData:dataRead];
    }
    else {
        NSLog(@"------ start download.");
        [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
        [self updateImage:[UIImage imageNamed:@"zheshiluwei.jpg"]];
    }
}


- (void)setBackgroundDownload {
    
    NSURL *urlstr=[[NSURL alloc] initWithString:[self.downloadString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NS0Log(@"url:%@", urlstr);
    
    //把图片转换为二进制的数据
    NSData *data = [NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
    if(data) {
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
    [ImageViewCache setImageViewCache:self.downloadString withData:data];
    
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


- (void)clickPostViewImage {
    NSLog(@"click post view image.");
    
    if(nil != self.selector) {
//        [self.target performSelector:self.selector withObject:nil];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end