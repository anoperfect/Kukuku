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
    
};


/*
 PostDataView 接收的字段字段
 @"title"           - 第一行左边的. 显示日期 uid.
 @"info"            - 第一行右边的. 显示tid, 或者replycount. 可重写.
 @"manageInfo"      - 第二行左边的. 显示sage.
 @"otherInfo"       - 第二行右边的. 显示一些其他信息. 暂时是显示更新回复信息. 用在CollectionViewController显示新回复状态.
 @"content"         - 正文.  根据需要已作内容调整.
 @"colorUid"        - 标记uid颜色. 暂时使用uid颜色标记特定thread. 比如Po, //self post , self reply, follow, other cookie.
 @"postdata"        -   copy的PostData.
                        id, thumb replycount直接从raw postdata中读取.
 @"showAction"      - 是否显示postdata中的操作菜单.
 */
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *manageInfoLabel;
@property (nonatomic, strong) UILabel *otherInfoLabel;
@property (nonatomic, strong) RTLabel *contentLabel;
@property (strong,nonatomic) PostImageView *imageView;
@property (nonatomic, strong) UISegmentedControl *actionButtons;

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
        
        if(!self.manageInfoLabel) {
            self.manageInfoLabel = [[UILabel alloc] init];
            self.manageInfoLabel.text = @"";
            self.manageInfoLabel.font = [AppConfig fontFor:@"PostTitle"];
            self.manageInfoLabel.textColor = [AppConfig textColorFor:@"manageInfo"];
            self.manageInfoLabel.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:self.manageInfoLabel];
        }
        
        if(!self.otherInfoLabel) {
            self.otherInfoLabel = [[UILabel alloc] init];
            self.otherInfoLabel.text = @"";
            self.otherInfoLabel.font = [AppConfig fontFor:@"PostTitle"];
            self.otherInfoLabel.textColor = [AppConfig textColorFor:@"otherInfo"];
            self.otherInfoLabel.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:self.otherInfoLabel];
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
        
        if(!self.actionButtons) {
            self.actionButtons = [[UISegmentedControl alloc] init];
            [self.actionButtons addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.actionButtons];
        }
    }
    
    return self;
}


- (void)actionPressed:(UISegmentedControl*)sender {
    LOG_POSTION
    NSInteger index = sender.selectedSegmentIndex;
    
    NSArray *actionStrings = [self.data objectForKey:@"actionStrings"];
    NSLog(@"action on row %@ with action %@", self.data[@"row"], actionStrings[index]);
    
    if(self.rowAction) {
        self.rowAction([(NSNumber*)(self.data[@"row"]) integerValue], actionStrings[index]);
    }
    
    sender.selectedSegmentIndex = -1;
}


- (void)setContent
{
    NSLog(@"PostDataView data : %@", self.data);
    
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
    
    NSString *manageInfoString = [self.data objectForKey:@"manageInfo"];
    [self.manageInfoLabel setText:manageInfoString];
    
    NSString *otherInfoString = [self.data objectForKey:@"otherInfo"];
    [self.otherInfoLabel setText:otherInfoString];
    
    NSString *content = [self.data objectForKey:@"content"];
    content = content?content:@"null\n111";
    [self.contentLabel setText:content];
    
    PostData *postData = [self.data objectForKey:@"postdata"];
    
    //UIViewImage
    NSString *thumb = postData.thumb;
    
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
    
    self.actionButtons.hidden = YES;
    NSNumber *showActions = [self.data objectForKey:@"showAction"];
    if([showActions boolValue]) {
        NSArray *actionStrings = [self.data objectForKey:@"actionStrings"];
        NSInteger count = actionStrings.count;
        if(count > 0) {
            self.actionButtons.hidden = NO;
            
            [self.actionButtons removeAllSegments];
            for(NSInteger index = 0; index < count; index ++) {
                [self.actionButtons insertSegmentWithTitle:actionStrings[index] atIndex:index animated:YES];
            }
        }
    }
}


- (void)layoutContent
{
    CGRect frameTitleLabel          = CGRectZero;
    CGRect frameInfoLabel           = CGRectZero;
    CGRect frameManageInfo          = CGRectZero;
    CGRect frameOtherInfo           = CGRectZero;
    CGRect frameContentLabel        = CGRectZero;
    CGRect frameImageViewContent    = CGRectZero;
    CGRect frameActionButtons       = CGRectZero;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:CGSizeMake(self.frame.size.width, 10000)];
    //设置外边框.
    [layout setUseEdge:@"LayoutAll" in:FRAMELAYOUT_NAME_MAIN withEdgeValue:edge];
    
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
    if([self.manageInfoLabel.text length] > 0 || [self.otherInfoLabel.text length] > 0) {
        [layout setUseBesideMode:@"InfoAdditional" besideTo:@"TitleLine" withDirection:FrameLayoutDirectionBelow andSizeValue:20.0];
        [layout divideInVertical:@"InfoAdditional" to:@"manageInfo" and:@"otherInfo" withWidthValue:60.0];
        frameManageInfo = [layout getCGRect:@"manageInfo"];
        frameOtherInfo  = [layout getCGRect:@"otherInfo"];
        
        heightPaddingTitleContent = 0.0;
    }
    else {
        [layout setUseBesideMode:@"InfoAdditional" besideTo:@"TitleLine" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
    }
    
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
        [layout setUseBesideMode:@"ImageLine" besideTo:@"PaddingContentImage" withDirection:FrameLayoutDirectionBelow andSizeValue:1.0];
    }
    else {
        CGFloat heightImage = 68.0;
        [layout setUseBesideMode:@"ImageLine" besideTo:@"PaddingContentImage" withDirection:FrameLayoutDirectionBelow andSizeValue:heightImage];
        [layout divideInVertical:@"ImageLine" to:@"Image" and:@"ImageLeft" withWidthValue:100.0];
        frameImageViewContent = [layout getCGRect:@"Image"];
        
        heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME(frameImageViewContent) + edge.bottom;
    }
    
    [layout setUseBesideMode:@"PaddingImageActionButtons" besideTo:@"ImageLine" withDirection:FrameLayoutDirectionBelow andSizeValue:6.0];
    
    if(!self.actionButtons.hidden) {
        CGFloat heightActionButtons = 36.0;
        [layout setUseBesideMode:@"ActionButtons" besideTo:@"PaddingImageActionButtons" withDirection:FrameLayoutDirectionBelow andSizeValue:heightActionButtons];
        frameActionButtons = [layout getCGRect:@"ActionButtons"];
        
        heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME(frameActionButtons) + edge.bottom;
    }
    
    self.titleLabel.frame           = frameTitleLabel;
    self.infoLabel.frame            = frameInfoLabel;
    self.manageInfoLabel.frame      = frameManageInfo;
    self.otherInfoLabel.frame       = frameOtherInfo;
    self.contentLabel.frame         = frameContentLabel;
    self.imageView.frame            = frameImageViewContent;
    self.actionButtons.frame        = frameActionButtons;
    
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


+ (PostDataCellView*)PostDatalViewWithTid:(NSInteger)tid
                             andInitFrame:(CGRect)frame
                         completionHandle:(void (^)(PostDataCellView* postDataView, NSError* connectionError))handle
{
    NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
    [dictm setObject:[NSString stringWithFormat:@"NO.%zd", tid] forKey:@"title"];
    [dictm setObject:@""                                        forKey:@"info"];
    [dictm setObject:@""                                        forKey:@"manageInfo"];
    [dictm setObject:@""                                        forKey:@"otherInfo"];
    [dictm setObject:@"加载中..."                                forKey:@"content"];
    
    PostDataCellView *postDataView = [self threadCellViewWithData:dictm andInitFrame:frame];
    
    NSLog(@"update %zd", tid);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        //获取last page的信息.
        PostData *topic = [[PostData alloc] init];
        [PostData sendSynchronousRequestByThreadId:tid andPage:1 andValueTopicTo:topic];
        if(topic.id == tid) {
            postDataView.data = [NSDictionary dictionaryWithDictionary:[topic toViewDisplayData:ThreadDataToViewTypeInfoUseNumber]];
        }
        else {
            NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
            [dictm setObject:[NSString stringWithFormat:@"NO.%zd", tid] forKey:@"title"];
            [dictm setObject:@""                                        forKey:@"info"];
            [dictm setObject:@""                                        forKey:@"manageInfo"];
            [dictm setObject:@""                                        forKey:@"otherInfo"];
            [dictm setObject:@"获取数据失败."                             forKey:@"content"];
            postDataView.data = [NSDictionary dictionaryWithDictionary:dictm];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [postDataView setContent];
            [postDataView layoutContent];
            handle(postDataView, nil);
        });
    });
    
    return postDataView;
}


+ (NSInteger)countObject
{
    return kcountObject;
}


- (void)dealloc {
    NSLog(@"dealloc %@", self);
    
    kcountObject --;
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



