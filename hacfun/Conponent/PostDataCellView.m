//
//  PostDataViewCell.m
//  hacfun
//
//  Created by Ben on 15/7/15.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "PostDataCellView.h"
#import "FuncDefine.h"
#import "RTLabel.h"
#import "PostImageView.h"
#import "AppConfig.h"


@interface PostDataCellView () {
    NSObject* _frameObserver;
    
};

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *infoAdditionalLabel;
@property (strong,nonatomic) RTLabel *contentLabel;

@property (strong,nonatomic) PostImageView *imageView;

@property (assign,nonatomic) NSInteger row;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, assign) CGFloat borderTop;
@property (nonatomic, assign) CGFloat borderLeft;



@end








static NSInteger kcountObject = 0;




@implementation PostDataCellView
- (UIView*) getThumbImage {
    return self.imageView;
}


- (UIView*)getContentLabel {
    return self.contentLabel;
}


- (void)setFrameObserver:(id)frameObserver
{
    assert(!_frameObserver);
    _frameObserver = frameObserver;
    [self addObserver:_frameObserver forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"-=-=-=%@ %zi set observer %@ setdata", self, self.row, _frameObserver);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CellViewFrameChanged" object:self];
    
    
    
    NSString *s1 = [[NSString alloc] initWithFormat:@"%@", self];
    s1 = [s1 stringByAppendingString:@"xxx"];
    
    
    

    
//    
//    
//        if(self.layout) {
//            NSLog(@"------ PostDataCellView layout");
//            self.layout(self, 0);
//        }
//        else {
//            NSLog(@"------ no PostDataCellView layout");
//        }
//        
//    
//    return;
//    
//    CGRect frame = [((NSValue*)[change objectForKey:@"new"]) CGRectValue];
//    LOG_RECT(frame, @"cell")
//    
//    PostDataCellView *cell = object;
//    
//    [cell.layer removeAllAnimations];
//    
//    CALayer *border = [CALayer layer];
//    border.frame = CGRectMake(0.0f, frame.size.height, cell.frame.size.width, 2.0f);
//    border.backgroundColor = [[UIColor blueColor] CGColor];
//    
//    [self.layer addSublayer:border];
}


- (instancetype)initWithFrame1:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        kcountObject ++;
        self.row = -1;
        self.backgroundColor = [AppConfig backgroundColorFor:@"PostDataCellView"];
        
        if(!self.titleLabel) {
            self.titleLabel = [[UILabel alloc] init];
            self.titleLabel.text = @"yyyy-mm-dd xyu-ACV-";
            self.titleLabel.font = [AppConfig fontFor:@"PostTitle"];
            self.titleLabel.textColor = [AppConfig textColorFor:@"CellTitle"];
//            self.titleLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
            [self addSubview:self.titleLabel];
        }
        
        if(!self.infoLabel) {
            self.infoLabel = [[UILabel alloc] init];
            self.infoLabel.text = [NSString stringWithFormat:@"回应: %ld", -1L];
            
            self.infoLabel.font = [AppConfig fontFor:@"PostTitle"];
            self.infoLabel.textColor = [AppConfig textColorFor:@"CellInfo"];
            [self.infoLabel setTextAlignment:NSTextAlignmentRight];
            
            [self addSubview:self.infoLabel];
        }
        
        if(!self.infoAdditionalLabel) {
            self.infoAdditionalLabel = [[UILabel alloc] init];
            self.infoAdditionalLabel.text = @"";
            self.infoAdditionalLabel.font = [AppConfig fontFor:@"PostTitle"];
            self.infoAdditionalLabel.textColor = [AppConfig textColorFor:@"CellInfoAdditional"];
            self.infoAdditionalLabel.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:self.infoAdditionalLabel];
        }
        
        if(!self.contentLabel) {
            self.contentLabel = [[RTLabel alloc] init];
            [self addSubview:self.contentLabel];
            
            self.contentLabel.text = @"content\n内容\n示范";
            
            self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.contentLabel.font = [AppConfig fontFor:@"PostContent"];
            self.contentLabel.textColor = [AppConfig textColorFor:@"Black"];
        }
        
        if(!self.imageView) {
            self.imageView = [[PostImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [self addSubview:self.imageView];
        }
    }
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}


- (void)setContent
{
    NSString *title = [self.data objectForKey:@"title"];
    title = title?title:@"null";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    UIColor *colorUid = [self.data objectForKey:@"colorUid"];
    if([title length] >= 29 && colorUid) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(21,8)];
    }
    //    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, [textTitle length])];
    //[str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    //    self.titleView.font = [UIFont systemFontOfSize:10.0];
    self.titleLabel.attributedText = attributedString;
//    [self.titleLabel setText:title];
    
    NSString *info = [self.data objectForKey:@"info"];
    info = info?info:@"null";
    [self.infoLabel setText:info];
    
    NSString *infoAdditionalString = [self.data objectForKey:@"infoAdditional"];
    infoAdditionalString = infoAdditionalString?infoAdditionalString:@"";
    [self.infoAdditionalLabel setText:infoAdditionalString];
    NSMutableAttributedString *attributedInfoAdditionalString = [[NSMutableAttributedString alloc] initWithString:infoAdditionalString];
    
    NSRange rangeSage = [infoAdditionalString rangeOfString:@"SAGE"];
    if(rangeSage.location != NSNotFound) {
        [attributedInfoAdditionalString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangeSage];
    }
    self.infoAdditionalLabel.attributedText = attributedInfoAdditionalString;
    
    NSString *content = [self.data objectForKey:@"content"];
    content = content?content:@"null\n111";
    [self.contentLabel setText:content];
    
    //UIViewImage
    NSString *thumb = [self.data objectForKey:@"thumb"];
    
    //判断是否设置无图模式.
    NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"disableimageshow"] ;
    BOOL b = [value boolValue];
    if(nil == thumb || [thumb isEqualToString:@""] || b) {
        self.imageView.hidden = YES;
    }
    else {
        self.imageView.hidden = NO;
        NSString *imageHost = [[AppConfig sharedConfigDB] configDBGet:@"imageHost"];
        [self.imageView setDownloadUrlString:[NSString stringWithFormat:@"%@/%@", imageHost, thumb]];
    }
}


- (void)layoutContent
{
    CGRect frameTitleLabel          = CGRectZero;
    CGRect frameInfoLabel           = CGRectZero;
    CGRect frameInfoAdditionalLabel = CGRectZero;
    CGRect frameContentLabel        = CGRectZero;
    CGRect frameImageViewContent    = CGRectZero;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:CGSizeMake(self.frame.size.width, 10000)];
    //设置外边框.
    [layout setUseEdge:@"LayoutAll" in:NAME_MAIN_FRAME withEdgeValue:edge];
    
    //Title line布局在最上. title与info的宽度按照比例分配.
    [layout setUseIncludedMode:@"TitleLine" includedTo:@"LayoutAll" withPostion:FrameLayoutPositionTop andSizeValue:20.0];
    
    //UIFont *font = [UIFont systemFontOfSize:12];
    UIFont *font = [AppConfig fontFor:@"PostTitle"];
//    NSString *text = @"2016-02-03 12:34:56 ABCDEF00";
    NSString *text = @"2016-02-03 12:34:56 WWWWWWWW";
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=font;
    CGSize maxSize=CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    NSLog(@"@@@---%@", NSStringFromCGSize(textSize));
    //Title line布局在最上. title与info的宽度按照比例分配.
    
    [layout divideInVertical:@"TitleLine" to:@"Title" and:@"Info" withPercentage:0.66];
    [layout divideInVertical:@"TitleLine" to:@"Title" and:@"Info" withWidthValue:textSize.width];
    frameTitleLabel     = [layout getCGRect:@"Title"];
    frameInfoLabel      = [layout getCGRect:@"Info"];
    
    CGFloat heightPaddingTitleContent = 10.0;
    if([self.infoAdditionalLabel.text length] > 0) {
        [layout setUseBesideMode:@"InfoAdditional" besideTo:@"TitleLine" withDirection:FrameLayoutDirectionBelow andSizeValue:20.0];
        heightPaddingTitleContent = 0.0;
    }
    else {
        [layout setUseBesideMode:@"InfoAdditional" besideTo:@"TitleLine" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
    }
    frameInfoAdditionalLabel = [layout getCGRect:@"InfoAdditional"];
    
    //Title和正文间设置间距.
    [layout setUseBesideMode:@"PaddingTitleContent" besideTo:@"InfoAdditional" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingTitleContent];
    
    //设置正文.
    [layout setUseLeftMode:@"Content" standardTo:@"PaddingTitleContent" withDirection:FrameLayoutDirectionBelow];
    //contentLabel需自调整高度.
    frameContentLabel = [layout getCGRect:@"Content"];
    self.contentLabel.frame = frameContentLabel;
    CGSize size = [self.contentLabel optimumSize];
    frameContentLabel.size.height = size.height;
    //重新设置
    [layout setCGRect:frameContentLabel toName:@"Content"];
    
    //Content和image之间的间距.
    [layout setUseBesideMode:@"PaddingContentImage" besideTo:@"Content" withDirection:FrameLayoutDirectionBelow andSizeValue:10.0];
    
    CGFloat heightAdjust = 0.0;
    if(self.imageView.hidden) {
        heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME(frameContentLabel) + edge.bottom;
    }
    else {
        CGFloat heightImage = 68.0;
        [layout setUseBesideMode:@"ImageLine" besideTo:@"PaddingContentImage" withDirection:FrameLayoutDirectionBelow andSizeValue:heightImage];
        [layout divideInVertical:@"ImageLine" to:@"Image" and:@"ImageLeft" withWidthValue:100.0];
        frameImageViewContent = [layout getCGRect:@"Image"];
        
        heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME(frameImageViewContent) + edge.bottom;
    }
    
#if 0
    self.titleView.frame    = [layout getCGRect:@"TitleLine"];
    NSMutableString *textTitle = [[NSMutableString alloc] initWithString:self.titleLabel.text];
    [textTitle appendString:@" "];
    [textTitle appendString:self.infoLabel.text];
    self.titleView.text     = textTitle;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textTitle];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(20,8)];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, [textTitle length])];
    //[str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    self.titleView.font = [UIFont systemFontOfSize:10.0];
//    self.titleView.attributedText = attributedString;
    
//    self.contentLabel.font = [UIFont systemFontOfSize:16.0];
#endif
    
    self.titleLabel.frame           = frameTitleLabel;
    self.infoLabel.frame            = frameInfoLabel;
    self.infoAdditionalLabel.frame  = frameInfoAdditionalLabel;
    self.contentLabel.frame         = frameContentLabel;
    self.imageView.frame            = frameImageViewContent;
    
    LOG_RECT(frameTitleLabel,           @"frameTitleLabel")
    LOG_RECT(frameInfoLabel,            @"frameInfoLabel")
    LOG_RECT(frameInfoAdditionalLabel,  @"frameInfoAdditionalLabel")
    LOG_RECT(frameContentLabel,         @"frameContentLabel")
    LOG_RECT(frameImageViewContent,     @"frameImageViewContent")
    
    FRAMELAYOUT_SET_HEIGHT(self, heightAdjust);
    NSLog(@"adjust height to %f.", heightAdjust);
}


+ (PostDataCellView*)threadCellViewWithData:(NSDictionary*)dict andInitFrame:(CGRect)frame
{
    PostDataCellView *cellView = [[PostDataCellView alloc] initWithFrame1:frame];
    cellView.data = [dict copy];
    
    //设置各空间的现实内容.
    [cellView setContent];
    
    //调整layout.
    [cellView layoutContent];
    
    return cellView;
}


+ (NSInteger)countObject
{
    return kcountObject;
}



- (void)dealloc {
    
    kcountObject --;
    [self removeObserver:self forKeyPath:@"frame"];
    if(_frameObserver) {
        NSLog(@"-=-=-=%@ %zi revome observer %@ dealloc", self, self.row, _frameObserver);
        [self removeObserver:_frameObserver forKeyPath:@"frame"];
    }
    
    NSLog(@"dealloc %@", self);
}


@end


//Label显示html相关的code
//    self.titleLabel.text = titleText;
//    NSAttributedString *attrText = [[NSAttributedString alloc]initWithData:[titleText dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//    self.titleLabel.attributedText = attrText;


//    NSString * htmlString = @"<html><body> Some html string \n <font size=\"13\" color=\"red\">This is some text!</font> </body></html>";
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
//    myLabel.attributedText = attrStr;
//    [self.view addSubview:myLabel];



//    self.titleLabel.attributedText = attrText;


//UILabel计算自适应size的code.

//CGSize maxsize = {self.contentLabel.frame.size.width,1000};
//NSDictionary * dict = @{NSFontAttributeName : self.contentLabel.font };
//CGSize size = [self.contentLabel.text boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
//self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, size.width, size.height);
//
//NS0Log(@"content label height : %lf", self.contentLabel.frame.size.height);



