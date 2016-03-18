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

@property (strong,nonatomic) RTLabel *titleLabel;

@property (strong,nonatomic) RTLabel *infoLabel;

@property (strong,nonatomic) RTLabel *contentLabel;

@property (strong,nonatomic) PostImageView *imageView;

@property (assign,nonatomic) NSInteger row;


@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, assign) CGFloat borderTop;
@property (nonatomic, assign) CGFloat borderLeft;



@end


//[AppConfig fontFor:@""]
//[AppConfig backgroundColorFor:@""]
//[AppConfig textColorFor:@""]

@implementation PostDataCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.row = -1;
        self.backgroundColor = [AppConfig backgroundColorFor:@"PostDataCellView"];
        
        if(!self.titleLabel) {
            self.titleLabel = [[RTLabel alloc] init];
            self.titleLabel.text = @"yyyy-mm-dd xyu-ACV-";
            self.titleLabel.font = [AppConfig fontFor:@"PostContent"];
            self.titleLabel.textColor = [AppConfig textColorFor:@"CellTitle"];
            self.titleLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
            [self addSubview:self.titleLabel];
        }

        if(!self.infoLabel) {
            self.infoLabel = [[RTLabel alloc] init];
            self.infoLabel.text = [NSString stringWithFormat:@"回应: %ld", -1L];
            
            self.infoLabel.font = [AppConfig fontFor:@"PostContent"];
            self.infoLabel.textColor = [AppConfig textColorFor:@"CellInfo"];
            [self.infoLabel setTextAlignment:RTTextAlignmentRight];
            
            [self addSubview:self.infoLabel];
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
    
    [self layoutSubviews];
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    
    return self;
}


#if 0
- (void)layoutSubviews {
    [self doesNotRecognizeSelector:@selector(layoutSubviews)];
    
    CGRect frame = self.frame;
    
    CGFloat xBorder = 6;
    CGFloat yBorder = 6;
    CGFloat xPadding = 6;
    //RTLable text显示贴着上边框.导致跟infoLabel不对齐. 因此将titleLabel移下一点.
    [self.titleLabel setFrame:CGRectMake(xBorder, yBorder, frame.size.width * 0.66, 20)];
    
    CGFloat x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + xPadding;
    CGFloat width = frame.size.width - x - xPadding; width = width>0.0?width:0;
    [self.infoLabel setFrame:CGRectMake(x, yBorder, width, 20)];
    
    X_CENTER(self.contentLabel, xBorder)
    
    FRAME_BELOW_TO(self.contentLabel, self.titleLabel, yBorder)
    
    LOG_VIEW_REC0(self.contentLabel, @"cell-content")
    LOG_VIEW_REC0(self, @"cell")
}
#endif


- (void)setPostData:(NSDictionary*)data inRow:(NSInteger)row {
    
    NS0Log(@"******setPostData");
    CGFloat borderTopAndBottom = 10;

    NSString *title = (NSString*)[data objectForKey:@"title"];
    title = title?title:@"null";
    [self.titleLabel setText:title];
    
    NSString *info = (NSString*)[data objectForKey:@"info"];
    info = info?info:@"null";
    [self.infoLabel setText:info];
    
    NSString *content = (NSString*)[data objectForKey:@"content"];
    content = content?content:@"null\n111";
    [self.contentLabel setText:content];
    
    //RTLabel相关.
    CGSize size = [self.contentLabel optimumSize];
    FRAME_SET_HEIGHT(self.contentLabel, size.height)
    NS0Log(@"xxxxxx optimumSize.height : %lf", size.height);
    
    #define Y_BLOW(view, border) (view.frame.origin.y + view.frame.size.height + border)
    CGFloat viewHeight = Y_BLOW(self.contentLabel, borderTopAndBottom);
    
    //UIViewImage
    NSString *thumb = (NSString*)[data objectForKey:@"thumb"];
    
    //判断是否设置无图模式.
    NSString *value = [[AppConfig sharedConfigDB] configDBSettingKVGet:@"disableimageshow"] ;
    BOOL b = [value boolValue];
    if(nil == thumb || [thumb isEqualToString:@""] || b) {
        
    }
    else {
        [self.imageView setFrame:CGRectMake(10, Y_BLOW(self.contentLabel, 3), 100, 68)];
        NSString *imageHost = [[AppConfig sharedConfigDB] configDBGet:@"imageHost"];
        [self.imageView setDownloadUrlString:[NSString stringWithFormat:@"%@/%@", imageHost, thumb]];
        
        viewHeight = Y_BLOW(self.imageView, borderTopAndBottom);
        
        NS0Log(@"//////set image");
    }
    
    self.row = row;
    FRAME_SET_HEIGHT(self, viewHeight)
}


- (void)setPostDataInitThreadId:(NSInteger)threadId {
    
    NSString *title = [NSString stringWithFormat:@"No.%zi", threadId];
    [self.titleLabel setText:title];
    
    CGFloat viewHeight = Y_BLOW(self.titleLabel, 3);
    
    FRAME_SET_HEIGHT(self, viewHeight)
}


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
        
        self.row = -1;
        self.backgroundColor = [AppConfig backgroundColorFor:@"PostDataCellView"];
        
        if(!self.titleLabel) {
            self.titleLabel = [[RTLabel alloc] init];
            self.titleLabel.text = @"yyyy-mm-dd xyu-ACV-";
            self.titleLabel.font = [AppConfig fontFor:@"PostContent"];
            self.titleLabel.textColor = [AppConfig textColorFor:@"CellTitle"];
            self.titleLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
            [self addSubview:self.titleLabel];
        }
        
        if(!self.infoLabel) {
            self.infoLabel = [[RTLabel alloc] init];
            self.infoLabel.text = [NSString stringWithFormat:@"回应: %ld", -1L];
            
            self.infoLabel.font = [AppConfig fontFor:@"PostContent"];
            self.infoLabel.textColor = [AppConfig textColorFor:@"CellInfo"];
            [self.infoLabel setTextAlignment:RTTextAlignmentRight];
            
            [self addSubview:self.infoLabel];
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
    [self.titleLabel setText:title];
    
    NSString *info = [self.data objectForKey:@"info"];
    info = info?info:@"null";
    [self.infoLabel setText:info];
    
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
    CGRect frameContentLabel        = CGRectZero;
    CGRect frameImageViewContent    = CGRectZero;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:CGSizeMake(self.frame.size.width, 10000)];
    //设置外边框.
    [layout setUseEdge:@"LayoutAll" in:NAME_MAIN_FRAME withEdgeValue:edge];
    
    //Title line布局在最上. title与info的宽度按照比例分配.
    [layout setUseIncludedMode:@"TitleLine" includedTo:@"LayoutAll" withPostion:FrameLayoutPositionTop andSizeValue:20.0];
    [layout divideInVertical:@"TitleLine" to:@"Title" and:@"Info" withPercentage:0.66];
    frameTitleLabel     = [layout getCGRect:@"Title"];
    frameInfoLabel      = [layout getCGRect:@"Info"];
    
    //Title和正文间设置间距.
    [layout setUseBesideMode:@"PaddingTitleContent" besideTo:@"TitleLine" withDirection:FrameLayoutDirectionBelow andSizeValue:10.0];
    
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
    
    self.titleLabel.frame   = frameTitleLabel;
    self.infoLabel.frame    = frameInfoLabel;
    self.contentLabel.frame = frameContentLabel;
    self.imageView.frame    = frameImageViewContent;
    
    LOG_RECT(frameTitleLabel, @"frameTitleLabel")
    LOG_RECT(frameInfoLabel, @"frameInfoLabel")
    LOG_RECT(frameContentLabel, @"frameContentLabel")
    LOG_RECT(frameImageViewContent, @"frameImageViewContent")
    
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


- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"frame"];
    if(_frameObserver) {
        NSLog(@"-=-=-=%@ %zi revome observer %@ dealloc", self, self.row, _frameObserver);
        [self removeObserver:_frameObserver forKeyPath:@"frame"];
    }
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



