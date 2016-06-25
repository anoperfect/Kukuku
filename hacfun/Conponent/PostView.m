//
//  PostView.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "PostView.h"
#import "AppConfig.h"
#import "NSAttributedString+HTML.h"
@interface PostView () <RTLabelDelegate, TTTAttributedLabelDelegate> {
    
    
    
    
    
};


/*
 PostView 接收的字段字段
 @"title"           - 第一行左边的. 显示日期 uid.
 @"info"            - 第一行右边的. 显示tid, 或者replycount. 可重写.
 @"manageInfo"      - 第二行左边的. 显示sage.
 @"otherInfo"       - 第二行右边的. 显示一些其他信息. 暂时是显示更新回复信息. 用在CollectionViewController显示新回复状态.
 @"statusInfo"      - 第三行右边的. 显示一些状态信息.
 @"content"         - 正文.  根据需要已作内容调整.
 @"contentLineLimit"- 正文限制的行数.
 @"colorUid"        - 标记uid颜色. 接口返回的<font color>标签解析出的颜色.
 @"colorUidSign"    - 标记uid颜色. 暂时使用uid颜色标记特定thread. 比如Po, //self post , self reply, follow, other cookie.
 @"uidUnderLine"    - 标记uid下划线.
 @"thumb"           - 图片显示的地址.
 @"replies"         - 需显示的回应. 类型为NSArray, 数组成员为PostData.
 @"showAction"      - 是否显示postdata中的操作菜单.
 */
@property (strong,nonatomic) UILabel        *titleLabel;
@property (strong,nonatomic) UILabel        *infoLabel;
@property (nonatomic, strong) UILabel       *manageInfoLabel;
@property (nonatomic, strong) UILabel       *otherInfoLabel;
@property (nonatomic, strong) UILabel       *statusInfoLabel;
@property (nonatomic, strong) UILabel       *contentPrefixLabel;
@property (nonatomic, strong) UILabel       *contentSuffixLabel;

@property (nonatomic, strong) UIView        *contentLabel;

@property (nonatomic, strong) ViewContainer *repliesView;
@property (strong,nonatomic) PostImageView  *imageView;
@property (nonatomic, strong) UIToolbar     *actionButtons0;

@property (assign,nonatomic) NSInteger row;

@property (nonatomic, strong) PostData *data;
@property (nonatomic, assign) CGFloat borderTop;
@property (nonatomic, assign) CGFloat borderLeft;

@property (nonatomic, assign) BOOL fold; //是否折叠.



@end








static NSInteger kcountObject = 0;





@implementation PostView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        kcountObject ++;
        self.row = -1;
        self.backgroundColor = [UIColor colorWithName:@"PostViewBackground"];
        
        if(!self.titleLabel) {
            self.titleLabel = [[UILabel alloc] init];
            self.titleLabel.text = @"yyyy-mm-dd xyu-ACV-";
            self.titleLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.titleLabel.textColor = [UIColor colorWithName:@"PostViewLightText"];
            //            self.titleLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
            [self addSubview:self.titleLabel];
        }
        
        if(!self.infoLabel) {
            self.infoLabel = [[UILabel alloc] init];
            self.infoLabel.text = [NSString stringWithFormat:@"回应: %ld", -1L];
            
            self.infoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.infoLabel.textColor = [UIColor colorWithName:@"PostViewLightText"];
            [self.infoLabel setTextAlignment:NSTextAlignmentRight];
            
            [self addSubview:self.infoLabel];
        }
        
        if(!self.manageInfoLabel) {
            self.manageInfoLabel = [[UILabel alloc] init];
            self.manageInfoLabel.text = @"";
            self.manageInfoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.manageInfoLabel.textColor = [UIColor colorWithName:@"PostViewManageText"];
            self.manageInfoLabel.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:self.manageInfoLabel];
        }
        
        if(!self.otherInfoLabel) {
            self.otherInfoLabel = [[UILabel alloc] init];
            self.otherInfoLabel.text = @"";
            self.otherInfoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.otherInfoLabel.textColor = [UIColor colorWithName:@"PostViewLightText"];
            self.otherInfoLabel.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:self.otherInfoLabel];
        }
        
        if(!self.statusInfoLabel) {
            self.statusInfoLabel = [[UILabel alloc] init];
            self.statusInfoLabel.text = @"";
            self.statusInfoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.statusInfoLabel.textColor = [UIColor colorWithName:@"PostViewLightText"];
            self.statusInfoLabel.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:self.statusInfoLabel];
        }
        
        if(!self.contentPrefixLabel) {
            self.contentPrefixLabel = [[UILabel alloc] init];
            self.contentPrefixLabel.text = @"";
            self.contentPrefixLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.contentPrefixLabel.textColor = [UIColor colorWithName:@"PostViewLightText"];
            self.contentPrefixLabel.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:self.contentPrefixLabel];
        }
        
        if(!self.contentSuffixLabel) {
            self.contentSuffixLabel = [[UILabel alloc] init];
            self.contentSuffixLabel.text = @"";
            self.contentSuffixLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.contentSuffixLabel.textColor = [UIColor colorWithName:@"PostViewLightText"];
            self.contentSuffixLabel.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:self.contentSuffixLabel];
        }
        
        if(!self.contentLabel) {
            self.contentLabel = [self contentLabelBuild];
            [self addSubview:self.contentLabel];
        }
        
        if(!self.repliesView) {
            self.repliesView = [[ViewContainer alloc] init];
            [self addSubview:self.repliesView];
//            self.repliesView.userInteractionEnabled = NO;
        }
        
        if(!self.imageView) {
            self.imageView = [[PostImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [self addSubview:self.imageView];
            [self.imageView addTarget:self action:@selector(clickViewThumb:) forControlEvents:UIControlEventTouchDown];
        }
        
        if(!self.actionButtons0) {
            self.actionButtons0 = [[UIToolbar alloc] init];
            //[self.actionButtons addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.actionButtons0];
            self.actionButtons0.tintColor = [UIColor colorWithName:@"PostViewActionText"];
        }
    }
    
    return self;
}


- (void)setPostData:(PostData *)postData
{
    _data = postData;
    
    //设置各空间的现实内容.
    [self setContent];
    
    //调整layout.
    [self layoutContent];
}


- (void)clickViewThumb:(id)sender
{
    PostImageView *postImageView = (PostImageView*)sender;
    
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    NSString *imageHost = host.imageHost;
    NSString *downloadString = [NSString stringWithFormat:@"%@%@", imageHost, self.data.image];
    postImageView.linkImageString = downloadString;
    
    [self.delegate PostView:self didSelectThumb:[postImageView getDisplayingImage] withImageLink:downloadString];
}



#if 0
- (void)actionPressed:(UISegmentedControl*)sender {
    LOG_POSTION
    NSInteger index = sender.selectedSegmentIndex;
    
    NSArray *actionStrings = [self.data objectForKey:@"actionStrings"];
    NSLog(@"action on row %@ with action %@", self.data[@"row"], actionStrings[index]);
    
    NSIndexPath *indexPath = [self.data objectForKey:@"indexPath"];
    if(self.rowAction) {
        self.rowAction(indexPath, actionStrings[index]);
    }
    
    sender.selectedSegmentIndex = -1;
}
#endif


- (void)setContent
{
    NS0Log(@"PostView data : %@", [NSString stringFromNSDictionary:self.data.postViewData]);
    
    NSString *title = [self.data.postViewData objectForKey:@"title"];
    title = title?title:@"TITLE NAN";
    
    //一些加下划线和颜色相关的.
    if(title.length > 21) {
        NSRange uidRange = NSMakeRange(21, title.length-21);
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        UIColor *colorUid = [self.data.postViewData objectForKey:@"colorUid"];
        UIColor *colorUidSign = [self.data.postViewData objectForKey:@"colorUidSign"];
        if(colorUid) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorUid range:uidRange];
        }
        else if(colorUidSign) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorUidSign range:uidRange];
        }
        
        NSNumber *uidUnderLineNumber = [self.data.postViewData objectForKey:@"uidUnderLine"];
        if([uidUnderLineNumber isKindOfClass:[NSNumber class]] && [uidUnderLineNumber boolValue]) {
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:uidRange];
        }
        
        NSNumber *uidBoldNumber = [self.data.postViewData objectForKey:@"uidBold"];
        if([uidBoldNumber isKindOfClass:[NSNumber class]] && [uidBoldNumber boolValue]) {
            //            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:uidRange];
            
            
            UIFont *font = self.titleLabel.font;
            font = [UIFont boldSystemFontOfSize:font.pointSize];
            [attributedString addAttribute:NSFontAttributeName value:font range:uidRange];
        }
        
        self.titleLabel.attributedText = attributedString;
    }
    else {
        self.titleLabel.text = title;
    }
    
    NSString *info = [self.data.postViewData objectForKey:@"info"];
    info = info?info:@"";
    [self.infoLabel setText:info];
    
    //关于折叠.
    NSString *foldReason = [self.data.postViewData objectForKey:@"fold"];
    if(foldReason) {
        self.fold = YES;
        [self.infoLabel setText:foldReason];
        self.manageInfoLabel.hidden = YES;
        self.otherInfoLabel.hidden = YES;
        self.contentPrefixLabel.hidden = YES;
        self.contentSuffixLabel.hidden = YES;
        self.contentLabel.hidden = YES;
        self.imageView.hidden = YES;
    }
    else {
        self.fold = NO;
        NSString *manageInfoString = [self.data.postViewData objectForKey:@"manageInfo"];
        [self.manageInfoLabel setText:manageInfoString];
        self.manageInfoLabel.hidden = NO;
        
        NSString *otherInfoString = [self.data.postViewData objectForKey:@"otherInfo"];
        [self.otherInfoLabel setText:otherInfoString];
        self.otherInfoLabel.hidden = NO;
        
        NSString *statusInfoString = [self.data.postViewData objectForKey:@"statusInfo"];
        [self.statusInfoLabel setText:statusInfoString?statusInfoString:@""];
        self.statusInfoLabel.hidden = NO;
        
        [self.contentPrefixLabel setText:[self.data.postViewData objectForKey:@"contentPrefix"]];
        [self.contentSuffixLabel setText:[self.data.postViewData objectForKey:@"contentSuffix"]];
        
        //可能更换content控件.
        [self contentLabelSet];

        self.imageView.hidden = YES;
        NSString *thumb = [self.data.postViewData objectForKey:@"thumb"];
        if([thumb isKindOfClass:[NSString class]] && thumb.length > 0) {
            self.imageView.hidden = NO;
            self.imageView.downloadString = thumb;
        }
        else {
            self.imageView.downloadString = nil;
        }
        
        self.repliesView.hidden = YES;
        NSArray *postDataReplies = [self.data.postViewData objectForKey:@"replies"];
        //LOG_POSTION
        if(postDataReplies.count > 0) {
            self.repliesView.hidden = NO;
            LOG_POSTION
            self.repliesView.frame = CGRectMake(self.frame.size.width * 0.1, 0, self.frame.size.width * 0.9 - 10, 360);
            LOG_RECT(self.repliesView.frame, @"replies0")
#if 0
            self.repliesView.type = ThreadDataToViewTypeSimple;
            [self.repliesView appendDataOnPage:0 with:postDataReplies removeDuplicate:NO andReload:YES];
            NSLog(@"rtrtrt%f", [self.repliesView optumizeHeight]);
#endif
            NSMutableArray *postViews = [[NSMutableArray alloc] init];
            for(PostData *postDataReply in postDataReplies) {
                [postDataReply generatePostViewData:ThreadDataToViewTypeSimple];
                
                PostView *postView = [PostView PostViewWith:postDataReply andFrame:CGRectMake(0, 0, self.repliesView.frame.size.width - 16, 360)];
                postView.backgroundColor = [UIColor whiteColor];
                [postViews addObject:postView];
            }
            
            [self.repliesView verticalLayoutViews:postViews
                                         withEdge:UIEdgeInsetsMake(5, 5, 5, 5)
                                   andSubViewEdge:UIEdgeInsetsMake(5, 0, 5, 0)];
            LOG_RECT(self.repliesView.frame, @"replies1")
            
            [self.repliesView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                LOG_RECT(view.frame, @"postView1")
            }];
            
            self.repliesView.backgroundColor = [UIColor colorWithName:@"PostViewRepliesBackground"];
        }
    }
    
    self.actionButtons0.hidden = YES;
    NSNumber *showActions = [self.data.postViewData objectForKey:@"showAction"];
    if([showActions isKindOfClass:[NSNumber class]] && [showActions boolValue]) {
        NSLog(@"show actions.")
        NSArray *actionStrings = [self.data.postViewData objectForKey:@"actionStrings"];
        NSInteger count = actionStrings.count;
        if(count > 0) {
            self.actionButtons0.hidden = NO;
            NSIndexPath *indexPath = [self.data.postViewData objectForKey:@"indexPath"];
            if(!indexPath) {
                NSLog(@"#error - PostViewData indexPath nil.");
                indexPath = [NSIndexPath indexPathWithIndex:0];
            }
            
            NSMutableArray *items = [[NSMutableArray alloc] init];
            
            for(NSInteger index = 0; index < count; index ++) {
                
                if(index > 0) {
                    UIBarButtonItem *flexibleitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
                    [items addObject:flexibleitem];
                }
                
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:actionStrings[index]
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(cellAction:)];
                
                //item.image = [UIImage imageNamed:@"edit"];
                item.style = UIBarButtonItemStylePlain;
                
                [items addObject:item];
            }
            
            [self.actionButtons0 setItems:items animated:NO];
        }
        else {
            NSLog(@"#error - no actions string set.");
        }
        
    }
    else {
        //NSLog(@"NOT show actions");
    }
}





- (void)cellAction:(UIBarButtonItem*)sender
{
    NSLog(@"sender : %@ %@", sender, sender.title);
    if([self.delegate respondsToSelector:@selector(PostView:actionString:)]) {
        [self.delegate PostView:self actionString:sender.title];
    }
}


- (void)layoutContent
{
    NSLog(@"tid [%zd] PostView layoutContent . width = %f", self.data.tid, self.frame.size.width);
    
    //标记自适应高度.
    CGFloat heightAdjust = 0.0;
    
    CGRect frameTitleLabel          = CGRectZero;
    CGRect frameInfoLabel           = CGRectZero;
    CGRect frameManageInfo          = CGRectZero;
    CGRect frameOtherInfo           = CGRectZero;
    CGRect frameStatusInfo          = CGRectZero;
    CGRect frameContentPrefixLabel  = CGRectZero;
    CGRect frameContentSuffixLabel  = CGRectZero;
    CGRect frameContentLabel        = CGRectZero;
    CGRect frameRepliesView         = CGRectZero;
    CGRect frameImageViewContent    = CGRectZero;
    CGRect frameActionButtons       = CGRectZero;
    
    CGFloat heightPaddingLineTitle      = 0;
    CGFloat heightPaddingLineOther      = 0;
    CGFloat heightPaddingLineStatus     = 6;
    CGFloat heightPaddingLineContent    = 6;
    CGFloat heightPaddingLineImage      = 6;
    CGFloat heightPaddingLineReply      = 6;
    CGFloat heightPaddingLineAction     = 6;
    
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:CGSizeMake(self.frame.size.width, 10000)];
    //设置外边框.
    [layout setUseEdge:@"LayoutAll" in:FRAMELAYOUT_NAME_MAIN withEdgeValue:edge];
    [layout setUseIncludedMode:@"LineInit" includedTo:@"LayoutAll" withPostion:FrameLayoutPositionTop andSizeValue:0.0];
    
    if(self.titleLabel.text.length > 0 || self.infoLabel.text.length > 0) {
        [layout setUseBesideMode:@"PaddingLineTitle" besideTo:@"LineInit" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineTitle];
        //UIFont *font = [UIFont systemFontOfSize:12];
        UIFont *font = [UIFont fontWithName:@"PostTitle"];
        //    NSString *text = @"2016-02-03 12:34:56 ABCDEF00";
        NSString *text = @"2016-02-03 12:34:56 WWWWWWWW ";
        NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
        attrs[NSFontAttributeName]=font;
        CGSize maxSize=CGSizeMake(MAXFLOAT, MAXFLOAT);
        CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        NS0Log(@"@@@---%@", NSStringFromCGSize(textSize));
        //Title line布局在最上. title与info的宽度按照比例分配.
        NSString *textInfo = self.infoLabel.text;
        NSMutableDictionary *attrsInfo=[NSMutableDictionary dictionary];
        attrsInfo[NSFontAttributeName]=font;
        CGSize maxSizeInfo=CGSizeMake(MAXFLOAT, MAXFLOAT);
        CGSize textSizeInfo = [textInfo boundingRectWithSize:maxSizeInfo options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsInfo context:nil].size;
        NS0Log(@"@@@---%@", NSStringFromCGSize(textSizeInfo));
        
        CGRect frameTitleLine = [layout getCGRect:@"PaddingLineTitle"];
        if(textSize.width + textSizeInfo.width < frameTitleLine.size.width) {
            //Title line布局在最上. title与info的宽度按照先分配Title的方式分配.
            [layout setUseIncludedMode:@"LineTitle" includedTo:@"PaddingLineTitle" withPostion:FrameLayoutPositionTop andSizeValue:20.0];
            [layout divideInVertical:@"LineTitle" to:@"Title" and:@"Info" withPercentage:0.66];
            [layout divideInVertical:@"LineTitle" to:@"Title" and:@"Info" withWidthValue:textSize.width];
            [self.infoLabel setTextAlignment:NSTextAlignmentRight];
        }
        else {
            [layout setUseIncludedMode:@"LineTitle" includedTo:@"PaddingLineTitle" withPostion:FrameLayoutPositionTop andSizeValue:40.0];
            [layout divideInHerizon:@"LineTitle" to:@"Title" and:@"Info" withPercentage:0.5];
            [self.infoLabel setTextAlignment:NSTextAlignmentLeft];
        }
        
        frameTitleLabel     = [layout getCGRect:@"Title"];
        frameInfoLabel      = [layout getCGRect:@"Info"];
    }
    else {
        [layout setUseBesideMode:@"PaddingLineTitle" besideTo:@"LineTitle" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        [layout setUseIncludedMode:@"LineTitle" includedTo:@"LayoutAll" withPostion:FrameLayoutPositionTop andSizeValue:0.0];
    }
    
    if(self.fold) {
        heightPaddingLineTitle      = 0;
        heightPaddingLineOther      = 0;
        heightPaddingLineStatus     = 0;
        heightPaddingLineContent    = 0;
        heightPaddingLineImage      = 0;
        heightPaddingLineReply      = 0;
        heightPaddingLineAction     = 0;
        
        [layout setUseBesideMode:@"PaddingLineOther" besideTo:@"LineTitle" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineOther];
        [layout setUseBesideMode:@"LineOther" besideTo:@"PaddingLineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineStatus" besideTo:@"LineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineStatus];
        [layout setUseBesideMode:@"LineStatus" besideTo:@"PaddingLineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineContentPrefix" besideTo:@"LineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineContent];
        [layout setUseBesideMode:@"LineContentPrefix" besideTo:@"PaddingLineContentPrefix" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        
        [layout setUseBesideMode:@"PaddingLineContent" besideTo:@"LineContentPrefix" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineContent];
        [layout setUseBesideMode:@"LineContent" besideTo:@"PaddingLineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineContentSuffix" besideTo:@"PaddingLineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineContent];
        [layout setUseBesideMode:@"LineContentSuffix" besideTo:@"PaddingLineContentSuffix" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineImage" besideTo:@"LineContentSuffix" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineImage];
        [layout setUseBesideMode:@"LineImage" besideTo:@"PaddingLineImage" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineReply" besideTo:@"LineImage" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineReply];
        [layout setUseBesideMode:@"LineReply" besideTo:@"PaddingLineReply" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineAction" besideTo:@"LineReply" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineAction];
        [layout setUseBesideMode:@"LineAction" besideTo:@"PaddingLineAction" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
    }
    else {
        if([self.manageInfoLabel.text length] > 0 || [self.otherInfoLabel.text length] > 0) {
            [layout setUseBesideMode:@"PaddingLineOther" besideTo:@"LineTitle" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineOther];
            [layout setUseBesideMode:@"LineOther" besideTo:@"PaddingLineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:20.0];
            [layout divideInVertical:@"LineOther" to:@"manageInfo" and:@"otherInfo" withWidthValue:60.0];
            frameManageInfo = [layout getCGRect:@"manageInfo"];
            frameOtherInfo  = [layout getCGRect:@"otherInfo"];
        }
        else {
            [layout setUseBesideMode:@"PaddingLineOther" besideTo:@"LineTitle" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"LineOther" besideTo:@"PaddingLineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        }
        
        if(self.statusInfoLabel.text.length > 0) {
            [layout setUseBesideMode:@"PaddingLineStatus" besideTo:@"LineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"LineStatus" besideTo:@"PaddingLineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:10.0];
            frameStatusInfo = [layout getCGRect:@"LineStatus"];
        }
        else {
            [layout setUseBesideMode:@"PaddingLineStatus" besideTo:@"LineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"LineStatus" besideTo:@"PaddingLineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        }
        
        if(self.contentPrefixLabel.text.length > 0) {
            [layout setUseBesideMode:@"PaddingContentPrefixLabel" besideTo:@"LineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"ContentPrefixLabel" besideTo:@"PaddingContentPrefixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:10.0];
            frameContentPrefixLabel = [layout getCGRect:@"ContentPrefixLabel"];
            
            self.contentPrefixLabel.frame = frameContentPrefixLabel;
            CGSize size = [self.contentPrefixLabel sizeThatFits:self.contentPrefixLabel.frame.size];
            if(size.height <= 10.0) {
                
            }
            else {
                [layout setUseBesideMode:@"ContentPrefixLabel" besideTo:@"PaddingContentPrefixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:size.height];
                frameContentPrefixLabel = [layout getCGRect:@"ContentPrefixLabel"];
            }
            
            heightPaddingLineContent = 16;
        }
        else {
            [layout setUseBesideMode:@"PaddingContentPrefixLabel" besideTo:@"LineOther" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"ContentPrefixLabel" besideTo:@"PaddingContentPrefixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        }
        
        //正文和title之间有间隔.
        [layout setUseBesideMode:@"PaddingLineContent" besideTo:@"PaddingContentPrefixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineContent];
        //设置正文.
        [layout setUseBesideMode:@"LineContent" besideTo:@"PaddingLineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:20.0];
        //contentLabel需自调整高度.
        frameContentLabel = [layout getCGRect:@"LineContent"];
        self.contentLabel.frame = frameContentLabel;
        
        
        
        
        frameContentLabel.size.height = [self optumizeHeightOfContent];
        //重新设置
        [layout setCGRect:frameContentLabel toName:@"LineContent"];
        
        
        if(self.contentSuffixLabel.text.length > 0) {
            [layout setUseBesideMode:@"PaddingContentSuffixLabel" besideTo:@"LineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:6.0];
            [layout setUseBesideMode:@"ContentSuffixLabel" besideTo:@"PaddingContentSuffixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:10.0];
            frameContentSuffixLabel = [layout getCGRect:@"ContentSuffixLabel"];
            
            self.contentSuffixLabel.frame = frameContentSuffixLabel;
            CGSize size = [self.contentSuffixLabel sizeThatFits:self.contentSuffixLabel.frame.size];
            if(size.height <= 10.0) {
                
            }
            else {
                [layout setUseBesideMode:@"ContentSuffixLabel" besideTo:@"PaddingContentSuffixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:size.height];
                frameContentSuffixLabel = [layout getCGRect:@"ContentSuffixLabel"];
            }
        }
        else {
            [layout setUseBesideMode:@"PaddingContentSuffixLabel" besideTo:@"LineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"ContentSuffixLabel" besideTo:@"PaddingContentSuffixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        }
        
        //Image.
        if(self.imageView.hidden) {
            [layout setUseBesideMode:@"PaddingLineImage" besideTo:@"ContentSuffixLabel" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"LineImage" besideTo:@"PaddingLineImage" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        }
        else {
            CGFloat heightImage = 68.0;
            [layout setUseBesideMode:@"PaddingLineImage" besideTo:@"LineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineImage];
            [layout setUseBesideMode:@"LineImage" besideTo:@"PaddingLineImage" withDirection:FrameLayoutDirectionBelow andSizeValue:heightImage];
            [layout divideInVertical:@"LineImage" to:@"Image" and:@"ImageLeft" withWidthValue:100.0];
            frameImageViewContent = [layout getCGRect:@"Image"];
        }
        
        //Reply.
        if(self.repliesView.hidden) {
            [layout setUseBesideMode:@"PaddingLineReply" besideTo:@"LineImage" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
            [layout setUseBesideMode:@"LineReply" besideTo:@"PaddingLineReply" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        }
        else {
            frameRepliesView = self.repliesView.frame;
            [layout setUseBesideMode:@"PaddingLineReply" besideTo:@"LineImage" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineReply];
            [layout setUseBesideMode:@"LineReply" besideTo:@"PaddingLineReply" withDirection:FrameLayoutDirectionBelow andSizeValue:frameRepliesView.size.height];
            [layout divideInVertical:@"LineReply" to:@"RepliesViewLeft" and:@"RepliesView" withPercentage:0.1];
            frameRepliesView = [layout getCGRect:@"RepliesView"];
        }
    }
    
    if(self.actionButtons0.hidden) {
        [layout setUseBesideMode:@"PaddingLineAction" besideTo:@"LineReply" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        [layout setUseBesideMode:@"LineAction" besideTo:@"PaddingLineAction" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
    }
    else {
        CGFloat heightActionButtons = 36.0;
        
        [layout setUseBesideMode:@"PaddingLineAction" besideTo:@"LineReply" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineAction];
        [layout setUseBesideMode:@"LineAction" besideTo:@"PaddingLineAction" withDirection:FrameLayoutDirectionBelow andSizeValue:heightActionButtons];
        [layout setUseEdge:@"ActionButtons" in:@"LineAction" withEdgeValue:UIEdgeInsetsMake(0, 0, 0, 0)];
        frameActionButtons = [layout getCGRect:@"ActionButtons"];
    }
    
    self.titleLabel.frame           = frameTitleLabel;
    self.infoLabel.frame            = frameInfoLabel;
    self.manageInfoLabel.frame      = frameManageInfo;
    self.otherInfoLabel.frame       = frameOtherInfo;
    self.statusInfoLabel.frame      = frameStatusInfo;
    self.contentPrefixLabel.frame   = frameContentPrefixLabel;
    self.contentSuffixLabel.frame   = frameContentSuffixLabel;
    self.contentLabel.frame         = frameContentLabel;
    self.imageView.frame            = frameImageViewContent;
    self.repliesView.frame          = frameRepliesView;
    self.actionButtons0.frame       = frameActionButtons;
    
    //LOG_RECT(self.repliesView.frame, @"replies1")
//    for(UIView *postView in self.repliesView.subviews) {
//        LOG_RECT(postView.frame, @"postView1")
//    }
    
    NS0Log(@"rty : %@", layout);
    
    heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME([layout getCGRect:@"LineAction"]) + edge.bottom;
    //heightAdjust = 500;
    
    FRAMELAYOUT_SET_HEIGHT(self, heightAdjust);
    NSLog(@"tid [%zd] adjust height to %f.", self.data.tid, heightAdjust);
    //LOG_RECT(self.frame, @"p1")
}





+ (PostView*)PostViewWith:(PostData*)postData andFrame:(CGRect)frame
{
    PostView *postView = [[PostView alloc] initWithFrame:frame];
    postView.data = postData;
    
    //设置各空间的现实内容.
    [postView setContent];
    
    //调整layout.
    [postView layoutContent];
    
    return postView;
}



+ (PostView*)PostDatalViewWithTid:(NSInteger)tid
                         andFrame:(CGRect)frame
                          useType:(ThreadDataToViewType)type
                 completionHandle:(void (^)(PostView* postView, NSError* connectionError))handle
{
    PostData *postData = [PostData fromOnlyTid:tid];
    [postData generatePostViewData:ThreadDataToViewTypeInfoUseNumber];
    [postData.postViewData setObject:@"加载中..." forKey:@"content"];
    
    NS0Log(@"%@", postData.postViewData);
    PostView *postView = [self PostViewWith:postData andFrame:frame];

    NSLog(@"update %zd", tid);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(void){
        //获取last page的信息.
        NSMutableArray *replies = [[NSMutableArray alloc] init];
        PostData *topic = [PostData sendSynchronousRequestByTid:tid atPage:1 repliesTo:replies storeAdditional:nil];
        if(topic) {
            [postView.data copyFrom:topic];
            [postView.data generatePostViewData:type];
        }
        else {
            [postView.data.postViewData setObject:@"加载失败" forKey:@"content"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [postView setContent];
            [postView layoutContent];
            handle(postView, nil);
        });
    });

    return postView;
}


- (NSString*)desc
{
    
    NSMutableString *s = [NSMutableString stringWithFormat:@"--------------------------------------------\n%@\n", self];
    for(UIView *view in self.subviews) {
        [s appendFormat:@"    %@\n", view];
    }
    [s appendFormat:@"--------------------------------------------\n"];
    
     return s;
}


+ (NSInteger)countObject
{
    return kcountObject;
}


- (void)dealloc {
    NSLog(@"dealloc %@", self);
    
    kcountObject --;
}



//字符转换.
+ (NSString*) contentLabelContentRetreat:(NSString*)content
{
    //一些www的关键字符信息需转义.
    content = [NSString decodeWWWEscape:content];
    
    //新版本使用NCR显示部分字符. 修改.
    content = [content NCRDecode];
    
    //font属性由RTLabel显示大小不合适. 手动修改成这样.
    content = [content stringByReplacingOccurrencesOfString:@"font size=\"5\"" withString:@"font size=\"16\""];
    
    //对No.xxx加载超链接.
    content = [self addLinkForReferenceNumber:content];
    
    //对[ref tid="123456"/]进行处理.
    content = [self addLinkForRefTag:content];
    
    //对http地址加载超链接. 对link的标签处置的有问题, 另外那个正则表达式有bug.
    //content = [self addLinkForWebAddr:content];
    
    return content;
}


#if CONTENT_USE_RTLabel


+ (id)postDataContentTreat:(PostData*)postData
{
    NSString *content = [PostView addLinkForRefTag:postData.content];
    content = [PostView contentLabelContentRetreatRTLabel:content];
    return content;
}


+ (void)postDataContentAsyncTreat:(PostData*)postData
{
    return ;
    
    //    dispatch_async([[AppConfig sharedConfigDB] postDataRetreatQueue], ^{
    //        self.contentAsysncTreat = [self postDataContentTreat];
    //    });
}


//字符转换.
+ (NSString*) contentLabelContentRetreatRTLabel:(NSString*)content
{
    //一些www的关键字符信息需转义.
    content = [NSString decodeWWWEscape:content];
    
    //新版本使用NCR显示部分字符. 修改.
    content = [content NCRDecode];
    
    //font属性由RTLabel显示大小不合适. 手动修改成这样.
    content = [content stringByReplacingOccurrencesOfString:@"font size=\"5\"" withString:@"font size=\"16\""];
    
    //对No.xxx加载超链接.
    content = [self addLinkForReferenceNumber:content];
    
    //对[ref tid="123456"/]进行处理.
    //content = [self addLinkForRefTag:content];
    
    //对http地址加载超链接. 对link的标签处置的有问题, 另外那个正则表达式有bug.
    //content = [self addLinkForWebAddr:content];
    
    return content;
}



- (UIView*)contentLabelBuild
{
    RTLabel *label = [[RTLabel alloc] init];
    label.text = @"content\n内容\n示范";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont fontWithName:@"PostContent"];
    label.textColor = [UIColor colorWithName:@"PostViewText"];
    label.textColor = [UIColor blackColor];
    label.delegate = self;
    
    return label;
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSLog(@"url = %@", url);
    [self.delegate PostView:self didSelectLinkWithURL:url];
}


- (void)contentLabelSet
{
//    NSString *content = [self.data.postViewData objectForKey:@"content"];
//    content = [PostView contentLabelContentRetreat:content];
    
    RTLabel *label = (RTLabel*)(self.contentLabel);
    
    if(self.data.contentAsysncTreat) {
        [label setText:self.data.contentAsysncTreat];
    }
    else {
        NSString *s = [PostView postDataContentTreat:self.data];
        NSLog(@"s = %@, <%@>", s, self.data.content);
        if([s isKindOfClass:[NSString class]]) {
            [label setText:s];
        }
        else {
            [label setText:@"NAN"];
        }
    }
    
    self.contentLabel.hidden = NO;
}


- (CGFloat)optumizeHeightOfContent
{
    RTLabel *label = (RTLabel*)(self.contentLabel);
    
    CGSize size = [label optimumSize];
    return size.height;
}




#endif



#if CONTENT_USE_TTTAttributedLabel

#define LINE_SPACING    9.0


+ (id)postDataContentTreat:(PostData*)postData
{
    NSString *content = [self addLinkForRefTag:postData.content];
    NS0Log(@"----------content : \n%@", content);
    //系统解析方法占用／等待main thread的资源. 主副线程同时执行到此api会产生阻塞.
    //    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    
    //使用DTCoreText的解析方法.
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:[content dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}


+ (void)postDataContentAsyncTreat:(PostData*)postData
{
    dispatch_async([[AppConfig sharedConfigDB] postDataRetreatQueue], ^{
        postData.contentAsysncTreat = [self postDataContentTreat:postData];
    });
}


- (UIView*)contentLabelBuild
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = @"content\n内容\n示范";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont fontWithName:@"PostContent"];
    label.textColor = [UIColor colorWithName:@"PostViewText"];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineSpacing = LINE_SPACING;
    label.delegate = self;
    
    return label;
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"URL%@", url);
}


- (void)setAttributedStringTo:(NSAttributedString*)attributedString
{
    TTTAttributedLabel *label = (TTTAttributedLabel*)(self.contentLabel);

    NSMutableAttributedString *attributedStringModify = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [attributedStringModify addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PostContent"] range:NSMakeRange(0, attributedStringModify.length)];
    [attributedStringModify addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithName:@"PostViewText"] range:NSMakeRange(0, attributedStringModify.length)];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINE_SPACING];
//    [paragraphStyle setParagraphSpacing:-3];
//    [paragraphStyle setLineHeightMultiple:1];
    [attributedStringModify addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStringModify.length)];

    label.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(__bridge NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor redColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    label.activeLinkAttributes = mutableActiveLinkAttributes;
    
    label.attributedText = attributedStringModify;
    

}


- (void)contentLabelSet
{
    TTTAttributedLabel *label = (TTTAttributedLabel*)(self.contentLabel);
    self.contentLabel.hidden = NO;
    
    if(self.data.contentAsysncTreat) {
        if([self.data.contentAsysncTreat isKindOfClass:[NSAttributedString class]]) {

            [self setAttributedStringTo:self.data.contentAsysncTreat];
        }
        else if([self.data.contentAsysncTreat isKindOfClass:[NSString class]]) {
            label.text = self.data.contentAsysncTreat;
        }
        else {
            label.text = @"NAN";
        }
    }
    else {
        NSLog(@"main thread treat content data.");
        NSAttributedString *attrString = [PostView postDataContentTreat:self.data];
        NSLog(@"main thread treat content data. %@", attrString);
        
        if([attrString isKindOfClass:[NSAttributedString class]]) {
            [self setAttributedStringTo:attrString];
        }
        else if([attrString isKindOfClass:[NSString class]]) {
            label.text = attrString;
        }
        else {
            [label setText:@"NAN"];
        }
    }
    
    NSLog(@"ert : %@", label.attributedText);
}


- (CGFloat)optumizeHeightOfContent
{
    TTTAttributedLabel *label = (TTTAttributedLabel*)(self.contentLabel);
    
    CGSize size = [label sizeThatFits:label.frame.size];
    return size.height;
}

#endif


+ (NSString*)addLinkForReferenceNumber:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@">>No.[0-9]+"];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        rangeResult = [searchText rangeOfString:@">>No.[0-9]+" options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
        [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NS0Log(@"%zi %zi",
               [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
               [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *sub = [searchText substringWithRange:NSMakeRange(range.location+2, range.length-2)];
        NSString *replacement = [NSString stringWithFormat:@"<a href='%@'>>>%@</a>", sub, sub];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return searchText;
}


+ (NSString*)addLinkForRefTag:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@"[ref tid="];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        rangeResult = [searchText rangeOfString:@"\\[ref tid=\"[0-9]+\"/\\]" options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
        [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NSLog(@"%zi %zi",
              [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
              [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *keyString = @"[ref tid=\"";
        NSString *tidString = [searchText substringWithRange:NSMakeRange(range.location+keyString.length, range.length-keyString.length)];
        NSInteger tid = [tidString integerValue];
        
        NSString *replacement = [NSString stringWithFormat:@"<a href='No.%zd'>>>No.%zd</a>", tid, tid];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return searchText;
}


+ (NSString*)addLinkForWebAddr:(NSString*)stringFrom {
    
    NSString *searchText = stringFrom;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    NSMutableArray *aryLocation = [[NSMutableArray alloc] init];
    NSMutableArray *aryLength = [[NSMutableArray alloc] init];
    
    while(1) {
        rangeResult = [searchText rangeOfString:@"http"];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        NSString * regexString = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        //        NSString *urlReg = @"^(https?://)?(([0-9a-z_!~*'().&=+$%-]+:)?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}\\.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+\\.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
        
        rangeResult = [searchText rangeOfString:regexString options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        //已经添加链接的不添加.
        NSLog(@"zxc %zd %zd", rangeResult.location, rangeResult.length);
        NSString *subString = [searchText substringFromIndex:(rangeResult.location+rangeResult.length)];
        if([subString hasPrefix:@"</a>"] || [subString hasPrefix:@"\""]) {
            NSLog(@"ignore link");
        }
        else {
            [aryLocation addObject:[NSNumber numberWithInteger:rangeResult.location]];
            [aryLength addObject:[NSNumber numberWithInteger:rangeResult.length]];
        }
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }
    
    NSInteger num = [aryLocation count];
    for(NSInteger i = num-1; i>=0 ; i--) {
        
        NS0Log(@"%zi %zi",
               [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
               [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSRange range = NSMakeRange(
                                    [((NSNumber*)[aryLocation objectAtIndex:i]) integerValue],
                                    [((NSNumber*)[aryLength objectAtIndex:i]) integerValue]);
        
        NSString *sub = [searchText substringWithRange:NSMakeRange(range.location, range.length)];
        
        NSString *replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>", sub, sub];
        searchText = [searchText stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return searchText;
}



@end
