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
 @"statusInfo"      - 第三行右边的. 显示一些状态信息.
 @"content"         - 正文.  根据需要已作内容调整.
 @"colorUid"        － 标记uid颜色. 接口返回的<font color>标签解析出的颜色.
 @"colorUidSign"    － 标记uid颜色. 暂时使用uid颜色标记特定thread. 比如Po, //self post , self reply, follow, other cookie.
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
@property (nonatomic, strong) UISegmentedControl *actionButtons1;
@property (nonatomic, strong) UIToolbar *actionButtons0;

@property (assign,nonatomic) NSInteger row;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, assign) CGFloat borderTop;
@property (nonatomic, assign) CGFloat borderLeft;

@property (nonatomic, assign) BOOL fold; //是否折叠.

@end








static NSInteger kcountObject = 0;




@implementation PostDataCellView
- (id) getThumbImage {
    return self.imageView;
}


- (id)getContentLabel {
    return self.contentLabel;
}


- (instancetype)initWithFrame1:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        kcountObject ++;
        self.row = -1;
        self.backgroundColor = [UIColor colorWithName:@"PostDataCellViewBackground"];
        
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
        
        if(!self.contentLabel) {
            self.contentLabel = [[RTLabel alloc] init];
            [self addSubview:self.contentLabel];
            
            self.contentLabel.text = @"content\n内容\n示范";
            
            self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.contentLabel.font = [UIFont fontWithName:@"PostContent"];
            self.contentLabel.textColor = [UIColor colorWithName:@"ThreadContentText"];
            self.contentLabel.textColor = [UIColor blackColor];
        }
        
        if(!self.imageView) {
            self.imageView = [[PostImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [self addSubview:self.imageView];
        }
        
#if 0
        if(!self.actionButtons) {
            self.actionButtons = [[UISegmentedControl alloc] init];
            [self.actionButtons addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.actionButtons];
        }
#else
        if(!self.actionButtons1) {
            self.actionButtons0 = [[UIToolbar alloc] init];
            //[self.actionButtons addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.actionButtons0];
        }
        
#endif
        
        
        
        
    }
    
    return self;
}


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


- (void)setContent
{
    NS0Log(@"PostDataView data : %@", [NSString stringFromNSDictionary:self.data]);
    
    NSString *title = [self.data objectForKey:@"title"];
    title = title?title:@"null";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    UIColor *colorUid = [self.data objectForKey:@"colorUid"];
    UIColor *colorUidSign = [self.data objectForKey:@"colorUidSign"];
    if(colorUid) {
        if(title.length > 21) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorUid range:NSMakeRange(21, title.length-21)];
            NSLog(@"colorUid %@ to [%@]", colorUid, [title substringWithRange:NSMakeRange(21, title.length-21)]);
        }
    }
    else if(colorUidSign) {
        if(title.length > 21) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorUidSign range:NSMakeRange(21, title.length-21)];
        }
    }
    
    //    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, [textTitle length])];
    //[str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    //    self.titleView.font = [UIFont systemFontOfSize:10.0];
    self.titleLabel.attributedText = attributedString;
//    [self.titleLabel setText:title];
    
    NSString *info = [self.data objectForKey:@"info"];
    info = info?info:@"null";
    [self.infoLabel setText:info];
    
    //关于折叠.
    NSString *foldReason = [self.data objectForKey:@"fold"];
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
        NSString *manageInfoString = [self.data objectForKey:@"manageInfo"];
        [self.manageInfoLabel setText:manageInfoString];
        self.manageInfoLabel.hidden = NO;
        
        NSString *otherInfoString = [self.data objectForKey:@"otherInfo"];
        [self.otherInfoLabel setText:otherInfoString];
        self.otherInfoLabel.hidden = NO;
        
        NSString *content = [self.data objectForKey:@"content"];
        content = content?content:@"null\n111";
        [self.contentLabel setText:content];
        self.contentLabel.hidden = NO;
        
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
            Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
            NSString *imageHost = host.imageHost;
            [self.imageView setDownloadUrlString:[NSString stringWithFormat:@"%@/%@", imageHost, thumb]];
        }
    }
   
#if 0
    self.actionButtons.hidden = YES;
    NSNumber *showActions = [self.data objectForKey:@"showAction"];
    if([showActions boolValue]) {
        NSArray *actionStrings = [self.data objectForKey:@"actionStrings"];
        NSInteger count = actionStrings.count;
        if(count > 0) {
            self.actionButtons.hidden = NO;
            NSIndexPath *indexPath = [self.data objectForKey:@"indexPath"];
            if(!indexPath) {
                NSLog(@"#error - PostViewData indexPath nil.");
                indexPath = [NSIndexPath indexPathWithIndex:0];
            }
            
            [self.actionButtons removeAllSegments];
            for(NSInteger index = 0; index < count; index ++) {
                [self.actionButtons insertSegmentWithTitle:actionStrings[index] atIndex:index animated:YES];
            }
        }
    }
#else
    self.actionButtons0.hidden = YES;
    NSNumber *showActions = [self.data objectForKey:@"showAction"];
    if([showActions isKindOfClass:[NSNumber class]] && [showActions boolValue]) {
        NSLog(@"show actions.")
        NSArray *actionStrings = [self.data objectForKey:@"actionStrings"];
        NSInteger count = actionStrings.count;
        if(count > 0) {
            self.actionButtons0.hidden = NO;
            NSIndexPath *indexPath = [self.data objectForKey:@"indexPath"];
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
    
#endif
}


- (void)cellAction:(UIBarButtonItem*)sender
{
    NSLog(@"sender : %@ %@", sender, sender.title);
    
    NSLog(@"action on row %@ with action %@", self.data[@"row"], sender.title);
    
    NSIndexPath *indexPath = [self.data objectForKey:@"indexPath"];
    if(self.rowAction) {
        self.rowAction(indexPath, sender.title);
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
    UIFont *font = [UIFont fontWithName:@"PostTitle"];
//    NSString *text = @"2016-02-03 12:34:56 ABCDEF00";
    NSString *text = @"2016-02-03 12:34:56 WWWWWWWW ";
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=font;
    CGSize maxSize=CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    NSLog(@"@@@---%@", NSStringFromCGSize(textSize));
    //Title line布局在最上. title与info的宽度按照比例分配.
    NSString *textInfo = self.infoLabel.text;
    NSMutableDictionary *attrsInfo=[NSMutableDictionary dictionary];
    attrsInfo[NSFontAttributeName]=font;
    CGSize maxSizeInfo=CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize textSizeInfo = [textInfo boundingRectWithSize:maxSizeInfo options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsInfo context:nil].size;
    NSLog(@"@@@---%@", NSStringFromCGSize(textSizeInfo));
    
    CGRect frameTitleLine = [layout getCGRect:@"TitleLine"];
    if(textSize.width + textSizeInfo.width < frameTitleLine.size.width) {
        [layout divideInVertical:@"TitleLine" to:@"Title" and:@"Info" withPercentage:0.66];
        [layout divideInVertical:@"TitleLine" to:@"Title" and:@"Info" withWidthValue:textSize.width];
    }
    else {
        [layout setUseIncludedMode:@"TitleLine" includedTo:@"LayoutAll" withPostion:FrameLayoutPositionTop andSizeValue:40.0];
        [layout divideInHerizon:@"TitleLine" to:@"Title" and:@"Info" withPercentage:0.5];
        [self.infoLabel setTextAlignment:NSTextAlignmentLeft];
    }
    
    frameTitleLabel     = [layout getCGRect:@"Title"];
    frameInfoLabel      = [layout getCGRect:@"Info"];
    
    //标记自适应高度.
    CGFloat heightAdjust = 0.0;
    
    if(self.fold) {
        heightAdjust = frameTitleLabel.origin.y + frameTitleLabel.size.height;
        LOG_RECT(frameTitleLabel, @"xcv");
        [layout setUseBesideMode:@"PaddingActionButtons" besideTo:@"TitleLine" withDirection:FrameLayoutDirectionBelow andSizeValue:6.0];
    }
    else {
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
        
        [layout setUseBesideMode:@"PaddingActionButtons" besideTo:@"ImageLine" withDirection:FrameLayoutDirectionBelow andSizeValue:6.0];
    }
    
#if 0
    if(!self.actionButtons0.hidden) {
        CGFloat heightActionButtons = 36.0;
        [layout setUseBesideMode:@"ActionButtons" besideTo:@"PaddingActionButtons" withDirection:FrameLayoutDirectionBelow andSizeValue:heightActionButtons];
        frameActionButtons = [layout getCGRect:@"ActionButtons"];
            
        heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME(frameActionButtons) + edge.bottom;
    }
#else
    if(!self.actionButtons0.hidden) {
        CGFloat heightActionButtons = 36.0;
        [layout setUseBesideMode:@"ActionButtonsTemp" besideTo:@"PaddingActionButtons" withDirection:FrameLayoutDirectionBelow andSizeValue:heightActionButtons];
        CGRect frameActionButtonsTemp = [layout getCGRect:@"ActionButtonsTemp"];
        
        frameActionButtons = frameActionButtonsTemp;
        frameActionButtons.origin.x = 5;
        frameActionButtons.size.width = self.frame.size.width - 2 * frameActionButtons.origin.x;
        [layout setCGRect:frameActionButtons toName:@"ActionButtons"];
        self.actionButtons0.tintColor = [UIColor colorWithName:@"CellActionButtonsText"];
        
        heightAdjust = FRAMELAYOUT_Y_BLOW_FRAME(frameActionButtons) + edge.bottom;
    }
    
    
#endif


    self.titleLabel.frame           = frameTitleLabel;
    self.infoLabel.frame            = frameInfoLabel;
    self.manageInfoLabel.frame      = frameManageInfo;
    self.otherInfoLabel.frame       = frameOtherInfo;
    self.contentLabel.frame         = frameContentLabel;
    self.imageView.frame            = frameImageViewContent;
    self.actionButtons0.frame        = frameActionButtons;
    
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
        NSMutableArray *replies = [[NSMutableArray alloc] init];
        PostData *topic = [PostData sendSynchronousRequestByTid:tid atPage:1 repliesTo:replies storeAdditional:nil];
        if(topic) {
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



@interface PostView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *postDatas;
@property (nonatomic, strong) PostData *topic;
@property (nonatomic, strong) NSMutableDictionary *optumizeHeights;


@end

@implementation PostView



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.tableView];
    }
    return self;
}


- (void)layoutSubviews
{
    self.tableView.frame = self.bounds;
    [self.tableView reloadData];
}


- (void)setPostDatas:(NSArray *)postDatas belongTo:(PostData*)topic
{
    _postDatas = postDatas;
    _topic = topic;
    self.optumizeHeights = [[NSMutableDictionary alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    CGRect frame = self.frame;
    frame.size.height = 36;
    label.frame = frame;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PostContent"];
    if(topic) {
        label.text = [NSString stringWithFormat:@"显示最近%zd条回复. 共%zd条.", postDatas.count, topic.replyCount];
    }
    else {
        label.text = [NSString stringWithFormat:@"显示最近%zd条回复.", postDatas.count];
    }
    
    self.tableView.tableHeaderView = label;

    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = tableView.bounds.size.height;
    if([self.optumizeHeights objectForKey:indexPath]) {
        height =[[self.optumizeHeights objectForKey:indexPath] floatValue];
    }
    
    NSLog(@"------tableView[%@] heightForRowAtIndexPath return %.1f", [NSString stringFromTableIndexPath:indexPath], height);
    return height;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;
    NSLog(@"------tableView------ numberOfSectionsInTableView : %zd", sections);
    return sections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rows = self.postDatas.count;
    NSLog(@"------tableView------ numberOfRowsInSection : %zd", rows);
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView cellForRowAtIndexPath : %@", [NSString stringFromTableIndexPath:indexPath]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        CGRect frame = cell.frame;
        frame.size.width = tableView.frame.size.width;
        [cell setFrame:frame];
    }
    else {
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.tag = indexPath.row;
    
    PostData *postData = self.postDatas[indexPath.row];
    NSMutableDictionary *postViewDataRow = [postData toViewDisplayData:ThreadDataToViewTypeInfoUseNumber];
    
    PostDataCellView *v = [PostDataCellView threadCellViewWithData:postViewDataRow
                                                      andInitFrame:CGRectMake(0, 0, cell.frame.size.width, 100)];
    [cell addSubview:v];
    [v setTag:TAG_PostDataCellView];
    
    [self.optumizeHeights setObject:[NSNumber numberWithFloat:v.frame.size.height] forKey:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NS0Log(@"点击的行数是:%@", [NSString stringFromTableIndexPath:indexPath]);

}


//增加上拉刷新.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat judgeOffsetY = scrollView.contentSize.height
    + scrollView.contentInset.bottom
    - scrollView.frame.size.height;
    //    - self.postView.tableFooterView.frame.size.height;
    
    //拉到低栏20及以上才出发上拉刷新.
    CGFloat heightTrigger = 36.0;
    if(offsetY >= judgeOffsetY + heightTrigger) {
        NSLog(@"pull up trigger loadmore.");
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



