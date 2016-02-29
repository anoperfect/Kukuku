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
//@property (strong,nonatomic) UIViewController* vc;
@property (assign,nonatomic) id target;
@property (assign,nonatomic) SEL selector;



@end




@implementation PostImageView

- (void)setBackgroundDownload {
    
    NSURL *urlstr=[[NSURL alloc] initWithString:[self.downloadString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NS0Log(@"url:%@", urlstr);
    
    //把图片转换为二进制的数据
    NSData *data=[NSData dataWithContentsOfURL:urlstr];//这一行操作会比较耗时
    if(data) {
        [self performSelectorOnMainThread:@selector(updateImageByData:) withObject:data waitUntilDone:NO];
    }
    else {
        NSLog(@"error : url[%@] content return nil ", urlstr);
    }
}


- (void)updateImageByData:(NSData*)data {
    UIImage *image = [UIImage imageWithData:data];
    NS0Log(@"%lf, %lf", image.size.width, image.size.height);
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [ImageViewCache setImageViewCache:self.downloadString withData:data];
    
    CGFloat widht = self.frame.size.height * image.size.width / image.size.height;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, widht, self.frame.size.height)];
    
    [self setImage:image forState:UIControlStateNormal];
}


- (void)setDownloadUrlString : (NSString*)downloadString {
    NS0Log(@"downloadString %@", downloadString);

    self.downloadString = downloadString;
    
    NSData *dataRead = [ImageViewCache getImageViewCache:self.downloadString];
    NS0Log(@"%zi", [dataRead length]);
    if([dataRead length] > 0) {
        NS0Log(@"------ use downloaded image.");
        [self updateImageByData:dataRead];
    }
    else {
        NS0Log(@"------ start download.");
        [self setImage:[UIImage imageNamed:@"zheshiluwei.jpg"] forState:UIControlStateNormal];
        [self performSelectorInBackground:@selector(setBackgroundDownload) withObject:nil];
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


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
//        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPostViewImage)];
//        [self addGestureRecognizer:labelTapGestureRecognizer];
        
    }
    return self;
}


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