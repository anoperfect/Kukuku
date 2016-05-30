//
//  PostView.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "PostView.h"
#import "AppConfig.h"
@interface PostView () <RTLabelDelegate> {
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
@property (nonatomic, strong) RTLabel       *contentLabel;
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

- (instancetype)initWithFrame1:(CGRect)frame
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
            self.titleLabel.textColor = [UIColor colorWithName:@"CellTitleText"];
            //            self.titleLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
            [self addSubview:self.titleLabel];
        }
        
        if(!self.infoLabel) {
            self.infoLabel = [[UILabel alloc] init];
            self.infoLabel.text = [NSString stringWithFormat:@"回应: %ld", -1L];
            
            self.infoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.infoLabel.textColor = [UIColor colorWithName:@"CellInfoText"];
            [self.infoLabel setTextAlignment:NSTextAlignmentRight];
            
            [self addSubview:self.infoLabel];
        }
        
        if(!self.manageInfoLabel) {
            self.manageInfoLabel = [[UILabel alloc] init];
            self.manageInfoLabel.text = @"";
            self.manageInfoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.manageInfoLabel.textColor = [UIColor colorWithName:@"manageInfoText"];
            self.manageInfoLabel.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:self.manageInfoLabel];
        }
        
        if(!self.otherInfoLabel) {
            self.otherInfoLabel = [[UILabel alloc] init];
            self.otherInfoLabel.text = @"";
            self.otherInfoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.otherInfoLabel.textColor = [UIColor colorWithName:@"otherInfoText"];
            self.otherInfoLabel.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:self.otherInfoLabel];
        }
        
        if(!self.statusInfoLabel) {
            self.statusInfoLabel = [[UILabel alloc] init];
            self.statusInfoLabel.text = @"";
            self.statusInfoLabel.font = [UIFont fontWithName:@"PostTitle"];
            self.statusInfoLabel.textColor = [UIColor colorWithName:@"otherInfoText"];
            self.statusInfoLabel.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:self.statusInfoLabel];
        }
        
        if(!self.contentLabel) {
            self.contentLabel = [[RTLabel alloc] init];
            [self addSubview:self.contentLabel];
            
            self.contentLabel.text = @"content\n内容\n示范";
            
            self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.contentLabel.font = [UIFont fontWithName:@"PostContent"];
            self.contentLabel.textColor = [UIColor colorWithName:@"ThreadContentText"];
            self.contentLabel.textColor = [UIColor blackColor];
            
            self.contentLabel.delegate = self;
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
            self.actionButtons0.tintColor = [UIColor colorWithName:@"CellActionButtonsText"];
        }
    }
    
    return self;
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
    NS0Log(@"PostView data : %@", [NSString stringFromNSDictionary:self.data]);
    
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
        
        NSString *content = [self.data.postViewData objectForKey:@"content"];
        content = content?content:@"无正文...";
        [self.contentLabel setText:content];
        self.contentLabel.hidden = NO;
        
        self.imageView.hidden = YES;
        NSString *thumb = [self.data.postViewData objectForKey:@"thumb"];
        if([thumb isKindOfClass:[NSString class]] && thumb.length > 0) {
            self.imageView.hidden = NO;
            [self.imageView setDownloadUrlString:thumb];
        }
        
        self.repliesView.hidden = YES;
        NSArray *postDataReplies = [self.data.postViewData objectForKey:@"replies"];
        LOG_POSTION
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
            for(UIView *postView in self.repliesView.subviews) {
                LOG_RECT(postView.frame, @"postView1")
            }
            
            self.repliesView.backgroundColor = [UIColor colorWithName:@"repliesInPostView"];
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
                item.style = UIBarButtonItemStyleBordered;
                
                [items addObject:item];
            }
            
            [self.actionButtons0 setItems:items animated:NO];
        }
        else {
            NSLog(@"#error - no actions string set.");
        }
        
    }
    else {
        NSLog(@"NOT show actions");
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
    NSLog(@"PostView layoutContent . width = %f", self.frame.size.width);
    
    //标记自适应高度.
    CGFloat heightAdjust = 0.0;
    
    CGRect frameTitleLabel          = CGRectZero;
    CGRect frameInfoLabel           = CGRectZero;
    CGRect frameManageInfo          = CGRectZero;
    CGRect frameOtherInfo           = CGRectZero;
    CGRect frameStatusInfo          = CGRectZero;
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
        
        [layout setUseBesideMode:@"PaddingLineContent" besideTo:@"LineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineContent];
        [layout setUseBesideMode:@"LineContent" besideTo:@"PaddingLineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
        
        [layout setUseBesideMode:@"PaddingLineImage" besideTo:@"LineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineImage];
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
        //正文和title之间有间隔.
        [layout setUseBesideMode:@"PaddingLineContent" besideTo:@"LineStatus" withDirection:FrameLayoutDirectionBelow andSizeValue:heightPaddingLineContent];
        //设置正文.
        [layout setUseBesideMode:@"LineContent" besideTo:@"PaddingLineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:20.0];
        //contentLabel需自调整高度.
        frameContentLabel = [layout getCGRect:@"LineContent"];
        self.contentLabel.frame = frameContentLabel;
        CGSize size = [self.contentLabel optimumSize];
        frameContentLabel.size.height = size.height;
        //重新设置
        [layout setCGRect:frameContentLabel toName:@"LineContent"];
        
        //Image.
        if(self.imageView.hidden) {
            [layout setUseBesideMode:@"PaddingLineImage" besideTo:@"LineContent" withDirection:FrameLayoutDirectionBelow andSizeValue:0.0];
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
    self.contentLabel.frame         = frameContentLabel;
    self.imageView.frame            = frameImageViewContent;
    self.repliesView.frame          = frameRepliesView;
    self.actionButtons0.frame       = frameActionButtons;
    
    LOG_RECT(self.repliesView.frame, @"replies1")
    for(UIView *postView in self.repliesView.subviews) {
        LOG_RECT(postView.frame, @"postView1")
    }
    
    NS0Log(@"rty : %@", layout);
    
    heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME([layout getCGRect:@"LineAction"]) + edge.bottom;
    //heightAdjust = 500;
    
    FRAMELAYOUT_SET_HEIGHT(self, heightAdjust);
    NSLog(@"adjust height to %f.", heightAdjust);
}


+ (PostView*)PostViewWith:(PostData*)postData andFrame:(CGRect)frame
{
    PostView *postView = [[PostView alloc] initWithFrame1:frame];
    postView.data = postData;
    
    //设置各空间的现实内容.
    [postView setContent];
    
    //调整layout.
    [postView layoutContent];
    
    return postView;
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    NSLog(@"url = %@", url);
    [self.delegate PostView:self didSelectLinkWithURL:url];
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


+ (NSInteger)countObject
{
    return kcountObject;
}


- (void)dealloc {
    NSLog(@"dealloc %@", self);
    
    kcountObject --;
}

@end
